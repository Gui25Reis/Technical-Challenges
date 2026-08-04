//
//  AccountNotificationCellViewModelDelegate.swift
//  DoorDashDebuggingUIKit
//

protocol AccountNotificationCellViewModelDelegate: AnyObject {
    func didToggleSwitch(newValue: Bool)
}

class AccountNotificationCellViewModel {
    weak var delegate: AccountNotificationCellViewModelDelegate?
    
    var isOn = false {
        didSet {
            delegate?.didToggleSwitch(newValue: isOn)
        }
    }
    
    var descriptionText: String {
        isOn
        ? "You will receive notifications for your orders."
        : "You will not receive notifications for your orders."
    }
}
