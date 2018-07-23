//
//  DetayViewController.swift
//  iosuygulama
//
//  Created by tolga iskender on 23.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import UIKit
import SDWebImage
class DetayViewController: UIViewController, UITableViewDelegate ,  UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var apiKey = ""
    var kaynak = ""
    var tip = ""
    var resimArray = [String]()
    var baslikArray = [String]()
    var detayArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (apiKey == "tr")
        {
            kaynak="country"
            tip = "top-headlines"
        }
        else
        {
            kaynak="sources"
            tip = "everything"
        }
        getNews(urlString: "https://newsapi.org/v2/"+"\(tip)"+"?\(kaynak)="+"\(apiKey)"+"&apiKey=669d3fb03f3e463c843f6596ddea57eb")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baslikArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! detayTableViewCell
        
        cell.baslik.text=baslikArray[indexPath.row]
        cell.detay.text=detayArray[indexPath.row]
        cell.resim.sd_setImage(with: URL(string: resimArray[indexPath.row]), placeholderImage:nil)
        indicator.stopAnimating()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func getNews(urlString:String)
    {
        resimArray.removeAll()
        baslikArray.removeAll()
        detayArray.removeAll()
        
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
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let haberler = json!["articles"] as? NSArray
                    {
                        for i in 0..<haberler.count
                        {
                            if let jsonVeri = haberler[i] as? NSDictionary
                            {
                                if let title = jsonVeri["title"] as? String
                                {
                                    self.baslikArray.append(title)
                                    
                                }
                                if let description = jsonVeri["description"] as? String
                                {
                                    self.detayArray.append(description)
                                    
                                }
                                if let urlToImage = jsonVeri["urlToImage"] as? String
                                {
                                    self.resimArray.append(urlToImage)
                                    
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

   


