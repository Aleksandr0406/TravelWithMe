//
//  Segment.swift
//  Travel-Schedule
//
//  Created by 1111 on 29.07.2025.
//

import Foundation

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
    var hasTransfer: Bool
}
