//
//  MockOrdersDataLoading.swift
//
//  Copyright © 2024 DoorDash. All rights reserved.
//

import Combine
import Foundation

final class MockOrderHistoryDataLoading: DataLoading {
    private let queue = DispatchQueue(label: "network", attributes: .concurrent)
    private let lock = NSLock()
    
    func load(request: URLRequest) -> AnyPublisher<(request: URLRequest, data: Data, response: URLResponse), Error> {
        guard let pathComponents = request.url?.pathComponents,
              pathComponents.count > 1 else {
            return Fail(error: NSError(domain: "", code: 1))
                .eraseToAnyPublisher()
        }
        
        let path = pathComponents[1]
        
        switch path {
        case "order":
            return Just(())
                .delay(
                    for: .seconds(Double.random(in: 0.1...0.2)),
                    scheduler: DispatchQueue(label: "background", target: queue)
                )
                .map { _ in
                    let id = Int(pathComponents[2]) ?? 0
                    let names = [
                        "frosty bear",
                        "nom nom nom",
                        "yum yum",
                        "all the food",
                    ]
                    let name = names[abs(id.hashValue) % names.count]
                    let descriptions = [
                        "Poke Bowl - Large (3 Proteins)",
                        "Ramen - Spicy Miso",
                        "Burger - Double Cheeseburger",
                        "Pizza - Pepperoni",
                        "Salad - Caesar extra dressing",
                        "Tacos - Al Pastor",
                        "Sushi - Sashimi Platter",
                    ]
                    let description = descriptions[abs(id.hashValue) % descriptions.count]
                    let data = """
                    {
                        "storeName": "\(name)",
                        "id": \(id),
                        "description": "\(description)"
                    }
                    """.data(using: .utf8)!
                    return (request, data, URLResponse())
                }
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case "orderIds":
            return Just(())
                .delay(
                    for: .seconds(Double.random(in: 0.1...0.2)),
                    scheduler: DispatchQueue(label: "background", target: queue)
                )
                .map { _ in
                    let ids = (0...1000).map({ "\($0)" }).joined(separator: ",")
                    let data = "[\(ids)]".data(using: .utf8)!
                    return (request, data, URLResponse())
                }
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        default:
            return Fail(error: NSError(domain: "", code: 1))
                .eraseToAnyPublisher()
        }
    }
}
