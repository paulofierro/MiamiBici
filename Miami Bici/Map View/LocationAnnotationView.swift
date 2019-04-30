//
//  LocationAnnotationView.swift
//  Miami Bici
//
//  Created by Paulo Fierro on 29/04/2019.
//  Copyright © 2019 Jadehopper Ltd. All rights reserved.
//

import MapKit

/// The map "pin" that will be rendered for each annotation
class LocationAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? LocationAnnotation else { return }
            canShowCallout = false
            glyphText = annotation.location.hasBikes ? "✅" : "❌"
            markerTintColor = (annotation.location.hasBikes) ? .green : nil
        }
    }
}
