//
//  FakeNetworkSession.swift
//  Copyright © 2026 DoorDash, Inc. All rights reserved.
//
// ## Confidentiality Notice
// This interview exercise and all associated materials are confidential
// and proprietary to DoorDash, Inc. By accessing these materials, you
// agree not to share, publish, or distribute any part of this exercise
// or your solution.
//
// Violation of this agreement may result in disqualification from
// consideration for employment at DoorDash.
//

import Foundation
import Combine

private let orderResponseFileURL: URL = {
    let path = Bundle.main.path(forResource: "OrderResponse", ofType: "json")!
    return URL(fileURLWithPath: path)
}()

private let submissionResponseFileURL: URL = {
    let path = Bundle.main.path(forResource: "SubmissionResponse", ofType: "json")!
    return URL(fileURLWithPath: path)
}()

/// Candidates should not modify this file or class
class FakeNetworkSession {
    private static let queue = DispatchQueue(label: "com.doordash.random-queue", qos: .background)
    
    /// Candidates should not modify this property
    let getOrderPublisher = FakeNetworkPublisher(fileURL: orderResponseFileURL).subscribe(on: FakeNetworkSession.queue)
    
    /// Candidates should not modify this property
    let submitOrderPublisher = FakeNetworkPublisher(fileURL: submissionResponseFileURL).subscribe(on: FakeNetworkSession.queue)
    
    /// Candidates should not modify this method
    func getOrder(completionHandler: @escaping (Data) -> Void) {
        FakeNetworkSession.queue.asyncAfter(deadline: .now() + 1.0) {
            let data = try! Data(contentsOf: orderResponseFileURL)
            completionHandler(data)
        }
    }
    
    /// Candidates should not modify this method
    func submitOrder(orderId: String, completionHandler: @escaping (Data) -> Void) {
        print("Submitting order with id: \(orderId)")
        FakeNetworkSession.queue.asyncAfter(deadline: .now() + 1.0) {
            let data = try! Data(contentsOf: submissionResponseFileURL)
            completionHandler(data)
        }
    }
    
    /// Candidates should not modify this method
    func getOrder() async -> Data {
        try? await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
        return try! Data(contentsOf: orderResponseFileURL)
    }
    
    /// Candidates should not modify this method
    func submitOrder(orderId: String) async -> Data {
        print("Submitting order with id: \(orderId)")
        try? await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
        return try! Data(contentsOf: submissionResponseFileURL)
    }
}

/// Candidates should not modify this class
struct FakeNetworkPublisher: Publisher {
    typealias Output = Data
    typealias Failure = Error

    let fileURL: URL

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = FileSubscription(fileURL: fileURL, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

/// Candidates should not modify this class
private class FileSubscription<S: Subscriber>: Subscription where S.Input == Data, S.Failure == Error {
    private let fileURL: URL
    private var subscriber: S?

    init(fileURL: URL, subscriber: S) {
        self.fileURL = fileURL
        self.subscriber = subscriber
    }

    func request(_ demand: Subscribers.Demand) {
        if demand > 0 {
            do {
                let data = try Data(contentsOf: fileURL)
                _ = subscriber?.receive(data)
                subscriber?.receive(completion: .finished)
            } catch {
                subscriber?.receive(completion: .failure(error))
            }
        }
    }

    func cancel() {
        subscriber = nil
    }
}
