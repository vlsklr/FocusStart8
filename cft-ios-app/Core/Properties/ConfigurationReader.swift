import  Foundation

protocol IConfigurationReader {
	func readStorageType() -> String?
	func readFirstItem() -> (title: String?, body: String?)
}

final class ConfigurationReader: IConfigurationReader {

	private enum Keys: String {
		case storageType = "StorageType"
	}

	func readStorageType() -> String? {
		let bundle = Bundle(for: type(of: self))
		guard let path = bundle.path(forResource: "Configuration", ofType: "plist"),
			  let plistData = FileManager.default.contents(atPath: path) else {
			return nil
		}
		var format = PropertyListSerialization.PropertyListFormat.xml
		let collection = try? PropertyListSerialization.propertyList(from: plistData,
																	 options: .mutableContainersAndLeaves,
																	 format: &format) as? [String: Any]
		return collection?[Keys.storageType.rawValue] as? String
	}

	func readFirstItem() -> (title: String?, body: String?) {
		fatalError("Не реализовано")
	}
}
