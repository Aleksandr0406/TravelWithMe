//
//  File.swift
//  Travel-Schedule
//
//  Created by 1111 on 12.05.2025.
//
import SwiftUI

struct MainScreenView: View {
    let viewModel: MainScreenViewModel
    let storiesViewModel: StoriesViewModel
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    MiniStoriesView(viewModel: viewModel)
                        .fullScreenCover(isPresented: viewModel.$stateProperty.isPresentingStory) {
                            StoriesView(viewModel: storiesViewModel)
                        }
                }
                .frame(height: 140)
                .padding(.leading, 16)
            }
            ZStack {
                BlueRoundedRectangleView()
                HStackElementsView(viewModel: viewModel)
            }
            .frame(width: 311, height: 96)
            .padding(.top, 44)
            ButtonSearchView(viewModel: viewModel)
            Spacer()
        }
    }
}

private struct MiniStoriesView: View {
    let viewModel: MainScreenViewModel
    
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
    let viewModel: MainScreenViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                WhiteRoundedRectangleView()
                ButtonsFromToView(viewModel: viewModel)
            }
            .frame(width: 259, height: 96)
            ButtonReversedView(viewModel: viewModel)
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
    let viewModel: MainScreenViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            TextFromView(viewModel: viewModel)
            TextToView(viewModel: viewModel)
        }
    }
}

private struct TextFromView: View {
    let viewModel: MainScreenViewModel
    
    var body: some View {
        Text(viewModel.stateProperty.isFromPointShow ? viewModel.finalDestination : "Откуда")
            .lineLimit(1)
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(viewModel.stateProperty.isFromPointShow  ? .black : .gray)
            .padding(.leading, 16)
            .frame(width: 259, height: 48, alignment: .leading)
            .onTapGesture {
                viewModel.stateProperty.isFromPointSelected = true
                viewModel.stateProperty.path.append("CitiesList")
            }
    }
}

private struct TextToView: View {
    let viewModel: MainScreenViewModel
    
    private var finalDestination: String {
        return viewModel.stateProperty.cityTo + " (" + (viewModel.stateProperty.stationTo ?? "") + ")"
    }
    
    var body: some View {
        Text(viewModel.stateProperty.isToPointShow ? finalDestination : "Куда")
            .lineLimit(1)
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(viewModel.stateProperty.isToPointShow ? .black : .gray)
            .padding(.leading, 16)
            .frame(width: 259, height: 48, alignment: .leading)
            .onTapGesture {
                viewModel.stateProperty.isToPointSelected = true
                viewModel.stateProperty.path.append("CitiesList")
            }
    }
}

private struct ButtonReversedView: View {
    let viewModel: MainScreenViewModel
    
    var body: some View {
        Button(action: swapDestinations) {
            Image(.changed)
        }
        .frame(width: 36, height: 36)
        .background(.white)
        .cornerRadius(18)
    }
    
    private func swapDestinations() {
        viewModel.cityHelp = viewModel.stateProperty.cityFrom
        viewModel.stationHelp = viewModel.stateProperty.stationFrom ?? ""
        viewModel.stateProperty.cityFrom = viewModel.stateProperty.cityTo
        viewModel.stateProperty.stationFrom = viewModel.stateProperty.stationTo
        viewModel.stateProperty.cityTo = viewModel.cityHelp
        viewModel.stateProperty.stationTo = viewModel.stationHelp
    }
}

private struct ButtonSearchView: View {
    let viewModel: MainScreenViewModel
    
    private var travelScheduleNetAccess: TravelScheduleNetAccess {
        TravelScheduleNetAccess(loadedData: viewModel.$loadedData)
    }
    
    var isHidden: Bool {
        viewModel.stateProperty.stationTo != nil && viewModel.stateProperty.stationFrom != nil
    }
    
    var body: some View {
        Button("Найти") {
            viewModel.loadedData.segments = []
            travelScheduleNetAccess.getBetweenStationsSchedule(
                codeIdFrom: viewModel.loadedData.codeIdFrom,
                codeIdTo: viewModel.loadedData.codeIdTo
            )
            viewModel.stateProperty.path.append("CarrierList")
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


