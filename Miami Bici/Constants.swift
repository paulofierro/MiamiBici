//
//  Constants.swift
//  Miami Bici
//
//  Created by Paulo Fierro on 29/04/2019.
//  Copyright © 2019 Jadehopper Ltd. All rights reserved.
//

import CoreLocation
import Foundation

struct Constants {
    /// The number of seconds the app will wait before considering a request as timed out
    static let networkRequestTimeout: TimeInterval = 30.0

    /// Our data source
    static let API_URL = URL(string: "http://www.citibikemiami.com/downtown-miami-locations2.xml")!

    /// Our center point
    static let miami = CLLocationCoordinate2D(latitude: 25.798353222539873, longitude: -80.16495606635253)
}
