//
//  MapViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/4/21.
//

import UIKit
import SQLite
import CoreLocation
import GoogleMaps
import GoogleMapsUtils

class MapViewController: UIViewController {
    
    lazy var userProfile = UserProfileViewController()
    lazy var symptomTestView = SymptomTestViewController()
    var manager = LocationManager()
    var positiveHeatMapLayer: GMUHeatmapTileLayer!
    var negativeHeatMapLayer: GMUHeatmapTileLayer!
    let database = DataBaseCommands()
    var zoom: Float = 14.0
    var locationManager = CLLocationManager()
    var userLatitude: CLLocationDegrees?
    var userLongitude: CLLocationDegrees?
    var currentLocationStr = ""
    var list_positive = [GMUWeightedLatLng]()
    var list_negative = [GMUWeightedLatLng]()
    var guest = Guest()
    
    @IBOutlet weak var myPageButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var symptomTestButton: UIBarButtonItem!
    @IBOutlet weak var heatMapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        
        if let vcs = self.navigationController?.viewControllers {
            let previousVC = vcs[vcs.count - 2]
            if previousVC is MainPageViewController {
                pinButton?.isEnabled = false
                myPageButton?.isEnabled = false
                symptomTestButton?.isEnabled = false
                heatMapView.isUserInteractionEnabled = false
                
            } else if userProfile.user!.testApplied {
                symptomTestButton.isEnabled = false
            } else if userProfile.user!.id != 0 && userProfile.user!.testApplied == false {
                symptomTestButton.isEnabled = true
            }
        }
        
        heatMapView.delegate = self
        userProfile.delegate = self
        symptomTestView.delegate = self
        heatMapView.isMyLocationEnabled = true
        negativeHeatMapLayer = GMUHeatmapTileLayer()
        positiveHeatMapLayer = GMUHeatmapTileLayer()
        positiveHeatMapLayer.radius = 300
        negativeHeatMapLayer.radius = 200
        
        print("Test: \(String(describing: userProfile.user?.testApplied))")
        
        let positiveGradientColors: [UIColor] = [.red , .purple]
        let gradientStartPoints: [NSNumber] = [0.1, 0.3]
        positiveHeatMapLayer.gradient = GMUGradient(
            colors: positiveGradientColors,
            startPoints: gradientStartPoints,
            colorMapSize: 500
        )
        
        let negativeGradientColors: [UIColor] = [.yellow, .green]
        let negativeGradientStartPoints: [NSNumber] = [0.1, 0.3]
        negativeHeatMapLayer.gradient = GMUGradient(
            colors: negativeGradientColors,
            startPoints: negativeGradientStartPoints,
            colorMapSize: 256
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        addPositiveHeatmap()
        positiveHeatMapLayer.map = heatMapView
        addNegativeHeatmap()
        negativeHeatMapLayer.map = heatMapView
    }
    
    func getPositiveLocations() -> [Locations] {
        
        var locationArray: [Locations] = []
        if let symptomList = database.symptomList(){
            for each in symptomList{
                let new_user = database.getUser(idValue: each.user_Id)
                if each.output == 1 {
                    let thisLocation = Locations()
                    thisLocation.lattitude = each.lat
                    thisLocation.longitude = each.long
                    if new_user?.testApplied == true {
                        let forUserLocation = Locations()
                        forUserLocation.lattitude = new_user!.userLat
                        forUserLocation.longitude = new_user!.userLong
                        locationArray.append(forUserLocation)
                    }
                    locationArray.append(thisLocation)
                }
            }
        }
        return locationArray
    }
    
    
    func getNegativeLocations() -> [Locations] {
        
        var locationArray: [Locations] = []
        if let symptomList = database.symptomList(){
            for each in symptomList{
                let new_user = database.getUser(idValue: each.user_Id)
                if each.output == 0 {
                    let thisLocation = Locations()
                    thisLocation.lattitude = each.lat
                    thisLocation.longitude = each.long
                    if new_user?.testApplied == true{
                        let forUserLocation = Locations()
                        forUserLocation.lattitude = new_user!.userLat
                        forUserLocation.longitude = new_user!.userLong
                        locationArray.append(forUserLocation)
                    }
                    locationArray.append(thisLocation)
                }
            }
        }
        return locationArray
    }
    
