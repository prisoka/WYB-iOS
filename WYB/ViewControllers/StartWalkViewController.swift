//
//  StartWalkingViewController.swift
//  WYB
//
//  Created by Priscilla Okawa on 10/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//
import UIKit
class StartWalkViewController: UIViewController {
    
    @IBOutlet weak var dogPhoto: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var startWalkBtn: UIButton!
    @IBOutlet weak var contactOwnerBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var startWalkCardView: UIView!

    
    let networkClient = NetworkClient()
    
    var request: WalkRequest?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Start Walking View Controller DidLoad")
        
        if let request = request {
            setRequest(request: request)
        }
        
        dogPhoto.layer.borderWidth = 1.0
        dogPhoto.layer.masksToBounds = false
        dogPhoto.layer.borderColor = UIColor.white.cgColor
        dogPhoto.layer.cornerRadius = dogPhoto.frame.size.width / 2
        dogPhoto.clipsToBounds = true
    }
    
    func setRequest(request: WalkRequest) {
        self.request = request
        
        if let request = self.request {
            // using Kingfish to load image from URL async
            if let urlString = request.dogPhotoUrl,
                let url = URL(string: urlString) {
                dogPhoto.kf.setImage(with: url)
            }
            
            dogName.text = request.dogName
            ownerName.text = "Owner: " + request.userName
            date.text = "Date: " + request.requestDateString
            time.text = "Time: " + request.requestTimeString
            location.text = "Pick up: " + request.addressOne + ", " + (request.addressTwo ?? "")
            
            startWalkCardView.layer.cornerRadius = 10
            startWalkCardView.layer.borderWidth = 2
            startWalkCardView.layer.borderColor = UIColor(red: 0/255.0, green: 209/255.0, blue: 178/255.0, alpha: 1).cgColor
        }
    }
    
    @IBAction func contactOwnerBtnTapped(_ sender: Any) {
        if let request = self.request,
            let phoneNumber = request.phoneNumber,
            let url = URL(string: "tel:\(String(phoneNumber))") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
