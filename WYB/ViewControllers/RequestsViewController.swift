//
//  RequestsViewController.swift
//  WYB
//
//  Created by Priscilla Okawa on 5/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let networkClient = NetworkClient()
    
    let dogName = ["Aquila", "Flora", "Happy", "Peanut Butter"]
    
    let dogPhoto = [UIImage(named: "Aquila"), UIImage(named: "Flora"), UIImage(named: "Happy"), UIImage(named: "PeanutButter")]
    
    let dates = ["09/05/2018", "09/06/2018", "09/07/2018", "09/08/2018"]

    let times = ["06:00 AM", "09:30 AM", "06:45 PM", "11:11 AM"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("requests view controller did load")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        networkClient.fetchAllRequests(completionBlock: { (requests, error) in
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "requestCardCell", for: indexPath) as! RequestCell
        
        cell.dogPhoto.image = dogPhoto[indexPath.row]
        cell.dogName.text = "Dog Name: " + dogName[indexPath.row]
        cell.requestDate.text = "Date: " + dates[indexPath.row]
        cell.requestTime.text = "Time: " + times[indexPath.row]
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(red: 0, green: 209, blue: 178, alpha: 1).cgColor

        return cell
    }
}
