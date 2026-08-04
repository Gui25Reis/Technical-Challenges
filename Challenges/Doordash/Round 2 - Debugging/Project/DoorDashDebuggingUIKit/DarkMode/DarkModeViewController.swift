//
//  DarkModeViewController.swift
//  DoorDashDebuggingUIKit
//
//  Created by shawn wu on 7/23/24.
//

import UIKit

class DarkModeViewController: UIViewController {
    
    private var viewModel = DarkModeViewModel()
    
    private let switchView = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "Dark Mode"
        
        let switchLabel = UILabel()
        switchLabel.text = "Dark Mode"
        
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
        
        switchView.isOn = viewModel.isDarkModeEnabled
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    @objc private func switchValueChanged() {
        viewModel.isDarkModeEnabled = switchView.isOn
    }
}

class DarkModeViewModel {
    @Service var preferenceService: DarkModePreferenceService
    private var debounceTask: DispatchWorkItem?
    
    init() {
        preferenceService.onDarkModeChange {
            self.debounceAndShowAlert()
        }
    }
    
    private func debounceAndShowAlert() {
        let task = DispatchWorkItem {
            self.postNotification()
            self.debounceTask = nil
        }
        debounceTask?.cancel()
        debounceTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: task)
    }
    
    private func postNotification() {
        NotificationCenter.default.post(name: .displayAlert, object: nil, userInfo: [
            alertTextUserInfoKey: "Dark Mode is \(isDarkModeEnabled ? "enabled" : "disabled")"
        ])
    }

    var isDarkModeEnabled: Bool {
        get { preferenceService.isDarkModeEnabled }
        set { preferenceService.isDarkModeEnabled = newValue }
    }
}
