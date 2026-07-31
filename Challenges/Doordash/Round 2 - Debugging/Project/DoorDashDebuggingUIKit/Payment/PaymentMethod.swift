//
//  PaymentMethod.swift
//  DoorDashDebuggingUIKit
//
//  Created by Mike Zaslavskiy on 8/12/24.
//

import Foundation

/// Payment method domain model
struct PaymentMethod: Codable {
    let id: String
    let name: String
    let last4: String?
    let type: PaymentMethodType
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case last4 = "last4"
        case type = "type"
    }
}

/// Payment method type - whether or not it's a card, apple pay or venmo
enum PaymentMethodType: Codable {
    case card
    case applePay
    case venmo
}
