import UIKit

protocol INoteScreenView: AnyObject {
    var noteText: String { get }
    func update(_ vm: NoteScreenViewModel)
}

final class NoteScreenView: UIView {
    private lazy var textView: UITextView = {
        var view = UITextView()
        view.backgroundColor = .secondarySystemBackground
        view.font = UIFont.systemFont(ofSize: 16)
        view.tintColor = UIColor.mainRed
        view.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        view.keyboardDismissMode = .interactive
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
        return view
    }()

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubviews()
        self.makeConstraints()
        self.setObservers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.clearObservers()
    }
}

extension NoteScreenView: INoteScreenView {
    func update(_ vm: NoteScreenViewModel) {
        if vm.isEditMode == false {
            textView.becomeFirstResponder()
        } else {
            let attributedText = NSMutableAttributedString(string: "\(vm.mainText)",
                                                           attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)])
            let titleBold = NSMutableAttributedString(string: vm.title,
                                                      attributes: [.font: UIFont.boldSystemFont(ofSize: 18)])
            attributedText.insert(titleBold, at: 0)
            textView.attributedText = attributedText
        }
    }

    var noteText: String {
        return self.textView.text
    }
}

private extension NoteScreenView {
    func addSubviews() {
        self.addSubview(self.textView)
    }

    private func makeConstraints() {
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.textView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.textView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor)
        ])
    }

    func setObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    func clearObservers() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func updateTextView(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            self.textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        }
    }
}
