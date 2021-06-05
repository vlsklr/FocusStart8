import UIKit
import Foundation

protocol IMainScreenTableAdapter: AnyObject {
    var delegate: MainScreenTableAdapterDelegate? { get set}
    var tableView: UITableView? { get set}
    func update(notes: [MainScreenItemViewModel])
}

protocol MainScreenTableAdapterDelegate: AnyObject {
    func onItemClick(note: UUID)
    func onItemDelete(note: UUID)
}

final class MainScreenTableAdapter: NSObject {
    private enum Constants {
        static let noteCell = "NoteCell"
    }
    private var notes = [MainScreenItemViewModel]()
    weak var delegate: MainScreenTableAdapterDelegate?
    weak var tableView: UITableView? {
        didSet {
            self.tableView?.delegate = self
            self.tableView?.dataSource = self
            self.tableView?.register(MainScreenNoteCell.self, forCellReuseIdentifier: Constants.noteCell)
        }
    }
}

extension MainScreenTableAdapter: IMainScreenTableAdapter {
    func update(notes: [MainScreenItemViewModel]) {
        self.notes = notes
        self.tableView?.reloadData()
    }
}

extension MainScreenTableAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.onItemClick(note: self.notes[indexPath.row].id)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить", handler: { (_, _, _) in
            self.delegate?.onItemDelete(note: self.notes[indexPath.row].id)
        })
        deleteAction.backgroundColor = .mainRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension MainScreenTableAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = self.notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.noteCell, for: indexPath)
        (cell as? MainScreenNoteCell)?.update(vm: note)
        return cell
    }
}
