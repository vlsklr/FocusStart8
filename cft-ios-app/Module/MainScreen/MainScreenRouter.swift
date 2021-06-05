//
//  MainScreenRouter.swift
//  cft-ios-app
//
//  Created by Lsgsk on 21.05.2021.
//  Copyright © 2021 Lsgsk. All rights reserved.
//

import UIKit

protocol IMainScreenRouter: AnyObject {
    func createNote()
    func openNote(note: NoteModel)
	func shareFile(path: URL)
}

final class MainScreenRouter: IMainScreenRouter {
    weak var controller: UIViewController?
	private let user: UserModel

	init(user: UserModel) {
		self.user = user
	}

    @objc func createNote() {
		let controller = NoteScreenAssembly().build(user: self.user)
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }

    func openNote(note: NoteModel) {
		let controller = NoteScreenAssembly().build(user: self.user, note: note)
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }

	func shareFile(path: URL) {
		let activityViewController = UIActivityViewController(activityItems: [path],
															  applicationActivities: nil)
		self.controller?.present(activityViewController, animated: true)
	}
}
