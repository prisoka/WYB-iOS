//
//  SingleRequestViewController.swift
//  WYB
//
//  Created by Priscilla Okawa on 6/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import UIKit

class SingleRequestViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dogName = ["Aquila", "Flora", "Happy", "Peanut Butter"]
    
    let dogPhoto = [UIImage(named: "Aquila"), UIImage(named: "Flora"), UIImage(named: "Happy"), UIImage(named: "PeanutButter")]
    
    let ownerName = ["Priscilla", "Luke", "Rodrigo" , "Lara"]
    
    let dates = ["09/05/2018", "09/06/2018", "09/07/2018", "09/08/2018"]
    
    let times = ["06:00 AM", "09:30 AM", "06:45 PM", "11:11 AM"]

    
    let locations = ["test", "test 2", "test 3", "test 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Single Request View Controller DidLoad")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "requestCardDetails", for: indexPath) as! SingleRequestCollectionViewCell
        
        cell.dogPhoto.image = dogPhoto[indexPath.row]
        cell.dogName.text = "Dog: " + dogName[indexPath.row]
        cell.ownerName.text = "Owner: " + ownerName[indexPath.row]
        cell.date.text = "Date: " + dates[indexPath.row]
        cell.time.text = "Time: " + times[indexPath.row]
        cell.location.text = "Pick up: " + locations[indexPath.row]
        
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(red: 0, green: 209, blue: 178, alpha: 1).cgColor

        
        return cell
    }
}
