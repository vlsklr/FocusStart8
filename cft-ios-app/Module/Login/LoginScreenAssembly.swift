import UIKit

final class LoginScreenAssembly {
	func build() -> UIViewController {
		let userDefaultsStorage = AppDelegate.container.resolve(IUserDefaultsStorage.self)!
		let userStorage = AppDelegate.container.resolve(IUserStorage.self)!
		let router = LoginScreenRouter()
		let presenter = LoginScreenPresenter(userStorage: userStorage,
											 userDefaultsStorage: userDefaultsStorage,
											 router: router)
		let controller = LoginScreenViewController(presenter: presenter)
		router.controller = controller
		return controller
	}
}
