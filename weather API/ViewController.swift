//
//  ViewController.swift
//  weather API
//
//  Created by apple on 25/04/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource ,CLLocationManagerDelegate
{
    @IBOutlet weak var iconIMG: UIImageView!
    @IBOutlet weak var wLBL: UILabel!
    var locationManager:CLLocationManager!
    var json = NSDictionary()
    var weatherdata = NSArray()
    var we = NSDictionary()
    var main = NSDictionary()
    var wea = Int()
    var c = Int()
    var feell = Int()
    var x = Int()
    @IBOutlet weak var countrynameLBL: UILabel!
    @IBOutlet weak var weatherLBL: UILabel!
    @IBOutlet weak var weatherCOLl: UICollectionView!
    
    @IBOutlet weak var mainVIEW: UIView!
    
    @IBOutlet weak var windLBL: UILabel!
    
    @IBOutlet weak var feelsLBL: UILabel!
    @IBOutlet weak var humidityLBL: UILabel!
    @IBOutlet weak var pressure: UILabel!
    
    @IBOutlet weak var wuind1: UILabel!
    
    @IBOutlet weak var feels1: UILabel!
    @IBOutlet weak var hum1: UILabel!
    @IBOutlet weak var pre1: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherCOLl.delegate = self
        self.weatherCOLl.dataSource = self
        self.mainVIEW.layer.cornerRadius = 20
        mainVIEW.backgroundColor =  UIColor (red: 50.0/255.0, green: 90.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        weatherLBL.textColor = UIColor.white
        wLBL.textColor = UIColor.white
        windLBL.textColor = UIColor.white
        feelsLBL.textColor = UIColor.white
        humidityLBL.textColor = UIColor.white
        pressure.textColor = UIColor.white
        wuind1.textColor = UIColor.white
        feels1.textColor = UIColor.white
        hum1.textColor = UIColor.white
        pre1.textColor = UIColor.white


        self.requestWeatherForLocation()
        
        locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()

            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
        
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)

                self.countrynameLBL.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCollectionViewCell", for: indexPath) as! weatherCollectionViewCell
        
        return cell
    }
    func requestWeatherForLocation() {
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=11.0176&lon=11.0176&appid=4cd569ffb3ecc3bffe9c0587ff02109f")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let err = error{
                print(err.localizedDescription)
            }
            if let resp = response as? HTTPURLResponse{
                print(resp.statusCode)
            }
            do{
                self.json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                self.weatherdata = self.json.value(forKey: "weather")as! NSArray
               
                self.we = self.weatherdata[0] as! NSDictionary
                self.main = self.json.value(forKey: "main")as! NSDictionary
                self.wea = Int("\((self.json.value(forKey: "main") as! NSDictionary).value(forKey: "temp") as! NSNumber)" ) ?? Int((self.json.value(forKey: "main") as! NSDictionary).value(forKey: "temp") as! NSNumber)
                self.c = (self.wea - 32) * 5 / 9;
                self.feell = Int("\((self.json.value(forKey: "main") as! NSDictionary).value(forKey: "feels_like") as! NSNumber)") ?? Int((self.json.value(forKey: "main") as! NSDictionary).value(forKey: "feels_like") as! NSNumber)
                self.x = (self.feell - 32) * 5 / 9;
                
            }
            catch let err as NSError{
                print(err.localizedDescription)
            }
            DispatchQueue.main.async {
                self.weatherCOLl.reloadData()
                self.Updates()
            }
        }
       
            task.resume()
    }
    
    func Updates(){
        self.iconIMG.image = UIImage.init(named: self.we.value(forKey: "icon") as! String)
        self.weatherLBL.text = self.we.value(forKey: "description") as! String
        self.wLBL.text = "\(self.c)° C "
        self.windLBL.text = "\((self.json.value(forKey: "wind") as! NSDictionary).value(forKey: "speed") as! NSNumber)"
        self.feelsLBL.text = "\(self.x)° C "
        self.humidityLBL.text = "\((self.json.value(forKey: "main") as! NSDictionary).value(forKey: "humidity") as! NSNumber)"
        self.pressure.text = "\((self.json.value(forKey: "main") as! NSDictionary).value(forKey: "pressure") as! NSNumber)"
//        self.weatherdata = (self.json.value(forKey: "main") as! NSDictionary).value(forKey: "temp") as! NSArray
        
    }
    
    @IBAction func nextpage(_ sender: Any) {
//        let push = storyboard?.instantiateViewController(withIdentifier: "nextdaysViewController") as! nextdaysViewController
//        self.navigationController?.pushViewController(push, animated: true)
    }
    

}

