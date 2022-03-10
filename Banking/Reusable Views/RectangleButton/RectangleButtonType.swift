//
//  RectangleButtonType.swift
//  Banking
//
//  Created by Nico Christian on 09/03/22.
//

import Foundation
import UIKit

enum RectangleButtonType {
    case login
    case registerPrimary
    case registerSecondary
    case makeTransfer
    case transferNow
    
    func getTitle() -> String {
        switch self {
        case .login:
            return "Login"
        case .registerPrimary, .registerSecondary:
            return "Register"
        case .makeTransfer:
            return "Make Transfer"
        case .transferNow:
            return "Transfer Now"
        }
    }
    
    func getBackgroundColor() -> UIColor {
        switch self {
        case .login, .registerPrimary, .makeTransfer, .transferNow:
            return .systemBlue
        case .registerSecondary:
            return .white
        }
    }
    
    func getTintColor() -> UIColor {
        switch self {
        case .login, .registerPrimary, .makeTransfer, .transferNow:
            return .white
        case .registerSecondary:
            return .systemBlue
        }
    }
    
    func getBorderWidth() -> CGFloat {
        switch self {
        case .login, .registerPrimary, .makeTransfer, .transferNow:
            return 0
        case .registerSecondary:
            return 1
        }
    }
    
    func getBorderColor() -> UIColor {
        switch self {
        case .login, .registerPrimary, .makeTransfer, .transferNow:
            return .clear
        case .registerSecondary:
            return .systemBlue
        }
    }
}
