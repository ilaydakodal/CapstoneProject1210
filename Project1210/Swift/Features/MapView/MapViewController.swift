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
         var manager = LocationManager()
    var login: LoginViewController!
    
    @IBOutlet weak var myPageButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var symptomTestButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinButton?.isEnabled = false
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
        relocate()
        
        print("location")
    }
    
    @IBAction func symptomTestButtonPressed(_ sender: Any) {
        self.present(symptomTestView, animated: true, completion: nil)
    }
    
    func addMapPin(with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        mapView?.setRegion(MKCoordinateRegion(center: location.coordinate,
                                             span: MKCoordinateSpan(latitudeDelta: 0.05,
                                                                    longitudeDelta: 0.05)),
                          animated: true)
    }
    
    func relocate() {
        mapView.setVisibleMapRect(
            mapView.annotations.reduce(MKMapRect.null) { result, next in
                let point = MKMapPoint(next.coordinate)
                let rect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
                guard !result.isNull else { return rect }
                return result.union(rect)
            },
            edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20),
            animated: true
        )
    }
}
