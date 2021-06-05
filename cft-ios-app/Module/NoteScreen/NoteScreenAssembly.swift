import UIKit

final class NoteScreenAssembly {
    func build(user: UserModel, note: NoteModel? = nil) -> UIViewController {
		let noteStorage = AppDelegate.container.resolve(INoteStorage.self)!
		let router = NoteScreenRouter()
		let presenter = NoteScreenPresenter(router: router,
											noteStorage: noteStorage,
											center: NotificationCenter.default, user: user,
                                            noteData: note)
        let controller = NoteScreenViewController(presenter: presenter)
        router.controller = controller
        return controller
    }
}
