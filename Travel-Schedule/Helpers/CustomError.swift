//
//  CustomError.swift
//  Travel-Schedule
//
//  Created by 1111 on 29.07.2025.
//

import Foundation

enum CustomError: Error {
    case JsonFailed(String)
    case ClientNil
    case ServerError
    case InternetError
    case notFound
}
