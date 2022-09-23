//
//  ErrorPopUpView.swift
//  SwiftyCompanion
//
//  Created by Julia Martcenko on 14/09/2022.
//

import UIKit

class ErrorPopUpView: UIView {

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = UIColor(named: "projectFailure")
		label.font = .systemFont(ofSize: 22)
		label.textAlignment = .center
		label.numberOfLines = 0
		label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		return label
	}()

	// MARK: Init
	@available(*, unavailable, message:"init is unavailable")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)

		self.backgroundColor = .lightGray
		self.layer.borderWidth = 2
		self.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
		self.layer.cornerRadius = 16
		self.layer.masksToBounds = true

		self.addSubview(self.titleLabel)
		NSLayoutConstraint.activate([
			self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
			self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
		])
	}
}
