//
//  LocationManager.swift
//  Weather-Test
//
//  Created by Monalisa Nanda on 5/28/23.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    func getLocationPosition() -> (lat: Double, lon: Double)?
}

class LocationManager: NSObject, LocationManagerProtocol, CLLocationManagerDelegate {
    private var manager: CLLocationManager = CLLocationManager()
    private var position: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined, .restricted, .denied:
            manager.requestLocation()
        default:
            fatalError()
        }
        manager.startUpdatingLocation()
    }
    
    func getLocationPosition() -> (lat: Double, lon: Double)? {
        if let position = position {
            return (position.coordinate.latitude, position.coordinate.longitude)
        } else {
            return nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Unable to do more of it....
        //Unable to get location permission Dialog in Simulator...
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
