import Foundation

final class NoteModel {
    let uid: UUID
	let holder: UUID
    private(set) var title: String?
    private(set) var text: String?

    init(holder: UUID, title: String?, text: String?) {
        self.uid = UUID()
		self.holder = holder
        self.title = title
        self.text = text
    }

    init(uid: UUID, holder: UUID, title: String?, text: String?) {
        self.uid = uid
		self.holder = holder
        self.title = title
        self.text = text
    }

    init?(note: Note) {
		guard let uid = note.uid, let holder = note.holder?.uid else { return nil }
        self.uid = uid
		self.holder = holder
        self.title = note.title
        self.text = note.text
    }

	func update(title: String?, text: String?) {
        self.title = title
        self.text = text
    }
}
