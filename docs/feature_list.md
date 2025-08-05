# Fire Triangulation App – Screens & Feature List (MVP)

---

## 1. Observation Set List View

**Purpose:** View, create, and manage multiple fire observation sets.

### Features:

- List all observation sets
  - Display: name, number of observations (e.g., "3 of 5")
- Create new set (default name = current date)
- Rename set
- Tap to open Compass/Map view
- Swipe-to-delete set (with confirmation)

---

## 2. Compass View

**Purpose:** Capture directional observations using device compass and location.

### Features:

- Rotating compass dial with fixed upward arrow (ADF-style)
- Live compass heading display (numeric and graphical)
- Flatness detection (warn user if phone is tilted > ±20°)
- Capture button:
  - Records heading, location, timestamp, accuracy
  - Adds named observation (e.g., "O1")
- Warning if heading/location data is inaccurate
- Access to edit or delete past observations in current set

---

## 3. Map View

**Purpose:** Visualize observations and triangulate source.

### Features:

- Plot each observation's location as a point
- Draw directional ray from each observation (based on heading)
- Configurable ray length (default 25 miles)
- Intersection point shown:
  - 2 observations: line intersection
  - 3+ observations: least-squares intersection
- Live updates as observations are added or deleted
- MapView requires internet

---

## 4. Observation Detail View

**Purpose:** Review and edit individual observations.

### Features:

- List of observations in current set
  - Display: name, timestamp, heading, lat/lng
- Tap observation to:
  - View details
  - Edit (heading, lat/lng)* *(post-MVP/paid)
  - Delete observation

---

## 5. Settings View

**Purpose:** Configure global app settings.

### Features:

- Ray length (slider or input field, default 25 mi)
- Dark mode toggle (follows system by default)
- (Post-MVP) other visual or performance tweaks

---

## 6. Calibration & Warnings (Overlay/Modal)

**Purpose:** Ensure accurate data collection.

### Features:

- Prompt to calibrate compass if needed
- Tilt warning overlay if phone not level
- Accuracy warning (low GPS or heading accuracy)
- Legal disclaimer (triangulation is approximate, not emergency use)

---

## 7. Debug / Diagnostics View (optional/dev only)

**Purpose:** View raw sensor data for debugging purposes.

### Features:

- Live location and compass heading
- Accuracy metrics
- Flatness angle
