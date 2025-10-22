//
//  DIContainer.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import Foundation

class DIContainer {
    private var factories: [ObjectIdentifier: (DIContainer) -> Any] = [:]
    private var singletons: [ObjectIdentifier: Any] = [:]
    
    enum Scope {
        case transient
        case singleton
    }

    func register<T>(_ type: T.Type, scope: Scope = .transient, factory: @escaping (DIContainer) -> T) {
        let identifier = ObjectIdentifier(T.self)
        self.factories[identifier] = factory
        if scope == .singleton {
            self.singletons[identifier] = factory(self)
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let identifier = ObjectIdentifier(T.self)
        
        guard let factory = factories[identifier] else {
            fatalError("Dependency \(T.self) not registered")
        }
        
        if let singleton = singletons[identifier] as? T {
            return singleton
        }
        
        guard let instance = factory(self) as? T else {
            fatalError("Factory for \(T.self) returned incorrect type")
        }
        
        return instance
    }
}
