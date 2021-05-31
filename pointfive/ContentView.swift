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

struct AppState: Equatable {
    var drivers: [Driver]
    var teams: [Team]
}

enum AppAction {
    case onAppear
    case result(PointFiveKit.Action)
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
            .fetch(.teams, environment.session)
            .receive(on: DispatchQueue.main)
            .map(AppAction.result)
            .eraseToEffect()
    case let .result(.teamsFetchResult(teams)):
        state.teams = teams
        return .none
    default: return .none
    }
}
.debug()

struct TeamCardView: View {
    @State
    var team: Team
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(team.name)
                .font(.title2)
        }
        .background(Color.orange)
    }
}

struct ContentView: View {
    let store: Store<AppState, AppAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.teams) { team in
                        TeamCardView(team: team)
                    }
                }
                .navigationTitle("Teams")
                .onAppear(perform: {
                    viewStore.send(.onAppear)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( 
            store: .init(
                initialState: .init(
                    drivers: [],
                    teams: [.mock, .mock, .mock]
                ),
                reducer: reducer,
                environment: AppEnvironment.live
            )
        )
    }
}
