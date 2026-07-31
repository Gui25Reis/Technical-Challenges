//
//  OrderCartWebService.swift
//  DoorDashDebuggingUIKit
//
//  Created by shawn wu on 8/12/24.
//

import Foundation
import Combine

struct OrderCartResponse: Decodable {
    let id: String
    let cartItems: [CartItem]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cartItems = "cart_items"
    }
    
    struct CartItem: Decodable {
        let id: String
        let quantity: Int
        let item: Item
    }
    
    struct Item: Decodable {
        let id: String
        let name: String
        let price: Double
        let imageUrl: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case price
            case imageUrl = "image_url"
        }
    }
}

protocol OrderCartWebService {
    func getOrderCart(withId id: String, completion: @escaping (Result<OrderCartResponse, Error>) -> Void)
    func updateOrderCart(cartId id: String, itemId: String, quantity: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

extension NetworkService: OrderCartWebService {}

extension OrderCartWebService where Self: URLLoading {
    func getOrderCart(withId id: String, completion: @escaping (Result<OrderCartResponse, Error>) -> Void) {
        process(
            URLRequest(url: URL(string: "www.doordash.com/cartDetails")!)
        ) { result in
            do {
                let data = try result.get().data
                let response = try JSONDecoder().decode(OrderCartResponse.self, from: data)
                print(response)
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateOrderCart(cartId id: String, itemId: String, quantity: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "www.doordash.com/update")!)
        request.httpBody = try! JSONEncoder().encode(UpdateCartItem.init(cartId: id, itemId: itemId, quantity: quantity))
        request.httpMethod = "POST"
        return process(request) { result in
            DispatchQueue.main.async {
                completion(result.map { _ in () })
            }
        }
    }
}

struct UpdateCartItem: Codable {
    let cartId: String
    let itemId: String
    let quantity: Int
}
