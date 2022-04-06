//
//  Extension.swift
//  Banking
//
//  Created by Nico Christian on 09/03/22.
//

import Foundation

extension NSObject {
    class var identifier: String {
        return String(describing: self)
    }
}

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}

extension String {
    var iso8601withFractionalSeconds: Date { return Formatter.iso8601withFractionalSeconds.date(from: self)! }
}
                    

extension Date {
    func removeTimeStamp() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self))!
    }
    
    func dashboardFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: self)
    }
}
