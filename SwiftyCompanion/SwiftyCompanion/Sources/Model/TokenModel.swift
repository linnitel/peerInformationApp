//
//  AuthorizationModel.swift
//  SwiftyCompanion
//
//  Created by Yuliya Martsenko on 10.03.2022.
//

import Foundation


//	"access_token":"42804d1f2480c240f94d8f24b45b318e4bf42e742f0c06a42c6f4242787af42d",
//	"token_type":"bearer",
//	"expires_in":7200,
//	"scope":"public",
//	"created_at":1443451918

struct TokenModel: Codable {
    var token: String
	var tokenType: String
	var expiresIn: Int
	var scope: String
	var createdAt: Int

	enum CodingKeys: String, CodingKey {
		case token = "access_token"
		case tokenType = "token_type"
		case expiresIn = "expires_in"
		case scope
		case createdAt = "created_at"
	}
}

// {"resource_owner_id":74,"scopes":["public"],"expires_in_seconds":7174,"application":{"uid":"3089cd94d72cc9109800a5eea5218ed4c3e891ec1784874944225878b95867f9"},"created_at":1439460680}%

// MARK: - TokenInformationModel
struct TokenInformationModel: Codable {
	let resourceOwnerID: Int
	let scopes: [String]
	let expiresInSeconds: Int
	let application: Application
	let createdAt: Int

	enum CodingKeys: String, CodingKey {
		case resourceOwnerID = "resource_owner_id"
		case scopes
		case expiresInSeconds = "expires_in_seconds"
		case application
		case createdAt = "created_at"
	}
}

// MARK: - Application
struct Application: Codable {
	let uid: String
}
