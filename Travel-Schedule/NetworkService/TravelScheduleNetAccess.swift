//
//  TravelScheduleNetAccess.swift
//  Travel-Schedule
//
//  Created by 1111 on 04.07.2025.
//

import Foundation
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
            print("Error")
            return nil
        }
    }()
    
    @Binding var loadedData: LoadedData
    
    //    func getNearestStations() {
    //        guard let client else { return }
    //        let service = TravelScheduleService(
    //            client: client,
    //            apikey: "2687cbe0-00bc-46ff-a210-539299d1c7ae"
    //        )
    //
    //        Task {
    //            let stations = try await service.getNearestStations(lat: 59.9386300, lng: 30.3141300, distance: 50)
    //                }
    //            }
    
    func getBetweenStationsSchedule(codeIdFrom: String, codeIdTo: String) {
        guard let client else { return }
        let service = TravelScheduleService(
            client: client,
            apikey: "2687cbe0-00bc-46ff-a210-539299d1c7ae"
        )
        
        Task {
            let betweenStationsSchedule = try await service.getBetweenStationsSchedule(from: codeIdFrom, to: codeIdTo)
            guard let segments = betweenStationsSchedule.segments else { return }
            segments.forEach {
                let departureDate = $0.departure
                let arrivalDate = $0.arrival
                let duration = $0.duration
                let carrierTitle = $0.thread?.carrier?.title
                let startDate = $0.start_date
                let logoSmall = $0.thread?.carrier?.logo_svg
                let logo = $0.thread?.carrier?.logo
                
                let carrierPhone = $0.thread?.carrier?.phone
                let carrierEmail = $0.thread?.carrier?.email
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                let dateDeparture = dateFormatter.date(from: departureDate ?? "")
                let dateArrival = dateFormatter.date(from: arrivalDate ?? "")
                dateFormatter.dateFormat = "HH:mm"
                let shortStringDepDate = dateFormatter.string(from: dateDeparture ?? Date())
                let shortStringArrDate = dateFormatter.string(from: dateArrival ?? Date())
                
                let dateFormatterForStartDate = DateFormatter()
                dateFormatterForStartDate.dateFormat = "yyyy.MM.dd"
                let dateStart = dateFormatterForStartDate.date(from: startDate ?? "")
                dateFormatterForStartDate.locale = Locale(identifier: "ru_RU")
                dateFormatterForStartDate.dateStyle = .long
                dateFormatterForStartDate.dateFormat = "dd MMMM"
                let dateStartString = dateFormatterForStartDate.string(from: dateStart ?? Date())
                
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
                    logo: logo ?? ""
                )
                loadedData.segments.append(segment)
            }
            print(loadedData.segments.count)
            loadedData.segments.forEach { print($0.logoSmall) }
        }
    }
    
    func getOnStationsSchedule() {
        guard let client = client else { return }
        let service = TravelScheduleService(
            client: client,
            apikey: "2687cbe0-00bc-46ff-a210-539299d1c7ae"
        )
        
        Task {
            let onStationsSchedule = try await service.getOnStationsSchedule(station: "s9600213")
            print(onStationsSchedule)
        }
    }
    
    func getRouteStations() {
        guard let client = client else { return }
        let service = TravelScheduleService(
            client: client,
            apikey: "2687cbe0-00bc-46ff-a210-539299d1c7ae"
        )
        
        Task {
            let routeStations = try await service.getRouteStations(uid: "")
            print(routeStations)
        }
    }
    
    func getNearestCity() {
        guard let client = client else { return }
        let service = TravelScheduleService(
            client: client,
            apikey: "2687cbe0-00bc-46ff-a210-539299d1c7ae"
        )
        
        Task {
            let nearestCity = try await service.getNearestCity(lat: 59.864177, lng: 30.319163)
            print(nearestCity)
        }
    }
    
    func getCarrierInfo() {
        guard let client = client else { return }
        let service = TravelScheduleService(
            client: client,
            apikey: "2687cbe0-00bc-46ff-a210-539299d1c7ae"
        )
        
        Task {
            let carrierInfo = try await service.getCarrierInfo(code: "112")
            print(carrierInfo)
        }
    }
    
    func getStationsList() {
        guard let client = client else { return }
        let service = TravelScheduleService(
            client: client,
            apikey: "2687cbe0-00bc-46ff-a210-539299d1c7ae"
        )
        
        Task {
            let stationsList = try await service.getStationsList()
            guard let countries = stationsList.countries else { return }
            for country in countries {
                if country.title == "Россия" {
                    guard let regions = country.regions else { return }
//                    regions.forEach { print($0.title) }
                    for region in regions {
                        if region.title == "Москва и Московская область" || region.title == "Санкт-Петербург и Ленинградская область" {
                            guard let settlements = region.settlements else { return }
                            for settlement in settlements {
                                guard let stations = settlement.stations else { return  }
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
                                    loadedData.settlement.append(settlement)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getCopyright() {
        guard let client = client else { return }
        let service = TravelScheduleService(
            client: client,
            apikey: "2687cbe0-00bc-46ff-a210-539299d1c7ae"
        )
        
        Task {
            let copyright = try await service.getCopyright(format: "json")
            print(copyright.copyright?.text ?? "")
        }
    }
}
