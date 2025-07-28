//
//  TimeOptionsView.swift
//  Travel-Schedule
//
//  Created by 1111 on 19.05.2025.
//

import SwiftUI

struct TimeOptionsView: View {
    @State private var isTransferOptionYesSelect: Bool = false
    @State private var isTransferOptionNoSelect: Bool = false
    
    let viewModel: TimeOptionsViewModel
    
    var body: some View {
        VStack {
            Text("Время отправления")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            MorningTimeView(viewModel: viewModel, isTransferOptionYesSelect: $isTransferOptionYesSelect, isTransferOptionNoSelect: $isTransferOptionNoSelect)
            DayTimeView(viewModel: viewModel, isTransferOptionYesSelect: $isTransferOptionYesSelect, isTransferOptionNoSelect: $isTransferOptionNoSelect)
            EveningTimeView(viewModel: viewModel, isTransferOptionYesSelect: $isTransferOptionYesSelect, isTransferOptionNoSelect: $isTransferOptionNoSelect)
            NightTimeView(viewModel: viewModel, isTransferOptionYesSelect: $isTransferOptionYesSelect, isTransferOptionNoSelect: $isTransferOptionNoSelect)
            Text("Показывать варианты с пересадками")
                .font(.system(size: 24, weight: .bold))
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            TransferYesView(isTransferOptionYesSelect: $isTransferOptionYesSelect, isTransferOptionNoSelect: $isTransferOptionNoSelect, viewModel: viewModel)
            TransferNoView(isTransferOptionYesSelect: $isTransferOptionYesSelect, isTransferOptionNoSelect: $isTransferOptionNoSelect, viewModel: viewModel)
        }
        .padding([.leading, .trailing], 16)
        Spacer()
        Button("Применить") {
            viewModel.stateProperty.path.removeLast()
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
    let viewModel: TimeOptionsViewModel
    
    @Binding var isTransferOptionYesSelect: Bool
    @Binding var isTransferOptionNoSelect: Bool
    
    var body: some View {
        HStack {
            Text("Утро 06:00 - 12:00")
                .font(.system(size: 17, weight: .regular))
            Spacer()
            Image(viewModel.stateProperty.isMorningTimeSelect ? .checked : .transferOptionSquare)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    viewModel.stateProperty.isMorningTimeSelect.toggle()
                    if viewModel.stateProperty.isMorningTimeSelect && (isTransferOptionYesSelect || isTransferOptionNoSelect) {
                        viewModel.stateProperty.shouldHide = false
                    }
                    viewModel.checkOptionTime()
                    viewModel.filterTime(minInterval: 6, maxInterval: 12)
                }
        }
        .frame(height: 60)
    }
}

private struct DayTimeView: View {
    let viewModel: TimeOptionsViewModel
    
    @Binding var isTransferOptionYesSelect: Bool
    @Binding var isTransferOptionNoSelect: Bool
    
    var body: some View {
        HStack {
            Text("День 12:00 - 18:00")
                .font(.system(size: 17, weight: .regular))
            Spacer()
            Image(viewModel.stateProperty.isDayTimeSelect ? .checked : .transferOptionSquare)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    viewModel.stateProperty.isDayTimeSelect.toggle()
                    if viewModel.stateProperty.isDayTimeSelect && (isTransferOptionYesSelect || isTransferOptionNoSelect)  {
                        viewModel.stateProperty.shouldHide = false
                    }
                    viewModel.checkOptionTime()
                    viewModel.filterTime(minInterval: 12, maxInterval: 18)
                }
        }
        .frame(height: 60)
    }
}

private struct EveningTimeView: View {
    let viewModel: TimeOptionsViewModel
    
    @Binding var isTransferOptionYesSelect: Bool
    @Binding var isTransferOptionNoSelect: Bool
    