    func addNegativeHeatmap() {
        let neg_locations = getNegativeLocations()
        for item in neg_locations{
            let lat = item.lattitude
            let lng = item.longitude
            let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng), intensity: 100)
            list_negative.append(coords)
        }
        
        negativeHeatMapLayer.weightedData = list_negative
    }
    
    func addPositiveHeatmap() {
        let locations = getPositiveLocations()
        for item in locations {
            let lat = item.lattitude
            let lng = item.longitude
            let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng), intensity: 500)
            list_positive.append(coords)
        }
        positiveHeatMapLayer.weightedData = list_positive
    }
    
    @IBAction func MyPageButtonPressed(_ sender: UIButton) {
        self.present(userProfile, animated: true, completion: nil)
    }
    
    @IBAction func PinButtonPressed(_ sender: Any) {
        zoom = 17.0
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = GMSCameraPosition(latitude: userLocation.latitude, longitude: userLocation.longitude, zoom: zoom)
            self.heatMapView.animate(to: viewRegion)
            self.locationManager.stopUpdatingLocation()
        }
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
            //self.addNegativeHeatmap()
            //self.addPositiveHeatmap()
        }
        print("location")
    }
    
    @IBAction func symptomTestButtonPressed(_ sender: Any) {
        symptomTestView.modalPresentationStyle = .fullScreen
        present(symptomTestView, animated: true, completion: nil)
    }
}

extension MapViewController: StatusDelegate, TimerManagerDelegate {
    func timerManager(controller: UserProfileViewController, userValue: User) {
        if userValue.testApplied{
            self.symptomTestButton.isEnabled = false
            
        } else {
            self.symptomTestButton.isEnabled = true
        }
    }
    
    func statusManager(controller: SymptomTestViewController, userValue: User) {
        print("Test Value: \(userValue.testApplied)")
        if userValue.testApplied{
            self.symptomTestButton.isEnabled = false
            self.userProfile.startTimer()
            //self.database.updateUserLocation(latValue: userLatitude ?? 0.0, longValue: userLongitude ?? 0.0, userValues: userValue)
            _ = database.getUser(idValue: userValue.id)
            addNegativeHeatmap()
            addPositiveHeatmap()
            
            //print("this user Lat: \(new_User?.userLat), this user long: \(new_User?.userLong)")
        } else {
            self.symptomTestButton.isEnabled = true
        }
    }
}

//MARK: - MapViewDelegate
extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[locations.count-1] as CLLocation
        manager.startUpdatingLocation()
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let camera = GMSCameraPosition(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: zoom)
        userLatitude = userLocation.coordinate.latitude
        userLongitude = userLocation.coordinate.longitude
        
        if userProfile.user == nil {
            database.updateGuestLocation(latValue: userLocation.coordinate.latitude, longValue: userLocation.coordinate.longitude, guestValues: guest)
        } else {
            database.updateUserLocation(latValue: userLocation.coordinate.latitude, longValue: userLocation.coordinate.longitude, userValues: userProfile.user!)
        }
        
        let marker = GMSMarker()
        marker.position = coordinations
        marker.title = self.setUserClosestLocation(latValue: userLocation.coordinate.latitude, longValue: userLocation
                                                    .coordinate.longitude)
        marker.map = heatMapView
        heatMapView.animate(to: camera)
    }
    
    
    func setUserClosestLocation(latValue: CLLocationDegrees, longValue: CLLocationDegrees) -> String{
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latValue, longitude: longValue)
        
        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
            if error == nil {
                if placemarks?.count ?? 0 > 0{
                    let placeMark = placemarks?[0]
                    if let Name = placeMark?.name{
                        if let City = placeMark?.locality{
                            if let subCity = placeMark?.subLocality{
                                self.currentLocationStr = Name + ", " + City + ", " + subCity
                            }
                            
                        }
                    }
                }
            }
        }
        return currentLocationStr
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
