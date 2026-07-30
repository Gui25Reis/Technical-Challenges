//
//  ChekoutModel.swift
//  CheckoutInterview
//
//  Created by Gui Reis on 15/07/26.
//

import Foundation

enum CheckoutModels {
    
    struct CheckoutModel: Codable {
        var id: String
        var items: [CheckoutItemModel]
    }
    
    struct CheckoutItemModel: Codable {
        var name: String
        var displayPrice: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case displayPrice = "display_price"
        }
    }
}
