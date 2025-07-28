//
//  StationsListView.swift
//  Travel-Schedule
//
//  Created by 1111 on 14.05.2025.
//

import SwiftUI

struct StationsListView: View {
    let viewModel: StationsListViewModel
    var city: String
    
    var body: some View {
        VStack(spacing: 0) {
            StationsView(viewModel: viewModel, cityTitle: city)
        }
        .toolbarRole(.editor)
        .navigationTitle("Выбор станции")
    }
}

private struct StationsView: View {
    let viewModel: StationsListViewModel
    
    @State private var searchStations = ""
    
    private var stations: [Station] {
        let city: Settlement = viewModel.loadedData.settlement.first { $0.title == cityTitle } ?? Settlement(
            title: "",
            code: "",
            stations: []
        )
        return city.stations
    }
    
    var cityTitle: String
    
    var filteredStations: [Station] {
        guard !searchStations.isEmpty else { return stations }
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
                        if viewModel.stateProperty.isFromPointSelected && viewModel.stateProperty.isToPointSelected == false {
                            viewModel.stateProperty.cityFrom = cityTitle
                            viewModel.stateProperty.stationFrom = station.name
                            viewModel.stateProperty.isFromPointSelected = false
                            viewModel.stateProperty.isFromPointShow = true
                            viewModel.loadedData.codeIdFrom = station.codeId
                        }
                        
                        if viewModel.stateProperty.isFromPointSelected == false && viewModel.stateProperty.isToPointSelected {
                            viewModel.stateProperty.cityTo = cityTitle
                            viewModel.stateProperty.stationTo = station.name
                            viewModel.stateProperty.isToPointSelected = false
                            viewModel.stateProperty.isToPointShow = true
                            viewModel.loadedData.codeIdTo = station.codeId
                        }
                        viewModel.stateProperty.path.removeLast(viewModel.stateProperty.path.count)
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
