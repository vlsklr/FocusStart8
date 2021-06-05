import Foundation

protocol IMainScreenPresenter: MainScreenTableAdapterDelegate {
    func viewDidLoad(adapter: IMainScreenTableAdapter, controller: IMainScreenController)
	func createNote()
}

final class MainScreenPresenter {
    private weak var adapter: IMainScreenTableAdapter?
    private weak var controller: IMainScreenController?
    private let router: IMainScreenRouter
    private let notesStorage: INoteStorage
    private let center: NotificationCenter
	private let configurationReader: IConfigurationReader
	private let user: UserModel
    private var notes: [NoteModel] = []
	init(router: IMainScreenRouter, notesStorage: INoteStorage, configurationReader: IConfigurationReader, center: NotificationCenter, user: UserModel) {
		self.router = router
        self.notesStorage = notesStorage
		self.configurationReader = configurationReader
        self.center = center
		self.user = user
        self.center.addObserver(self, selector: #selector(reloadNotes),
                                name: Notification.Name.updateNotification,
                                object: nil)
    }

    deinit {
        self.center.removeObserver(self)
    }
}

extension MainScreenPresenter: IMainScreenPresenter {
    func viewDidLoad(adapter: IMainScreenTableAdapter, controller: IMainScreenController) {
        self.adapter = adapter
        self.controller = controller
        self.controller?.configureNavBar(title: "ЦФТ - Заметки")
        self.displayNotes()
    }

	func createNote() {
		self.router.createNote()
	}
}

extension MainScreenPresenter: MainScreenTableAdapterDelegate {
    func onItemDelete(note: UUID) {
        guard let note = self.notes.first(where: { $0.uid == note }) else { return }
        self.notesStorage.remove(note: note) { [weak self] in
            self?.reloadNotes()
        }
    }

    func onItemClick(note: UUID) {
        guard let note = self.notes.first(where: { $0.uid == note }) else { return }
        self.router.openNote(note: note)
    }
}

private extension MainScreenPresenter {
	func displayNotes() {
		self.notes = self.notesStorage.getNotes(for: self.user)
		self.adapter?.update(notes: self.notes.map { MainScreenItemViewModel(id: $0.uid, title: $0.title, text: $0.text) })
	}

    @objc func reloadNotes() {
        self.displayNotes()
    }
}
