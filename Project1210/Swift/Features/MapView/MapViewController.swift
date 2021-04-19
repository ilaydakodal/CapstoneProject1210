//
//  MapViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/4/21.
//

import UIKit
import MapKit
import SQLite
import CoreLocation

class MapViewController: UIViewController {
    
    lazy var userProfile = UserProfileViewController()
    lazy var symptomTestView = SymptomTestViewController()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.addMapPin(with: location)
            }
        }
        
    }
    
    @IBAction func MyPageButtonPressed(_ sender: Any) {
        //userProfile.modalPresentationStyle = .fullScreen
        self.present(userProfile, animated: true, completion: nil)
    }
    
    @IBAction func PinButtonPressed(_ sender: Any) {
        mapView.showsUserLocation = true
        
        print("location")
    }
    
    @IBAction func symptomTestButtonPressed(_ sender: Any) {
        self.present(symptomTestView, animated: true, completion: nil)
    }
    
    func addMapPin(with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate,
                                             span: MKCoordinateSpan(latitudeDelta: 0.1,
                                                                    longitudeDelta: 0.1)),
                          animated: true)
        mapView.addAnnotation(pin)
    }
}
