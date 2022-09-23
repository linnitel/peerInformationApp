//
//  SkillProgressBar.swift
//  SwiftyCompanion
//
//  Created by Julia Martcenko on 17/08/2022.
//

import UIKit

class SkillProgressBar: UIView {

	private let progressViewHeight: CGFloat = 8

	public var progress: CGFloat = 0.0 { didSet { self.setNeedsLayout() } }
	public var maxProgress: CGFloat = 20.0 { didSet { self.setNeedsLayout() } }

	private var progressRatio: CGFloat {
		self.progress / self.maxProgress
	}

	private var markerLeftConstraint: NSLayoutConstraint?

	// MARK: Views
	public lazy var progressView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(named: "accentColor")
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = self.progressViewHeight / 2
		return view
	}()

	private lazy var progressMarker: UIView = {
		let view = UIView()
		view.backgroundColor = .black
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private lazy var progressLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .gray
		label.font = .systemFont(ofSize: 10)
		label.textAlignment = .left
		return label
	}()

	// MARK: Init
	@available(*, unavailable, message:"init is unavailable")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)

		self.addSubview(self.progressView)
		self.addSubview(self.progressMarker)
		self.addSubview(self.progressLabel)


		let constraint = self.progressMarker.leadingAnchor.constraint(equalTo: self.progressView.leadingAnchor)
		self.markerLeftConstraint = constraint
		NSLayoutConstraint.activate([
			self.progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			self.progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			self.progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
			self.progressView.heightAnchor.constraint(equalToConstant: 8),

			constraint,
			self.progressMarker.topAnchor.constraint(equalTo: self.topAnchor),
			self.progressMarker.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			self.progressMarker.widthAnchor.constraint(equalToConstant: 2),

			self.progressLabel.leadingAnchor.constraint(equalTo: self.progressMarker.trailingAnchor, constant: 4),
			self.progressLabel.topAnchor.constraint(equalTo: self.progressMarker.topAnchor, constant: 2)
		])
	}

	override public func layoutSubviews() {
		super.layoutSubviews()

		self.progressLabel.text = String(format: "%.2f", self.progress)
		self.markerLeftConstraint?.constant = self.frame.width * self.progressRatio
	}
}
