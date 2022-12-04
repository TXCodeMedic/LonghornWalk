//
//  LaunchScreenViewController.swift
//  LonghornWalk
//
//  Created by Yousuf Din on 12/1/22.
//

import UIKit
import AVFoundation

var player: AVAudioPlayer?

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class LaunchScreenViewController: UIViewController {
    
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 20,
                                                  y: 259,
                                                  width: 390,
                                                  height: 414))
        imageView.image = UIImage(named: "logo")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if UserDefaults.standard.bool(forKey: "darkMode") == false {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        }
        
        if UserDefaults.standard.string(forKey: "font") == "system" {
            UILabel.appearance(whenContainedInInstancesOf: [UIViewController.self]).font = UIFont.init(name: "San Francisco", size: 14)
        }
        else if UserDefaults.standard.string(forKey: "font") == "courier" {
            UILabel.appearance(whenContainedInInstancesOf: [UIViewController.self]).font = UIFont.init(name: "courier", size: 14)
        }
        else if UserDefaults.standard.string(forKey: "font") == "futura" {
            UILabel.appearance(whenContainedInInstancesOf: [UIViewController.self]).font = UIFont.init(name: "futura", size: 14)
        }
        else if UserDefaults.standard.string(forKey: "font") == "papyrus" {
            UILabel.appearance(whenContainedInInstancesOf: [UIViewController.self]).font = UIFont.init(name: "papyrus", size: 14)
        }
        else if UserDefaults.standard.string(forKey: "font") == "timesNewRoman" {
            UILabel.appearance(whenContainedInInstancesOf: [UIViewController.self]).font = UIFont.init(name: "Times New Roman", size: 14)
        }
        
        if UserDefaults.standard.bool(forKey: "sound") == false {
            player?.volume = 0.0
        } else {
            playSound()
        }
        
        view.addSubview(imageView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.performSegue(withIdentifier: "launchSegue", sender: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.animation()
        }
    }
    
    func animation() {
        UIView.animate(withDuration: 1) {
            let size = self.view.frame.size.width * 2
            let xposition = size - self.view.frame.width
            let yposition = self.view.frame.height - size
            
            self.imageView.frame = CGRect(x: -(xposition/2),
                                          y: yposition/2,
                                          width: size,
                                          height: size)
            self.imageView.alpha = 0
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "launchSound", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }

}
