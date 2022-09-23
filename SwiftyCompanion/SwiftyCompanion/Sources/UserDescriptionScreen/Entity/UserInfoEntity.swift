//
//  UserInfoEntity.swift
//  SwiftyCompanion
//
//  Created by Julia Martcenko on 17/08/2022.
//

import Foundation

struct UserInfoEntity {
	let email: String
	let login: String
	let firstName: String
	let lastName: String
	var imageURL: URL?
	let wallet: Int
	let correctionPoint: Int
	let cursuses: [CursusEntity]
	var activeCursusIndex: Int = 0
	var activeCursus: CursusEntity {
		self.cursuses[self.activeCursusIndex]
	}

	init(with model: UserDataModel) {
		self.email = model.email
		self.login = model.login
		self.firstName = model.firstName
		self.lastName = model.lastName
		if let imageURL = model.imageURL {
			self.imageURL = URL(string: imageURL)
		}
		self.wallet = model.wallet
		self.correctionPoint = model.correctionPoint

		self.cursuses = model.cursusUsers.map { CursusEntity(with: $0, projects: model.projectsUsers) }
	}

}


struct CursusEntity {
	let id: Int
	let level: Double
	let skills: [Skill]
	let name: String
	let projects: [ProjectEntity]

	init(with model: CursusUser, projects: [ProjectsUser]) {
		self.id = model.cursusID
		self.level = model.level
		self.skills = model.skills
		self.name = model.cursus.name
		let cursusProjects = projects.filter { $0.cursusIDS.first(where: { $0 == model.cursusID }) != nil }
		self.projects = cursusProjects.compactMap { ProjectEntity(with: $0) }
	}
}

struct ProjectEntity {
	let finalMark: Int?
	let status: Status
	let validated: Bool
	let name: String

	init(with model: ProjectsUser) {
		self.finalMark = model.finalMark
		self.status = Status(rawValue: model.status ?? "") ?? .other
		self.validated = model.validated ?? false
		self.name = model.project?.name ?? ""
	}
}


enum Status: String {
	case finished = "finished"
	case inProgress = "in_progress"
	case searchingAGroup = "searching_a_group"
	case creatingGroup = "creating_group"
	case other

	var text: String {
		switch self {
			case .finished:
				return "finished"
			case .inProgress:
				return "in progress"
			case .searchingAGroup:
				return "searching for a group"
			case .creatingGroup:
				return "creating a group"
			case .other:
				return ""
		}
	}
}
