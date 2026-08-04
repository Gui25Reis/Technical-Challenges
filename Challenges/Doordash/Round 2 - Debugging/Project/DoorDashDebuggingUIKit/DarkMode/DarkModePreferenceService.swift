//
//  DarkModePreferenceService.swift.swift
//
//  Copyright © 2024 DoorDash. All rights reserved.
//

import Combine
import Foundation

class DarkModePreferenceService {
    private let key = "isDarkModeEnabled"
    
    var isDarkModeEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: key)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
            onDarkModeChangeObservers.forEach { $0() }
        }
    }
    
    private var onDarkModeChangeObservers: [() -> Void] = []
    
    func onDarkModeChange(perform action: @escaping () -> Void) {
        onDarkModeChangeObservers.append(action)
    }
}
