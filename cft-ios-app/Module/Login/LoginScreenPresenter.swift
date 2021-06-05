import Foundation

protocol ILoginScreenPresenter: ILoginScreenViewDelegate {
	func viewDidLoad(uiView: ILoginScreenView)
}

final class LoginScreenPresenter: ILoginScreenPresenter {
	private weak var uiView: ILoginScreenView?
	private let userStorage: IUserStorage
	private let userDefaultsStorage: IUserDefaultsStorage
	private let router: ILoginScreenRouter

	init(userStorage: IUserStorage, userDefaultsStorage: IUserDefaultsStorage, router: ILoginScreenRouter) {
		self.userStorage = userStorage
		self.userDefaultsStorage = userDefaultsStorage
		self.router = router
	}

	func viewDidLoad(uiView: ILoginScreenView) {
		self.uiView = uiView
		self.uiView?.set(users: self.getCountTitle())
	}
}

extension LoginScreenPresenter: ILoginScreenViewDelegate {
	func login(login: String?, password: String?) {
		guard let login = login, login.isEmpty == false, let password = password, password.isEmpty == false else {
			self.uiView?.showAlert(message: "Введите логин и пароль")
			return
		}
		guard let user = self.userStorage.getUser(login: login, password: password) else {
			self.uiView?.showAlert(message: "Пользователь не зарегистрирован или пароль не верен")
			return
		}
		self.router.openMainScreen(user: user)
	}

	func signin(login: String?, password: String?) {
		guard let login = login, login.isEmpty == false, let password = password, password.isEmpty == false else {
			self.uiView?.showAlert(message: "Введите логин и пароль")
			return
		}
		guard self.userStorage.getUser(login: login, password: password) == nil else {
			self.uiView?.showAlert(message: "Такой пользователь уже зарегистрирован")
			return
		}
		self.uiView?.set(progress: true)
		let newUser = UserModel(login: login, password: password)
		self.userStorage.saveUser(user: newUser, completion: {
			self.uiView?.set(progress: false)
			self.router.openMainScreen(user: newUser)
		})
	}
}

private extension LoginScreenPresenter {
	func getCountTitle() -> String {
		return "Users in system: \(self.userStorage.usersCount())"
	}
}
