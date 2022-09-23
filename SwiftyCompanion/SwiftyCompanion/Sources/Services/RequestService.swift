//
//  TokenRequestService.swift
//  SwiftyCompanion
//
//  Created by Yuliya Martsenko on 23.02.2022.
//

import Foundation
import AuthenticationServices

/// Delegate object for ViewControllerInteractor
protocol ViewControllerInteractorDelegate: ASWebAuthenticationPresentationContextProviding {

	/// Show default AlertViewController with given message
	func showErrorWith(message: String)
}

protocol RequestServiceProtocol: AnyObject {
	var delegate: ViewControllerInteractorDelegate? { get set }

    func requestToken(completion: (() -> Void)?)
	func getLoginInfo(login: String, completion: ((UserDataModel) -> Void)?)
}

final class RequestService: RequestServiceProtocol {
    
	var request = RequestModel(
		header: "https://api.intra.42.fr",
		path: "/oauth/token",
		uid: "4d266237ee6c6e8a4ed08c3677204f068abebaafc0a1348d2931a16a14b37e79",
		secret: "fea1889722a34278885d98e2c46ae72d81b689ad8e231672e21b467e4134ce00",
		redirect: "https://api.intra.42.fr/oauth/authorize?client_id=4d266237ee6c6e8a4ed08c3677204f068abebaafc0a1348d2931a16a14b37e79&redirect_uri=rush00App%3A%2F%2Frush00App&response_type=code"
	)
	var authorizationData: TokenModel?

	var tokenActive: Bool {
		if let tokenData = authorizationData {
			return Double(tokenData.createdAt + tokenData.expiresIn) > Date().timeIntervalSince1970
		}
		return false
	}

	public weak var delegate: ViewControllerInteractorDelegate?
    
    func requestToken(completion: (() -> Void)?) {
		guard let url = URL(string: self.request.header + self.request.path) else {
			self.delegate?.showErrorWith(message: SwiftyCompanionAppError.wrongToken.localizedDescription)
			return
		}
		var request = URLRequest(url: url)
		request.httpBody = "grant_type=client_credentials&client_id=\(self.request.uid)&client_secret=\(self.request.secret)".data(using: .utf8)
		request.httpMethod = self.request.requestMethod

		URLSession.shared.dataTask(with: request) { tokenData, _, _ in
			if let tokenData = tokenData,
			   let jsonObject = try? JSONDecoder().decode(TokenModel.self, from: tokenData) {
				self.authorizationData = jsonObject
				completion?()
				return
			} else {
				self.delegate?.showErrorWith(message: SwiftyCompanionAppError.wrongToken.localizedDescription)
			}
		}.resume()
	}

	private func createRequest(token: String, requestURL: URL, method: String) -> URLRequest {
		let bearer = "Bearer " + token
		var request = URLRequest(url: requestURL)
		request.setValue(bearer, forHTTPHeaderField: "Authorization")
		request.httpMethod = method
		return request
	}

	private func checkToken(completion: (() -> Void)?) {
		guard let url = URL(string: self.request.header + "/oauth/token/info") else {
			return
		}

		if let token = self.authorizationData?.token {
			let request = self.createRequest(token: token, requestURL: url, method: "GET")

			URLSession.shared.dataTask(with: request) { tokenInfo, _, _ in
				if let tokenInfo = tokenInfo,
				   let _ = try? JSONDecoder().decode(TokenInformationModel.self, from: tokenInfo) {
					completion?()
					return
				} else {
					self.requestToken(completion: completion)
				}
			}.resume()
		}
		self.requestToken(completion: completion)
	}

	private func performRequest(to path: String, with params: [String: String], completion: (() -> Void)?) {
		if !tokenActive {
			self.requestToken {
				self.performRequest(to: path, with: params, completion: completion)
			}
		}
		completion?()
	}

	func getLoginInfo(login: String, completion: ((UserDataModel) -> Void)?) {
		guard !login.isEmpty else { return }
		guard let url = URL(string: self.request.header + "/v2/users/\(login)") else {
			self.delegate?.showErrorWith(message: SwiftyCompanionAppError.noUser.localizedDescription)
			return
		}
		guard let token = self.authorizationData?.token else {
			self.requestToken(completion: nil)
			return
		}
		let request = self.createRequest(token: token, requestURL: url, method: "GET")

		URLSession.shared.dataTask(with: request) { userData, _, _ in
			if let userData = userData,
			   let jsonObject = try? JSONDecoder().decode(UserDataModel.self, from: userData) {
				completion?(jsonObject)
				return
			} else {
				self.delegate?.showErrorWith(message: SwiftyCompanionAppError.noUser.localizedDescription)
			}
		}.resume()
	}
}
