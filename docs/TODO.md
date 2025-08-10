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

- [x] Re-map Sighting Detail view to Compass view
  - [x] **Replace navigation target**
    - [x] In `SightingsListView`, change `NavigationLink` destination from `SightingDetailView` → `CompassMapContainerView`
    - x ] Pass `sighting.id`, `store`, and `locationManager` to Compass view
    - [x] Remove `NavigationView` wrapper inside Compass to avoid nested nav bars
    - [x] Set navigation title to the active sighting's name
  - [x] **Compass view data source**
    - [x] Accept `id: UUID?` and `store: SightingStore` in Compass view
    - [x] Add computed property to fetch `Sighting` from store by id
    - [x] Ensure computed property updates when `store.sightings` changes
    - [ ] bug: view shifts up when "New Sighting" text is replaced with the date
  - [ ] **Observations list under Capture**
    - [ ] Show list header: `"Observations (n/5)"`
    - [/] Include footer: `"Maximum of 5 observations reached."` when at max
    - [ ] List each observation with:
      - Name (e.g., "O1")
      - Heading in degrees
      - Lat/Lon coordinates
    - [ ] Support swipe-to-delete (updates store)
    - [ ] Empty state text: `"No observations yet"`
  - [x] **Capture button rules**
    - [x] Disable Capture button when at 5/5 observations
    - [/] Show info text when disabled: `"Maximum of 5 observations reached."`

- [x] Sensors layer (enhanced `LocationManager`)
  - [x] CoreLocation: lat/lng + `horizontalAccuracy`
  - [x] Heading: prefer **true**; fallback to **magnetic**; expose `headingDegrees`
  - [x] CoreMotion: tilt detection → `tiltDegrees`, `isFlat` (±20°)
  - [x] Publish: `headingDegrees`, `headingAccuracy`, `headingSource`, `location`, `locationAccuracy`, `isFlat`, `needsCalibrationHint`
  - [x] Lifecycle: `startUpdates()` / `stopUpdates()`

- [ ] ADF-style compass view
  - [ ] Fixed arrow pointing up
  - [ ] Rotating dial based on live heading
  - [ ] Live numeric heading label
  - [ ] Heading source indicator (“True”/“Mag”)
  - [ ] Apply theme fonts/colors

- [ ] Accuracy & tilt warnings
  - [ ] Show warning if `headingAccuracy > 12°`
  - [ ] Show warning if `horizontalAccuracy > 30 m`
  - [ ] Tilt overlay when outside ±20° (warn only)
  - [ ] “Calibrate for best results” banner when `needsCalibrationHint == true`

- [ ] Capture button (real data)
  - [ ] Gather: heading, headingAccuracy, lat, lon, horizontalAccuracy, timestamp
  - [ ] Auto-assign name (`O1`, `O2`, …) based on count
  - [ ] Append to active `Sighting` in `SightingStore`
  - [ ] Disable capture when at max

- [ ] Confirmation feedback on capture
  - [ ] Haptic feedback
  - [ ] Toast/snackbar (“Captured O#”)
  - [ ] Visual pulse around dial

- [ ] Observation sheet view
  - [ ] Editable Sighting name (inline)
  - [ ] Read-only list of observations (MVP)
  - [ ] (Future) Delete observation support

- [ ] Navigation
  - [ ] Pass active `Sighting` ID from Sightings list to Compass container
  - [ ] Inject `SightingStore` singleton into Compass container

- [x] Live sensor stats (always visible under Capture)
  - [x] Heading (°) + source
  - [x] Heading accuracy
  - [x] Lat / Lon
  - [x] GPS accuracy
  - [x] Tilt° + flatness state

- [x] Permissions
  - [x] Ensure “When In Use” location permission (already in place)
  - [x] Allow system compass calibration prompt

- [ ] Polish
  - [ ] Portrait-only enforcement
  - [ ] Target = latest - 1 (confirm project setting)

---

## Proposed component breakdown

- `Views/Compass/CompassHeader.swift`
  - Contains the top “stack”: `HeadingAccuracyWarningView`, `HeadingBadge`, and the circular dial (`ArrowView`).
  - Props:
    - `headingDegrees: Double?` (for the badge)
    - maybe a `showWarning: Bool` (or pass `LocationManager` if you prefer)

- `Views/Compass/CompassDial.swift`
  - Just the visual dial you have now:
    - Circle stroke + `ArrowView`
  - Props:
    - `size: CGFloat` (so we’re not hardcoding 350)
    - `arrowHeight: CGFloat`

- `Views/Compass/CaptureButtonRow.swift`
  - The centered “Capture” card row + disabled state + max‑reached info text (optional prop).
  - Props:
    - `isDisabled: Bool`
    - `onTap: () -> Void`

- `Views/Compass/SensorStatsRow.swift` (optional; you already have `SensorStatsView`)
  - If you want it styled specifically for list rows (no separators, full‑bleed).

- `Views/Observations/ObservationsSection.swift`
  - The section used inside your `List`, with header/empty state, and swipe‑to‑delete.
  - Props:
    - `observations: [Observation]`
    - `maxCount: Int`
    - `onDelete: (IndexSet) -> Void`

- `Views/Common/ToastBanner.swift` (already in your file; just move)
  - No changes needed—simply move to a common folder for reuse.

- `Utilities/Formatters.swift` (optional)
  - `static func timeHHmm(_ date: Date) -> String`
  - `static func latLon(_ lat: Double, _ lon: Double) -> String`
  - Avoids ad‑hoc `DateFormatter()` creation in views.

## What `CompassMapContainerView` keeps

- State (`activeSightingID`, `shouldShowMap`, toast state).
- Store lookups (`sighting`, counts, max logic).
- Capture action (build + append).
- Toolbar (map icon) and sheet presentation.
- The top-level `List` composition.

## End result

- `CompassMapContainerView` becomes a short, readable composer:
  - `CompassHeader(...)`
  - `CaptureButtonRow(isDisabled: isAtMaximumObservations, onTap: capture)`
  - `SensorStatsRow(...)` (or your existing `SensorStatsView`)
  - `ObservationsSection(...)`
  - Toast overlay + toolbar + sheet remain as-is.

## Suggested order (fastest wins)

1) **ObservationsSection.swift** (easy, isolates the longest block)
2) **CaptureButtonRow.swift** (removes action UI noise from the main file)
3) **CompassDial.swift** + **CompassHeader.swift** (pure UI extraction)
4) Move **ToastBanner** to `Views/Common`
5) Add **Formatters.swift** (optional polish)



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
