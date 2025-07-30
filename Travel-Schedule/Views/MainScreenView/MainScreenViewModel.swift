//
//  MainScreenViewModel.swift
//  Travel-Schedule
//
//  Created by 1111 on 28.07.2025.
//

import SwiftUI

final class MainScreenViewModel: ObservableObject {
    @Published var cityHelp: String = ""
    @Published var stationHelp: String = ""
    @Published var indexesOfViewStories: [Int] = []
    @Published var stateProperty: StateProperties = StateProperties()
    @Published var loadedData: LoadedData = LoadedData()
    
    let storiesThemes: [UIImage] = [
        UIImage(resource: .mainTheme1),
        UIImage(resource: .mainTheme2),
        UIImage(resource: .mainTheme3)
    ]
}

