//
//  UserDescriptionViewController.swift
//  SwiftyCompanion
//
//  Created by Yuliya Martsenko on 22.02.2022.
//

import UIKit

class UserDescriptionViewController: UIViewController {

	// MARK: Cell Identifiers
	let projectCellId = "ProjectTableViewCell"
	let skillCellId = "SkillTableViewCell"
	let cursusCellId = "CursusCollectionViewCell"

	// MARK: Constants
	let buttonHeight: CGFloat = 24
	let imageHeight: CGFloat = 64

	// MARK: Data
	var userEntity: UserInfoEntity

	// MARK: Services
	let photoLoader: PhotoLoadServiceProtocol

	//MARK: Views
	private lazy var backButton: UIButton = {
		let button = UIButton()
		button.setTitle("X", for: .normal)
		button.backgroundColor = .white
		button.setTitleColor(.black, for: .normal)
		button.layer.cornerRadius = self.buttonHeight / 2
		button.layer.borderColor = UIColor.black.cgColor
		button.layer.borderWidth = 2
		button.addTarget(self, action: #selector(self.didTapBackButton), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private lazy var userImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerRadius = self.imageHeight / 2
		imageView.layer.masksToBounds = true
		imageView.layer.borderColor = UIColor.black.cgColor
		imageView.layer.borderWidth = 1
		return imageView
	}()

	private let userNickLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = UIColor(named: "accentColor")
		label.font = .systemFont(ofSize: 24)
		label.textAlignment = .right
		return label
	}()

	private let userNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.font = .systemFont(ofSize: 24)
		label.textAlignment = .right
		label.numberOfLines = 0
		return label
	}()

	private let walletLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = UIColor(named: "accentColor")
		label.font = .systemFont(ofSize: 12)
		label.textAlignment = .left
		return label
	}()

	private let correctionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.font = .systemFont(ofSize: 12)
		label.textAlignment = .left
		return label
	}()

	private let emailLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .gray
		label.font = .systemFont(ofSize: 12)
		label.textAlignment = .left
		return label
	}()

	private let levelLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = UIColor(named: "projectSuccess")
		label.font = .systemFont(ofSize: 24)
		label.textAlignment = .left
		label.numberOfLines = 0
		return label
	}()

	private lazy var cursusCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
//		layout.sectionInset = UIEdgeInsets(top: 4, left: 2, bottom: 4, right: 2)
		let width = (self.view.frame.width - 32.0 - CGFloat(12 * self.userEntity.cursuses.count)) / CGFloat(self.userEntity.cursuses.count)
		layout.itemSize = CGSize(width: width, height: 56)
		let view = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
		view.backgroundColor = .clear
		view.register(CursusCollectionViewCell.self, forCellWithReuseIdentifier: self.cursusCellId)
		view.translatesAutoresizingMaskIntoConstraints = false

		view.delegate = self
		view.dataSource = self

		return view
	}()
