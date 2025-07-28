//
//  SettingsView.swift
//  Travel-Schedule
//
//  Created by 1111 on 20.05.2025.
//

import SwiftUI

struct SettingsView: View {
    let viewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            DarkThemeHStackView(viewModel: viewModel)
            UserAgreementHStackView(viewModel: viewModel)
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
    @State private var isEnabled: Bool = false
    
    let viewModel: SettingsViewModel
    
    var body: some View {
        HStack {
            Text("Темная тема")
                .font(.system(size: 17, weight: .regular))
                .frame(maxWidth: .infinity,maxHeight: 60, alignment: .leading)
            Spacer()
            Toggle("", isOn: $isEnabled)
                .onChange(of: isEnabled)
            {
                viewModel.stateProperty.colorScheme = isEnabled ? .dark : .light
            }
        }
        .padding([.leading, .trailing], 16)
    }
}

private struct UserAgreementHStackView: View {
    let viewModel: SettingsViewModel
    
    var body: some View {
        HStack {
            Text("Пользовательское соглашение")
                .font(.system(size: 17, weight: .regular))
                .frame(maxWidth: .infinity,maxHeight: 60, alignment: .leading)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .onTapGesture {
            viewModel.stateProperty.path.append("UserAgreement")
        }
        .padding(.leading, 16)
        .padding(.trailing, 18)
    }
}
