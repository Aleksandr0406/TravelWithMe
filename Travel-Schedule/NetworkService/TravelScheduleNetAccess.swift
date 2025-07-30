//
//  TravelScheduleNetAccess.swift
//  Travel-Schedule
//
//  Created by 1111 on 04.07.2025.
//

import OpenAPIURLSession
import SwiftUI

struct TravelScheduleNetAccess {
    private let client: Client? = {
        do {
            let client = try Client(
                serverURL: Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            return client
        } catch {
            print("TravelScheduleNetAccess client Error")
            return nil
        }
    }()
    
    func getBetweenStationsSchedule(codeIdFrom: String, codeIdTo: String) async -> [Segment] {
        guard let client else {
            print("getBetweenStationsSchedule error")
            return []
        }
        let service = TravelScheduleService(
            client: client,
            apikey: Constants.api
        )
        
        var newSegments: [Segment] = []
        
        do {
            let betweenStationsSchedule = try await service.getBetweenStationsSchedule(from: codeIdFrom, to: codeIdTo)
            guard let segments = betweenStationsSchedule.segments else {
                print("getBetweenStationsSchedule error")
                return []
            }
            
            segments.forEach {
                let departureDate = $0.departure
                let arrivalDate = $0.arrival
                let duration = $0.duration
                let carrierTitle = $0.thread?.carrier?.title
                let startDate = $0.start_date
                let logoSmall = $0.thread?.carrier?.logo_svg
                let logo = $0.thread?.carrier?.logo
                let hasTransfer = $0.has_transfers
                
                let carrierPhone = $0.thread?.carrier?.phone
                let carrierEmail = $0.thread?.carrier?.email
                
                let dateDeparture = FormatterFactory.timeFormatter.date(from: departureDate ?? "")
                let dateArrival = FormatterFactory.timeFormatter.date(from: arrivalDate ?? "")
                
                let shortStringDepDate = FormatterFactory.shortTimeFormatter.string(from: dateDeparture ?? Date())
                let shortStringArrDate = FormatterFactory.shortTimeFormatter.string(from: dateArrival ?? Date())
                
                let dateStart = FormatterFactory.dateFormatter.date(from: startDate ?? "")
                let dateStartString = FormatterFactory.shortDateFormatter.string(from: dateStart ?? Date())
                
                let hours = (duration ?? 0) / 3600
                var textDuration: String
                
                if hours == 1 {
                    textDuration = "\(hours) час"
                } else if hours == 2 || hours == 3 || hours == 4 {
                    textDuration = "\(hours) часа"
                } else {
                    textDuration = "\(hours) часов"
                }
                
                let segment = Segment(
                    departureDate: shortStringDepDate,
                    arrivalDate: shortStringArrDate,
                    duration: textDuration,
                    carrierTitle: carrierTitle ?? "Нет названия",
                    carrierPhone: carrierPhone ?? "Без телефона",
                    carrierEmail: carrierEmail ?? "-//-",
                    startDate: dateStartString,
                    logoSmall: logoSmall ?? "",
                    logo: logo ?? "",
                    hasTransfer: hasTransfer ?? false
                )
                newSegments.append(segment)
            }
        } catch {
            print("Ошибка при получении расписания: \(error.localizedDescription)")
        }
        return newSegments
    }
    
    func getStationsList() async -> [Settlement] {
        guard let client = client else {
            print("TravelScheduleNetAccess getStationsList: client: error")
            return []
        }
        let service = TravelScheduleService(
            client: client,
            apikey: Constants.api
        )
        
        var newSettlements: [Settlement] = []
        do {
            let stationsList = try await service.getStationsList()
            guard let countries = stationsList.countries else {
                print("TravelScheduleNetAccess getStationsList: countries: error")
                return []
            }
            for country in countries {
                if country.title == "Россия" {
                    guard let regions = country.regions else {
                        print("TravelScheduleNetAccess getStationsList: regions: error")
                        return []
                    }
                    for region in regions {
                        if region.title == "Москва и Московская область" || region.title == "Санкт-Петербург и Ленинградская область" {
                            guard let settlements = region.settlements else {
                                print("TravelScheduleNetAccess getStationsList: settlements: error")
                                return []
                            }
                            for settlement in settlements {
                                guard let stations = settlement.stations else {
                                    print("TravelScheduleNetAccess getStationsList: stations: error")
                                    return []
                                }
                                var filterStations: [Station] = []
                                for station in stations {
                                    let stationTitle = station.title
                                    let codeId = station.codes?.yandex_code
                                    if station.station_type == "train_station" && stationTitle != "" {
                                        let station = Station(name: stationTitle ?? "Без названия", codeId: codeId ?? "Без кода")
                                        filterStations.append(station)
                                    }
                                }
                                if !filterStations.isEmpty {
                                    let settlement = Settlement(
                                        title: settlement.title ?? "",
                                        code: settlement.codes?.yandex_code ?? "",
                                        stations: filterStations
                                    )
                                    newSettlements.append(settlement)
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Ошибка при получении списка станций: \(error.localizedDescription)")
        }
        return newSettlements
    }
}
