import UIKit

final class MainScreenNoteCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .secondarySystemBackground
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		self.contentView.addSubview(self.time)
		self.time.snp.makeConstraints { maker in
			maker.right.top.equalToSuperview().inset(5)
		}
    }

	fileprivate(set) lazy var time: UILabel = {
		let view = UILabel()
		view.font = UIFont.systemFont(ofSize: 12)
		view.textColor = .blue
		return view
	}()

    func update(vm: MainScreenItemViewModel) {
		self.time.text = vm.date
        self.textLabel?.text = vm.title
        let clearMainText = vm.text?.replacingOccurrences(of: "\n", with: "", options: .literal, range: nil)
        self.detailTextLabel?.text = clearMainText
    }
}
