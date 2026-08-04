//
//  AccountCellView.swift
//  DoorDashDebuggingUIKit
//
//  Created by Tien Ho on 4/29/24.
//

import UIKit

final class AccountCellView: UITableViewCell {
    
    static let id = "AccountCellView"
    
    let titleLabel = UILabel()
    let iconView = UIImageView()
    
    var model: AccountCellModel? {
        didSet {
            titleLabel.text = model?.title
            
            if let image = model?.image {
                iconView.image = UIImage(systemName: image)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpContent() {
        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}
