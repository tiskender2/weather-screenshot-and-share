//
//  HaberViewController.swift
//  iosuygulama
//
//  Created by tolga iskender on 23.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import UIKit
import CoreLocation
class HaberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var havaResimArr = [String]()
    var havaGunArr = [String] ()
    var havaDereceArr = [Double] ()
    let locManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var lat = ""
    var long = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            lat  = String(currentLocation.coordinate.latitude)
            long = String(currentLocation.coordinate.longitude)
        }
        havaCek(urlString: "https://api.darksky.net/forecast/e57ec92ce1708fe787cd1ca75f349d4e/"+"\(lat),\(long)")
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return havaDereceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! haberTableViewCell
        
        let date = NSDate(timeIntervalSince1970: Double(havaGunArr[indexPath.row])!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        let localDate = dateFormatter.string(from: date as Date)
        
       cell.havaResim.image=UIImage(named:havaResimArr[indexPath.row])
       cell.havaDerece.text="\(Int((havaDereceArr[indexPath.row]-32)/1.8))"+"C"
       cell.havagun.text=localDate
       indicator.stopAnimating()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
 
    
    @IBAction func share(_ sender: Any) {
        let message = "Fotoğrafi paylasıyorum!"
        
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        if  let img = img {
            let objectsToShare = [message,img] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    func havaCek(urlString:String)
    {
        havaGunArr.removeAll()
        havaResimArr.removeAll()
        havaDereceArr.removeAll()
        
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "GET"
       
     
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil
            {
                print(error!)
            }
            else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? AnyObject
                    
                    if let daily = json!["daily"] as? NSDictionary
                     {
                        if let gunler = daily["data"] as? NSArray
                        {
                            for i in 0..<4
                            {
                                if let jsonVeri = gunler[i] as? NSDictionary
                                {
                                    if let icon = jsonVeri["icon"] as? String
                                    {
                                        self.havaResimArr.append(icon)
                                        
                                    }
                                    
                                    if let time = jsonVeri["time"] as? Int
                                    {
                                        self.havaGunArr.append(String(time))
                                    }
                                    if let temp = jsonVeri["temperatureMax"] as? Double
                                    {
                                        self.havaDereceArr.append(temp)
                                        print(self.havaDereceArr)
                                    }
                                }
                            }
                        }
                     }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                }
                catch{
                    print(error)
                }
            }
            
        })
        task.resume()
    }
        
        
    }



