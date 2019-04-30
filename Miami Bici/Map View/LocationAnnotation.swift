//
//  LocationAnnotation.swift
//  Miami Bici
//
//  Created by Paulo Fierro on 29/04/2019.
//  Copyright © 2019 Jadehopper Ltd. All rights reserved.
//

import MapKit

/// Holds the location data for each map "pin"
class LocationAnnotation: NSObject, MKAnnotation {

    /// The annotation data
    let location: Location

    init(location: Location) {
        self.location = location
        super.init()
    }

    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }

    var title: String? {
        return location.address
    }

    var subtitle: String? {
        return "Bikes: \(location.bikes) Dockings: \(location.dockings)"
    }
}
