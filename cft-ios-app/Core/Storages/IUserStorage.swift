import Foundation

protocol IUserStorage {
	func getUser(login: String, password: String) -> UserModel?
	func saveUser(user: UserModel, completion: @escaping () -> Void)
	func usersCount() -> Int
}
