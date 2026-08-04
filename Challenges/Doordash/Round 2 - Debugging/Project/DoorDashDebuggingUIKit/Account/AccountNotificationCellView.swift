//
//  AccountCellView.swift
//  DoorDashDebuggingUIKit
//

import UIKit

final class AccountNotificationCellView: UITableViewCell {
    
    static let id = "AccountNotificationCellView"
    
    private let switchView = UISwitch()
    private let descriptionLabel = UILabel()
    
    private let viewModel = AccountNotificationCellViewModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpContent()
        viewModel.delegate = self
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpContent() {
        let switchLabel = UILabel()
        switchLabel.text = "Push Notifications"
        
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.font = .systemFont(ofSize: 12)
        
        let hStack = UIStackView(arrangedSubviews: [switchLabel, switchView])
        hStack.axis = .horizontal
        hStack.spacing = 8
        
        let vStack = UIStackView(arrangedSubviews: [hStack, descriptionLabel])
        vStack.axis = .vertical
        vStack.spacing = 4
        vStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    @objc private func switchValueChanged() {
        viewModel.isOn = switchView.isOn
    }
}

extension AccountNotificationCellView: AccountNotificationCellViewModelDelegate {
    func didToggleSwitch(newValue: Bool) {
        descriptionLabel.text = viewModel.descriptionText
    }
}
