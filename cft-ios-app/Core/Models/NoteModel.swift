import Foundation

final class NoteModel: Encodable {
    let uid: UUID
	let holder: UUID
	private(set) var date: Date
    private(set) var title: String?
    private(set) var text: String?

    init(holder: UUID, title: String?, text: String?) {
        self.uid = UUID()
		self.date = Date()
		self.holder = holder
        self.title = title
        self.text = text
    }

    init(uid: UUID, holder: UUID, date: Date, title: String?, text: String?) {
        self.uid = uid
		self.holder = holder
		self.date = date
        self.title = title
        self.text = text
    }

	init?(note: Note) {
		guard let uid = note.uid,
			  let holder = note.holder?.uid,
			  let date = note.date else { return nil }
        self.uid = uid
		self.holder = holder
		self.date = date
        self.title = note.title
        self.text = note.text
    }

	func update(title: String?, text: String?) {
		self.date = Date()
        self.title = title
        self.text = text
    }
}
