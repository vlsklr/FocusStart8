import Foundation

protocol IUserDefaultsStorage {
	func lastEnteredPerson() -> UUID
	var timesOfUsage: Int { get set }
}

final class UserDefaultsStorage: IUserDefaultsStorage {
	enum Keys {
		static let lastOpenedUser = "lastOpenedUser"
	}

	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults = .standard) {
		self.userDefaults = userDefaults
	}

	func lastEnteredPerson() -> UUID {
		fatalError("Не реализовано")
	}

	var timesOfUsage: Int {
		get {
			fatalError("Не реализовано")
		}
		set {
			fatalError("Не реализовано \(newValue)")
		}
	}
}
