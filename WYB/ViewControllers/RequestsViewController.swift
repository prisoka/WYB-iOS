//
//  RequestsViewController.swift
//  WYB
//
//  Created by Priscilla Okawa on 5/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let dogName = ["Aquila", "Flora", "Happy", "Peanut Butter"]
    
    let dogPhoto = [UIImage(named: "Aquila"), UIImage(named: "Flora"), UIImage(named: "Happy"), UIImage(named: "PeanutButter")]
    
    let dates = ["09/05/2018", "09/06/2018", "09/07/2018", "09/08/2018"]
    
    let times = ["06:00 AM", "09:30 AM", "06:45 PM", "11:11 AM"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("requests view controller did load")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.dogPhoto.image = dogPhoto[indexPath.row]
        cell.dogName.text = dogName[indexPath.row]
        cell.requestDate.text = dates[indexPath.row]
        cell.requestTime.text = times[indexPath.row]

        return cell
    }
}
