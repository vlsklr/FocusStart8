import Foundation

protocol IMainScreenPresenter: MainScreenTableAdapterDelegate {
	func viewDidLoad(adapter: IMainScreenTableAdapter, controller: IMainScreenController)
	func createNote()
	func makeBackup()
}

final class MainScreenPresenter {
	private weak var adapter: IMainScreenTableAdapter?
	private weak var controller: IMainScreenController?
	private let router: IMainScreenRouter
	private let notesStorage: INoteStorage
	private let center: NotificationCenter
	private let configurationReader: IConfigurationReader
	private let backupManager: IBackupManager
	private let user: UserModel
	private var notes: [NoteModel] = []
	init(router: IMainScreenRouter, notesStorage: INoteStorage, configurationReader: IConfigurationReader, backupManager: IBackupManager, center: NotificationCenter, user: UserModel) {
		self.router = router
		self.notesStorage = notesStorage
		self.configurationReader = configurationReader
		self.center = center
		self.backupManager = backupManager
		self.user = user
		self.center.addObserver(self, selector: #selector(reloadNotes),
								name: Notification.Name.updateNotification,
								object: nil)
	}

	deinit {
		self.center.removeObserver(self)
	}

	private let timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm:ss"
		return formatter
	}()
}

extension MainScreenPresenter: IMainScreenPresenter {
	func makeBackup() {
		do {
			let path = try self.backupManager.backup(for: self.user)
			self.router.shareFile(path: path)
		} catch {
			self.controller?.showAlert(message: "Не удалось выполнить операцию")
		}
	}

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
		self.notesStorage.remove(note: note) { [weak self] error in
			if error != nil {
				self?.controller?.showAlert(message: "Ошибка удаления")
			} else {
				self?.reloadNotes()
			}
		}
	}

	func onItemClick(note: UUID) {
		guard let note = self.notes.first(where: { $0.uid == note }) else { return }
		self.router.openNote(note: note)
	}
}

private extension MainScreenPresenter {
	func displayNotes() {
		defer {
			self.adapter?.update(notes: self.notes.map { MainScreenItemViewModel(id: $0.uid,
																				 title: $0.title,
																				 text: $0.text,
																				 date: self.timeFormatter.string(from: $0.date)) })
		}
		do {
			self.notes = try self.notesStorage.getNotes(for: self.user)
		} catch {
			self.controller?.showAlert(message: "Ошибка загрузки данных")
			self.notes = []
		}
	}

	@objc func reloadNotes() {
		self.displayNotes()
	}
}
