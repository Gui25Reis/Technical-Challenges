//
//  Order.swift
//
//  Copyright © 2024 DoorDash. All rights reserved.
//

struct Order: Decodable, Identifiable, Comparable {
    let id: Int
    let storeName: String
    let description: String
    
    static func < (lhs: Order, rhs: Order) -> Bool {
        lhs.id < rhs.id
    }
}
