//
//  Endpoint.swift
//  DoordashAI
//

import Foundation

enum Endpoint {
    case storeFeed
    case menu

    var url: URL {
        switch self {
        case .storeFeed:
            return URL(string: "https://dd-interview.github.io/android/v1/feed?query=food&lat=37.7816&lng=-122.4156")!
        case .menu:
            return URL(string: "https://dd-interview.github.io/android/v1/menu")!
        }
    }
}
