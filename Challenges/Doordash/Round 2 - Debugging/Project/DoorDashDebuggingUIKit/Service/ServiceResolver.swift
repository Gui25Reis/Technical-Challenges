//
//  ServiceResolver.swift
//  DoorDashDebugging
//
//  Created by Ryan Zhang on 5/13/24.
//

import Foundation

final class ServiceResolver {
    
    static let shared = ServiceResolver()
    
    private var registerLookup: [ObjectIdentifier: (ServiceResolver) -> Any] = [:]
    private var resolveLookup: [ObjectIdentifier: Any] = [:]
    
    init() {}
    
    func register<T>(_ type: T.Type, block: @escaping (ServiceResolver) -> T) {
        registerLookup[ObjectIdentifier(type)] = block
    }
    
    /// Resolves the given instance (type) and stores it in our `resolveLookup` to
    /// only allocate and create one instance per lifetime of `ServiceResolver`.
    ///
    /// - Parameter type: The type of instance that we'd like to resolve.
    /// - Returns: If registered, this function will return the type of instance that we were able to resolve.
    ///  If the type of instance wasn't registered, or if something else went wrong, this function will return nil.
    func resolve<T>(_ type: T.Type) -> T? {
        let key = ObjectIdentifier(type)
        
        // Looks up the instance generator for the given key
        guard let factory = registerLookup[key] else {
            return nil
        }
        
        // Attempts to create the instance
        guard let newService = factory(self) as? T else {
            return nil
        }
        
        if let service = resolveLookup[key] as? T {
            return service
        }
        
        resolveLookup[key] = newService
        
        // Returns the new service
        return newService
    }
}
