//
//  nextdaysViewController.swift
//  weather API
//
//  Created by apple on 25/04/23.
//

import UIKit
import CoreLocation

class nextdaysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var json = NSDictionary()
    @IBOutlet weak var weatherTBL: UITableView!
    var daily = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherTBL.delegate = self
        self.weatherTBL.dataSource = self
        self.requestWeatherForLocation()
        
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weaTableViewCell", for: indexPath)as! weaTableViewCell
//        print("\((((self.json.value(forKey: "daily") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "weather") as! NSDictionary).value(forKey: "icon") as! NSNumber)")
        cell.iconIMG.image = UIImage(named: "\(((self.daily.object(at: indexPath.row) as! NSDictionary).value(forKey: "weather") as! NSDictionary).value(forKey: "icon") as! NSNumber)")
        return cell
    }
    func requestWeatherForLocation() {
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04&appid=4cd569ffb3ecc3bffe9c0587ff02109f")
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
                print(self.json.value(forKey: "daily"))
                self.daily = self.json.value(forKey: "daily") as! NSArray
               
            }
            catch let err as NSError{
                print(err.localizedDescription)
            }
            DispatchQueue.main.async {
                self.weatherTBL.reloadData()
            }
        }
       
            task.resume()
    }
   
}
