# Fire Triangulation App – Wireframes (Text Version)

---

## 1. Observation Set List View

+------------------------------------------------+
| 🔥 Fire Sightings                              |
+------------------------------------------------+
| [ + ] New Fire Observation Set                 |
+------------------------------------------------+
| ▸ 2025-08-04 Smoke Plume         [3 of 5]      |
| ▸ Backyard Burn                [1 of 5] ⌦       |
+------------------------------------------------+

> Tap a row to go to Compass/Map
> Swipe left to delete a set

---

## 2. Compass View (ADF Style)

+------------------------------------------------+
| < Back       2025-08-04 Smoke Plume      (3/5) |
+------------------------------------------------+
|                                                |
|     [ Rotating Compass Ring w/ Markings ]      |
|                                                |
|                   ↑                            |
|              (fixed arrow)                     |
|                                                |
|      Heading: 127° E • Tilt OK • GPS OK        |
|                                                |
| [ Capture Observation ]                        |
|------------------------------------------------|
| 🟡 Tilt too high! Please hold flat.            |
| 🔴 Compass accuracy low! Try calibrating.      |
+------------------------------------------------+

> Tap “Capture” to save current heading/location as an observation

---

## 3. Map View

+------------------------------------------------+
| < Back        2025-08-04 Smoke Plume (3/5)     |
+------------------------------------------------+
| [ 🗺️ Map ]                                     |
|  ⬤ O1 → → →                                   |
|  ⬤ O2 → → →                                   |
|  ⬤ O3 → → →                                   |
|                                                |
| 🔥 Estimated Source: [Lat, Lng]                |
|------------------------------------------------|
| Ray Length: 25 mi                              |
+------------------------------------------------+

> Rays are drawn from observation points using heading
> Intersection is recalculated live

---

## 4. Observation Detail View

+------------------------------------------------+
| < Back        Observations (3 of 5)            |
+------------------------------------------------+
| O1 - 127° @ 8:12PM - [lat, lng]     [🗑️]       |
| O2 - 102° @ 8:13PM - [lat, lng]     [🗑️]       |
| O3 - 220° @ 8:14PM - [lat, lng]     [🗑️]       |
+------------------------------------------------+

> Tap to see details
> Swipe to delete or tap 🗑️

---

## 5. Settings View

+------------------------------------------------+
| ⚙️ Settings                                    |
+------------------------------------------------+
| 🔧 Ray Length: [──────25 mi──────]            |
| 🌓 Dark Mode: [ Follow System ▸ ]             |
| 📄 Disclaimer: Triangulation is approximate.   |
+------------------------------------------------+

---

## 6. Warning Overlays (in-context)

- 🔴 Compass accuracy is low
- 🟡 Device tilt exceeds ±20°
- 📘 Prompt to calibrate compass
- ⚠️ Triangulation is only an estimate. Not for emergency use.

---

## Notes:
- All views use SwiftUI navigation stacks
- Modals or alerts used for:
  - New set naming
  - Delete confirmation
  - Tilt/accuracy/calibration warnings
