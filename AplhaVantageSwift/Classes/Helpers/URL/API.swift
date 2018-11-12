//
//  APIUrl.swift
//  Pods
//
//  Created by Sourav Chandra on 13/11/18.
//

import Foundation

enum API {
    case base

    var urlString: String {
        switch self {
        case .base: return "https://www.alphavantage.co/query"
        }
    }

    var url: URL {
        return URL(string: urlString)!
    }

    func url(with params: [String: String]) -> URL {
        let paramString = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        let finalString = "\(urlString)?\(paramString)"
        return URL(string: finalString)!
    }
}
