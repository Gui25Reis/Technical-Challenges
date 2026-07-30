//
//  Menu.swift
//  DoordashAI
//

import Foundation

struct Menu: Decodable {
    let id: String
    let name: String
    let items: [MenuItem]
}

struct MenuItem: Decodable {
    let id: String
    let name: String
    let priceCents: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case priceCents = "price_cents"
    }
}
