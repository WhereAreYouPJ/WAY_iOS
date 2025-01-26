//
//  GeocodeLocationUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 24.01.25.
//

import Foundation
import CoreLocation

protocol GeocodeLocationUseCase {
    func execute(location: Location, completion: @escaping (Result<Location, Error>) -> Void)
}

final class GeocodeLocationUseCaseImpl: GeocodeLocationUseCase {
    private let geocoder: CLGeocoder
    
    init(geocoder: CLGeocoder = CLGeocoder()) {
        self.geocoder = geocoder
    }
    
    func execute(location: Location, completion: @escaping (Result<Location, Error>) -> Void) {
        geocoder.geocodeAddressString(location.streetName) { placemarks, error in
            if let error = error {
                completion(.failure(error))
            } else if let placemark = placemarks?.first,
                      let coordinate = placemark.location?.coordinate {
                let geocodedLocation = Location(
                    sequence: location.sequence,
                    location: location.location,
                    streetName: location.streetName,
                    x: coordinate.longitude,
                    y: coordinate.latitude
                )
                completion(.success(geocodedLocation))
            } else {
                completion(.success(location))
            }
        }
    }
}
