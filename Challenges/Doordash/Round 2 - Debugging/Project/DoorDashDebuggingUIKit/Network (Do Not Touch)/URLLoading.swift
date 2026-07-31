//
//  URLLoading.swift
//  DoorDashDebugging
//
//  Created by shawn wu on 4/14/24.
//

import Foundation
import Combine

/// Protocol to describe services capable of fetching remote resources
protocol URLLoading {
    /// Processes a specified `URLRequest` and initiates a networking operation using a completion handler. The completion handler is called with a `Result` type that either holds a successful output as a tuple containing an instance of `Data` and the `URLResponse`, or an `Error` in case of a failure.
    /// - Parameter request: An `URLRequest` for the networking operation.
    /// - Parameter completionHandler: A completion handler that is called with a `Result` type. On success, it contains a tuple of `Data` and `URLResponse`; on failure, it contains an `Error`.
    /// - Note: The completion handler will be executed on the background thread that performed the network operation.
    func process(_ request: URLRequest, completionHandler: @escaping (Result<(data: Data, response: URLResponse), Error>) -> Void)
}
