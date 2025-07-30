//
//  SettingsView.swift
//  Travel-Schedule
//
//  Created by 1111 on 20.05.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel = SettingsViewModel()
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            DarkThemeHStackView(viewModel: viewModel, tabScreenViewModel: tabScreenViewModel)
            UserAgreementHStackView(path: $path)
            Spacer()
            Text("Приложение использует API «Яндекс.Расписания»\nВерсия 1.0 (beta)")
                .font(.system(size: 12, weight: .regular))
                .multilineTextAlignment(.center)
                .lineSpacing(16)
                .padding(.bottom, 24)
        }
    }
}

private struct DarkThemeHStackView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @ObservedObject var tabScreenViewModel: TabScreenViewModel
    
    var body: some View {
        HStack {
            Text("Темная тема")
                .font(.system(size: 17, weight: .regular))
                .frame(maxWidth: .infinity,maxHeight: 60, alignment: .leading)
            Spacer()
            Toggle("", isOn: $viewModel.isEnabled)
                .onChange(of: viewModel.isEnabled)
            {
                tabScreenViewModel.colorScheme = viewModel.isEnabled ? .dark : .light
            }
        }
        .padding([.leading, .trailing], 16)
    }
}

private struct UserAgreementHStackView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            Text("Пользовательское соглашение")
                .font(.system(size: 17, weight: .regular))
                .frame(maxWidth: .infinity,maxHeight: 60, alignment: .leading)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .onTapGesture {
            path.append("UserAgreement")
        }
        .padding(.leading, 16)
        .padding(.trailing, 18)
    }
}
