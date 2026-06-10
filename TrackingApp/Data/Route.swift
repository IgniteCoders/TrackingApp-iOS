//
//  Route.swift
//  TrackingApp
//
//  Created by Tardes on 10/6/26.
//

struct Route : Codable {
    let id: String
    let userId: String
    let startDate: Int64
    var endDate: Int64?
}
