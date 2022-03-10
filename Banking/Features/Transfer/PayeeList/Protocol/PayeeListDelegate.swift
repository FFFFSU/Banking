//
//  PayeeListProtocol.swift
//  Banking
//
//  Created by Nico Christian on 10/03/22.
//

import Foundation

protocol PayeeListDelegate {
    func didSelectPayee(_ payee: PayeeData)
}
