//
//  OrderWebService.swift
//
//  Copyright © 2024 DoorDash. All rights reserved.
//

import Combine
import Foundation

protocol OrderHistoryWebService {
    func fetchOrder(id: Int, completion: @escaping (Result<Order, Error>) -> Void)
    func fetchOrderIDs(completion: @escaping (Result<[Int], Error>) -> Void)
}

extension NetworkService: OrderHistoryWebService {}

extension OrderHistoryWebService where Self: URLLoading {
    func fetchOrder(id: Int, completion: @escaping (Result<Order, Error>) -> Void) {
        let request = URLRequest(url: URL(string: "www.doordash.com/order/\(id)")!)
        process(request) { result in
            do {
                let data = try result.get().data
                let order = try JSONDecoder().decode(Order.self, from: data)
                completion(.success(order))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchOrderIDs(completion: @escaping (Result<[Int], Error>) -> Void) {
        process(
            URLRequest(url: URL(string: "www.doordash.com/orderIds/")!)
        ) { result in
            do {
                let data = try result.get().data
                let order = try JSONDecoder().decode([Int].self, from: data)
                completion(.success(order))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
