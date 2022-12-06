//
//  popupLocationViewController.swift
//  LonghornWalk
//
//  Created by Yousuf Din on 12/4/22.
//
// Filename: LonghornWalk
// Team: 10
// Course: CS329E

import UIKit

class popupLocationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var locationName: UILabel!
    
    var image = UIImage()
    var name = ""
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.image = image
        locationName.text = name
    }
}
