//
//  blogViewController.swift
//  iosuygulama
//
//  Created by tolga iskender on 23.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import UIKit

class blogViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    let haberArray:Array = ["ABC News","BBC Sport","Bloomberg","Türkiye Haberleri"]
    let haberApi:Array = ["abc-news","bbc-sport","bloomberg","tr"]
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return haberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = haberArray[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb =  UIStoryboard(name: "Main", bundle: nil)
        let dv = sb.instantiateViewController(withIdentifier: "DetayViewController") as! DetayViewController
        dv.apiKey=haberApi[indexPath.row]
        self.navigationController?.pushViewController(dv, animated: true)
    }
}
