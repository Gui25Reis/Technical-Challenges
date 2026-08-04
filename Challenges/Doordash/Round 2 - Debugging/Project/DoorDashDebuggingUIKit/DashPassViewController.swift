//
//  DashPassViewController.swift
//  DoorDashDebuggingUIKit
//
//  Created by shawn wu on 4/12/24.
//

import UIKit

final class DashPassViewController: UIViewController {
    private var viewModel = DashPassViewModel()
    
    private let switchView = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "DashPass"
        
        let switchLabel = UILabel()
        switchLabel.text = "DashPass"
        
        let vStack = UIStackView(arrangedSubviews: [switchLabel, switchView])
        vStack.axis = .horizontal
        vStack.spacing = 8
        vStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            vStack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16)
        ])
        
        switchView.isOn = viewModel.isDashPassEnabled
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    @objc private func switchValueChanged() {
        viewModel.isDashPassEnabled = switchView.isOn
    }
}

class DashPassViewModel {
    private let key = "isDashPassEnabled"
    
    init() {
        self.isDashPassEnabled = UserDefaults.standard.bool(forKey: key)
    }
    
    var isDashPassEnabled: Bool {
        willSet {
            UserDefaults.standard.setValue(isDashPassEnabled, forKey: self.key)
        }
    }
}
