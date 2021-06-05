import UIKit
import CoreData
import Swinject

/*
1) Изучите проект, архитектуру и имеющиеся компоненты

2) Добавить в модель Note поле даты создания/изменения заметки. При изменении заметки, дата должна обновляться.
3) Добавьте на главном экране сортировку заметок по дате от старых к новым, выведите дату в отддельную UILable в формате "05-06-2021"
4) Ограничьте вывод заметок: только за текущий год, заголовок содержит любую цифру
5) Закончите функционал удаления заметки, удаление использует background контекст

6) База данных никак не информирует об ошибках сохранения или чтения данных, исправьте это.
В случает ошибки сохранения, презентер должен выдавать алерт с сообщением. При чтениии - пустой список.
В обоих случах должны писаться логи в консоль
7) Расширьте протокол IUserStorage, и отображайте на LoginScreen, сколько в системе зарегистрированных пользователей
8) Добавьте в MainScreen кнопку "backup", которая сохраняет в файл, создаваемый в documentDirectory все заметки текущего пользователя
Сериализация происходит в формат json или xml. После чего запускает UIActivityViewController с предложением расшарить файл

9) Добработайте в модуле MainScreen добавление первой приветсвенной ячейки. Для этого доработайте ConfigurationReader,
который извлекает из Configuration.plist наполнение первой ячейки, после чего добавьте ее в бд. Ячейка должна быть своя для каждого нового пользователя.
10) Используя UserDefaultsStorage, запомните, какой пользователь последний авторизовывался в системе и заполняйте его логин на экране авторизации
11) Использую UserDefaultsStorage, сколько всего раз все пользователи авторизовывались в системе.
Выводите эту информацию рядом с колл-вом пользователей в системе

12) Добавьте на экране авторизации кнопку удаления профиля с указанным логином и паролем.
Обеспечте каскадное удаление ассоциированных заметок. Обесепечте кооректность всех счетчиков (UserDefaultsStorage)
13) Закончите StorageFactory, добавьте поддержку хранилища, основанного на sqllite.
14) Закончите StorageFactory, добавьте поддержку хранилищ, основанного на файловой системе.
На файловой системе для каждого пользователя создается папка с файлами заметок
Тип хранилища сборки конфиругируется в Configuration.plist, извлекается ConfigurationReader

15) Хранить пароль в базе данных - плохая идея. Изменити программу так, чтобы в базе хранил хеш пароля, например md5
*/

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	static let container = Container()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		AppDelegate.initDependences()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let controller = LoginScreenAssembly().build()
        let navigationVC = UINavigationController(rootViewController: controller)
        self.window?.rootViewController = navigationVC
        self.window?.makeKeyAndVisible()
        self.window?.overrideUserInterfaceStyle = .light
        return true
    }

	static func initDependences() {
		AppDelegate.container.register(IUserDefaultsStorage.self) { _ in
			return UserDefaultsStorage(userDefaults: UserDefaults.standard)
		}
		AppDelegate.container.register(IConfigurationReader.self) { _ in
			ConfigurationReader()
		}
		let configurationReader = AppDelegate.container.resolve(IConfigurationReader.self)!
		let storage = StorageFactory(reader: configurationReader).generateStorage()
		AppDelegate.container.register(INoteStorage.self) { _ in
			return storage
		}
		.inObjectScope(.container)
		AppDelegate.container.register(IUserStorage.self) { _ in
			return storage
		}
		.inObjectScope(.container)

		AppDelegate.container.register(IBackupManager.self) { resolver in
			let noteStorage = resolver.resolve(INoteStorage.self)!
			return BackupManager(fileManager: FileManager.default, storage: noteStorage)
		}
	}
}
