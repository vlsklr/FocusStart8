import UIKit
import CoreData

protocol IMainScreenController: AnyObject {
    func configureNavBar(title: String)
	func showAlert(message: String)
}

final class MainScreenViewController: UIViewController {
    private let presenter: IMainScreenPresenter
    private let tableAdapter: IMainScreenTableAdapter
    private let customView: MainScreenView
    init(presenter: IMainScreenPresenter, tableAdapter: IMainScreenTableAdapter) {
        self.presenter = presenter
        self.tableAdapter = tableAdapter
        self.customView = MainScreenView()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.customView
        self.tableAdapter.tableView = self.customView.tableView
        self.tableAdapter.delegate = self.presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad(adapter: self.tableAdapter,
                                   controller: self)
    }
}

extension MainScreenViewController: IMainScreenController {
	func showAlert(message: String) {
		let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

    func configureNavBar(title: String) {
        self.title = title
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainRed,
                                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
        let backBarItem = UIBarButtonItem()
        backBarItem.title = self.title
        backBarItem.tintColor = UIColor.mainRed
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNote))
        rightBarItem.tintColor = UIColor.mainRed
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        self.navigationController?.navigationBar.barTintColor = .secondarySystemBackground
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.backBarButtonItem = backBarItem
    }
}

private extension MainScreenViewController {
    @objc func createNote() {
        self.presenter.createNote()
    }
}