    var body: some View {
        HStack {
            Text("Вечер 18:00 - 00:00")
                .font(.system(size: 17, weight: .regular))
            Spacer()
            Image(viewModel.stateProperty.isEveningTimeSelect ? .checked : .transferOptionSquare)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    viewModel.stateProperty.isEveningTimeSelect.toggle()
                    if viewModel.stateProperty.isEveningTimeSelect && (isTransferOptionYesSelect || isTransferOptionNoSelect) {
                        viewModel.stateProperty.shouldHide = false
                    }
                    viewModel.checkOptionTime()
                    viewModel.filterTime(minInterval: 18, maxInterval: 24)
                }
        }
        .frame(height: 60)
    }
}

private struct NightTimeView: View {
    let viewModel: TimeOptionsViewModel
    
    @Binding var isTransferOptionYesSelect: Bool
    @Binding var isTransferOptionNoSelect: Bool
    
    var body: some View {
        HStack {
            Text("Ночь 00:00 - 06:00")
                .font(.system(size: 17, weight: .regular))
            Spacer()
            Image(viewModel.stateProperty.isNightTimeSelect ? .checked : .transferOptionSquare)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    viewModel.stateProperty.isNightTimeSelect.toggle()
                    if viewModel.stateProperty.isNightTimeSelect && (isTransferOptionYesSelect || isTransferOptionNoSelect)  {
                        viewModel.stateProperty.shouldHide = false
                    }
                    viewModel.checkOptionTime()
                    viewModel.filterTime(minInterval: 0, maxInterval: 6)
                }
        }
        .frame(height: 60)
    }
}

private struct TransferYesView: View {
    @Binding var isTransferOptionYesSelect: Bool
    @Binding var isTransferOptionNoSelect: Bool
    
    let viewModel: TimeOptionsViewModel
    
    var body: some View {
        HStack {
            Text("Да")
                .font(.system(size: 17, weight: .regular))
            Spacer()
            Image(isTransferOptionYesSelect ? .transferOptionCheck : .transferOptionCircle)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    if isTransferOptionYesSelect == false && isTransferOptionNoSelect == false {
                        isTransferOptionYesSelect = true
                    }
                    if isTransferOptionNoSelect == true {
                        isTransferOptionYesSelect = true
                        isTransferOptionNoSelect = false
                    }
                    if (isTransferOptionYesSelect == true || isTransferOptionNoSelect == true) && (viewModel.stateProperty.isMorningTimeSelect || viewModel.stateProperty.isDayTimeSelect || viewModel.stateProperty.isEveningTimeSelect || viewModel.stateProperty.isNightTimeSelect) {
                        viewModel.stateProperty.shouldHide = false
                    }
                }
        }
        .frame(height: 60)
    }
}

private struct TransferNoView: View {
    @Binding var isTransferOptionYesSelect: Bool
    @Binding var isTransferOptionNoSelect: Bool
    
    let viewModel: TimeOptionsViewModel
    
    var body: some View {
        HStack {
            Text("Нет")
                .font(.system(size: 17, weight: .regular))
            Spacer()
            Image(isTransferOptionNoSelect ? .transferOptionCheck : .transferOptionCircle)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    if isTransferOptionYesSelect == false && isTransferOptionNoSelect == false {
                        isTransferOptionNoSelect = true
                        viewModel.filterSegmentsWithTransfers(hasTransfers: false)
                    }
                    
                    if isTransferOptionYesSelect == true {
                        isTransferOptionNoSelect = true
                        isTransferOptionYesSelect = false
                        viewModel.filterSegmentsWithTransfers(hasTransfers: false)
                    }
                    
                    if (isTransferOptionYesSelect == true || isTransferOptionNoSelect == true) && (viewModel.stateProperty.isMorningTimeSelect || viewModel.stateProperty.isDayTimeSelect || viewModel.stateProperty.isEveningTimeSelect || viewModel.stateProperty.isNightTimeSelect) {
                        viewModel.stateProperty.shouldHide = false
                    }
                }
        }
        .frame(height: 60)
    }
}
