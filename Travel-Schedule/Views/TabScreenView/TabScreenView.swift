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
    
    private var travelScheduleNetAccess: TravelScheduleNetAccess {
        TravelScheduleNetAccess(loadedData: $loadedData)
    }
    
    var body: some View {
        NavigationStack(path: $stateProperty.path) {
            TabView {
                MainScreenView(
                    viewModel: MainScreenViewModel(stateProperty: $stateProperty, loadedData: $loadedData),
                    storiesViewModel: StoriesViewModel(stateProperty: $stateProperty)
                )
                .tabItem {
                    Image(.main)
                        .renderingMode(.template)
                }
                .toolbarBackground(.visible, for: .tabBar)
                SettingsView(viewModel: SettingsViewModel(stateProperty: $stateProperty))
                    .tabItem {
                        Image(.options)
                            .renderingMode(.template)
                    }
                    .toolbarBackground(.visible, for: .tabBar)
            }
            .accentColor(.darkWhite)
            .navigationDestination(for: String.self) { value in
                if value == "CitiesList" {
                    CitiesListView(viewModel: CitiesListViewModel(stateProperty: $stateProperty, loadedData: $loadedData))
                } else if value == "CarrierList" {
                    CarrierListView(viewModel: CarrierListViewModel(stateProperty: $stateProperty, loadedData: $loadedData))
                } else if value == "TimeOptions" {
                    TimeOptionsView(viewModel: TimeOptionsViewModel(stateProperty: $stateProperty, loadedData: $loadedData))
                } else if value == "CarrierInfo" {
                    CarrierInfoView(viewModel: CarrierInfoViewModel(loadedData: $loadedData))
                } else if value == "UserAgreement" {
                    UserAgreementView(viewModel: UserAgreementViewModel(stateProperty: $stateProperty))
                } else {
                    StationsListView(viewModel: StationsListViewModel(stateProperty: $stateProperty, loadedData: $loadedData), city: value)
                }
            }
        }
        .accentColor(.darkWhite)
        .environment(\.colorScheme, stateProperty.colorScheme)
        .onAppear {
            travelScheduleNetAccess.getStationsList()
        }
    }
}
