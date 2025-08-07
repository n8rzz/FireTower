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

- [ ] Block in basic UI Components
  - [ ] Circle for compass (non-functional)
  - [ ] Button for observation
  - [ ] Slide up panel for map
- [ ] Clicking "Capture" stores randomized Observation

---

## Compass View Implementation

- [ ] Build ADF-style compass view:
  - [ ] Fixed arrow pointing up
  - [ ] Rotating compass dial based on heading
  - [ ] Live heading label
- [ ] Flatness detection logic (±20° threshold)
- [ ] Accuracy warning overlays (GPS & heading)
- [ ] Capture button:
  - [ ] Record compass heading
  - [ ] Record current lat/lng
  - [ ] Record timestamp & accuracy
  - [ ] Append to active observation set
- [ ] Confirmation feedback on capture (e.g., animation or toast)

---

## Observation Set Management

- [ ] Observation Set List View:
  - [ ] Display all sets with name + count
  - [ ] Create new set (default to today’s date)
  - [ ] Rename set
  - [ ] Delete with confirmation
- [ ] Observation Detail View:
  - [ ] List all observations in selected set
  - [ ] Tap to view details
  - [ ] Delete observation
  - [ ] (Optional) Edit screen for heading/lat/lng

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
