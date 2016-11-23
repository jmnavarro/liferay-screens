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
import UIKit
import AVFoundation
import AVKit


public class VideoDisplayView_default: BaseScreenletView, FileDisplayViewModel {

	@IBOutlet weak var view: UIView?

	public var playerController: AVPlayerViewController?

	public var url: NSURL? {
		didSet {
			if let playerController = self.playerController {
				playerController.view.removeFromSuperview()
				self.playerController = nil
			}

			if let url = url {
				self.playerController = AVPlayerViewController()

				let video = AVPlayer(URL: url)
				playerController!.player = video
				playerController!.view.frame = self.bounds

				self.view?.addSubview(playerController!.view)

				video.play()
			}
		}
	}

	public var title: String? {
		didSet {
			self.presentingViewController?.title = title
		}
	}
}
