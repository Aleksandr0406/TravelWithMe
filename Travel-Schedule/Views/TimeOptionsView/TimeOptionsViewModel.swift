//
//  ViewModel.swift
//  Travel-Schedule
//
//  Created by 1111 on 27.07.2025.
//

import SwiftUI

struct TimeOptionsViewModel {
    @Binding var stateProperty: StateProperties
    @Binding var loadedData: LoadedData
    
    func filterTime(minInterval: Int, maxInterval: Int) {
        let calculatedSegments = loadedData.segments.filter {
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
        
        if stateProperty.isMorningTimeSelect && minInterval == 6 {
            stateProperty.filterSegmentsMorningTime = calculatedSegments
        }
        
        if stateProperty.isMorningTimeSelect == false && minInterval == 6 {
            stateProperty.filterSegmentsMorningTime = []
        }
        
        if stateProperty.isDayTimeSelect && minInterval == 12 {
            stateProperty.filterSegmentsDayTime = calculatedSegments
        }
        
        if stateProperty.isDayTimeSelect == false && minInterval == 12 {
            stateProperty.filterSegmentsDayTime = []
        }
        
        if stateProperty.isEveningTimeSelect && minInterval == 18 {
            stateProperty.filterSegmentsEveningTime = calculatedSegments
        }
        
        if stateProperty.isEveningTimeSelect == false && minInterval == 18 {
            stateProperty.filterSegmentsEveningTime = []
        }
        
        if stateProperty.isNightTimeSelect && minInterval == 0 {
            stateProperty.filterSegmentsNightTime = calculatedSegments
        }
        
        if stateProperty.isNightTimeSelect == false && minInterval == 0 {
            stateProperty.filterSegmentsNightTime = []
        }
        
        stateProperty.filteredSegments = stateProperty.filterSegmentsMorningTime + stateProperty.filterSegmentsDayTime + stateProperty.filterSegmentsEveningTime + stateProperty.filterSegmentsNightTime
    }
    
    func checkOptionTime() {
        if stateProperty.isMorningTimeSelect == false && stateProperty.isDayTimeSelect == false &&
            stateProperty.isEveningTimeSelect == false && stateProperty.isNightTimeSelect == false {
            stateProperty.shouldHide = true
            stateProperty.showTimeSpecifyRedDot = false
        } else {
            stateProperty.showTimeSpecifyRedDot = true
        }
    }
}
