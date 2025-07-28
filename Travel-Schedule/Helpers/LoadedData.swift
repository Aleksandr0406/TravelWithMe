//
//  StoredData.swift
//  Travel-Schedule
//
//  Created by 1111 on 07.07.2025.
//

import Foundation

struct LoadedData {
    var settlement: [Settlement] = []
    var codeIdFrom: String = ""
    var codeIdTo: String = ""
    var segments: [Segment] = []
    var singleSegment: Segment?
}

struct Segment: Hashable {
    var departureDate: String
    var arrivalDate: String
    var duration: String
    var carrierTitle: String
    var carrierPhone: String
    var carrierEmail: String
    var startDate: String
    var logoSmall: String
    var logo: String
}

struct Settlement {
    var title: String
    var code: String
    var stations: [Station]
}

struct Station: Hashable {
    var name: String
    var codeId: String
}
