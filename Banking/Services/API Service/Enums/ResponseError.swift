//
//  ResponseError.swift
//  Banking
//
//  Created by Nico Christian on 09/03/22.
//

import Foundation

enum LoginError: String {
    case userNotFound = "user not found"
    case invalidLoginCredential = "invalid login credential"
}
