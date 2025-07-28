//
//  CarrierInfoView.swift
//  Travel-Schedule
//
//  Created by 1111 on 20.05.2025.
//

import SwiftUI

struct CarrierInfoView: View {
    let viewModel: CarrierInfoViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: viewModel.loadedData.singleSegment?.logo ?? "")) { state in
                switch state {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .cornerRadius(24)
                        .padding([.top, .bottom], 16)
                case .failure:
                    Image(.placeholder)
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            Text(viewModel.loadedData.singleSegment?.carrierTitle ?? "Ошибка")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            VStack(spacing: 0) {
                Text("E-mail")
                    .font(.system(size: 17, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(viewModel.loadedData.singleSegment?.carrierEmail ?? "Нет email")
                    .font(.system(size: 12, weight: .regular))
                    .accentColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 60)
            VStack(spacing: 0) {
                Text("Телефон")
                    .font(.system(size: 17, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(viewModel.loadedData.singleSegment?.carrierPhone ?? "Нет телефона")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 60)
            Spacer()
        }
        .padding([.leading, .trailing], 16)
        .toolbarRole(.editor)
        .navigationTitle("Информация о перевозчике")
    }
}
