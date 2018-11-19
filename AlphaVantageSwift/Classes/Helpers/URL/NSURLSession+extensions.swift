//
//  NSURLSession+extensions.swift
//  Pods
//
//  Created by Sourav Chandra on 13/11/18.
//

import Foundation

public enum AVResult<T, U: Error> {
    case success(T)
    case failure(U)
}

protocol RawInitializable {
    init(data: Data, identifier: Identifiable) throws
}

protocol ResponseType {

    associatedtype Response: RawInitializable

    var rawResponse: URLResponse? { get }
    var parsedResponse: AVResult<Response, AVError> { get }

    init(rawResponse: URLResponse?, parsedResponse: AVResult<Response, AVError>)
}

extension ResponseType {
    static func success(rawResponse: URLResponse?, parsedResponse: Response) -> Self {
        return Self.init(rawResponse: rawResponse, parsedResponse: .success(parsedResponse))
    }

    static func failure(rawResponse: URLResponse?, message: String) -> Self {
        return Self.init(rawResponse: rawResponse, parsedResponse: .failure(.requestFailed(message: message)))
    }

    static func failure(rawResponse: URLResponse?, error: NSError) -> Self {
        return Self.init(rawResponse: rawResponse, parsedResponse: .failure(.generalError(error: error)))
    }
}


class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    func get<Response: ResponseType>(
        params: [String: String],
        identifier: Identifiable,
        handler: @escaping (_ response: Response) -> Void
        ) -> Callable {
        return URLSession.shared.dataTask(with: API.base.url(with: params)) { (data, urlResponse, error) in
            guard let data = data else {
                let errorMessage = error?.localizedDescription ?? "Could not send the network request"
                let response = Response.failure(rawResponse: urlResponse, message: errorMessage)
                handler(response)
                return
            }

            do {
                let parsedData = try Response.Response.init(data: data, identifier: identifier)
                let response = Response.success(rawResponse: urlResponse, parsedResponse: parsedData)
                handler(response)
                return
            } catch {
                let response = Response.failure(rawResponse: urlResponse, message: error.localizedDescription)
                handler(response)
            }
        }
    }

}
