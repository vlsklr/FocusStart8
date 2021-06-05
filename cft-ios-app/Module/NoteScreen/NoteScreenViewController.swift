import Foundation
import UIKit
import CoreData

protocol INoteScreenController: AnyObject {
    func configureNavBar(button: String)
	func showAlert(message: String)
}

final class NoteScreenViewController: UIViewController {
    private let presenter: INoteScreenPresenter
    private let customView: NoteScreenView

    init(presenter: INoteScreenPresenter) {
        self.presenter = presenter
        self.customView = NoteScreenView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad(uiView: self.customView,
                                   controller: self)
    }
}

extension NoteScreenViewController: INoteScreenController {
    func configureNavBar(button: String) {
        let rightBarButton = UIBarButtonItem(title: button,
                                             style: .done,
                                             target: self,
                                             action: #selector(self.saveNote))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.mainRed
    }

	func showAlert(message: String) {
		let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

    @objc func saveNote() {
        self.presenter.saveNote()
    }
}
