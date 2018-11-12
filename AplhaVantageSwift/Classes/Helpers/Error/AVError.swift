//
//  AVError.swift
//  AplhaVantageSwift-iOS
//
//  Created by Sourav Chandra on 13/11/18.
//

import Foundation

public enum AVError: Error, CustomNSError {
    case missingApiKey
    case requestFailed(message: String?)
    case generalError(error: NSError)

    public var errorCode: Int {
        switch self {
        case .missingApiKey: return 1001
        case .requestFailed: return 1002
        case let .generalError(error): return error.code
        }
    }

    public var localizedDescription: String {
        switch self {
        case .missingApiKey: return "API key is missing please initialize properly"
        case let .requestFailed(message): return message ?? "Request Failed"
        case let .generalError(error): return error.localizedDescription
        }
    }

    public var errorUserInfo: [String : Any] {
        return [
            NSLocalizedDescriptionKey: localizedDescription
        ]
    }
}
