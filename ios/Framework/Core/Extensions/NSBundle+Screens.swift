/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/
import Foundation


extension NSBundle {

	public var isFrameworkBundle: Bool {
		return bundlePath.hasSuffix(".framework")
	}

	public var isAppBundle: Bool {
		return bundlePath.hasSuffix(".app")
	}

	public var isLiferayScreensBundle: Bool {
		let screensPrefix = "liferayscreens"
		let bundleName = ((bundleIdentifier ?? "") as NSString).pathExtension.lowercaseString

		return bundleName.hasPrefix(screensPrefix)
	}

	public class func allBundles(currentClass: AnyClass) -> [NSBundle] {
		let bundles = [
			discoverFrameworkBundles(),
			bundlesForDefaultTheme(currentClass),
			bundlesForCore(currentClass),
			bundlesForApp(currentClass),
			[NSBundle(forClass: currentClass)]
		]
			.flatMap { $0 }

		return bundles.reduce([]) { ac, x in
			ac.contains(x) ? ac : ac + [x]
		}
	}

	public class func discoverFrameworkBundles() -> [NSBundle] {
		let allBundles = NSBundle.allFrameworks() + NSBundle.allBundles()

		let screensBundles = allBundles.filter {
			$0.isLiferayScreensBundle
		}

		let innerBundles = screensBundles.map {
			($0.isFrameworkBundle || $0.isAppBundle) ? discoverInnerBundles($0) : [$0]
		}.flatMap {
			$0
		}

		return screensBundles + innerBundles
	}

	public class func discoverInnerBundles(rootBundle: NSBundle) -> [NSBundle] {
		let innerBundlesPaths = rootBundle.pathsForResourcesOfType("bundle", inDirectory: nil)

		return innerBundlesPaths.flatMap {
			NSBundle(path: $0)
		}.filter {
			$0 != nil
		}.map {
			$0!
		}
	}

	public class func bundlesForDefaultTheme(currentClass: AnyClass) -> [NSBundle] {
		return [
			bundleForName("LiferayScreens-default", forClass: currentClass),
			bundleForName("LiferayScreens-ee-default", forClass: currentClass)
		]
	}

	public class func bundlesForCore(currentClass: AnyClass) -> [NSBundle] {
		return [
			bundleForName("LiferayScreens-core", forClass: currentClass),
			bundleForName("LiferayScreens-ee-core", forClass: currentClass)
		]
	}

	public class func bundleForName(name: String, forClass currentClass: AnyClass) -> NSBundle {
		let currentClassBundle = NSBundle(forClass: currentClass)
		let frameworkBundle = NSBundle(forClass: BaseScreenlet.self)

		// In test environment, separated bundles don't exist.
		// In such case, the frameworkBundle is used
		let bundlePath = currentClassBundle.pathForResource(name, ofType: "bundle")
			?? frameworkBundle.pathForResource(name, ofType: "bundle")
			?? frameworkBundle.bundlePath

		return NSBundle(path: bundlePath)!
	}

	public class func bundlesForApp(currentClass: AnyClass) -> [NSBundle] {

		func appFile(path: String) -> String? {
			let files = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
			return (files ?? []).filter {
				($0 as NSString).pathExtension == "app"
			}
			.first
		}

		let components = ((NSBundle.mainBundle().resourcePath ?? "") as NSString).pathComponents ?? []

		if components.last == "Overlays" {
			// running into IB
			let coreBundle = bundlesForCore(currentClass)[0]

			if let range = coreBundle.resourcePath?.rangeOfString("Debug-iphonesimulator"),
				path = coreBundle.resourcePath?.substringToIndex(range.endIndex),
				appName = appFile(path),
				appBundle = NSBundle(path: (path as NSString).stringByAppendingPathComponent(appName)) {
					return [NSBundle.mainBundle(), appBundle]
			}
		}

		return [NSBundle.mainBundle()]
	}


	public class func imageInBundles(name name: String, currentClass: AnyClass) -> UIImage? {
		for bundle in allBundles(currentClass) {
			if let path = bundle.pathForResource(name, ofType: "png") {
				return UIImage(contentsOfFile: path)
			}
		}

		return nil
	}

}
