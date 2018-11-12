//
//  StockTimeSeries.swift
//  Pods
//
//  Created by Sourav Chandra on 13/11/18.
//

import Foundation

enum StockTimeSeries {
    case intraday
    case daily
    case dailyAdjusted
    case weekly
    case weeklyAdjusted
    case monthly
    case monthlyAdjusted
    case quote
    case search

    var function: String {
        switch self {
        case .intraday: return "TIME_SERIES_INTRADAY"
        case .daily: return "TIME_SERIES_DAILY"
        case .dailyAdjusted: return "TIME_SERIES_DAILY_ADJUSTED"
        case .monthly: return "TIME_SERIES_MONTHLY"
        case .monthlyAdjusted: return "TIME_SERIES_MONTHLY"
        case .weekly: return "TIME_SERIES_WEEKLY"
        case .weeklyAdjusted: return "TIME_SERIES_WEEKLY_ADJUSTED"
        case .quote: return "GLOBAL_QUOTE"
        case .search: return "SYMBOL_SEARCH"
        }
    }
}
