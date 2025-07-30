//
//  CityOptionView.swift
//  Travel-Schedule
//
//  Created by 1111 on 12.05.2025.
//

import SwiftUI

struct CitiesListView: View {
    @StateObject private var viewModel: CitiesListViewModel = CitiesListViewModel()
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: .zero) {
            CitiesOptionView(viewModel: viewModel, path: $path)
        }
        .toolbarRole(.editor)
        .navigationTitle("Выбор города")
    }
}

private struct CitiesOptionView: View {
    @State private var searchCities = ""
    @ObservedObject var viewModel: CitiesListViewModel
    @Binding var path: NavigationPath
    
    private var cities: [String] {
        let citiesWithNoEmpty = viewModel.loadedData.settlements.filter { !$0.title.isEmpty }
        let sortedCities = citiesWithNoEmpty.sorted { $0.title < $1.title }
        let citiesTitles = sortedCities.map { $0.title  }
        return citiesTitles
    }
    
    private var filteredCities: [String] {
        guard !searchCities.isEmpty else {
            print("error")
            return cities
        }
        return cities.filter { $0.localizedCaseInsensitiveContains((searchCities)) }
    }
    
    var body: some View {
        VStack {
            if filteredCities.isEmpty {
                Text("Начните вводить название города")
                    .font(.system(size: 24, weight: .bold))
            } else {
                ListView(viewModel: viewModel, path: $path, filteredCities: filteredCities)
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
    @ObservedObject var viewModel: CitiesListViewModel
    @Binding var path: NavigationPath
    
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
                path.append(city)
            }
        }
    }
}

