# FireTower – Task Breakdown (MVP)

---

## Project Setup & Core Infrastructure

- [x] Set up Xcode project (SwiftUI, iOS 16+)
- [x] Create app icon and launch screen placeholder
- [x] Define app-wide color palette and theme
- [x] Create global data models:
  - [x] ObservationSet
  - [x] Observation
- [x] Implement local storage for observation sets
- [x] Set up permissions:
  - [x] Location usage prompt
  - [ ] Compass calibration handling
- [x] Add `MainTabView` with links to placeholders
- [x] Add basic LaunchScreen

---

## Basic Observations

- [x] Block in basic UI Components
  - [x] Circle for compass (non-functional)
  - [x] Button for observation
  - [x] Slide up panel for map
- [x] Clicking "Capture" stores randomized Observation
- [x] Add arrow overlay 

---

## Sightings Management

- [x] Create Sightings store
  - [x] support file storage
- [x] Store Sightings
- [x] Sightings List View:
  - [x] Display all sightings with name + count
  - [x] Create new sighting (default to today’s date)
  - [ ] Rename sighting
  - [ ] Delete with confirmation
- [x] Sighting Detail View:
  - [x] List all observations in selected sighting
  - [x] Tap to view details
  - [ ] Delete observation
  - [ ] (Optional) Edit screen for heading/lat/lng

---

## Compass View Implementation

- [ ] Re-map Sighting Detail view to Compass view
  - [ ] Move observations list into a bottom sheet
  - [ ] Use active `Sighting` from `SightingStore` singleton
  - [ ] Disable capture button when at max (5/5) observations
- [ ] Build SensorsManager (ObservableObject)
  - [ ] Integrate CoreLocation for lat/lng, horizontalAccuracy, true/magnetic heading
  - [ ] Integrate CoreMotion for tilt detection (±20°)
  - [ ] Publish heading, headingAccuracy, location, horizontalAccuracy, isFlat, headingSource
  - [ ] Start/stop updates with view lifecycle
- [ ] Build ADF-style compass view
  - [ ] Fixed arrow pointing up
  - [ ] Rotating compass dial based on heading
  - [ ] Live numeric heading label
  - [ ] Heading source indicator (“True”/“Mag”)
  - [ ] Apply project theme fonts/colors
- [ ] Accuracy & tilt warnings
  - [ ] Show warning if headingAccuracy > 12°
  - [ ] Show warning if horizontalAccuracy > 30 m
  - [ ] Show tilt overlay when outside ±20° (warn only)
  - [ ] “Calibrate for best results” banner when poor heading accuracy
- [ ] Capture button
  - [ ] Gather heading, headingAccuracy, location, horizontalAccuracy, timestamp
  - [ ] Auto-assign name (O1, O2, …) based on count
  - [ ] Append observation to active `Sighting` in `SightingStore`
  - [ ] Disable capture when at max
- [ ] Confirmation feedback on capture
  - [ ] Haptic feedback
  - [ ] Toast/snackbar (“Captured O3”)
  - [ ] Visual pulse animation around dial
- [ ] Observation sheet view
  - [ ] Editable Sighting name
  - [ ] Read-only list of observations (for MVP)
  - [ ] (Future) Delete observation support
- [ ] Navigation
  - [ ] Pass active `Sighting` ID from Sightings list to Compass view
  - [ ] Inject `SightingStore` singleton into Compass view
- [ ] Permissions
  - [ ] Ensure “When In Use” location permissions requested
  - [ ] Show system compass calibration prompt if required
- [ ] Polish
  - [ ] Portrait-only layout
  - [ ] MVP-target iOS version (latest - 1)


---

## Map View & Triangulation Logic

- [ ] Show observation points on MapKit
- [ ] Draw directional rays from each point (based on heading)
- [ ] Add intersection logic:
  - [ ] 2-ray: basic line intersection
  - [ ] 3+ ray: least-squares intersection
- [ ] Plot intersection point on map
- [ ] Update in real-time as observations are added/removed
- [ ] Configurable ray length (default 25 mi)

---

## Settings & Warnings

- [ ] Settings screen:
  - [ ] Ray length setting
  - [ ] Toggle for dark mode (follows system by default)
- [ ] Compass calibration prompts
- [ ] Tilt/flatness overlay
- [ ] Accuracy and disclaimer overlays

---

## Persistence & Offline Support

- [ ] Store observation sets and observations locally (e.g., Codable + FileManager)
- [ ] Load data on launch
- [ ] Save on app exit or changes
- [ ] Handle offline state (disable map features if offline)

---

## Testing & Polish

- [ ] Unit tests for triangulation/intersection logic
- [ ] UI testing for each view
- [ ] Device testing (iPhone only for MVP)
- [ ] Error handling and fallbacks
- [ ] Add test data mode for debug builds

---

## App Store Preparation (Optional for MVP)

- [ ] App Store listing (screenshots, description, keywords)
- [ ] Privacy policy and disclaimer
- [ ] Prepare TestFlight build
- [ ] MVP submission for beta testers
