//
//  MainScreenViewModel.swift
//  Travel-Schedule
//
//  Created by 1111 on 28.07.2025.
//

import SwiftUI

struct MainScreenViewModel {
    @State var cityHelp: String = ""
    @State var stationHelp: String = ""
    @State var indexesOfViewStories: [Int] = []
    
    @Binding var stateProperty: StateProperties
    @Binding var loadedData: LoadedData
    
    let storiesThemes: [UIImage] = [
        UIImage(resource: .mainTheme1),
        UIImage(resource: .mainTheme2),
        UIImage(resource: .mainTheme3)
    ]
    
    var finalDestination: String {
        return stateProperty.cityFrom + " (" + (stateProperty.stationFrom ?? "") + ")"
    }
}
