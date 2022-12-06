//
//  DirectionsViewController.swift
//  LonghornWalk
//
//  Created by Yousuf Din on 12/4/22.
//
// Filename: LonghornWalk
// Team: 10
// Course: CS329E

import UIKit

protocol ModalViewControllerDelegate
{
    func sendValue(var value : NSString)
}

class DirectionsViewController: UIViewController {

    @IBOutlet weak var directionsLabel: UITextView!
    
    var directions: [String] = []
    var delegate: ModalViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        directionsLabel.text = directions.joined(separator: "\n\n\n")
    }
}
