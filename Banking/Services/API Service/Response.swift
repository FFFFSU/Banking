//
//  ResponseModel.swift
//  Banking
//
//  Created by Nico Christian on 09/03/22.
//

import Foundation

struct AuthenticationResponse: Codable {
    var status: String
    var token: String?
    var username: String?
    var accountNo: String?
    var error: String?
}

struct ErrorResponse: Codable {
    var name: String?
    var message: String?
    var expiredAt: String?
}

struct BalanceResponse: Codable {
    var status: String
    var accountNo: String?
    var balance: Double?
    var error: ErrorResponse?
}

struct TransferResponse: Codable {
    var status: String
    var transactionId: String?
    var amount: Double?
    var description: String?
    var recipientAccount: String?
    var error: String?
}
