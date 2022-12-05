//
//  popupLocationViewController.swift
//  LonghornWalk
//
//  Created by Yousuf Din on 12/4/22.
//

import UIKit

class popupLocationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var locationName: UILabel!
    
   // @IBOutlet weak var locationAddress: UILabel!
    
    var image = UIImage()
    var name = ""
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(name)
        imageView.image = image
        locationName.text = name
       // locationAddress.text = address
    }

}
