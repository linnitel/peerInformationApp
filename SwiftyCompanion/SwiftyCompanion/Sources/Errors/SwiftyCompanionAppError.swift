//
//  SwiftyCompanionAppError.swift
//  SwiftyCompanion
//
//  Created by Yuliya Martsenko on 11.03.2022.
//

import Foundation

enum SwiftyCompanionAppError: LocalizedError {
	case wrongToken
	case noSession
	case noUser
	case wrongURL

	public var errorDescription: String? {
		switch self {
			case .wrongToken:
				return "Can't fetch token"
			case .noSession:
				return "Can't open OAUTH Authentication Session"
			case .noUser:
				return "User with this login doesn't exist"
			case .wrongURL:
				return "The image doesn't exist"
		}
	}
}
