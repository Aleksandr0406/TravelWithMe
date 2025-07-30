//
//  ViewModel.swift
//  Travel-Schedule
//
//  Created by 1111 on 27.07.2025.
//

import SwiftUI

final class TimeOptionsViewModel: ObservableObject, @unchecked Sendable {
    @Published var isTransferOptionYesSelect: Bool = false
    @Published var isTransferOptionNoSelect: Bool = false
    @Published var isMorningTimeSelect: Bool = false
    @Published var isDayTimeSelect: Bool = false
    @Published var isEveningTimeSelect: Bool = false
    @Published var isNightTimeSelect: Bool = false
    @Published var filterSegmentsMorningTime: [Segment] = []
    @Published var filterSegmentsDayTime: [Segment] = []
    @Published var filterSegmentsEveningTime: [Segment] = []
    @Published var filterSegmentsNightTime: [Segment] = []
    @Published var stateProperty: StateProperties = StateProperties()
    @Published var loadedData: LoadedData = LoadedData()
    
    let networkService: TravelScheduleNetAccess = TravelScheduleNetAccess()
    
    func filterTime(minInterval: Int, maxInterval: Int, codeIdFrom: String, codeIdTo: String) async -> [Segment] {
        let loadedSegments = await networkService.getBetweenStationsSchedule(codeIdFrom: codeIdFrom, codeIdTo: codeIdTo)
        let calculatedSegments = loadedSegments.filter {
            let charactersDepartureStringDateArray = $0.departureDate.map { $0 }
            var departureDateInMinutes: Int = 0
            var hours: String = ""
            var minutes: String = ""
            for index in 0..<charactersDepartureStringDateArray.count {
                if index == 0 || index == 1 {
                    hours = hours + String(charactersDepartureStringDateArray[index])
                }
                if index == 3 || index == 4 {
                    minutes = minutes + String(charactersDepartureStringDateArray[index])
                }
            }
            departureDateInMinutes = (Int(hours) ?? 0) * 60 + (Int(minutes) ?? 0)
            let minIntervalInMinutes = minInterval * 60
            let maxIntervalInMinutes = maxInterval * 60
            return departureDateInMinutes > minIntervalInMinutes && departureDateInMinutes < maxIntervalInMinutes
        }
        
        if isMorningTimeSelect && minInterval == 6 {
            filterSegmentsMorningTime = calculatedSegments
        }
        
        if isMorningTimeSelect == false && minInterval == 6 {
            filterSegmentsMorningTime = []
        }
        
        if isDayTimeSelect && minInterval == 12 {
            filterSegmentsDayTime = calculatedSegments
        }
        
        if isDayTimeSelect == false && minInterval == 12 {
            filterSegmentsDayTime = []
        }
        
        if isEveningTimeSelect && minInterval == 18 {
            filterSegmentsEveningTime = calculatedSegments
        }
        
        if isEveningTimeSelect == false && minInterval == 18 {
            filterSegmentsEveningTime = []
        }
        
        if isNightTimeSelect && minInterval == 0 {
            filterSegmentsNightTime = calculatedSegments
        }
        
        if isNightTimeSelect == false && minInterval == 0 {
            filterSegmentsNightTime = []
        }
        
        let filteredSegments = filterSegmentsMorningTime + filterSegmentsDayTime + filterSegmentsEveningTime + filterSegmentsNightTime
        return filteredSegments
    }
    
    func checkOptionTime() -> Bool {
        if isMorningTimeSelect == false && isDayTimeSelect == false &&
            isEveningTimeSelect == false && isNightTimeSelect == false {
            stateProperty.shouldHide = true
            return false
        } else {
            return true
        }
    }
    
    func filterSegmentsWithTransfers(hasTransfers: Bool) {
    }
}
