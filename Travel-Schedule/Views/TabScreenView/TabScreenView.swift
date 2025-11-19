//
//  MainScreenView.swift
//  Travel-Schedule
//
//  Created by 1111 on 11.05.2025.
//

import SwiftUI

struct TabScreenView: View {
    @State private var stateProperty: StateProperties = StateProperties()
    @State private var loadedData: LoadedData = LoadedData()
    @State var path: NavigationPath = NavigationPath()
    @StateObject var viewModel: TabScreenViewModel = TabScreenViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            TabView {
                MainScreenView(tabScreenViewModel: viewModel, path: $path)
                .tabItem {
                    Image(.main)
                        .renderingMode(.template)
                }
                .toolbarBackground(.visible, for: .tabBar)
                SettingsView(tabScreenViewModel: viewModel, path: $path)
                    .tabItem {
                        Image(.options)
                            .renderingMode(.template)
                    }
                    .toolbarBackground(.visible, for: .tabBar)
            }
            .accentColor(.darkWhite)
            .navigationDestination(for: String.self) { value in
                if value == "CitiesList" {
                    CitiesListView(path: $path)
                } else if value == "CarrierList" {
                    CarrierListView(tabScreenViewModel: viewModel, path: $path)
                } else if value == "TimeOptions" {
                    TimeOptionsView(tabScreenViewModel: viewModel, path: $path)
                } else if value == "CarrierInfo" {
                    CarrierInfoView()
                } else if value == "UserAgreement" {
                    UserAgreementView()
                } else {
                    StationsListView(tabScreenViewModel: viewModel, path: $path, city: value)
                }
            }
        }
        .accentColor(.darkWhite)
        .environment(\.colorScheme, viewModel.colorScheme)
    }
}
