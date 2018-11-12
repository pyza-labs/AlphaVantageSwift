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

protocol ResponseType {

    associatedtype Response: Codable

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

public class Disposable {

    typealias DisposeBlockType = () -> Void

    private let disposeBlock: DisposeBlockType

    init( _ disposeBlock: @escaping DisposeBlockType) {
        self.disposeBlock = disposeBlock
    }

    fileprivate func dispose() {
        disposeBlock()
    }

    public func disposed(by disposeBag: DisposeBag) {
        disposeBag.addToDisposeBag(disposable: self)
    }
}

public class DisposeBag {
    private var disposables: [Disposable] = []

    public init() {}

    fileprivate func addToDisposeBag(disposable: Disposable) {
        disposables.append(disposable)
    }

    deinit {
        disposables.forEach { $0.dispose() }
    }
}

class NetworkManager {
    class func get<Response: ResponseType>(
        params: [String: String],
        handler: @escaping (_ response: Response) -> Void
        ) -> Disposable {
        let task = URLSession.shared.dataTask(with: API.base.url(with: params)) { (data, urlResponse, error) in
            guard let data = data else {
                let errorMessage = error?.localizedDescription ?? "Could not send the network request"
                let response = Response.failure(rawResponse: urlResponse, message: errorMessage)
                handler(response)
                return
            }

            do {
                let parsedData = try JSONDecoder().decode(Response.Response.self, from: data)
                let response = Response.success(rawResponse: urlResponse, parsedResponse: parsedData)
                handler(response)
                return
            } catch {
                let response = Response.failure(rawResponse: urlResponse, message: error.localizedDescription)
                handler(response)
            }
        }
        task.resume()
        return Disposable {
            task.cancel()
        }
    }

}
