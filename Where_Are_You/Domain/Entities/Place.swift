//
//  Place.swift
//  Where_Are_You
//
//  Created by juhee on 13.08.24.
//

import Foundation
import MapKit

struct Place: Identifiable {
    var id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    var address: String
}
