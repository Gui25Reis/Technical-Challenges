//
//  PaymentMethodTableViewCell.swift
//  DoorDashDebuggingUIKit
//
//  Created by Mike Zaslavskiy on 8/12/24.
//

import Foundation
import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    static let id = "PaymentMethodTableViewCell"
    private let titleLabel = UILabel()
    private let iconLabel = UILabel()
    private let selectedCheckMarkLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpContent() {
        
        contentView.addSubview(iconLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectedCheckMarkLabel)
        
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedCheckMarkLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            iconLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            iconLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconLabel.widthAnchor.constraint(equalTo: iconLabel.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            titleLabel.leftAnchor.constraint(equalTo: iconLabel.rightAnchor, constant: -16),
            titleLabel.rightAnchor.constraint(equalTo: selectedCheckMarkLabel.leftAnchor, constant: 16),
        
            selectedCheckMarkLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            selectedCheckMarkLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            selectedCheckMarkLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -16),
            selectedCheckMarkLabel.widthAnchor.constraint(equalTo: iconLabel.heightAnchor),
        ])
        
        titleLabel.textAlignment = .left
        selectedCheckMarkLabel.text = "✔️"
    }
    
    func configure(with paymentMethod: PaymentMethod, isSelected: Bool) {
        titleLabel.text = paymentMethod.name
        selectedCheckMarkLabel.isHidden = !isSelected
        iconLabel.text = iconForPaymentType(paymentMethod.type)
    }
    
    private func iconForPaymentType(_ type: PaymentMethodType) -> String {
        switch type {
        case .applePay:
            return "🍎"
        case .card:
            return "💳"
        case .venmo:
            return "💸"
        }
    }
}
