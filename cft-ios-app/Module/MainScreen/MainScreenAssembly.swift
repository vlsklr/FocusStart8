import UIKit

extension Notification.Name {
    static let updateNotification = Notification.Name("updateNotification")
}

final class MainScreenAssembly {
    func build(user: UserModel) -> UIViewController {
		let configurationReader = AppDelegate.container.resolve(IConfigurationReader.self)!
		let noteStorage = AppDelegate.container.resolve(INoteStorage.self)!
		let backupManager = AppDelegate.container.resolve(IBackupManager.self)!

		let router = MainScreenRouter(user: user)
		let presenter = MainScreenPresenter(router: router,
											notesStorage: noteStorage,
											configurationReader: configurationReader,
											backupManager: backupManager,
											center: NotificationCenter.default,
											user: user)
        let tableAdapter = MainScreenTableAdapter()

        let controller = MainScreenViewController(presenter: presenter,
                                                  tableAdapter: tableAdapter)
        router.controller = controller
        return controller
    }
}
