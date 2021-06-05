import UIKit

final class MainScreenNoteCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .secondarySystemBackground
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }

    func update(vm: MainScreenItemViewModel) {
        self.textLabel?.text = vm.title
        let clearMainText = vm.text?.replacingOccurrences(of: "\n", with: "", options: .literal, range: nil)
        self.detailTextLabel?.text = clearMainText
    }
}
