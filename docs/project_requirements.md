# Fire Triangulation App – PRD (MVP)

## Overview

This app helps users determine the origin of smoke or fire sightings using triangulation, based on directional observations made via the device’s compass and GPS. Inspired by traditional fire towers, users can capture directional readings and visualize the estimated source on a map.

---

## Goals

- Allow users to capture directional observations tied to their location.
- Visualize observations and inferred fire location on a map using triangulation.
- Support multiple "fire events" (observation sets).
- Keep app offline-capable for capturing observations, but require internet for mapping.
- Provide a simple and intuitive user interface modeled after aviation-style directional instruments.

---

## Core Features

### 1. **Observation Sets**

- Users can create a new set of observations per suspected fire.
- Each set has a user-editable name (default to current date).
- Users can delete sets with a confirmation prompt.
- Observation sets contain up to **5 observations**.

### 2. **Compass View**

- Displays a fixed arrow pointing “up” with a rotating compass dial (like an ADF).
- Users hold the phone flat (±20° tilt allowed) to aim at the smoke.
- Tap **“Capture”** to record the observation:
  - Compass heading (degrees)
  - Latitude / Longitude
  - Timestamp
  - Accuracy metrics (location and heading)
- Observations are named automatically (e.g., O1, O2…).
- Users can edit or delete observations.

### 3. **Map View**

- Plots each observation as a point and a directional ray.
- Shows the estimated fire location by computing intersection(s) of rays:
  - Two observations → Line intersection
  - Three or more → Least-squares intersection
- Intersection point updates live as more observations are added.
- Ray length is configurable (default: 25 miles).

### 4. **Observation List View**

- Shows list of observation sets.
- Each entry shows name, number of observations (e.g., 3/5).
- Tap to view/edit observations.
- Swipe to delete entire sets (with confirmation).

### 5. **Settings View**

- Global settings only (per-session not supported in MVP).
- Configurable ray length (default 25 mi).
- Toggle dark mode support (via system appearance).
- Future options to be added post-MVP.

---

## Platform & Technical Requirements

- **Platform:** iOS (SwiftUI)
- **APIs:** CoreLocation, MapKit, CoreMotion (for orientation), Combine
- **Offline Support:** Observations can be captured offline; map and triangulation require internet.
- **Data Storage:** Local only (UserDefaults or local file persistence).
- **Data Model:** 
  - `ObservationSet` → has many `Observation`s
  - Each `Observation` includes heading, lat/lng, timestamp, accuracy

---

## Constraints & Considerations

- Heading accuracy can be unreliable indoors or near metal; app should display a disclaimer.
- User should be prompted to calibrate compass if needed.
- Ensure guidance to hold the phone flat is present.
- Triangulation is for reference only, not emergency use.

---

## Future Features (Post-MVP)

- Photos attached to observations
- Cloud sync & backup
- User collaboration (shared fire sets)
- Elevation capture
- External fire data overlays (e.g., CalFire)
- Manual heading/coordinate editing (potentially behind paywall)
- Advanced map tools (distance rings, measurement)
