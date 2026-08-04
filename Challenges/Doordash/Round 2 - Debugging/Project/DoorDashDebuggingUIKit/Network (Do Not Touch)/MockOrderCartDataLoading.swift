//
//  MockOrderCartDataLoading.swift
//  DoorDashDebugging
//
//  Created by Michael Guo on 5/21/24.
//

import Foundation
import Combine

final class MockOrderCartDataLoading: DataLoading {
    private let queue = DispatchQueue(label: "network", attributes: .concurrent)
    private let lock = NSLock()
    
    private var cartItemQuantityMap: [String: Int] = [
        "1": 4,
        "2": 3,
        "3": 2,
        "4": 1
    ]
    
    func load(request: URLRequest) -> AnyPublisher<(request: URLRequest, data: Data, response: URLResponse), Error> {
        switch request.url?.lastPathComponent {
        case "cartDetails":
            return Just(())
                .delay(
                    for: .seconds(Double.random(in: 0.2...1.2)),
                    scheduler: DispatchQueue(label: "background", target: queue)
                )
                .map {
                    (request, self.encodeCartData()!, URLResponse())
                }
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
 
        case "update":
            return Just(())
                .delay(
                    for: .seconds(Double.random(in: 0.2...1.2)),
                    scheduler: DispatchQueue(label: "background", target: queue)
                )
                .map { [weak self] in
                    guard let self = self,
                            let httpBody = request.httpBody,
                            let item = try? JSONDecoder().decode(UpdateCartItem.self, from: httpBody)
                    else { return }
                    
                    lock.lock()
                    let updateItemId = item.itemId
                    let quantity = item.quantity
                    var map = self.cartItemQuantityMap
                    map[updateItemId] = quantity
                    self.cartItemQuantityMap = map
                    lock.unlock()
                }
                .map {
                    (request, Data(), URLResponse())
                }
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            
        default:
            return Fail(error: NSError(domain: "", code: 1))
                .eraseToAnyPublisher()
        }
    }
    
    private func encodeCartData() -> Data? {
        let data = Data(cartResponseJsonString.utf8)
        guard var jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let cartItems = jsonObject["cart_items"] as? [[String: Any]] else {
            return nil
        }
        lock.lock()
        
        var newCartItems = [[String: Any]]()
        cartItems.forEach { item in
            var copied = item
            let itemId = item["id"] as? String ?? ""
            copied["quantity"] = cartItemQuantityMap[itemId] ?? item["quantity"]
            newCartItems.append(copied)
        }
        jsonObject["cart_items"] = newCartItems
        
        lock.unlock()
        return try? JSONSerialization.data(withJSONObject: jsonObject)
    }
}

// MARK: - Cart Reponse JSON

let cartResponseJsonString =
    """
    {
      "id": "123",
      "cart_items": [
        {
          "id": "1",
          "quantity": 2,
          "item": {
            "id": "1",
            "name": "Sweet Sour Chicken",
            "price": 12.99,
            "image_url": "takeoutbag.and.cup.and.straw"
          }
        },
        {
          "id": "2",
          "quantity": 1,
          "item": {
            "id": "2",
            "name": "Steamed Rice",
            "price": 2.99,
            "image_url": "takeoutbag.and.cup.and.straw"
          }
        },
        {
          "id": "3",
          "quantity": 1,
          "item": {
            "id": "3",
            "name": "Shrimp Fried Rice",
            "price": 14.50,
            "image_url": "takeoutbag.and.cup.and.straw"
          }
        },
        {
          "id": "4",
          "quantity": 1,
          "item": {
            "id": "4",
            "name": "Vegetables w/ Tofu",
            "price": 9.99,
            "image_url": "takeoutbag.and.cup.and.straw"
          }
        }
      ]
    }
    """
