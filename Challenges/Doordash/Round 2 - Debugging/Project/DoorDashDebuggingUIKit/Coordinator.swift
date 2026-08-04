//
//  Coordinator.swift
//  DoorDashDebuggingUIKit
//
//  Created by Tien Ho on 4/29/24.
//

import UIKit

final class Coordinator {
    weak var navigationController: UINavigationController?
    
    func navigate(to destination: NavigationDestination) {
        if destination == .payments {
            navigationController?.pushViewController(PaymentViewController(), animated: true)
        } else if destination == .dashpass {
            navigationController?.pushViewController(DashPassViewController(), animated: true)
        } else if destination == .darkmode {
            navigationController?.pushViewController(DarkModeViewController(), animated: true)
        } else if destination == .ordercart {
            navigationController?.present(UINavigationController(rootViewController: OrderCartViewController()), animated: true)
        } else if destination == .legal {
            navigationController?.pushViewController(LegalViewController(), animated: true)
        }
    }
}
