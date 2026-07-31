//
//  Service.swift
//  DoorDashDebugging
//
//  Created by Ryan Zhang on 5/13/24.
//

import Foundation

@propertyWrapper
struct Service<Service> {
    // Wrapped value is called on access of the property wrapper
    var wrappedValue: Service {
        // Resolve the instance
        ServiceResolver.shared.resolve(Service.self)!
    }
}

