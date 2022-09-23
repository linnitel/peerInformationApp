//
//  RequestModel.swift
//  SwiftyCompanion
//
//  Created by Julia Martcenko on 15/08/2022.
//

import Foundation

struct RequestModel {
	var header: String
	var path: String
	var uid: String
	var secret: String
	var redirect: String
	var requestMethod: String = "POST"

}


