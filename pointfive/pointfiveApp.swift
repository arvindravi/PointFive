//
//  pointfiveApp.swift
//  pointfive
//
//  Created by Arvind Ravi on 03/05/2021.
//

import SwiftUI

@main
struct pointfiveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: .init(
                    initialState: .init(
                        drivers: [
                            .mock,
                            .mock,
                            .mock 
                        ]
                    ),
                    reducer: reducer,
                    environment: AppEnvironment.live
                )
            )
        }
    }
}
