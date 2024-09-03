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
    var location: String
    var streetName: String
    var x: Double
    var y: Double
}
