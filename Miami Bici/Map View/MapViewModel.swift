//
//  MapViewModel.swift
//  Miami Bici
//
//  Created by Paulo Fierro on 29/04/2019.
//  Copyright © 2019 Jadehopper Ltd. All rights reserved.
//

import CoreLocation
import SwiftyXML
import UIKit

/// Generic Network Error
enum NetworkError: Error {
    case somethingWentWrong(message: String)
}

/// The data structure for each bike stand
struct Location {
    let id: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let bikes: Int
    let dockings: Int

    var hasBikes: Bool {
        return bikes > 0
    }
}

/// Handles the data fetching for the map view
class MapViewModel {

    /// Loads the bike data
    /// - Parameter completion: Returns an array of Location objects, or an error
    func fetchData(_ completion: @escaping (Result<[Location]?, NetworkError>) -> Void) {
        
        // TODO: We should use Reachability to figure out if we're offline

        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Constants.networkRequestTimeout
        config.timeoutIntervalForResource = Constants.networkRequestTimeout
        config.requestCachePolicy = .reloadIgnoringLocalCacheData

        let session = URLSession(configuration: config)
        let url = Constants.API_URL
        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { [weak self] data, response, _ in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }

            // Check for issues
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.somethingWentWrong(message: "Request failed for \(url.absoluteString)")))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.somethingWentWrong(message: "Received bad status code (\(httpResponse.statusCode)) data from \(url.absoluteString)")))
                return
            }
            guard let data = data else {
                completion(.failure(.somethingWentWrong(message: "Received invalid data from \(url.absoluteString)")))
                return
            }

            // All good! Parse and return the data
            let locations = self?.parseXML(data)
            completion(.success(locations))
        }
        task.resume()
    }

    /// Converts that delicious XML into something we can use
    private func parseXML(_ data: Data) -> [Location]? {
        guard let xml = XML(data: data) else {
            return nil
        }
        var locations = [Location]()
        for xmlLocation in xml["location"] {
            let location = Location(id: xmlLocation["Id"].stringValue,
                                    address: xmlLocation["Address"].stringValue,
                                    coordinate: CLLocationCoordinate2D(latitude: xmlLocation["Latitude"].doubleValue,
                                                                       longitude: xmlLocation["Longitude"].doubleValue),
                                    bikes: xmlLocation["Bikes"].intValue,
                                    dockings: xmlLocation["Dockings"].intValue)
            locations.append(location)
        }
        return locations
    }
}
