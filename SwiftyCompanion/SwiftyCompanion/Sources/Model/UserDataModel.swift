//
//  UserDataModel.swift
//  SwiftyCompanion
//
//  Created by Julia Martcenko on 15/08/2022.
//

import Foundation

// MARK: - UserDataModel
struct UserDataModel: Codable {
	let email: String
	let login: String
	let firstName: String
	let lastName: String
	let imageURL: String?
	let wallet: Int
	let correctionPoint: Int
	let projectsUsers: [ProjectsUser]
	let cursusUsers: [CursusUser]

	enum CodingKeys: String, CodingKey {
		case email
		case login
		case firstName = "first_name"
		case lastName = "last_name"
		case imageURL = "image_url"
		case wallet
		case correctionPoint = "correction_point"
		case projectsUsers = "projects_users"
		case cursusUsers = "cursus_users"
	}
}

// MARK: - ProjectsUser
struct ProjectsUser: Codable {
	let id, occurrence: Int?
	let finalMark: Int?
	let status: String?
	let validated: Bool?
	let currentTeamID: Int?
	let project: Project?
	let cursusIDS: [Int]
	let markedAt: String?
	let marked: Bool?
	let retriableAt: String?

	enum CodingKeys: String, CodingKey {
		case id, occurrence
		case finalMark = "final_mark"
		case status
		case validated = "validated?"
		case currentTeamID = "current_team_id"
		case project
		case cursusIDS = "cursus_ids"
		case markedAt = "marked_at"
		case marked
		case retriableAt = "retriable_at"
	}
}

// MARK: - Project
struct Project: Codable {
	let name: String
}

// MARK: - CursusUser
struct CursusUser: Codable {
	let grade: String?
	let level: Double
	let skills: [Skill]
	let cursusID: Int
	let cursus: Cursus

	enum CodingKeys: String, CodingKey {
		case grade, level, skills
		case cursusID = "cursus_id"
		case cursus
	}
}

// MARK: - Cursus
struct Cursus: Codable {
	let name: String
}

// MARK: - Skill
struct Skill: Codable {
	let name: String
	let level: Double
}
