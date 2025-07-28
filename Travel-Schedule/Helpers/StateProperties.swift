//
//  StateProperties.swift
//  Travel-Schedule
//
//  Created by 1111 on 23.05.2025.
//

import SwiftUI

struct StateProperties {
    var colorScheme: ColorScheme = .light
    var path = NavigationPath()
    var isFromPointSelected: Bool = false
    var isToPointSelected: Bool = false
    var cityFrom: String = "Откуда"
    var cityTo: String = "Куда"
    var stationFrom: String?
    var stationTo: String?
    var isFromPointShow: Bool = false
    var isToPointShow: Bool = false
    var isPresentingStory: Bool = false
    var isMorningTimeSelect: Bool = false
    var isDayTimeSelect: Bool = false
    var isEveningTimeSelect: Bool = false
    var isNightTimeSelect: Bool = false
    var shouldHide: Bool = true
    var showTimeSpecifyRedDot: Bool = false
    var filteredSegments: [Segment] = []
    var filterSegmentsMorningTime: [Segment] = []
    var filterSegmentsDayTime: [Segment] = []
    var filterSegmentsEveningTime: [Segment] = []
    var filterSegmentsNightTime: [Segment] = []
    var tabSelection: Int = 0
    var indexOfGroupStories: Int = 0
}
