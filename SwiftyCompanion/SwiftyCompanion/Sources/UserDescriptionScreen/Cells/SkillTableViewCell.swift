//
//  SkillTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Julia Martcenko on 17/08/2022.
//

import UIKit

class SkillTableViewCell: UITableViewCell {

	private let maxSkillLevel: Double = 20

	//MARK: Data Model
	internal var model: Skill? { didSet { self.setNeedsLayout() } }

	// MARK: Views
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .gray
		label.font = .systemFont(ofSize: 14)
		label.textAlignment = .left
		label.numberOfLines = 0
		return label
	}()

	private let progressBar: SkillProgressBar = {
		let bar = SkillProgressBar()
		bar.translatesAutoresizingMaskIntoConstraints = false
		return bar
	}()

	private let separator: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	// MARK: Init
	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		self.backgroundColor = .clear
		self.contentView.backgroundColor = .clear
		self.selectionStyle = .none

		self.contentView.addSubview(self.titleLabel)
		self.contentView.addSubview(self.progressBar)
		self.contentView.addSubview(self.separator)
		NSLayoutConstraint.activate([
			self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
			self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
			self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -4),

			self.progressBar.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 8),
			self.progressBar.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
			self.progressBar.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
			self.progressBar.heightAnchor.constraint(equalToConstant: 32),
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
			self.progressBar.progress = model.level
		}
	}
}
