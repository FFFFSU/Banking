//
//  Transaction.swift
//  Banking
//
//  Created by Nico Christian on 10/03/22.
//

import Foundation

struct Recipient: Codable {
    let accountNo: String
    let accountHolder: String
}

struct TransactionData: Codable {
    let transactionId: String
    let amount: Double
    let transactionDate: String
    let description: String?
    let transactionType: String
    let receipient: Recipient
}

struct Transaction: Codable {
    var status: String
    var data: [TransactionData]?
    var error: ErrorResponse?
}
