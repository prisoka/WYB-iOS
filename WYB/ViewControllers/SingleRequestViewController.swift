//
//  SingleRequestViewController.swift
//  WYB
//
//  Created by Priscilla Okawa on 6/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import UIKit
import Kingfisher

class SingleRequestViewController: UIViewController {
    
    @IBOutlet weak var dogPhoto: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var singleCardView: UIView!
    
    // this is how I instantiate the Object that lives in Model > NetworkClient.swift. I can use this anywhere inside RequestsViewController class
    let networkClient = NetworkClient()
    
    var request: WalkRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Single Request View Controller DidLoad")
        
        if let request = request {
            setRequest(request: request)
        }
    }
    
    // instantiating and presenting alert box
    private func displayAlert(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func setRequest(request: WalkRequest) {
        self.request = request
        
        if let request = self.request {
            // using Kingfish to load image from URL async
            if let urlString = request.dogPhotoUrl,
                let url = URL(string: urlString) {
                dogPhoto.kf.setImage(with: url)
            }
            
            dogName.text = "Dog: " + request.dogName
            ownerName.text = "Owner: " + request.userName
            date.text = "Date: " + request.requestDateString
            time.text = "Time: " + request.requestTimeString
            location.text = "Pick up at: " + request.addressOne + ", " + (request.addressTwo ?? "")
            
            singleCardView.layer.cornerRadius = 10
            singleCardView.layer.borderWidth = 2
            singleCardView.layer.borderColor = UIColor(red: 0, green: 209, blue: 178, alpha: 1).cgColor
        }
    }
}
