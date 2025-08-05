# Fire Triangulation App – Data Model Design & Swift Component Planning

---

## Data Model Design (MVP)

### 1. `ObservationSet`

```swift
struct ObservationSet: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var createdAt: Date
    var observations: [Observation]
}
```

- **Fields:**
  - `id`: Unique ID for the set
  - `name`: User-editable name (default = date)
  - `createdAt`: Timestamp when created
  - `observations`: Array of `Observation` objects (max 5)

---

### 2. `Observation`

```swift
struct Observation: Identifiable, Codable {
    var id: UUID = UUID()
    var heading: Double              // degrees (0–360)
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var locationAccuracy: Double?   // in meters
    var headingAccuracy: Double?    // in degrees
}
```

- **Fields:**
  - `id`: Unique ID
  - `heading`: Compass heading in degrees
  - `latitude`/`longitude`: Location where reading was taken
  - `timestamp`: Capture time
  - `locationAccuracy`: Optional
  - `headingAccuracy`: Optional

---

## Swift Component Planning

### 1. `ObservationSetListView`

- Lists all sets (name, observation count)
- Button to create new set
- Tap to open compass/map for selected set
- Swipe to delete with confirmation

### 2. `CompassView`

- Rotating compass background with fixed arrow
- Displays heading in degrees
- Detects phone tilt (±20°)
- “Capture” button adds observation
- Accuracy & tilt warning overlays

### 3. `MapView`

- Shows observation points and rays
- Intersection logic (line or least-squares)
- Configurable ray length
- Live updates when observation count changes

### 4. `ObservationDetailView`

- List of all observations in a set
- Tap to view details (time, location, heading)
- Swipe to delete
- (Future) Edit heading/coords

### 5. `SettingsView`

- Ray length slider/input
- Toggle for dark mode
- Placeholder for future settings

### 6. `OverlayWarnings`

- Compass calibration prompt
- Tilt warning
- Accuracy warning
- Legal disclaimer

### 7. `LocalDataStore`

- Save/load observation sets
- Uses Codable + FileManager
- Appends or updates individual sets
- Run on background thread to avoid UI blocking
