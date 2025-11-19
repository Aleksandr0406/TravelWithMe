//
//  TimeOptionsView.swift
//  Travel-Schedule
//
//  Created by 1111 on 19.05.2025.
//

import SwiftUI

struct TimeOptionsView: View {
    @StateObject private var viewModel: TimeOptionsViewModel = TimeOptionsViewModel()
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Text("Время отправления")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            MorningTimeView(viewModel: viewModel, tabScreenViewModel: tabScreenViewModel)
            DayTimeView(viewModel: viewModel, tabScreenViewModel: tabScreenViewModel)
            EveningTimeView(viewModel: viewModel, tabScreenViewModel: tabScreenViewModel)
            NightTimeView(viewModel: viewModel, tabScreenViewModel: tabScreenViewModel)
            Text("Показывать варианты с пересадками")
                .font(.system(size: 24, weight: .bold))
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            TransferYesView(viewModel: viewModel)
            TransferNoView(viewModel: viewModel)
        }
        .padding([.leading, .trailing], 16)
        Spacer()
        Button("Применить") {
            path.removeLast()
            //            viewModel.stateProperty.path.removeLast()
        }
        .font(.system(size: 17, weight: .bold))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(.blue)
        .cornerRadius(16)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16))
        .opacity(viewModel.stateProperty.shouldHide ? 0 : 1)
        .toolbarRole(.editor)
    }
}

private struct MorningTimeView: View {
    @ObservedObject var viewModel: TimeOptionsViewModel
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    
    var body: some View {
        HStack {
            Text("Утро 06:00 - 12:00")
                .font(.system(size: 17, weight: .regular))
            Spacer()
            Image(viewModel.isMorningTimeSelect ? .checked : .transferOptionSquare)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    viewModel.isMorningTimeSelect.toggle()
                    if viewModel.isMorningTimeSelect && (viewModel.isTransferOptionYesSelect || viewModel.isTransferOptionNoSelect) {
                        viewModel.stateProperty.shouldHide = false
                    }
                    tabScreenViewModel.showTimeSpecifyRedDot = viewModel.checkOptionTime()
                    Task { 
                        tabScreenViewModel.filteredSegments = await viewModel.filterTime(minInterval: 6, maxInterval: 12, codeIdFrom: tabScreenViewModel.loadedData.codeIdFrom, codeIdTo: tabScreenViewModel.loadedData.codeIdTo)
                    }
                }
        }
        .frame(height: 60)
    }
}

private struct DayTimeView: View {
    @ObservedObject var viewModel: TimeOptionsViewModel
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    
    var body: some View {
        HStack {
            Text("День 12:00 - 18:00")
                .font(.system(size: 17, weight: .regular))
            Spacer()
            Image(viewModel.isDayTimeSelect ? .checked : .transferOptionSquare)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    viewModel.isDayTimeSelect.toggle()
                    if viewModel.isDayTimeSelect && (viewModel.isTransferOptionYesSelect || viewModel.isTransferOptionNoSelect)  {
                        viewModel.stateProperty.shouldHide = false
                    }
                    tabScreenViewModel.showTimeSpecifyRedDot = viewModel.checkOptionTime()
                    Task {
                        tabScreenViewModel.filteredSegments = await
                        viewModel.filterTime(minInterval: 12, maxInterval: 18, codeIdFrom: tabScreenViewModel.loadedData.codeIdFrom, codeIdTo: tabScreenViewModel.loadedData.codeIdTo)
                    }
                }
        }
        .frame(height: 60)
    }
}

