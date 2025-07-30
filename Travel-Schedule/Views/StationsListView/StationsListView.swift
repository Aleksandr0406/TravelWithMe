//
//  StationsListView.swift
//  Travel-Schedule
//
//  Created by 1111 on 14.05.2025.
//

import SwiftUI

struct StationsListView: View {
    @StateObject private var viewModel: StationsListViewModel = StationsListViewModel()
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    @Binding var path: NavigationPath
    
    var city: String
    
    var body: some View {
        VStack(spacing: .zero) {
            StationsView(viewModel: viewModel, tabScreenViewModel: tabScreenViewModel, path: $path, cityTitle: city)
        }
        .toolbarRole(.editor)
        .navigationTitle("Выбор станции")
    }
}

private struct StationsView: View {
    @State private var searchStations = ""
    @ObservedObject var viewModel: StationsListViewModel
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    @Binding var path: NavigationPath
    
    private var stations: [Station] {
        let city: Settlement = viewModel.loadedData.settlements.first { $0.title == cityTitle } ?? Settlement(
            title: "",
            code: "",
            stations: []
        )
        return city.stations
    }
    
    var cityTitle: String
    
    var filteredStations: [Station] {
        guard !searchStations.isEmpty else {
            print("error")
            return stations
        }
        return stations.filter { $0.name.localizedCaseInsensitiveContains((searchStations)) }
    }
    
    var body: some View {
        VStack {
            if filteredStations.isEmpty {
                Text("Город не найден")
                    .font(.system(size: 24, weight: .bold))
            } else {
                List(filteredStations, id: \.self) { station in
                    HStack {
                        Text(station.name)
                            .frame(height: 40)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.darkWhite)
                    }
                    .onTapGesture {
                        if tabScreenViewModel.isFromPointSelected && tabScreenViewModel.isToPointSelected == false {
                            tabScreenViewModel.cityFrom = cityTitle
                            tabScreenViewModel.stationFrom = station.name
                            tabScreenViewModel.isFromPointSelected = false
                            tabScreenViewModel.isFromPointShow = true
                            tabScreenViewModel.loadedData.codeIdFrom = station.codeId
                        }
                        
                        if tabScreenViewModel.isFromPointSelected == false && tabScreenViewModel.isToPointSelected {
                            tabScreenViewModel.cityTo = cityTitle
                            tabScreenViewModel.stationTo = station.name
                            tabScreenViewModel.isToPointSelected = false
                            tabScreenViewModel.isToPointShow = true
                            tabScreenViewModel.loadedData.codeIdTo = station.codeId
                        }
                        path.removeLast(path.count)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
        }
        .searchable(
            text: $searchStations,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Введите запрос"
        )
    }
}
