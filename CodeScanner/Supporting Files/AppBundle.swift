//
//  AppBundle.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 23.10.2025.
//

import Foundation

enum AppBundle {
    static let test = ""
    static let production = ""

    private static let appBundle = Bundle.main.bundleIdentifier ?? production
    static var isReleaseBundle: Bool { appBundle == production }
    
    enum SharedKey {
        static let sharedSecretTest = ""
        static let sharedSecretProd = ""
    }
}
