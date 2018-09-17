//
//  MyWalksViewController.swift
//  WYB
//
//  Created by Priscilla Okawa on 6/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import UIKit

enum WalkType {
    case upcoming
    case past
}

class MyWalksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var myWalksSegmentControl: UISegmentedControl!
    @IBOutlet weak var acceptedReqCollectionView: UICollectionView!
    
    let networkClient = NetworkClient()
    var selectedWalkType = WalkType.upcoming
    var allRequests = [WalkRequest]()
    var filteredRequests = [WalkRequest]()
    
    var selectedRequest: WalkRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acceptedReqCollectionView.delegate = self
        acceptedReqCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        networkClient.fetchAllRequests(completionBlock: { (requests, error) in
            if let error = error {
                self.displayAlert(message: error.localizedDescription)
            } else if let requests = requests {
                self.allRequests = requests
                self.myWalksSegmentControl.sendActions(for: .valueChanged)
                self.acceptedReqCollectionView.reloadData()
            }
        })
        
        if let tabItems = tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[1]
            tabItem.badgeValue = nil
        }
    }
    
    // instantiating and presenting alert box
    private func displayAlert(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredRequests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingWalksCell", for: indexPath) as! RequestCell
        
        let request = filteredRequests[indexPath.row]
        
        // using Kingfish to load image from URL async
        if let urlString = request.dogPhotoUrl,
            let url = URL(string: urlString) {
            cell.dogPhoto.kf.setImage(with: url)
        }
        
        cell.nextPageIcon.isHidden = selectedWalkType == .past
        
        cell.dogName.text = request.dogName
        cell.requestDate.text = "Date: " + request.requestDate.toFormattedString()
        cell.requestTime.text = "Time: " + request.requestTimeString.toFormattedTimeString()
        
//        cell.layer.cornerRadius = 10
//        cell.layer.borderWidth = 2
//        cell.layer.borderColor = UIColor(red: 0/255.0, green: 209/255.0, blue: 178/255.0, alpha: 1).cgColor
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRequest = filteredRequests[indexPath.row]
        
        if selectedWalkType == .upcoming {
            performSegue(withIdentifier: "StartWalkCardDetailsSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedRequest = selectedRequest,
            segue.identifier == "StartWalkCardDetailsSegue",
            let startWalkViewController = segue.destination as? StartWalkViewController {
            startWalkViewController.request = selectedRequest
        }
    }
    
    func pastWalks() -> [WalkRequest] {
        let pastWalks = allRequests.filter({ (request) -> Bool in
            request.walkerId == userId && request.finishWalkTimeString != nil
        })
        return pastWalks
    }
    
    func upcomingWalks() -> [WalkRequest] {
        let upcomingWalks = allRequests.filter({ (request) -> Bool in
            request.walkerId == userId && request.finishWalkTimeString == nil
        })
        return upcomingWalks
    }
    
    @IBAction func toggle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("NEXT WALKS")
            selectedWalkType = .upcoming
            filteredRequests = upcomingWalks()
        } else {
            print("PAST WALKS")
            selectedWalkType = .past
            filteredRequests = pastWalks()
        }
        acceptedReqCollectionView.reloadData()
    }
}
