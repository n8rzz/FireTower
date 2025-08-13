# FireTower – Task Breakdown (MVP)

---

## Map View & Triangulation Logic

- [x] Show observation points on MapKit
- [x] Draw directional rays from each point (based on heading)
- [ ] Add intersection logic:
  - [ ] 2-ray: basic line intersection
  - [ ] 3+ ray: least-squares intersection
- [ ] Plot intersection point on map
- [ ] Update in real-time as observations are added/removed
- [ ] Configurable ray length (default 25 mi)
- [ ] Plotting 3rd ray plots in the wrong direction

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

## Project Setup & Core Infrastructure - post mvp

  - [ ] Compass calibration handling

## Sightings Management - post mvp

- [/] Sightings List View:
  - [ ] Rename sighting
  - [ ] Delete with confirmation

## Compass View Implementation - post mvp

- [ ] Observation sheet view
  - [ ] Editable Sighting name (inline)
  
- [x] ADF-style compass view
  - [ ] Apply theme fonts/colors

- [ ] Accuracy & tilt warnings
  - [ ] Show warning if `headingAccuracy > 12°`
  - [ ] Show warning if `horizontalAccuracy > 30 m`
  - [ ] Tilt overlay when outside ±20° (warn only)
  - [ ] “Calibrate for best results” banner when `needsCalibrationHint == true`

- [ ] Polish
  - [ ] Portrait-only enforcement
  - [ ] Heading smoothing + shortest-path animation
    - [ ] Unwrap 0/360 so 359°→1° rotates 2°, not 358°.
    - [ ] Add a light low-pass/median filter and a min-delta (e.g., ≥1–2°) to cut jitter.
    - [ ] When compass moves from 359 to 360 things jump

---

## App Store Preparation (Optional for MVP)

- [ ] App Store listing (screenshots, description, keywords)
- [ ] Privacy policy and disclaimer
- [ ] Prepare TestFlight build
- [ ] MVP submission for beta testers

---

## COMPLETE

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

## Sightings Management

- [x] Create Sightings store
  - [x] support file storage
- [x] Store Sightings
- [x] Sightings List View:
  - [x] Display all sightings with name + count
  - [x] Create new sighting (default to today’s date)
- [x] Sighting Detail View:
  - [x] List all observations in selected sighting
  - [x] Tap to view details

## Compass View Implementation

- [x] Re-map Sighting Detail view to Compass view
  - [x] **Replace navigation target**
    - [x] In `SightingsListView`, change `NavigationLink` destination from `SightingDetailView` → `CompassMapContainerView`
    - [x] Pass `sighting.id`, `store`, and `locationManager` to Compass view
    - [x] Remove `NavigationView` wrapper inside Compass to avoid nested nav bars
    - [x] Set navigation title to the active sighting's name
  - [x] **Compass view data source**
    - [x] Accept `id: UUID?` and `store: SightingStore` in Compass view
    - [x] Add computed property to fetch `Sighting` from store by id
    - [x] Ensure computed property updates when `store.sightings` changes
  - [x] **Observations list under Capture**
    - [x] Show list header: `"Observations (n/5)"`
    - [x] Include footer: `"Maximum of 5 observations reached."` when at max
    - [x] List each observation with:
      - Name (e.g., "O1")
      - Heading in degrees
      - Lat/Lon coordinates
    - [x] Support swipe-to-delete (updates store)
    - [x] Empty state text: `"No observations yet"`
  - [x] **Capture button rules**
    - [x] Disable Capture button when at 5/5 observations
    - [/] Show info text when disabled: `"Maximum of 5 observations reached."`

- [x] Sensors layer (enhanced `LocationManager`)
  - [x] CoreLocation: lat/lng + `horizontalAccuracy`
  - [x] Heading: prefer **true**; fallback to **magnetic**; expose `headingDegrees`
  - [x] CoreMotion: tilt detection → `tiltDegrees`, `isFlat` (±20°)
  - [x] Publish: `headingDegrees`, `headingAccuracy`, `headingSource`, `location`, `locationAccuracy`, `isFlat`, `needsCalibrationHint`
  - [x] Lifecycle: `startUpdates()` / `stopUpdates()`

- [x] Capture button (real data)
  - [x] Gather: heading, headingAccuracy, lat, lon, horizontalAccuracy, timestamp
  - [x] Auto-assign name based on time
  - [x] Append to active `Sighting` in `SightingStore`
  - [x] Disable capture when at max

- [x] Confirmation feedback on capture
  - [x] Haptic feedback
  - [x] Toast/snackbar (“Captured O#”)
  - [ ] Visual pulse around dial

- [ ] Observation sheet view
  - [ ] Editable Sighting name (inline)
  - [x] Read-only list of observations (MVP)
  - [x] Delete observation support

- [x] Navigation
  - [x] Pass active `Sighting` ID from Sightings list to Compass container
  - [x] Inject `SightingStore` singleton into Compass container

- [x] Live sensor stats (always visible under Capture)
  - [x] Heading (°) + source
  - [x] Heading accuracy
  - [x] Lat / Lon
  - [x] GPS accuracy
  - [x] Tilt° + flatness state

- [x] Permissions
  - [x] Ensure “When In Use” location permission (already in place)
  - [x] Allow system compass calibration prompt

- [x] ADF-style compass view
  - [x] Fixed arrow pointing up
  - [x] Rotating dial based on live heading
  - [x] Live numeric heading label
  - [x] Heading source indicator (“True”/“Mag”)
  - [ ] Apply theme fonts/colors

- [ ] Accuracy & tilt warnings
  - [ ] Show warning if `headingAccuracy > 12°`
  - [ ] Show warning if `horizontalAccuracy > 30 m`
  - [ ] Tilt overlay when outside ±20° (warn only)
  - [ ] “Calibrate for best results” banner when `needsCalibrationHint == true`

- [ ] Polish
  - [ ] Portrait-only enforcement
  - [ ] Target = latest - 1 (confirm project setting)
