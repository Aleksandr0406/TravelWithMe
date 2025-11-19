//
//  StationsListViewModel.swift
//  Travel-Schedule
//
//  Created by 1111 on 28.07.2025.
//

import SwiftUI

final class StationsListViewModel: ObservableObject, @unchecked Sendable {
    @Published var searchTextField: String = ""
    @Published var stateProperty: StateProperties = StateProperties()
    @Published var loadedData: LoadedData = LoadedData()
    
    var networkService: TravelScheduleNetAccess = TravelScheduleNetAccess()
    
    init() {
        Task { @MainActor in
            loadedData.settlements = await networkService.getStationsList()
        }
    }
}
