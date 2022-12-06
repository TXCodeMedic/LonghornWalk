import UIKit
import SwiftUI
import CoreLocation
import CoreData


// MARK: UTLocation Class
class UTLocation {
    var locationName:String
    var locationAddress:String
    var locationLatitude:CLLocationDegrees
    var locationLongitude:CLLocationDegrees
        
    init(name:String, address:String, latitude:CLLocationDegrees, longitude:CLLocationDegrees){
        self.locationName = name
        self.locationAddress = address
        self.locationLatitude = latitude
        self.locationLongitude = longitude
    }
}

//MARK: UT Locations
let PCL = UTLocation(name:"Perry-Castañeda Library", address:"101 E 21st St, Austin, TX, 78712", latitude: 30.28269313340662, longitude: -97.7381113172094)
// 30.28269313340662, -97.7381113172094
let ART = UTLocation(name: "Department of Art and Art History", address: "2301 San Jacinto Blvd, Austin, TX, 78705", latitude: 30.285809118247645, longitude: -97.73290565247262)
// 30.285809118247645, -97.73290565247262
let MAI = UTLocation(name: "The University of Texas at Austin Main Building", address: "110 Inner Campus Drive, Austin, TX, 78712", latitude: 30.286344137775412, longitude: -97.73930152606853)
// 30.286344137775412, -97.73930152606853
let RLM = UTLocation(name: "Physics, Math, and Astronomy Building", address: "2515 Speedway, Austin, TX, 78712", latitude:30.289039890662803, longitude:-97.73643390244438)
// 30.289039890662803, -97.73643390244438
let UNB = UTLocation(name: "Texas Union", address: "2308 Whitis Ave, Austin, TX 78712", latitude: 30.28671079741925, longitude: -97.74116258159587)
// 30.28671079741925, -97.74116258159587
let GRE = UTLocation(name: "Gregory Gym", address: "2101 Speedway, Austin, TX, 78712", latitude: 30.284490464141697, longitude: -97.73681183127968)
// 30.284490464141697, -97.73681183127968
let BUR = UTLocation(name: "Burdine Hall", address: "2505 University Ave, Austin, TX 78712", latitude: 30.288837784474733, longitude: -97.73820150244435)
// 30.288837784474733, -97.73820150244435
let WEL = UTLocation(name: "Robert A. Welch Hall", address: "105 E 24th St, Austin, TX, 78712", latitude: 30.287225312884132, longitude: -97.73779783127964)
// 30.287225312884132, -97.73779783127964
let RSC = UTLocation(name: "Recreational Sports Center", address: "2001 San Jacinto Blvd, Austin, TX, 78712", latitude: 30.281511239179437, longitude: -97.73291451533485)
// 30.281511239179437, -97.73291451533485
let CPE = UTLocation(name: "McKetta Department of Chemical Engineering", address: "200 E Dean Keeton St", latitude: 30.290818402184424, longitude: -97.73637315538319)
// 30.290818402184424, -97.73637315538319
let BCR = UTLocation(name: "Bulko's Classroom", address: "2317 Speedway, Austin, TX 78712", latitude: 30.286420514100342, longitude: -97.73658237360927)
// 30.286420514100342, -97.73658237360927

let UTLocationList = [PCL,ART,MAI,RLM,UNB,GRE,BUR,WEL,RSC,CPE,BCR]

