//
//  StockTimeSeries.swift
//  Pods
//
//  Created by Sourav Chandra on 13/11/18.
//

import Foundation

public enum StockTimeSeries {
    case intraday(interval: Interval)
    case daily
    case dailyAdjusted
    case weekly
    case weeklyAdjusted
    case monthly
    case monthlyAdjusted
    case quote
    case search

    public enum Interval {
        case one
        case five
        case fifteen
        case thirty
        case sixty

        var stringValue: String {
            switch self {
            case .one: return "1min"
            case .five: return "5min"
            case .fifteen: return "15min"
            case .thirty: return "30min"
            case .sixty: return "60min"
            }
        }
    }

    public enum OutputSize: String {
        case compact
        case full
    }

    enum DataType: String {
        case json
        case csv
    }

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

    var params: [String: String] {
        var defaultParams: [String: String] = [
            "function": function,
            "apikey": try! AVProvider.currentApiKey()
        ]
        switch self {
        case let .intraday(interval): defaultParams["interval"] = interval.stringValue
        default: break
        }
        return defaultParams
    }
}

extension StockTimeSeries {

    public func request(
        symbol: String,
        outputSize: OutputSize = .compact,
        handler: @escaping (StocksResponse) -> Void
        ) -> Disposable {
        var params = self.params
        params["symbol"] = symbol
        return NetworkManager.get(params: params, handler: handler)
    }

}

public struct StockData: Codable {
    public var metadata: [String: String]
    public var timeSeries: [String: [String: String]]
}

public struct StocksResponse: ResponseType {
    public var rawResponse: URLResponse?
    public var parsedResponse: AVResult<StockData, AVError>
}
