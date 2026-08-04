//
//  CurrencyFormatter.swift
//  DoordashAI
//

import Foundation

enum CurrencyFormatter {

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    static func string(fromCents cents: Int) -> String {
        let dollars = Decimal(cents) / 100
        return formatter.string(from: dollars as NSDecimalNumber) ?? "$\(dollars)"
    }
}
