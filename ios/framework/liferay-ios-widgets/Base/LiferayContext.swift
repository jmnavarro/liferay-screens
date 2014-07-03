//
//  LiferayContext.swift
//  liferay-swift-widgets
//
//  Created by jmWork on 01/07/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

import Foundation

struct LiferayContext {

	var server:String = "http://localhost:8080"
	var companyId:Int = 10154
	var groupId:Int = 10181

	var currentSession:LRSession?

	static var instance = LiferayContext()

	init() {
		let propertiesPath = NSBundle.mainBundle().pathForResource("liferay-context", ofType:"plist")
		if propertiesPath {
			loadContextFile(propertiesPath)
		}
		else {
			println("WARNING: liferay-context.plist file is not found. Falling back to template liferay-context-sample.list")

			if let templatePath = NSBundle.mainBundle().pathForResource("liferay-context-sample", ofType:"plist") {
				loadContextFile(propertiesPath)
			}
			else {
				println("ERROR: liferay-context-sample.plist file is not found")
			}
		}
	}

	mutating func loadContextFile(propertiesPath:String) {
		let properties = NSDictionary(contentsOfFile: propertiesPath)
		server = properties["server"] as String;
		companyId = properties["companyId"] as Int
		groupId = properties["groupId"] as Int
	}

	mutating func createSession(username:String, password:String) -> LRSession {
		self.currentSession = LRSession(server, username:username, password:password)
		return self.currentSession!
	}

	mutating func clearSession() {
		self.currentSession = nil
	}

}
