//
//  CursusCollectionViewCell.swift
//  SwiftyCompanion
//
//  Created by Julia Martcenko on 17/08/2022.
//

import UIKit

class CursusCollectionViewCell: UICollectionViewCell {

	// MARK: Views
	public let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.font = .systemFont(ofSize: 14)
		label.textAlignment = .center
		label.numberOfLines = 0
		return label
	}()

	public var selectedState: Bool = false { didSet { self.setNeedsLayout() } }

	// MARK: Init
	override init(frame: CGRect) {
		super.init(frame: frame)

		self.backgroundColor = .clear
		self.contentView.layer.cornerRadius = 16

		self.contentView.addSubview(self.titleLabel)
		NSLayoutConstraint.activate([
			self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
			self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 2),
			self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -2)
		])
	}

	@available(*, unavailable, message:"init is unavailable")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		self.contentView.backgroundColor = self.selectedState ? UIColor(named: "projectFailure") : UIColor(named: "accentColor")
	}

	override var isSelected: Bool { didSet { self.setNeedsLayout() } }
}
