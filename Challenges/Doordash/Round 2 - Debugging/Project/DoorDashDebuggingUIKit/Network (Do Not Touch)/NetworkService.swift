//
//  NetworkService.swift
//  DoorDashDebugging
//
//  Created by shawn wu on 4/14/24.
//

import Foundation
import Combine

final class NetworkService: URLLoading {
    private let session: DataLoading
    private let lock = NSLock()
    private var cancellables = Set<AnyCancellable>()
    
    /// Required initializer to specify the url loader object. The object has to conform to `DataLoading`.
    ///
    /// For most applications a `URLSession` object will do as the url loader for the network service.
    /// - Parameter urlLoader: A url loader object capable of returning publishers for networking operations.
    init(urlLoader: DataLoading) {
        self.session = urlLoader
    }
    
    /// Processes a `URLRequest` by performing a network operation and returns the results asynchronously via a completion handler.
    ///
    /// This function takes a `URLRequest` and executes the network request. Upon completion, it either provides a tuple containing `Data` and `URLResponse` or an error if the operation fails.
    ///
    /// - Parameter request: The `URLRequest` to be processed.
    /// - Parameter completionHandler: A closure that is called with the result of the network operation, either success with data and response or failure with an error.
    func process(_ request: URLRequest, completionHandler: @escaping (Result<(data: Data, response: URLResponse), Error>) -> Void) {
        let cancellable = session.load(request: request)
            .sink { completion in
                if case let .failure(error) = completion {
                    completionHandler(.failure(error))
                }
            } receiveValue: { (request: URLRequest, data: Data, response: URLResponse) in
                completionHandler(.success((data: data, response: response)))
            }
        
        lock.withLock {
            cancellable.store(in: &cancellables)
        }
    }
}

/// Describes the behavior for a URL loader to fetch data from a remote source for a `URLRequest`. Conforming objects can act as the URL
/// loader facility for the `NetworkService`.
protocol DataLoading {
    /// Creates a data task publisher for the `URLRequest` specified
    /// - Parameter request: The url request to execute.
    /// - Returns: A publisher with an output of `(request: URLRequest, data: Data, response: URLResponse)` for success,
    ///           and `Error` for failure.
    ///
    /// Objects conforming to this protocol can be used as the session of the `NetworkService`. The default object for this property is
    /// the `URLSession` which conforms to this protocol through an extension in this framework.
    func load(request: URLRequest) -> AnyPublisher<(request: URLRequest, data: Data, response: URLResponse), Error>
}
