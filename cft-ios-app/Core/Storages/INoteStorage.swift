import Foundation

protocol INoteStorage {
	func getNotes(for user: UserModel) -> [NoteModel]
    func create(note: NoteModel, completion: @escaping () -> Void)
    func update(note: NoteModel, completion: @escaping () -> Void)
    func remove(note: NoteModel, completion: @escaping () -> Void)
}
