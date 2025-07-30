//
//  TabScreenViewModel.swift
//  Travel-Schedule
//
//  Created by 1111 on 29.07.2025.
//

import Foundation
import SwiftUICore

final class TabScreenViewModel: ObservableObject {
    @Published var colorScheme: ColorScheme = .light
    @Published var isFromPointSelected: Bool = false
    @Published var isToPointSelected: Bool = false
    @Published var isFromPointShow: Bool = false
    @Published var isToPointShow: Bool = false
    @Published var cityFrom: String = "Откуда"
    @Published var cityTo: String = "Куда"
    @Published var stationFrom: String?
    @Published var stationTo: String?
    @Published var showTimeSpecifyRedDot: Bool = false
    @Published var filteredSegments: [Segment] = []
    @Published var loadedData: LoadedData = LoadedData()
    
    var finalDestinationFrom: String {
        return cityFrom + " (" + (stationFrom ?? "") + ")"
    }
    
    var finalDestinationTo: String {
        return cityTo + " (" + (stationTo ?? "") + ")"
    }
}
