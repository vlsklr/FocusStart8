import UIKit

protocol INoteScreenRouter: AnyObject {
    func goBack()
}

final class NoteScreenRouter: INoteScreenRouter {
    weak var controller: UIViewController?

    func goBack() {
        self.controller?.navigationController?.popViewController(animated: true)
    }
}
