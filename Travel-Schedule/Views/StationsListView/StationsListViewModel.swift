//
//  StationsListViewModel.swift
//  Travel-Schedule
//
//  Created by 1111 on 28.07.2025.
//

import SwiftUI

struct StationsListViewModel {
    @State var searchTextField: String = ""
    @Binding var stateProperty: StateProperties
    @Binding var loadedData: LoadedData
}
