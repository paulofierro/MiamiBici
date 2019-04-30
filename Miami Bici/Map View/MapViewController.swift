//
//  MapViewController.swift
//  Miami Bici
//
//  Created by Paulo Fierro on 29/04/2019.
//  Copyright © 2019 Jadehopper Ltd. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!

    private let viewModel = MapViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }

    /// Get the UI ready
    private func setupUI() {
        mapView.register(LocationAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        // Set the start position for the map
        zoomMap(radiusInMeters: 100, animated: false)
    }

    /// Fetch the data and display it
    private func loadData() {
        viewModel.fetchData { [weak self] result in
            switch result {
            case .success(let locations):
                guard let locations = locations else {
                    // TODO: Handle error
                    assertionFailure("No locations were loaded")
                    return
                }
                DispatchQueue.main.async {
                    self?.renderLocations(locations)
                }

            case .failure(let error):
                // TODO: Handle error
                assertionFailure(error.localizedDescription)
            }
        }
    }

    /// Render an array locations on the map
    private func renderLocations(_ locations: [Location]) {
        // Transform all the locations to annotations and put them on the map
        let annotations: [LocationAnnotation] = locations.map {
            LocationAnnotation(location: $0)
        }
        mapView.addAnnotations(annotations)

        // Zoom to a 10km radius
        zoomMap(radiusInMeters: 10_000)
    }

    /// Zooms the map to a particular location
    private func zoomMap(radiusInMeters: Double, animated: Bool = true) {
        let region = MKCoordinateRegion(center: Constants.miami,
                                        latitudinalMeters: radiusInMeters,
                                        longitudinalMeters: radiusInMeters)
        mapView.setRegion(region, animated: animated)
    }
}

extension MapViewController: MKMapViewDelegate {
    // Nothing to see here
}
