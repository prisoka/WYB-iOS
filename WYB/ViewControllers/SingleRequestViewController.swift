//
//  SingleRequestViewController.swift
//  WYB
//
//  Created by Priscilla Okawa on 6/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import UIKit
import Kingfisher

class SingleRequestViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // this is how I instantiate the Object that lives in Model > NetworkClient.swift. I can use this anywhere inside RequestsViewController class
    let networkClient = NetworkClient()
    
    var requests = [WalkRequest]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Single Request View Controller DidLoad")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        networkClient.fetchAllRequests(completionBlock: { (requests, error) in
            if let error = error {
                self.displayAlert(message: error.localizedDescription)
            } else if let requests = requests {
                //Do something with requestsResponse here
                self.requests = requests
                self.collectionView.reloadData()
            }
        })
    }
    
    // instantiating and presenting alert box
    private func displayAlert(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requests.count
//        return request != nil ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "requestCardDetails", for: indexPath) as! SingleRequestCollectionViewCell
        
        let request = requests[indexPath.row]
        print(request)

//        if let request = request {
            // using Kingfish to load image from URL async
            if let urlString = request.dogPhotoUrl,
                let url = URL(string: urlString) {
                cell.dogPhoto.kf.setImage(with: url)
            }
            
            cell.dogName.text = "Dog: " + request.dogName
            cell.ownerName.text = "Owner: " + request.userName
            cell.date.text = "Date: " + request.requestDateString
            cell.time.text = "Time: " + request.requestTimeString
            cell.location.text = "Pick up at: " + request.addressOne

            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor(red: 0, green: 209, blue: 178, alpha: 1).cgColor
//        }
        
        return cell
    }
}
