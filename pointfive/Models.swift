//
//  Models.swift
//  pointfive
//
//  Created by Arvind Ravi on 03/05/2021.
//

import SwiftUI

struct Driver: Equatable, Identifiable {
    let id = UUID()
    let name: String
    let team: Team
    
    enum Team: String {
        case mercedes, ferrari, redbull, mclaren, renault, astonmartin, alfaromeo, alphatauri, haas, williams
        
        var displayName: String {
            rawValue
        }
    }
}

extension Driver {
    static let mock: Driver  = .init(name: "Lando Norris", team: .mclaren)
}
