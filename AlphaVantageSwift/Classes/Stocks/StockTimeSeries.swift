//
//  StockTimeSeries.swift
//  Pods
//
//  Created by Sourav Chandra on 13/11/18.
//

import Foundation

protocol Identifiable {
    var keyName: String { get }
}

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
        ) -> Callable {
        var params = self.params
        params["symbol"] = symbol
        return NetworkManager.shared.get(params: params, identifier: self, handler: handler)
    }

}

extension StockTimeSeries: Identifiable {
    var keyName: String {
        switch self {
        case .daily, .dailyAdjusted: return "Time Series (Daily)"
        case .weeklyAdjusted: return "Weekly Adjusted Time Series"
        case .weekly: return "Weekly Time Series"
        case .monthly: return "Monthly Time Series"
        case .monthlyAdjusted: return "Monthly Adjust Time Series"

        case .intraday(let interval): return "Time Series (\(interval.stringValue))"
        default: return ""
        }
    }
}

public struct StockData: RawInitializable {

    public struct SeriesData {
        public let volume: Double
        public let low: Double
        public let high: Double
        public let close: Double
        public let open: Double

        init(dictionaryValue: [String: Double]) {
            let dictionaryValue = dictionaryValue.mapKeys { $0.trimmingCharacters(in: CharacterSet(charactersIn: String($0.split(separator: " ").first!))).trimmingCharacters(in: .whitespacesAndNewlines) }
            volume = dictionaryValue["volume"]!
            low = dictionaryValue["low"]!
            high = dictionaryValue["high"]!
            close = dictionaryValue["close"]!
            open = dictionaryValue["open"]!
        }
    }

    public var metadata: [String: String]
    public var timeSeries: [Date: SeriesData]

    init(data: Data, identifier: Identifiable) throws {
        let dictionaryValue = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let dictData = dictionaryValue as? [String: Any] else { throw AVError.parsingFailed(message: "Bad response") }

        guard let metadata = dictData["Meta Data"] as? [String: String] else { throw AVError.parsingFailed(message: "Could not parse meta data")  }
        self.metadata = metadata

        guard let timeSeries = dictData[identifier.keyName] as? [String: [String: String]] else { throw AVError.parsingFailed(message: "Could not parse the time series") }
        self.timeSeries = try timeSeries.reduce([:]) {
            let date = try Date.fromTimeSeries($1.key)
            var mutable = $0
            mutable[date] = SeriesData(dictionaryValue: $1.value.mapValues { Double($0)! })
            return mutable
        }
    }
}

public struct StocksResponse: ResponseType {
    public var rawResponse: URLResponse?
    public var parsedResponse: AVResult<StockData, AVError>
}
