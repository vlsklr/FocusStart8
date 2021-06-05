import Foundation

enum BackupErrors: Error {
	case documentDirectory
	case fileManager
	case serialize
}

protocol IBackupManager {
	func backup(for user: UserModel) throws -> URL
}

final class BackupManager: IBackupManager {

	private let fileManager: FileManager
	private let storage: INoteStorage
	init(fileManager: FileManager, storage: INoteStorage) {
		self.fileManager = fileManager
		self.storage = storage
	}

	func backup(for user: UserModel) throws -> URL {
		let folderPath = try self.makeFolderURL(for: user)
		let filePath = folderPath.appendingPathComponent(user.uid.uuidString)
		try self.prepareUserFolder(dirPath: folderPath)

		let notes = try self.storage.getNotes(for: user)
		let json = try self.serialize(notes: notes)

		try json.write(to: filePath, atomically: false, encoding: .utf8)
		return filePath
	}

	func serialize(notes: [NoteModel]) throws -> String {
		let jsonEncoder = JSONEncoder()
		let jsonData = try jsonEncoder.encode(notes)
		guard let json = String(data: jsonData, encoding: .utf8) else {
			throw BackupErrors.serialize
		}
		return json
	}

	private func prepareUserFolder(dirPath: URL) throws {
		if self.fileManager.fileExists(atPath: dirPath.path) == false {
			do {
				try self.fileManager.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print(error.localizedDescription)
				throw BackupErrors.fileManager
			}
		}
	}

	private func makeFolderURL(for user: UserModel) throws -> URL {
		guard let dirPath = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
			throw BackupErrors.documentDirectory
		}
		return dirPath
	}
}
