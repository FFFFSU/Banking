//
//  Transaction.swift
//  Banking
//
//  Created by Nico Christian on 10/03/22.
//

import Foundation

struct Receipient: Codable {
    let accountNo: String
    let accountHolder: String
}

struct TransactionData: Codable {
    let transactionId: String
    let amount: Double
    let transactionDate: String
    let description: String?
    let transactionType: String
    let receipient: Receipient?
    let sender: Receipient?
}

struct Transaction: Codable {
    var status: String
    var data: [TransactionData]?
    var error: ErrorResponse?
}
