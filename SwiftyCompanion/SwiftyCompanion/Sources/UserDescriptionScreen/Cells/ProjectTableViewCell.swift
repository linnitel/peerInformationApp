//
//  ProjectTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Julia Martcenko on 17/08/2022.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

	internal var model: ProjectEntity?

	// MARK: Views
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = UIColor(named: "accentColor")
		label.font = .systemFont(ofSize: 14)
		label.textAlignment = .left
		label.numberOfLines = 0
		label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		return label
	}()

	private let statusLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.font = .systemFont(ofSize: 14)
		label.textAlignment = .right
		label.numberOfLines = 0
		label.setContentHuggingPriority(.defaultLow, for: .horizontal)
		return label
	}()

	private let markLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 14)
		label.textAlignment = .right
		label.numberOfLines = 0
		label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		return label
	}()

	// MARK: Init
	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		self.backgroundColor = .clear
		self.contentView.backgroundColor = .clear
		self.selectionStyle = .none

		self.contentView.addSubview(self.titleLabel)
		self.contentView.addSubview(self.markLabel)
		self.contentView.addSubview(self.statusLabel)
		NSLayoutConstraint.activate([
			self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
			self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
			self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -4),

			self.markLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
			self.markLabel.topAnchor.constraint(equalTo: self.titleLabel.topAnchor),

			self.statusLabel.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 16),
			self.statusLabel.trailingAnchor.constraint(equalTo: self.markLabel.leadingAnchor, constant: -16),
			self.statusLabel.topAnchor.constraint(equalTo: self.markLabel.topAnchor)
		])
	}

	@available(*, unavailable, message:"init is unavailable")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Overrides
	override func layoutSubviews() {
		super.layoutSubviews()

		if let model = model {
			self.titleLabel.text = model.name
			if let finalMark = model.finalMark {
				self.markLabel.text = String(finalMark)
				self.statusLabel.text = model.status.text
				self.markLabel.textColor = model.validated ? UIColor(named: "projectSuccess") : UIColor(named: "projectFailure")
			}
		}
	}

}
