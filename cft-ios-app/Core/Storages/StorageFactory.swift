import Foundation

enum StorageType: String {
	case coredata
	case filesystem
	case sqllite
}

protocol IStorageFactory {
	func generateStorage() -> INoteStorage & IUserStorage
}

final class StorageFactory: IStorageFactory {
	private let reader: IConfigurationReader

	init(reader: IConfigurationReader) {
		self.reader = reader
	}

	func generateStorage() -> INoteStorage & IUserStorage {
		let storageType = StorageType(rawValue: self.reader.readStorageType() ?? StorageType.coredata.rawValue) ?? .coredata
		switch storageType {
		case .coredata:
			return CoreDataStorage()
		case .filesystem:
			fatalError("Не реализовано")
		case .sqllite:
			fatalError("Не реализовано")
		}
	}
}
