//
//  CarrierListView.swift
//  Travel-Schedule
//
//  Created by 1111 on 17.05.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct CarrierListView: View {
    let viewModel: CarrierListViewModel
    
    private var finalDestinationTo: String {
        return viewModel.stateProperty.cityTo + " (" + (viewModel.stateProperty.stationTo ?? "") + ")"
    }
    
    private var finalDestinationFrom: String {
        return viewModel.stateProperty.cityFrom + " (" + (viewModel.stateProperty.stationFrom ?? "") + ")"
    }
    
    var segments: [Segment] {
        if viewModel.stateProperty.showTimeSpecifyRedDot {
            viewModel.stateProperty.filteredSegments
        } else {
            viewModel.loadedData.segments
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(finalDestinationFrom + "→" + finalDestinationTo)
                .font(.system(size: 24, weight: .bold))
                .accentColor(.black)
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing], 16)
            if !segments.isEmpty {
                List(segments, id: \.self) { carrier in
                    SegmentCarrierView(segment: carrier)
                        .onTapGesture {
                            viewModel.loadedData.singleSegment = carrier
                            viewModel.stateProperty.path.append("CarrierInfo")
                        }
                }
                .frame(maxWidth: .infinity)
                .listStyle(.plain)
                .padding(.top, 16)
            } else {
                Spacer()
                Text("Вариантов нет")
                    .font(.system(size: 24, weight: Font.Weight.bold))
                Spacer()
            }
            Button(action: { viewModel.stateProperty.path.append("TimeOptions") }) {
                Text("Уточнить время")
                if viewModel.stateProperty.showTimeSpecifyRedDot {
                    Image(.timeSpecifyDot)
                        .frame(width: 8, height: 8)
                }
            }
            .font(.system(size: 17, weight: .bold))
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .foregroundStyle(.white)
            .background(.blue)
            .cornerRadius(16)
            .padding([.leading, .trailing], 16)
        }
        .toolbarRole(.editor)
    }
}

private struct SegmentCarrierView: View, Hashable {
    let segment: Segment
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .frame(maxWidth: .infinity)
                .frame(height: 104)
                .foregroundStyle(.lightGr)
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    if !segment.logoSmall.isEmpty {
                        WebImage(url: URL(string: segment.logoSmall))
                            .resizable()
                            .frame(width: 38, height: 38)
                            .cornerRadius(12)
                            .padding(.trailing, 8)
                    } else {
                        Image(.placeholder)
                            .frame(width: 38, height: 38)
                            .padding(.trailing, 8)
                    }
                    VStack(spacing: 0) {
                        Text(segment.carrierTitle)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.allBlack)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if segment.hasTransfer {
                            Text("С пересадкой")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    Text(segment.startDate)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.allBlack)
                        .padding(.bottom, 27)
                }
                .padding(EdgeInsets(top: 14, leading: 14, bottom: 0, trailing: 7))
                HStack {
                    Text(segment.departureDate)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.allBlack)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray)
                    Text(segment.duration)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.allBlack)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray)
                    Text(segment.arrivalDate)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.allBlack)
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 14)
            }
        }
    }
}
