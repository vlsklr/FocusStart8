import UIKit

protocol ILoginScreenView: AnyObject {
	func set(progress: Bool)
	func set(users: String)
	func showAlert(message: String)
}

final class LoginScreenViewController: UIViewController {
	private let presenter: ILoginScreenPresenter
	private let customView: LoginScreenView

	init(presenter: ILoginScreenPresenter) {
		self.presenter = presenter
		self.customView = LoginScreenView()
		super.init(nibName: nil, bundle: nil)
		self.customView.delagate = self.presenter
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		self.view = customView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.presenter.viewDidLoad(uiView: self)
	}
}

extension LoginScreenViewController: ILoginScreenView {
	func set(users: String) {
		self.customView.set(users: users)
	}

	func showAlert(message: String) {
		let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

	func set(progress: Bool) {
		self.customView.set(progress: progress)
	}
}
