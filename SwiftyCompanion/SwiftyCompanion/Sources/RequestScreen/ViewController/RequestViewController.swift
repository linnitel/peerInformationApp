import UIKit
import Alamofire
import AuthenticationServices

class RequestViewController: UIViewController {
    
    var tokenRequestService: RequestServiceProtocol?
    
    lazy var search: UITextField = {
        let view  = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 3.0
        view.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        view.layer.cornerRadius = 8.0
        view.backgroundColor = .lightGray
        view.placeholder = "Enter peer nickname:"
        view.textAlignment = .center
        view.becomeFirstResponder()
		view.autocorrectionType = .no
		view.autocapitalizationType = .none
		view.spellCheckingType = .no
        view.delegate = self
        view.returnKeyType = UIReturnKeyType.search
        let endAction = UIAction { [weak self] _ in
            guard let self = self,
                  let text = self.search.text else {
                return
            }
			self.tokenRequestService?.getLoginInfo(login: text) { userInfo in
				DispatchQueue.main.async {
					let controller = UserDescriptionViewController(userInfo: userInfo)
					self.navigationController?.pushViewController(controller, animated: true)
				}
			}
            view.resignFirstResponder()
        }
        view.addAction(endAction, for: .editingDidEnd)
        return view
    }()

	lazy var errorPopup: ErrorPopUpView = {
		let popUp = ErrorPopUpView()
		popUp.translatesAutoresizingMaskIntoConstraints = false
		popUp.isHidden = true
		return popUp
	}()
    
    private func setupNavigationBar() {
		self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
			self.search.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
			self.search.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.search.heightAnchor.constraint(equalToConstant: 50),
			self.search.widthAnchor.constraint(equalToConstant: 250),

			self.errorPopup.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
			self.errorPopup.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.errorPopup.widthAnchor.constraint(equalToConstant: 350),
			self.errorPopup.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
		if !self.errorPopup.isHidden {
			self.errorPopup.isHidden = true
			self.search.text = ""
			self.search.becomeFirstResponder()
		} else {
			self.search.resignFirstResponder()
		}
    }
    
    private func setupView() {
        if let image = UIImage(named: "backgroundImage.png") {
			self.view.backgroundColor = UIColor(patternImage: image)
        } else {
			self.view.backgroundColor = .green
        }
		self.view.addSubview(self.search)
		self.view.addSubview(self.errorPopup)
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissKeyboard (_:)))
		self.view.addGestureRecognizer(tapGesture)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		self.tokenRequestService = RequestService()
		self.tokenRequestService?.delegate = self
		self.tokenRequestService?.requestToken(completion: nil) // add showing alert with error message
		self.setupNavigationBar()
		self.setupView()
		self.setupConstraints()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.search.text = ""
		self.search.becomeFirstResponder()
	}
}

extension RequestViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.search.resignFirstResponder()
        return true
    }
}

extension RequestViewController: ViewControllerInteractorDelegate {
	func showErrorWith(message: String) {
		DispatchQueue.main.async {
			self.search.resignFirstResponder()
			self.errorPopup.titleLabel.text = message
			self.errorPopup.isHidden = false
			self.view.setNeedsLayout()
		}
	}

	func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
		return ASPresentationAnchor()
	}
}
