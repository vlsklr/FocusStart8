import Foundation

struct UserModel {
	let uid: UUID
	let login: String
	let password: String

	init(login: String, password: String) {
		self.uid = UUID()
		self.login = login
		self.password = password
	}

	init?(user: User) {
		guard let uid = user.uid,
			  let login = user.login,
			  let password = user.password
		else { return nil }
		self.uid = uid
		self.login = login
		self.password = password
	}
}
