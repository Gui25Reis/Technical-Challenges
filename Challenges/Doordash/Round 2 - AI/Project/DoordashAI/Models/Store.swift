//
//  Store.swift
//  DoordashAI
//

import Foundation

struct Store: Decodable {
    let id: Int
    let name: String
    let description: String
    let status: String
    let deliveryFeeCents: Int
    let coverImageURL: URL?

    enum CodingKeys: String, CodingKey {
        case id, name, description, status
        case deliveryFeeCents = "delivery_fee"
        case coverImageURL = "cover_img_url"
    }
}
