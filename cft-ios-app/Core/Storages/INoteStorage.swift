import Foundation

protocol INoteStorage {
	func getNotes(for user: UserModel) throws -> [NoteModel]
    func create(note: NoteModel, completion: @escaping (NoteException?) -> Void)
    func update(note: NoteModel, completion: @escaping (NoteException?) -> Void)
    func remove(note: NoteModel, completion: @escaping (NoteException?) -> Void)
}

enum NoteException: Error {
	case saveFailed
	case updateFailed
	case removeFailed
	case loadFailed
}
