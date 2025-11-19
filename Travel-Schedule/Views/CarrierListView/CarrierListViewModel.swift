//
//  CarrierListViewModel.swift
//  Travel-Schedule
//
//  Created by 1111 on 28.07.2025.
//

import SwiftUI

final class CarrierListViewModel: ObservableObject, @unchecked Sendable {
    @Published var loadedData: LoadedData = LoadedData()
    
    var networkService: TravelScheduleNetAccess = TravelScheduleNetAccess()
    
    func loadSegments(codeIdFrom: String, codeIdTo: String) {
        Task { @MainActor in
            loadedData.segments = await networkService.getBetweenStationsSchedule(codeIdFrom: codeIdFrom, codeIdTo: codeIdTo)
        }
    }
}