UIView

	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorColor = .clear
		tableView.backgroundColor = .clear
		tableView.tableFooterView?.backgroundColor = .clear
		tableView.showsVerticalScrollIndicator = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		tableView.estimatedRowHeight = 80
		tableView.rowHeight = UITableView.automaticDimension

		tableView.dataSource = self

		tableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: self.projectCellId)
		tableView.register(SkillTableViewCell.self, forCellReuseIdentifier: self.skillCellId)

		return tableView
	}()

	// MARK: Init
	init(userInfo: UserDataModel) {
		self.userEntity = UserInfoEntity(with: userInfo)
		self.photoLoader = PhotoLoadService()

		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable, message:"init is unavailable")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		self.view.backgroundColor = .white

		self.getImage(from: self.userEntity.imageURL)
		self.userNickLabel.text = self.userEntity.login
		self.userNameLabel.text = "\(self.userEntity.firstName) \(self.userEntity.lastName)"
		self.walletLabel.text = "Wallet: \(self.userEntity.wallet)₳"
		self.correctionLabel.text = "Evaluation points: \(self.userEntity.correctionPoint)"
		self.emailLabel.text = self.userEntity.email
		self.levelLabel.text = String(format: "lvl %.2f", self.userEntity.activeCursus.level)


		self.view.addSubview(self.backButton)
		self.view.addSubview(self.userImageView)
		self.view.addSubview(self.userNickLabel)
		self.view.addSubview(self.userNameLabel)
		self.view.addSubview(self.walletLabel)
		self.view.addSubview(self.correctionLabel)
		self.view.addSubview(self.emailLabel)
		self.view.addSubview(self.levelLabel)
		self.view.addSubview(self.cursusCollectionView)
		self.view.addSubview(self.tableView)
		NSLayoutConstraint.activate([
			self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
			self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
			self.backButton.heightAnchor.constraint(equalToConstant: self.buttonHeight),
			self.backButton.widthAnchor.constraint(equalToConstant: self.buttonHeight),

			self.userImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
			self.userImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
			self.userImageView.heightAnchor.constraint(equalToConstant: self.imageHeight),
			self.userImageView.widthAnchor.constraint(equalToConstant: self.imageHeight),

			self.userNickLabel.trailingAnchor.constraint(equalTo: self.userImageView.leadingAnchor, constant: -8),
			self.userNickLabel.topAnchor.constraint(equalTo: self.userImageView.topAnchor),

			self.userNameLabel.trailingAnchor.constraint(equalTo: self.userNickLabel.trailingAnchor),
			self.userNameLabel.topAnchor.constraint(equalTo: self.userNickLabel.bottomAnchor, constant: 4),

			self.walletLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
			self.walletLabel.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 8),

			self.correctionLabel.leadingAnchor.constraint(equalTo: self.walletLabel.leadingAnchor),
			self.correctionLabel.topAnchor.constraint(equalTo: self.walletLabel.bottomAnchor, constant: 8),

			self.levelLabel.bottomAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor),
			self.levelLabel.leadingAnchor.constraint(equalTo: self.walletLabel.leadingAnchor),
			self.levelLabel.trailingAnchor.constraint(equalTo: self.userNameLabel.leadingAnchor, constant: -4),

			self.emailLabel.topAnchor.constraint(equalTo: self.walletLabel.topAnchor),
			self.emailLabel.trailingAnchor.constraint(equalTo: self.userImageView.trailingAnchor),

			self.cursusCollectionView.topAnchor.constraint(equalTo: self.correctionLabel.bottomAnchor, constant: 16),
			self.cursusCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
			self.cursusCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
			self.cursusCollectionView.heightAnchor.constraint(equalToConstant: 70),

			self.tableView.topAnchor.constraint(equalTo: self.cursusCollectionView.bottomAnchor, constant: 4),
			self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)

		])
    }

	private func getImage(from url: URL?) {
		self.photoLoader.loadPhoto(from: url) { result in
			DispatchQueue.main.async {
				switch result {
					case .success(let image):
						self.userImageView.image = image
						print("Image fetched")
					case .failure(let error):
						print(error.localizedDescription)
				}
			}
		}
	}

	@objc func didTapBackButton() {
		self.navigationController?.popViewController(animated: true)
	}
}

extension UserDescriptionViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.userEntity.activeCursus.skills.count + self.userEntity.activeCursus.projects.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let skillsCount = self.userEntity.activeCursus.skills.count

		if indexPath.row < skillsCount {
			let cell = self.tableView.dequeueReusableCell(withIdentifier: self.skillCellId, for: indexPath)
			guard let skillsCell = cell as? SkillTableViewCell else { return cell }
			skillsCell.model = self.userEntity.activeCursus.skills[indexPath.row]
			return skillsCell
		}

		let cell = self.tableView.dequeueReusableCell(withIdentifier: self.projectCellId, for: indexPath)
		guard let projectCell = cell as? ProjectTableViewCell else { return cell }
		projectCell.model = self.userEntity.activeCursus.projects[indexPath.row - skillsCount]
		return projectCell
	}
}

extension UserDescriptionViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.userEntity.activeCursusIndex = indexPath.row
		self.levelLabel.text = String(format: "lvl %.2f", self.userEntity.activeCursus.level)
		self.cursusCollectionView.visibleCells.indices.forEach { [weak self] index in
			guard let self = self else { return }
			if let cursusCell = self.cursusCollectionView.visibleCells[index] as? CursusCollectionViewCell {
				cursusCell.selectedState = index == indexPath.row
			}
		}
		self.cursusCollectionView.reloadData()
		self.tableView.reloadData()
	}
}

extension UserDescriptionViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		self.userEntity.cursuses.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = self.cursusCollectionView.dequeueReusableCell(withReuseIdentifier: self.cursusCellId, for: indexPath)
		if let cursusCell = cell as? CursusCollectionViewCell {
			cursusCell.titleLabel.text = self.userEntity.cursuses[indexPath.row].name
			cursusCell.selectedState = self.userEntity.activeCursusIndex == indexPath.row
			return cursusCell
		}
		return cell
	}
}

