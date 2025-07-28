//
//  CityOptionView.swift
//  Travel-Schedule
//
//  Created by 1111 on 12.05.2025.
//

import SwiftUI

struct CitiesListView: View {
    let viewModel: CitiesListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CitiesOptionView(viewModel: viewModel)
        }
        .toolbarRole(.editor)
        .navigationTitle("Выбор города")
    }
}

private struct CitiesOptionView: View {
    let viewModel: CitiesListViewModel
    
    @State private var searchCities = ""
    
    private var cities: [String] {
        let citiesWithNoEmpty = viewModel.loadedData.settlement.filter { !$0.title.isEmpty }
        let sortedCities = citiesWithNoEmpty.sorted { $0.title < $1.title }
        let citiesTitles = sortedCities.map { $0.title  }
        return citiesTitles
    }
    
    private var filteredCities: [String] {
        guard !searchCities.isEmpty else { return cities }
        return cities.filter { $0.localizedCaseInsensitiveContains((searchCities)) }
    }
    
    var body: some View {
        VStack {
            if filteredCities.isEmpty {
                Text("Начните вводить название города")
                    .font(.system(size: 24, weight: .bold))
            } else {
                ListView(viewModel: viewModel, filteredCities: filteredCities)
                    .listStyle(.plain)
            }
        }
        .searchable(
            text: $searchCities,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Введите запрос"
        )
    }
}

private struct ListView: View {
    let viewModel: CitiesListViewModel
    var filteredCities: [String]
    
    var body: some View {
        List(filteredCities, id: \.self) { city in
            HStack {
                Text(city)
                    .frame(height: 40)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.darkWhite)
            }
            .listRowSeparator(.hidden)
            .onTapGesture {
                viewModel.stateProperty.path.append(city)
            }
        }
    }
}

