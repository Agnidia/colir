//
//  AppCommons.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

struct Commons {
    /// General closure for empty response
    ///
    typealias EmptyClosure = () -> Void
}

/// default states for SwiftUI View
///
enum StateMode: Int, CaseIterable {
    case idle
    case progress
    case success
    case fault
    
    static var allCases: [StateMode] {
        [.idle, .progress, .success, .fault]
    }
}

enum Secrets {
    //#error("setup secrets")
    static let userDefaultsId = "com.igrsoft.colir-defaults"
}