// MARK: ViewController Class
class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    // Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hereButton: UIButton!
    
    // Declare variables
    var recentlyVisitedLocations:[String] = []
    let locationCount = 11
    var locationIndex:Int = 0
    let locationManager = CLLocationManager()
    var userLong:Double = 0
    var userLat:Double = 0
    
    var delegate: UIViewController!
    
    //MARK: ViewDidLoad()
    override func viewDidLoad() {
        showImage(index: locationIndex)
        super.viewDidLoad()
        
        // Gestures
        print("\(String(describing: appDelegate.currentUser?.points))")
        // swipe left
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(recognizeSwipeGesture(recognizer:)))
        swipeLeftRecognizer.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeftRecognizer)
        
        // swipe right
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(recognizeSwipeGesture(recognizer:)))
        swipeRightRecognizer.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRightRecognizer)
        
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MapViewController {
            let vc = segue.destination as? MapViewController
            vc?.coordinate = CLLocationCoordinate2D(latitude: UTLocationList[locationIndex].locationLatitude, longitude: UTLocationList[locationIndex].locationLongitude)
        }
    }
    
    //MARK: LocationManager DidUpdateLocations
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Handle location update
            self.userLat = latitude
            self.userLong = longitude
            print("\nNew userLat and userLong")
            print("userLat: \(self.userLat)")
            print("userLong: \(self.userLong)\n")
        }
    }

    //MARK: LocationManager DidFailWithError
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
        print(error)
    }
    
    // MARK: Indexing / Gestures
    @IBAction func recognizeSwipeGesture(recognizer: UISwipeGestureRecognizer){
        if recognizer.direction == .right {
            if locationIndex == 0{
                locationIndex = 10
            } else {
                locationIndex -= 1
            }
            showImage(index: locationIndex)
        }
        if recognizer.direction == .left {
            locationIndex = (locationIndex + 1) % locationCount
            showImage(index: locationIndex)
        }
    }
    
    //MARK: ShowImage()
    func showImage(index:Int){
        imageView.image = UIImage(named: UTLocationList[index].locationName)
        
        locationNameLabel.text = UTLocationList[index].locationName
        locationAddressLabel.text = UTLocationList[index].locationAddress
    }
    
    //MARK: checkLocation()
    func checkLocation() -> Bool {
        print()
        print(UTLocationList[locationIndex].locationName)
        print(UTLocationList[locationIndex].locationAddress)
        print(UTLocationList[locationIndex].locationLatitude)
        print(UTLocationList[locationIndex].locationLongitude)
        
        // Set range of UTLocation Pin
        // Latitude
        let UTLocationLatitudeMinus = (UTLocationList[locationIndex].locationLatitude -  0.001000)

        
        let UTLocationLatitudePlus = (UTLocationList[locationIndex].locationLatitude + 0.001000)

        //Longitude
        let UTLocationLongitudeMinus = (UTLocationList[locationIndex].locationLongitude + 0.001500)

        let UTLocationLongitudePlus = (UTLocationList[locationIndex].locationLongitude -  0.001500)

        print("______________________Long______________________")
        print("\nlower bound: \(UTLocationLongitudeMinus)")
        print("user long: \(self.userLong)")
        print("upper bound: \(UTLocationLongitudePlus)\n")

        print("______________________Lat______________________")
        print("\nlower bound: \(UTLocationLatitudeMinus)")
        print("user lat: \(self.userLat)")
        print("upper lat: \(UTLocationLatitudePlus)\n")

        if ((self.userLat >= UTLocationLatitudeMinus) && (self.userLat <= UTLocationLatitudePlus)){
            print("User is in range of lat")
            // Made abs to check --> look for other options
            
            print("HERE!")
            print(abs(UTLocationLongitudeMinus))
            print(abs(self.userLong))
            print(abs(self.userLong))
            print()
            if ((abs(self.userLong) >= abs(UTLocationLongitudeMinus)) && (abs(self.userLong) <= abs(UTLocationLongitudePlus))){
                print("User is in range of long")
                print("User is at the location")
                return true

            } else {
                print("Wrong long")
                return false
            }
        } else {
            print("Wrong Lat")
            print("User is NOT at the location")
        }
        return false
    }
    
    //MARK: Location Verification
    @IBAction func locationVerification(_ sender: Any) {
        print("location verification button pressed")
        if checkLocation() == true{
            let newLocation = UTLocationList[locationIndex]
            let mainVC = delegate as! addtoCoreData
            // check if location is already in table view
            if mainVC.isRepeatingLocation(location: newLocation) != true{
                //add location to core data
                mainVC.storeLocation(location: newLocation)
                // update the table view
                mainVC.refreshTable()
                
                // get current date
                var currentDate = Date()
                var formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yy"
                var formattedDate = formatter.string(from: currentDate)
                
              // add points User object and then saveUser()
                appDelegate.currentUser?.points += 25
                appDelegate.currentUser?.lastUpdate = formattedDate
                appDelegate.currentUser?.saveUser()
                print(appDelegate.currentUser?.points)
                // ADD ALERT
                let alert = UIAlertController(
                    title: "Location Added!",
                    message: "+25 points!\nWe will document your visit!",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(
                    title: "OK",
                    style: .default))
                self.present(alert, animated: true)
                
                
            } else{
                // ADD ALERT SAYING ALREADY VISITED
                let alert = UIAlertController(
                    title: "Too Soon",
                    message: "You already visited this location today.\nCome back again tomorrow.",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(
                    title: "OK",
                    style: .default))
                self.present(alert, animated: true)
                // ADD ALERT
            }
        } else {
            // user is not at location
            // show an error message
            // ADD ALERT
            let alert = UIAlertController(
                title: "Not at the Location",
                message: "You are not at the location.\nRefer to the address on the screen.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            self.present(alert, animated: true)
        }
    }
}
