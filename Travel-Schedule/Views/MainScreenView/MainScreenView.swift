//
//  File.swift
//  Travel-Schedule
//
//  Created by 1111 on 12.05.2025.
//
import SwiftUI

struct MainScreenView: View {
    @StateObject private var viewModel: MainScreenViewModel = MainScreenViewModel()
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    MiniStoriesView(viewModel: viewModel)
                        .fullScreenCover(isPresented: $viewModel.stateProperty.isPresentingStory) {
                            StoriesView(mainViewModel: viewModel)
                        }
                }
                .frame(height: 140)
                .padding(.leading, 16)
            }
            ZStack {
                BlueRoundedRectangleView()
                HStackElementsView(viewModel: viewModel, tabScreenViewModel: tabScreenViewModel, path: $path)
            }
            .frame(width: 311, height: 96)
            .padding(.top, 44)
            ButtonSearchView(viewModel: viewModel, tabScreenViewModel: tabScreenViewModel, path: $path)
            Spacer()
        }
    }
}

private struct MiniStoriesView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    
    var body: some View {
        ForEach(0..<viewModel.storiesThemes.count, id: \.self) { index in
            let isStoryViewed = viewModel.indexesOfViewStories.contains(index)
            Image(uiImage: viewModel.storiesThemes[index])
                .frame(width: 92)
                .clipShape(.rect(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(.blue, lineWidth: isStoryViewed ? 0 : 4))
                .opacity(isStoryViewed ? 0.5 : 1)
                .onTapGesture {
                    viewModel.stateProperty.indexOfGroupStories = index
                    viewModel.indexesOfViewStories.append(viewModel.stateProperty.indexOfGroupStories)
                    viewModel.stateProperty.tabSelection = index
                    viewModel.stateProperty.isPresentingStory = true
                }
        }
    }
}

private struct BlueRoundedRectangleView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 343, height: 128)
            .foregroundStyle(.blue)
    }
}

private struct HStackElementsView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                WhiteRoundedRectangleView()
                ButtonsFromToView(viewModel: viewModel, tabScreenViewModel: tabScreenViewModel, path: $path)
            }
            .frame(width: 259, height: 96)
            ButtonReversedView(viewModel: viewModel, tabScreenViewModel: tabScreenViewModel)
        }
    }
}

private struct WhiteRoundedRectangleView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.white)
            .frame(width: 259, height: 96)
    }
}

private struct ButtonsFromToView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: .zero) {
            TextFromView(viewModel: viewModel, tabScreenViewModel: tabScreenViewModel, path: $path)
            TextToView(viewModel: viewModel, tabScreenViewModel: tabScreenViewModel, path: $path)
        }
    }
}

private struct TextFromView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        Text(tabScreenViewModel.isFromPointShow ? tabScreenViewModel.finalDestinationFrom : "Откуда")
            .lineLimit(1)
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(tabScreenViewModel.isFromPointShow  ? .black : .gray)
            .padding(.leading, 16)
            .frame(width: 259, height: 48, alignment: .leading)
            .onTapGesture {
                tabScreenViewModel.isFromPointSelected = true
                path.append("CitiesList")
            }
    }
}

private struct TextToView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        Text(tabScreenViewModel.isToPointShow ? tabScreenViewModel.finalDestinationTo : "Куда")
            .lineLimit(1)
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(tabScreenViewModel.isToPointShow ? .black : .gray)
            .padding(.leading, 16)
            .frame(width: 259, height: 48, alignment: .leading)
            .onTapGesture {
                tabScreenViewModel.isToPointSelected = true
                path.append("CitiesList")
            }
    }
}

private struct ButtonReversedView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    
    var body: some View {
        Button(action: swapDestinations) {
            Image(.changed)
        }
        .frame(width: 36, height: 36)
        .background(.white)
        .cornerRadius(18)
    }
    
    private func swapDestinations() {
        viewModel.cityHelp = tabScreenViewModel.cityFrom
        viewModel.stationHelp = tabScreenViewModel.stationFrom ?? ""
        tabScreenViewModel.cityFrom = tabScreenViewModel.cityTo
        tabScreenViewModel.stationFrom = tabScreenViewModel.stationTo
        tabScreenViewModel.cityTo = viewModel.cityHelp
        tabScreenViewModel.stationTo = viewModel.stationHelp
    }
}

private struct ButtonSearchView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    @Binding var path: NavigationPath
    
    var travelScheduleNetAccess: TravelScheduleNetAccess = TravelScheduleNetAccess()
    
    var isHidden: Bool {
        tabScreenViewModel.stationTo != nil && tabScreenViewModel.stationFrom != nil
    }
    
    var body: some View {
        Button("Найти") {
            path.append("CarrierList")
        }
        .frame(width: 150, height: 60)
        .background(.blue)
        .cornerRadius(16)
        .foregroundStyle(.white)
        .font(.system(size: 17, weight: .bold))
        .padding(.top, 16)
        .opacity(isHidden ? 1 : 0)
    }
}


