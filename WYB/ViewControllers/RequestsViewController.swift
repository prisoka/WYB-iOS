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
    
    // this is how I instantiate the Object that lives in Model > NetworkClient.swift. I can use this anywhere inside RequestsViewController class
    let networkClient = NetworkClient()
    
    var requests = [WalkRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("requests view controller did load")
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "requestCardCell", for: indexPath) as! RequestCell
        
        let request = requests[indexPath.row]
        
//        cell.dogPhoto.image = request.dogPhotoUrl
        cell.dogName.text = "Dog Name: " + request.dogName
        cell.requestDate.text = "Date: " + request.requestDateString
        cell.requestTime.text = "Time: " + request.requestTimeString
        
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(red: 0, green: 209, blue: 178, alpha: 1).cgColor

        return cell
    }
}
