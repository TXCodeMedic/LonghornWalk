import UIKit
import CoreLocation
import CoreData


// MARK: UTLOCATION CLASS
let PCL = UTLocation(name:"Perry-Castañeda Library", address:"101 E 21st St, Austin, TX, 78712", latitude: 30.2826535, longitude: -97.7382112)
// lat 30.2826535
// long -97.7382112

let ART = UTLocation(name: "Department of Art and Art History", address: "2301 San Jacinto Blvd, Austin, TX, 78705", latitude: 30.2856605, longitude: -97.7334386)
let MAI = UTLocation(name: "The University of Texas at Austin Main Building", address: "110 Inner Campus Drive, Austin, TX, 78712", latitude: 30.2859129, longitude: -97.7393780)
let RLM = UTLocation(name: "Physics, Math, and Astronomy Building", address: "2515 Speedway, Austin, TX, 78712", latitude:30.2890428, longitude:-97.7366309)

let UTLocationList = [PCL,ART,MAI,RLM]

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


// MARK: VIEWCONTROLLER CLASS
class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    // Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // Declare variables
    let locationCount = 4
    var locationIndex:Int = 0
    let locationManager = CLLocationManager()
    var userLong:Double = 0
    var userLat:Double = 0
    
    var delegate: UIViewController!
    
    
    override func viewDidLoad() {
        showImage(index: locationIndex)
        
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        print("Ask for permission")
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() == .authorizedAlways) {
            print("All Set")
            currentLoc = locationManager.location
            print("lat \(currentLoc.coordinate.latitude)")
            userLat = currentLoc.coordinate.latitude
            print("long \(currentLoc.coordinate.longitude)\n\n\n\n")
            userLong = currentLoc.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        userLat = locValue.latitude
        userLong = locValue.longitude
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Location Change Button Functions
    
    // MARK: IMAGEVIEW FUNCTIONS
    
    @IBAction func nextButtonIsPressed(_ sender: Any) {
        locationIndex = (locationIndex + 1) % locationCount
        showImage(index: locationIndex)
    }
    
    
    @IBAction func previousButtonIsPressed(_ sender: Any) {
        if locationIndex == 0{
            locationIndex = 3
        } else {
            locationIndex -= 1
        }
        showImage(index: locationIndex)
    }
    
    func showImage(index:Int){
        imageView.image = UIImage(named: "Image\(index)")
        
        locationNameLabel.text = UTLocationList[index].locationName
        locationAddressLabel.text = UTLocationList[index].locationAddress
    }
    
    //MARK: LOCATION VERIFICATION
    @IBAction func locationVerification(_ sender: Any) {
        // Set range of UTLocation Pin +/- 10%
        // Latitude
        var UTLocationLatitudeMinus = (UTLocationList[locationIndex].locationLatitude - (UTLocationList[locationIndex].locationLatitude * 0.1))
        
        var UTLocationLatitudePlus = (UTLocationList[locationIndex].locationLatitude + (UTLocationList[locationIndex].locationLatitude * 0.1))
        
        //Longitude
        var UTLocationLongitudeMinus = (UTLocationList[locationIndex].locationLongitude - (UTLocationList[locationIndex].locationLongitude * 0.1))
        
        var UTLocationLongitudePlus = (UTLocationList[locationIndex].locationLongitude + (UTLocationList[locationIndex].locationLongitude * 0.1))
        
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
                
                // add location to core data and add score
                
                let newLocation = UTLocationList[locationIndex]
                
                print(newLocation)
//                let mainVC = delegate as! addtoCoreData
//                mainVC.storeLocation(location: newLocation)
                // update the view
              
                
            } else {
                print("Wrong long")}
                print("User is NOT at the location")
        }
        else{
            print("Wrong Lat")
            print("User is NOT at the location")
        }
    }
}
