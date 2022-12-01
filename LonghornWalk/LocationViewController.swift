import UIKit
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
let PCL = UTLocation(name:"Perry-Castañeda Library", address:"101 E 21st St, Austin, TX, 78712", latitude: 30.2826535, longitude: -97.7382112)
let ART = UTLocation(name: "Department of Art and Art History", address: "2301 San Jacinto Blvd, Austin, TX, 78705", latitude: 30.2856605, longitude: -97.7334386)
let MAI = UTLocation(name: "The University of Texas at Austin Main Building", address: "110 Inner Campus Drive, Austin, TX, 78712", latitude: 30.2859129, longitude: -97.7393780)
let RLM = UTLocation(name: "Physics, Math, and Astronomy Building", address: "2515 Speedway, Austin, TX, 78712", latitude:30.2890428, longitude:-97.7366309)
let UNB = UTLocation(name: "Texas Union", address: "2308 Whitis Ave, Austin, TX 78712", latitude: 30.2866300, longitude: -97.7410396)
let GRE = UTLocation(name: "Gregory Gym", address: "2101 Speedway, Austin, TX, 78712", latitude: 30.2842791, longitude: -97.7367789)
let BUR = UTLocation(name: "Burdine Hall", address: "2505 University Ave, Austin, TX 78712", latitude: 30.2888324, longitude: -97.7383031)
let WEL = UTLocation(name: "Robert A. Welch Hall", address: "105 E 24th St, Austin, TX, 78712", latitude: 30.2870189, longitude: -97.7375652)
let RSC = UTLocation(name: "Recreational Sports Center", address: "2001 San Jacinto Blvd, Austin, TX, 78712", latitude: 30.2816054, longitude: -97.7327600)
let CPE = UTLocation(name: "McKetta Department of Chemical Engineering", address: "200 E Dean Keeton St", latitude: 30.2901878, longitude: -97.7364628)
let BCR = UTLocation(name: "Bulko's Classroom", address: "GDC 5.302 ", latitude: 30.2864251, longitude: -97.7365888)

let UTLocationList = [PCL,ART,MAI,RLM,UNB,GRE,BUR,WEL,RSC,CPE,BCR]

// MARK: ViewController Class
class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    // Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // Declare variables
    let locationCount = 11
    var locationIndex:Int = 0
    let locationManager = CLLocationManager()
    var userLong:Double = 0
    var userLat:Double = 0
    
    var delegate: UIViewController!
    
    //MARK: ViewDidLoad()
    override func viewDidLoad() {
        print("Inside LocationVC")
        showImage(index: locationIndex)
        
        super.viewDidLoad()
        // swipe left
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(recognizeSwipeGesture(recognizer:)))
        swipeLeftRecognizer.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeftRecognizer)
        
        // swipe right
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(recognizeSwipeGesture(recognizer:)))
        swipeRightRecognizer.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRightRecognizer)
        
        
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        print("Ask for permission")
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() == .authorizedAlways) {
            print("All Set")
            
            if locationManager.location != nil{
                currentLoc = locationManager.location
                print("lat \(currentLoc.coordinate.latitude)")
                userLat = currentLoc.coordinate.latitude
                print("long \(currentLoc.coordinate.longitude)\n\n\n\n")
                userLong = currentLoc.coordinate.longitude
            }else{
                // TO DO: debug why is locationManager.location nil?
                print("ERROR with LocationManager permissions")
            }
        }
    }
    
    //MARK: LocationManager Update Locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        userLat = locValue.latitude
        userLong = locValue.longitude
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        imageView.image = UIImage(named: "Image\(index)")
        print(index)
        
        locationNameLabel.text = UTLocationList[index].locationName
        locationAddressLabel.text = UTLocationList[index].locationAddress
    }
    
    //MARK: checkLocation()
    func checkLocation() -> Bool {
        // Set range of UTLocation Pin
        // Latitude
        
        let UTLocationLatitudeMinus = (UTLocationList[locationIndex].locationLatitude - (UTLocationList[locationIndex].locationLatitude - 0.000000000000200))

        let UTLocationLatitudePlus = (UTLocationList[locationIndex].locationLatitude + (UTLocationList[locationIndex].locationLatitude + 0.000000000000200))

        //Longitude
        let UTLocationLongitudeMinus = (UTLocationList[locationIndex].locationLongitude - (UTLocationList[locationIndex].locationLongitude - 0.000000000000200))

        let UTLocationLongitudePlus = (UTLocationList[locationIndex].locationLongitude + (UTLocationList[locationIndex].locationLongitude + 0.000000000000200))

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
                
                // TO DO: add points to userScore in firestore DB
                
            } else{
                print("is repeating location, will not be adding to table view")
            }
        } else {
            // user is not at location
            // show an error message
            print("user is not at location")
        }
    }
}
