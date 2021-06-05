import Foundation

protocol INoteScreenPresenter: AnyObject {
    func viewDidLoad(uiView: INoteScreenView, controller: INoteScreenController)
    func saveNote()
}

final class NoteScreenPresenter {
    private weak var uiView: INoteScreenView?
    private weak var controller: INoteScreenController?
    private let router: INoteScreenRouter
    private let noteStorage: INoteStorage
    private let center: NotificationCenter
	private let user: UserModel
    private var noteData: NoteModel?
    init(router: INoteScreenRouter, noteStorage: INoteStorage, center: NotificationCenter, user: UserModel, noteData: NoteModel? = nil) {
		self.router = router
        self.noteStorage = noteStorage
        self.center = center
		self.user = user
        self.noteData = noteData
    }
}

extension NoteScreenPresenter: INoteScreenPresenter {
    func viewDidLoad(uiView: INoteScreenView, controller: INoteScreenController) {
        self.uiView = uiView
        self.controller = controller
        self.displayNote()
    }

    func saveNote() {
        if let originalText = self.uiView?.noteText,
           originalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            let lines = originalText.split(separator: "\n")
            let title = String(lines.first ?? "")
            let text = originalText.replacingOccurrences(of: title, with: "", options: .literal, range: nil)
            self.saveNoteInStorage(title: title, text: text)
        }
    }

	func saveNoteInStorage(title: String, text: String) {
		if self.isEditMode, let noteData = self.noteData {
			noteData.update(title: title, text: text)
			self.noteStorage.update(note: noteData, completion: { _ in
				self.center.post(name: Notification.Name.updateNotification, object: nil)
				self.router.goBack()
			})
		} else {
			let note = NoteModel(holder: self.user.uid, title: title, text: text)
			self.noteStorage.create(note: note, completion: { error in
				if error == nil {
					self.center.post(name: Notification.Name.updateNotification, object: nil)
					self.router.goBack()
				} else {
					self.controller?.showAlert(message: "Ошибка создания записи")
				}
			})
		}
	}
}

private extension NoteScreenPresenter {
    var isEditMode: Bool {
        return self.noteData != nil
    }

    func displayNote() {
        self.controller?.configureNavBar(button: self.isEditMode ? "Сохранить" : "Создать")
        self.uiView?.update(NoteScreenViewModel(isEditMode: self.noteData != nil,
                                                title: self.noteData?.title ?? "",
                                                mainText: self.noteData?.text ?? ""))
    }
}

struct NoteScreenViewModel {
    let isEditMode: Bool
    let title: String
    let mainText: String
}
