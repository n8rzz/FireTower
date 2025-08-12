//
//  SightingMapView.swift
//  FireTower
//
//  Created by Nate Geslin on 8/11/25.
//

import SwiftUI
import MapKit

struct SightingMapView: View {
    let sighting: Sighting

    @State private var cameraPosition: MapCameraPosition
    private let rayLengthKm: Double = 25

    private struct Pin: Identifiable {
        let id: Int
        let coordinate: CLLocationCoordinate2D
        let title: String
    }

    private var pins: [Pin] {
        sighting.observations.enumerated().map { (idx, obs) in
            Pin(
                id: idx,
                coordinate: CLLocationCoordinate2D(latitude: obs.latitude, longitude: obs.longitude),
                title: obs.name.isEmpty ? "Obs \(idx + 1)" : obs.name
            )
        }
    }

    private var raySegments: [[CLLocationCoordinate2D]] {
        sighting.observations.map { obs in
            let start = CLLocationCoordinate2D(latitude: obs.latitude, longitude: obs.longitude)
            let end = Geo.destination(from: start, bearingDegrees: obs.heading, distanceKm: rayLengthKm)
            return [start, end]
        }
    }

    init(sighting: Sighting) {
        self.sighting = sighting
        let coords = sighting.observations.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        let fallback = coords.last ?? CLLocationCoordinate2D(latitude: 39.8283, longitude: -98.5795)
        let region = Self.regionThatFits(coords: coords, fallback: fallback)
        _cameraPosition = State(initialValue: .region(region))
    }

    var body: some View {
        Map(position: $cameraPosition) {
            // Pins
            ForEach(pins) { pin in
                Annotation(pin.title, coordinate: pin.coordinate) {
                    VStack(spacing: 2) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                        Text(pin.title)
                            .font(.caption2)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }

            // Bearing rays
            ForEach(raySegments.indices, id: \.self) { i in
                MapPolyline(coordinates: raySegments[i])
                    .stroke(Color.orange, lineWidth: 3)
            }

            // Blue dot for user location (if permission granted)
            UserAnnotation()
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: sighting.observations) { _ in
            let coords = sighting.observations.map {
                CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }
            let fallback = coords.last ?? defaultFallbackCenter()
            cameraPosition = .region(Self.regionThatFits(coords: coords, fallback: fallback))
        }
    }

    private func defaultFallbackCenter() -> CLLocationCoordinate2D {
        pins.first?.coordinate ?? CLLocationCoordinate2D(latitude: 39.8283, longitude: -98.5795)
    }

    private static func regionThatFits(
        coords: [CLLocationCoordinate2D],
        fallback: CLLocationCoordinate2D
    ) -> MKCoordinateRegion {
        guard !coords.isEmpty else {
            return MKCoordinateRegion(
                center: fallback,
                span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
            )
        }
        var minLat = coords[0].latitude, maxLat = coords[0].latitude
        var minLon = coords[0].longitude, maxLon = coords[0].longitude
        for c in coords.dropFirst() {
            minLat = min(minLat, c.latitude)
            maxLat = max(maxLat, c.latitude)
            minLon = min(minLon, c.longitude)
            maxLon = max(maxLon, c.longitude)
        }
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let latSpan = max((maxLat - minLat) * 1.6, 0.02)
        let lonSpan = max((maxLon - minLon) * 1.6, 0.02)
        return MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lonSpan)
        )
    }
}

// MARK: - Preview
#if DEBUG
import CoreLocation

private enum _PreviewCoords {
    static let coords: [CLLocationCoordinate2D] = [
        .init(latitude: 44.9778, longitude: -93.2650),
        .init(latitude: 45.0050, longitude: -93.3050),
        .init(latitude: 44.9600, longitude: -93.2350),
    ]
}

private extension Observation {
    static func preview(
        title: String,
        coordinate: CLLocationCoordinate2D,
        heading: Double
    ) -> Observation {
        Observation(
            name: title,
            heading: heading,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            locationAccuracy: 5,
            headingAccuracy: 2,
            elevation: nil,
            angle: nil
        )
    }
}

private extension Sighting {
    static var previewForMap: Sighting {
        var s = Sighting(name: "Preview Sighting")
        let headings: [Double] = [35, 160, 290]
        s.observations = zip(_PreviewCoords.coords.indices, _PreviewCoords.coords).map { idx, coord in
            Observation.preview(
                title: "Obs \(idx + 1)",
                coordinate: coord,
                heading: headings[idx % headings.count]
            )
        }
        return s
    }
}

#Preview("Map + Rays") {
    NavigationView {
        SightingMapView(sighting: .previewForMap)
    }
}
#endif
