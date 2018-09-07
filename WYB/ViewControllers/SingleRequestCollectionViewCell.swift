//
//  SingleRequestCollectionViewCell.swift
//  WYB
//
//  Created by Priscilla Okawa on 6/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import UIKit

class SingleRequestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dogPhoto: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
}
