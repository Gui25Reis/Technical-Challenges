//
//  OrdersService.swift
//
//  Copyright © 2024 DoorDash. All rights reserved.
//

import Combine
import Foundation

class OrderHistoryService {
    private let networkService = NetworkService(urlLoader: MockOrderHistoryDataLoading())
    
    private var cache: [Int: Order] = [:]
    
    func fetchOrderIDs(completion: @escaping (Result<[Int], Error>) -> Void) {
        networkService.fetchOrderIDs(completion: completion)
    }
    
    func fetchOrder(id: Int, completion: @escaping (Result<Order, Error>) -> Void) {
        // check if the cache has the order
        if let value = self.cache[id] {
            completion(.success(value))
            return
        }
        
        // if not fetch it and update the cache on success
        networkService.fetchOrder(id: id) { [weak self] result in
            if case .success(let order) = result {
                self?.cache[id] = order
            }
            completion(result)
        }
    }
}
