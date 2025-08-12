//
//  Geo.swift
//  FireTower
//
//  Created by Nate Geslin on 8/11/25.
//

import Foundation
import CoreLocation

enum Geo {
    /// Returns a destination coordinate given a start coordinate, a bearing (degrees, 0° = true north),
    /// and a distance in kilometers using a spherical Earth approximation.
    static func destination(
        from start: CLLocationCoordinate2D,
        bearingDegrees: Double,
        distanceKm: Double
    ) -> CLLocationCoordinate2D {
        let R = 6371.0 // km
        let brng = bearingDegrees * .pi / 180.0
        let dR = distanceKm / R

        let lat1 = start.latitude * .pi / 180.0
        let lon1 = start.longitude * .pi / 180.0

        let lat2 = asin(sin(lat1) * cos(dR) + cos(lat1) * sin(dR) * cos(brng))
        let lon2 = lon1 + atan2(
            sin(brng) * sin(dR) * cos(lat1),
            cos(dR) - sin(lat1) * sin(lat2)
        )

        return CLLocationCoordinate2D(
            latitude: lat2 * 180.0 / .pi,
            longitude: lon2 * 180.0 / .pi
        )
    }
}

