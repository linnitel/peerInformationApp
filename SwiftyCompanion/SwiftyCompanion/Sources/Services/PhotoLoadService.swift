//
//  PhotoLoadService.swift
//  SwiftyCompanion
//
//  Created by Julia Martcenko on 16/08/2022.
//

import UIKit

protocol PhotoLoadServiceProtocol {
	func loadPhoto(from url: URL?, completion: @escaping (Result<UIImage, Error>) -> ())
}

class PhotoLoadService: PhotoLoadServiceProtocol {

	func loadPhoto(from url: URL?, completion: @escaping (Result<UIImage, Error>) -> ()) {

		DispatchQueue.global().async {
			guard let url = url else {
				completion(.failure(SwiftyCompanionAppError.wrongURL))
				return
			}

			// make sure your image in this url does exist, otherwise
			// unwrap in a if let check / try-catch
			let data = try? Data(contentsOf: url)
			guard let data = data,
				  let image = UIImage(data: data) else {
				completion(.failure(SwiftyCompanionAppError.wrongURL))
				return
			}
			completion(.success(image))
		}
	}
}
