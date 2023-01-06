//
//  ViewController.swift
//  Weather Application
//
//  Created by Aamer Essa on 05/12/2022.
//

import UIKit
import Kingfisher
class ViewController: UIViewController {
    
    
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var daysWeather: UICollectionView!
    @IBOutlet weak var hourWether: UICollectionView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var cloudCover: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weather:Weather?
    var hours_weather = [Hour]()
    var days_weather = [Forecastday]()
    var pointer = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourWether.delegate = self
        hourWether.dataSource = self
        daysWeather.dataSource = self
        daysWeather.delegate = self
        
        view.backgroundColor = UIColor(red: 0.40, green: 0.89, blue: 1.00, alpha: 1.00)
        hourWether.backgroundColor = UIColor(red: 0.40, green: 0.89, blue: 1.00, alpha: 1.00)
        daysWeather.backgroundColor = UIColor(red: 0.40, green: 0.89, blue: 1.00, alpha: 1.00)
        
        let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=250340b405ed433a9c1182059221112&q=madinah&days=7&aqi=no&alerts=no")
        let sesssion = URLSession.shared
        let dataTask = sesssion.dataTask(with: url!) { data, response, error in

            let decoder = JSONDecoder()
            
            do{
                
                self.weather = try decoder.decode(Weather.self, from: data!)
                self.days_weather = self.weather!.forecast.forecastday // safe the weather of the days
                self.hours_weather = self.days_weather[0].hour
                
                
                DispatchQueue.main.async { [self] in
                   
                    let todayForamtter = DateFormatter()
                    todayForamtter.dateFormat = "h:mm a"
                    
                    self.cityLabel.text = "\(self.weather!.location.name)"
                    self.temp.text = "\(Int(self.weather!.current.temp_c))°"
                    self.weatherDescription.text = self.weather!.current.condition.text
                    self.time.text = "\(todayForamtter.string(from: Date()))"
                    self.windSpeed.text = "\(self.weather!.current.wind_mph)"
                    self.humidity.text = "\(self.weather!.current.humidity) %"
                    self.cloudCover.text = "\(self.weather!.current.cloud) %"
                 
                    
                    // desplay the date to the buttons
                    var btnTitel = [String]()
                    
                    for day in 0 ... self.days_weather.count-1 {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateFormat =  dateFormatter.date(from:self.days_weather[day].date)
                        dateFormatter.dateFormat = "EE, dd MMM "
                        btnTitel.append(dateFormatter.string(from: dateFormat!))
                    }
                    
                    btnOne.setTitle(btnTitel[0], for: .normal)
                    btnTwo.setTitle(btnTitel[1], for: .normal)
                    btnThree.setTitle(btnTitel[2], for: .normal)
                    
                    self.hourWether.reloadData()
                    self.daysWeather.reloadData()
                }
                
                
            } catch{
              print("\(error)")
            }
          
        }
        
        dataTask.resume()
        
    }
    
    
    @IBAction func onClickChangeDay(_ sender: UIButton) {
        switch sender.tag {
        case 0: pointer = 0; self.daysWeather.reloadData()
        case 1: pointer = 1; self.daysWeather.reloadData()
        case 2: pointer = 2; self.daysWeather.reloadData()
        default:
            pointer = 0
            self.daysWeather.reloadData()
        }
    }
    
    
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.daysWeather {
            return hours_weather.count
        }
        return hours_weather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.daysWeather {
            
            let cell = daysWeather.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! DaysCollectionViewCell
            
            // desplay the day
            let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateFormat =  dateFormatter.date(from: days_weather[self.pointer].date)
            dateFormatter.dateFormat = "EEEE"
            
            // desplay the time
            let time = days_weather[self.pointer].hour[indexPath.row].time
            let hourFormat = time.components(separatedBy: " ")  
            
            cell.day.text = dateFormatter.string(from: dateFormat!)
            cell.time.text = hourFormat[1]
            cell.condition.text = "\(days_weather[self.pointer].hour[indexPath.row].condition.text)"
            cell.maxTemp.text = "\(days_weather[self.pointer].hour[indexPath.row].temp_c) °"
            cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
            cell.layer.cornerRadius = 20
            return cell
            
        }
            let cell = hourWether.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HoursCollectionViewCell
        // desplay the time
            let time = hours_weather[indexPath.row].time
            let hourFormat = time.components(separatedBy: " ")
        
            cell.temp.text = "\(hours_weather[indexPath.row].temp_c )°"
            cell.time.text = hourFormat[1]
            cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
            cell.layer.cornerRadius = 20
            return cell
        
        
  
    }
  
}


    
    
    
    


