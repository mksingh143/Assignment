//
//  MapModel.swift
//  ManojiOSDev
//
//  Created by manojnkumar on 21/10/21.
//

import UIKit

struct TrucksModel : Codable {
    let responseCode : ResponseCode?
    let data : [TruckResult]?

    enum CodingKeys: String, CodingKey {

        case responseCode = "responseCode"
        case data = "data"
    }

}

struct ResponseCode : Codable {
    let responseCode : Int?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case responseCode = "responseCode"
        case message = "message"
    }

}

struct TruckResult : Codable {
    let id : Int?
    let companyId : Int?
    let truckTypeId : Int?
    let truckSizeId : Int?
    let truckNumber : String?
    let transporterId : Int?
    let trackerType : Int?
    let imeiNumber : String?
    let simNumber : String?
    let name : String?
    let password : String?
    let createTime : Int?
    let deactivated : Bool?
    let breakdown : Bool?
    let lastWaypoint : LastWaypoint?
    let lastRunningState : LastRunningState?
    let durationInsideSite : Int?
    let fuelSensorInstalled : Bool?
    let externalTruck : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case companyId = "companyId"
        case truckTypeId = "truckTypeId"
        case truckSizeId = "truckSizeId"
        case truckNumber = "truckNumber"
        case transporterId = "transporterId"
        case trackerType = "trackerType"
        case imeiNumber = "imeiNumber"
        case simNumber = "simNumber"
        case name = "name"
        case password = "password"
        case createTime = "createTime"
        case deactivated = "deactivated"
        case breakdown = "breakdown"
        case lastWaypoint = "lastWaypoint"
        case lastRunningState = "lastRunningState"
        case durationInsideSite = "durationInsideSite"
        case fuelSensorInstalled = "fuelSensorInstalled"
        case externalTruck = "externalTruck"
    }

}

struct LastWaypoint : Codable {
    let id : Int?
    let lat : Double?
    let lng : Double?
    let createTime : Int?
    let accuracy : Double?
    let bearing : Double?
    let truckId : Int?
    let speed : Double?
    let updateTime : Int?
    let ignitionOn : Bool?
    let odometerReading : Double?
    let batteryPower : Bool?
    let fuelLevel : Int?
    let batteryLevel : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case lat = "lat"
        case lng = "lng"
        case createTime = "createTime"
        case accuracy = "accuracy"
        case bearing = "bearing"
        case truckId = "truckId"
        case speed = "speed"
        case updateTime = "updateTime"
        case ignitionOn = "ignitionOn"
        case odometerReading = "odometerReading"
        case batteryPower = "batteryPower"
        case fuelLevel = "fuelLevel"
        case batteryLevel = "batteryLevel"
    }

}

struct LastRunningState : Codable {
    let truckId : Int?
    let stopStartTime : Int?
    let truckRunningState : Int?
    let lat : Double?
    let lng : Double?
    let stopNotficationSent : Int?

    enum CodingKeys: String, CodingKey {

        case truckId = "truckId"
        case stopStartTime = "stopStartTime"
        case truckRunningState = "truckRunningState"
        case lat = "lat"
        case lng = "lng"
        case stopNotficationSent = "stopNotficationSent"
    }

}
