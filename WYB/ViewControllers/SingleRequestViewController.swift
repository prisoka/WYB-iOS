//
//  SingleRequestViewController.swift
//  WYB
//
//  Created by Priscilla Okawa on 6/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import UIKit

class SingleRequestViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let dogName = ["Aquila", "Flora", "Happy", "Peanut Butter"]
    
    let dogPhoto = [UIImage(named: "Aquila"), UIImage(named: "Flora"), UIImage(named: "Happy"), UIImage(named: "PeanutButter")]
    
    let ownerName = ["Priscilla", "Luke", "Rodrigo" , "Lara"]
    
    let dates = ["09/05/2018", "09/06/2018", "09/07/2018", "09/08/2018"]
    
    let times = ["06:00 AM", "09:30 AM", "06:45 PM", "11:11 AM"]

    
    let location = ["test", "test 2", "test 3", "test 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Single Request View Controller DidLoad")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "requestCard", for: indexPath) as! SingleRequestCollectionViewCell
        
        cell.dogPhoto.image = dogPhoto[indexPath.row]
        cell.dogName.text = dogName[indexPath.row]
        cell.ownerName.text = ownerName[indexPath.row]
        cell.date.text = dates[indexPath.row]
        cell.time.text = times[indexPath.row]
        cell.location.text = dates[indexPath.row]
        
        return cell
    }
}
