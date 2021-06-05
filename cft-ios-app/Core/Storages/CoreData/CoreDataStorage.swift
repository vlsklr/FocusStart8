import Foundation
import CoreData

final class CoreDataStorage {
	private enum Constants {
		static let containerName = "CFTDataBase"
		static let entityName = "Note"
	}

	private lazy var container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: Constants.containerName)
		container.loadPersistentStores(completionHandler: { (_, error) in
			guard let error = error as NSError? else { return }
			fatalError("Unresolved error \(error), \(error.userInfo)")
		})
		return container
	}()
}

extension CoreDataStorage: INoteStorage {
	func getNotes(for user: UserModel) -> [NoteModel] {

		let calendar = Calendar.current
		let currentYear = calendar.dateComponents([.year], from: Date())
		let startOfThisYear = calendar.date(from: currentYear)!
		let nextYear = DateComponents(year: currentYear.year! + 1)
		let startOfNextYear = calendar.date(from: nextYear)!

		let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
		// NSPredicate(format: "ANY holder.uid = '\(user.uid)' AND (title CONTAINS[c] '1' OR title CONTAINS[c] '2')
		fetchRequest.predicate = NSPredicate(format: "ANY holder.uid = '\(user.uid)' AND \(#keyPath(Note.date)) >= %@ AND \(#keyPath(Note.date)) < %@", argumentArray: [startOfThisYear, startOfNextYear])
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.date), ascending: false)]
		return (try? self.container.viewContext.fetch(fetchRequest).compactMap { NoteModel(note: $0) }) ?? []
	}

	func create(note: NoteModel, completion: @escaping () -> Void) {
		self.container.performBackgroundTask { context in
			defer {
				DispatchQueue.main.async { completion() }
			}
			let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.uid)) = '\(note.holder)'")
			guard let user = try? context.fetch(fetchRequest).first else { return }
			let object = Note(context: context)
			object.uid = note.uid
			object.title = note.title
			object.text = note.text
			object.date = note.date
			object.holder = user
			try? context.save()
		}
	}

	func update(note: NoteModel, completion: @escaping () -> Void) {
		self.container.performBackgroundTask { context in
			let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Note.uid)) = %@", note.uid.uuidString)
			if let object = try? context.fetch(fetchRequest).first {
				object.title = note.title
				object.text = note.text
				object.date = note.date
			}
			try? context.save()
			DispatchQueue.main.async { completion() }
		}
	}

	func remove(note: NoteModel, completion: @escaping () -> Void) {
		self.container.performBackgroundTask { context in
			let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Note.uid)) = %@", note.uid.uuidString)
			if let object = try? context.fetch(fetchRequest).first {
				context.delete(object)
				try? context.save()
			}
			DispatchQueue.main.async { completion() }
		}
	}
}

extension CoreDataStorage: IUserStorage {
	func getUser(login: String, password: String) -> UserModel? {
		let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.login)) = '\(login)' && \(#keyPath(User.password)) = '\(password)'")
		guard let object = try? self.container.viewContext.fetch(fetchRequest).first else { return nil }
		return UserModel(user: object)
	}

	func saveUser(user: UserModel, completion: @escaping () -> Void) {
		self.container.performBackgroundTask { context in
			let object = User(context: context)
			object.uid = user.uid
			object.login = user.login
			object.password = user.password
			try? context.save()
			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { completion() })
		}
	}

	func usersCount() -> Int {
		fatalError("Не реализовано")
	}
}
