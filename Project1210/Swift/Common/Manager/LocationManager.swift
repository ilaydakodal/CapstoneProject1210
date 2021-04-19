//
//  LocationManager.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/19/21.
//

import Foundation
import CoreLocation

public class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manager.requestWhenInUseAuthorization()
    }
}
