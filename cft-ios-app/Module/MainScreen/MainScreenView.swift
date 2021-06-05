import UIKit

final class MainScreenView: UIView {
    fileprivate(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        self.addSubviews()
        self.makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainScreenView {
    func addSubviews() {
        self.addSubview(self.tableView)
    }

    private func makeConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}
