//
//  Date+extensions.swift
//  Pods
//
//  Created by Sourav Chandra on 20/11/18.
//

import Foundation

extension Date {
    static func fromTimeSeries(_ string: String) throws -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        guard let date = formatter.date(from: string) else { throw AVError.parsingFailed(message: "Could not parse the date \(string)") }
        return date
    }
}
