//
//  OrderCartPill.swift
//  DoorDashDebuggingUIKit
//
//  Created by shawn wu on 4/12/24.
//

import UIKit

final class OrderCartPill: UIView {
    private lazy var leadingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var middleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var trailingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        let stack = UIStackView(arrangedSubviews: [leadingLabel, middleLabel, trailingLabel])
        stack.axis = .horizontal
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
        
        backgroundColor = .red
        clipsToBounds = true
        layer.cornerRadius = 24
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(leadingTitle: String? = nil, middleTitle: String? = nil, trailingTitle: String? = nil) {
        leadingLabel.isHidden = leadingTitle == nil
        leadingLabel.text = leadingTitle
        middleLabel.isHidden = middleTitle == nil
        middleLabel.text = middleTitle
        trailingLabel.isHidden = trailingTitle == nil
        trailingLabel.text = trailingTitle
    }
}
