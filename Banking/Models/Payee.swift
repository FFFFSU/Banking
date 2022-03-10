//
//  Payees.swift
//  Banking
//
//  Created by Nico Christian on 10/03/22.
//

import Foundation

struct PayeeData: Codable {
    var id: String
    var name: String
    var accountNo: String
}

struct Payee: Codable {
    var status: String
    var data: [PayeeData]?
    var error: ErrorResponse?
}
