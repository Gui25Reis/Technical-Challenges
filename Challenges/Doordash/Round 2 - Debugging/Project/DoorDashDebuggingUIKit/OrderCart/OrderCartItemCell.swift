//
//  OrderCartItemCell.swift
//  DoorDashDebuggingUIKit
//
//  Created by Michael Guo on 8/13/24.
//

import UIKit

protocol OrderCartItemCellDelegate: AnyObject {
    func didUpdateQuantity(for item: OrderCartResponse.CartItem, quantity: Int)
}

class OrderCartItemCell: UITableViewCell {
    static let id = "OrderCartItemCellID"
    
    lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        iconView.contentMode = .scaleAspectFit
        return iconView
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        return titleLabel
    }()

    lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return subtitleLabel
    }()

    lazy var decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.addTarget(self, action: #selector(decrement(_:)), for: .touchUpInside)
        return button
    }()

    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    lazy var incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(increment(_:)), for: .touchUpInside)
        return button
    }()

    weak var delegate: OrderCartItemCellDelegate?

    var model: OrderCartResponse.CartItem? {
        didSet {
            updateUI()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        tintColor = .black
        setUpContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpContent() {
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.spacing = 4

        // Stepper
        let stepperView = UIStackView(arrangedSubviews: [decrementButton, quantityLabel, incrementButton])
        stepperView.backgroundColor = .white
        stepperView.layer.shadowColor = UIColor.black.cgColor
        stepperView.layer.shadowOpacity = 0.3
        stepperView.layer.shadowOffset = CGSize(width: 0, height: 2)
        stepperView.layer.shadowRadius = 4
        stepperView.layer.cornerRadius = 16

        // Content
        let contentStack = UIStackView(arrangedSubviews: [iconView, labelStack, stepperView])
        contentStack.axis = .horizontal
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.alignment = .center
        contentStack.spacing = 16

        contentView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }

    private func updateUI() {
        guard let model = model else { return }

        if let imageUrl = model.item.imageUrl {
            iconView.image = UIImage(systemName: imageUrl)
        }
        titleLabel.text = model.item.name
        subtitleLabel.text = "$\(model.item.price.formatted())"
        quantityLabel.text = "\(model.quantity)"
    }

    @objc private func decrement(_ sender: UIButton) {
        guard let model = model else { return }

        if model.quantity >= 1 {
            delegate?.didUpdateQuantity(for: model, quantity: model.quantity - 1)
        }
    }

    @objc private func increment(_ sender: UIButton) {
        guard let model = model else { return }

        delegate?.didUpdateQuantity(for: model, quantity: model.quantity + 1)
    }
}
