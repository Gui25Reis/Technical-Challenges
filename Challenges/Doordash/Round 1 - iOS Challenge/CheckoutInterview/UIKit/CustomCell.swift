//
//  CustomCell.swift
//  CheckoutInterview
//
//  Created by Gui Reis on 15/07/26.
//

import UIKit

class CustomCell: UITableViewCell {
    static let id = "CustomCellID"
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViewsAtScreen()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // Overrides
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        priceLabel.text = nil
    }
    
    // Setup
    func setupCell(with data: CheckoutModels.CheckoutItemModel) {
        titleLabel.text = data.name
        priceLabel.text = data.displayPrice ?? "$0.00"
    }
    
    private func addViewsAtScreen() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        
        let lateral: CGFloat = 16
        let between: CGFloat = 4
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: between),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: lateral),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -lateral),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            priceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: lateral),
            priceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -lateral)
        ])
    }
}
