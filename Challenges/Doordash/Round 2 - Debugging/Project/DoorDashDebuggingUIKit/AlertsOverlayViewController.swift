//
//  AlertsOverlayView.swift
//
//  Copyright © 2024 DoorDash. All rights reserved.
//

import Combine
import SwiftUI

class AlertsOverlayViewController: UIViewController {
    private let viewModel = AlertsOverlayViewModel()
    
    private let label = UILabel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.isHidden = true
        view.isUserInteractionEnabled = false
        
        let effectView = UIVisualEffectView()
        effectView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.layer.cornerRadius = 10
        effectView.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.numberOfLines = 0
        label.textAlignment = .center
        effectView.contentView.addSubview(label)
        view.addSubview(effectView)
        
        NSLayoutConstraint.activate([
            effectView.widthAnchor.constraint(equalToConstant: 200),
            effectView.heightAnchor.constraint(equalToConstant: 50),
            effectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            effectView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.topAnchor.constraint(equalTo: effectView.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: effectView.bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: effectView.leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: effectView.trailingAnchor, constant: -4),
        ])
    }
}

extension AlertsOverlayViewController: AlertsOverlayViewModelDelegate {
    func show(alert: String?) {
        view.isHidden = alert == nil
        label.text = alert
    }
}

protocol AlertsOverlayViewModelDelegate: AnyObject {
    func show(alert: String?)
}

class AlertsOverlayViewModel {
    private var queuedAlerts: [String] = []
    private var currentAlert: String? {
        didSet {
            delegate?.show(alert: currentAlert)
            
            if currentAlert != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) { [weak self] in
                    self?.showNextAlert()
                }
            }
        }
    }
    
    weak var delegate: AlertsOverlayViewModelDelegate?
    
    init() {
        NotificationCenter.default.addObserver(forName: .displayAlert, object: nil, queue: .main) { [weak self] notification in
            if let text = (notification.userInfo?[alertTextUserInfoKey] as? String) {
                self?.add(newAlert: text)
            }
        }
    }
    
    private func add(newAlert: String) {
        if currentAlert != nil {
            queuedAlerts.append(newAlert)
        } else {
            currentAlert = newAlert
        }
    }
    
    private func showNextAlert() {
        currentAlert = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            guard let self else { return }
            if let nextAlert = queuedAlerts.first {
                currentAlert = nextAlert
                queuedAlerts.removeFirst()
            }
        }
    }
}

extension Notification.Name {
    static let displayAlert = Notification.Name("Display Alert")
}

let alertTextUserInfoKey = "isDarkModeEnabled"
