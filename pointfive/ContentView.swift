//
//  ContentView.swift
//  pointfive
//
//  Created by Arvind Ravi on 03/05/2021.
//

import PointFiveKit
import ComposableArchitecture
import Combine
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

struct AppState: Equatable {
    var drivers: [Driver]
}

enum AppAction {
    case onAppear
    case fetchedImage(Result<PointFiveKit.Action, Never>)
}

struct AppEnvironment {
    var pointFiveKit: PointFiveKit
    var session: URLSession
}

extension AppEnvironment {
    static let live = AppEnvironment(
        pointFiveKit: .live,
        session: .shared
    )
}

let reducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    var cancellables = Set<AnyCancellable>()
    switch action {
    case .onAppear:
        return environment
            .pointFiveKit
            .fetch(.drivers, environment.session)
            .catchToEffect()
            .map { AppAction.fetchedImage($0) }
    case let .fetchedImage(result):
        switch result {
        case let .success(.result(image)):
            state.drivers = [
                .init(name: image.message, team: .mercedes)
            ]
            return .none
        default: return .none
        }
    default: return .none
    }
}
.debug()

struct DriverCardView: View {
    let driver: Driver
    var body: some View {
        VStack(alignment: .leading) {
            Text(driver.name)
                .font(.title)
            
            Text(driver.team.displayName)
                .font(.title3)
                .foregroundColor(.orange)
        }
    }
}

struct ContentView: View {
    let store: Store<AppState, AppAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.drivers) { driver in
                    DriverCardView(driver: driver)
                }
            }
            .onAppear(perform: {
                viewStore.send(.onAppear)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
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