private struct EveningTimeView: View {
    @ObservedObject var viewModel: TimeOptionsViewModel
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    
    var body: some View {
        HStack {
            Text("Вечер 18:00 - 00:00")
                .font(.system(size: 17, weight: .regular))
            Spacer()
            Image(viewModel.isEveningTimeSelect ? .checked : .transferOptionSquare)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    viewModel.isEveningTimeSelect.toggle()
                    if viewModel.isEveningTimeSelect && (viewModel.isTransferOptionYesSelect || viewModel.isTransferOptionNoSelect) {
                        viewModel.stateProperty.shouldHide = false
                    }
                    tabScreenViewModel.showTimeSpecifyRedDot = viewModel.checkOptionTime()
                    Task {
                        tabScreenViewModel.filteredSegments = await
                        viewModel.filterTime(minInterval: 18, maxInterval: 24, codeIdFrom: tabScreenViewModel.loadedData.codeIdFrom, codeIdTo: tabScreenViewModel.loadedData.codeIdTo)
                    }
                }
        }
        .frame(height: 60)
    }
}

private struct NightTimeView: View {
    @ObservedObject var viewModel: TimeOptionsViewModel
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    
    var body: some View {
        HStack {
            Text("Ночь 00:00 - 06:00")
                .font(.system(size: 17, weight: .regular))
            Spacer()
            Image(viewModel.isNightTimeSelect ? .checked : .transferOptionSquare)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    viewModel.isNightTimeSelect.toggle()
                    if viewModel.isNightTimeSelect && (viewModel.isTransferOptionYesSelect || viewModel.isTransferOptionNoSelect)  {
                        viewModel.stateProperty.shouldHide = false
                    }
                    tabScreenViewModel.showTimeSpecifyRedDot = viewModel.checkOptionTime()
                    Task {
                        tabScreenViewModel.filteredSegments = await
                        viewModel.filterTime(minInterval: 0, maxInterval: 6, codeIdFrom: tabScreenViewModel.loadedData.codeIdFrom, codeIdTo: tabScreenViewModel.loadedData.codeIdTo)
                    }
                }
        }
        .frame(height: 60)
    }
}

private struct TransferYesView: View {
    @ObservedObject var viewModel: TimeOptionsViewModel
    
    var body: some View {
        HStack {
            Text("Да")
                .font(.system(size: 17, weight: .regular))
            Spacer()
            Image(viewModel.isTransferOptionYesSelect ? .transferOptionCheck : .transferOptionCircle)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    if viewModel.isTransferOptionYesSelect == false && viewModel.isTransferOptionNoSelect == false {
                        viewModel.isTransferOptionYesSelect = true
                    }
                    if viewModel.isTransferOptionNoSelect == true {
                        viewModel.isTransferOptionYesSelect = true
                        viewModel.isTransferOptionNoSelect = false
                    }
                    if (viewModel.isTransferOptionYesSelect == true || viewModel.isTransferOptionNoSelect == true) && (viewModel.isMorningTimeSelect || viewModel.isDayTimeSelect || viewModel.isEveningTimeSelect || viewModel.isNightTimeSelect) {
                        viewModel.stateProperty.shouldHide = false
                    }
                }
        }
        .frame(height: 60)
    }
}

private struct TransferNoView: View {
    @ObservedObject var viewModel: TimeOptionsViewModel
    
    var body: some View {
        HStack {
            Text("Нет")
                .font(.system(size: 17, weight: .regular))
            Spacer()
            Image(viewModel.isTransferOptionNoSelect ? .transferOptionCheck : .transferOptionCircle)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    if viewModel.isTransferOptionYesSelect == false && viewModel.isTransferOptionNoSelect == false {
                        viewModel.isTransferOptionNoSelect = true
                        viewModel.filterSegmentsWithTransfers(hasTransfers: false)
                    }
                    
                    if viewModel.isTransferOptionYesSelect == true {
                        viewModel.isTransferOptionNoSelect = true
                        viewModel.isTransferOptionYesSelect = false
                        viewModel.filterSegmentsWithTransfers(hasTransfers: false)
                    }
                    
                    if (viewModel.isTransferOptionYesSelect == true || viewModel.isTransferOptionNoSelect == true) && (viewModel.isMorningTimeSelect || viewModel.isDayTimeSelect || viewModel.isEveningTimeSelect || viewModel.isNightTimeSelect) {
                        viewModel.stateProperty.shouldHide = false
                    }
                }
        }
        .frame(height: 60)
    }
}
