//
//  LocationManager.swift
//  Weather Application
//
//  Created by Aamer Essa on 05/12/2022.
//

import Foundation



struct Weather: Codable{
    var location : City
   var current : CurrentWeather
    var forecast : Forecast
    
}

struct City: Codable {
    var name : String
    var country : String
    var localtime : String
}

struct CurrentWeather: Codable {
    var temp_c : Int
    var condition : Condition
    var wind_mph : Double
    var humidity : Int
    var feelslike_c : Double
    var cloud : Int
}

struct Condition: Codable {
    var text: String
    var icon: String
}

struct Forecast: Codable {
    var forecastday : [Forecastday]
}

struct Forecastday: Codable {
    var date : String
    var day: Day
    var hour : [Hour]
}

struct Day: Codable {
    var maxtemp_c : Double
    var mintemp_c : Double
    var condition : Condition

}

struct Hour: Codable {
    var time: String
    var temp_c : Double
    var condition : Condition
}
