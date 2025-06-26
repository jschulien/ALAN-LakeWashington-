# ALAN-LakeWashington

This repository contains MATLAB scripts used for analyzing artificial light at night (ALAN) across the Lake Washington and Lake Sammamish basins. The scripts process in-situ irradiance data and satellite-based VIIRS Day/Night Band (DNB) radiance to explore spatial and temporal patterns in nighttime light.

---

## 📬 Contact

Jennifer A. Schulien  
[jennifer@schulcon.com](mailto:jennifer@schulcon.com)  
Schulien Consulting

---

## 📁 Scripts Overview

### 1. `import_cops.m`

#### 📌 Description
Processes hyperspectral irradiance profiles collected using a **Compact Optical Profiling System (C-OPS)**. Includes quality control, dark correction, smoothing, interpolation, and calculation of diffuse attenuation coefficients (Kd).

#### 📥 Input
- Multiple `*URC.csv` files exported from the Biospherical Instruments software

#### 📤 Output
- Smoothed, interpolated irradiance (`Ed`) profiles by depth
- Wavelength-specific Kd profiles per station
- Quality control plots for pitch/roll and irradiance consistency

#### ⚙️ Key Functions
- Filters out dark/reference casts
- Removes scans with pitch or roll > ±5°
- Computes dark noise correction
- Applies moving average smoothing
- Interpolates irradiance onto a common depth grid (0.1–40 m)
- Calculates and filters vertical diffuse attenuation coefficients (Kd)

#### 📦 Requirements
- MATLAB R2022a or later
- CSV reading capability

---

### 2. `viirs_dnb_monthly_reader_2014_2023.m`

#### 📌 Description
Loads and subsets monthly VIIRS DNB radiance and cloud-free coverage raster files from 2014–2023. Outputs gridded arrays for time-series analysis of nighttime light in the Pacific Northwest.

#### 📥 Input
- Directory structure containing monthly subfolders (e.g., `202001/`, `202002/`, ...)
  - `*.avg_rade9h.tif` — Monthly average radiance (nW·cm⁻²·sr⁻¹)
  - `*.cf_cvg.tif` — Cloud-free pixel coverage

#### 📤 Output
- `lat_cell`, `lon_cell` — Latitude and longitude vectors per month
- `rad_cell` — Monthly radiance arrays
- `cf_cvg_cell` — Monthly cloud-free pixel masks

#### 🌎 Subset Region of Interest
- **Longitude**: −125° to −116.45°
- **Latitude**: 45.5° to 50°
- Includes Seattle, Puget Sound, Lake Washington, and surrounding watersheds

#### ⚙️ Key Functions
- Iterative batch loading of `.tif` files
- Raster subsetting to defined ROI
- Storage of radiance and coverage arrays in cell format

#### 📦 Requirements
- MATLAB R2022a or later
- Built-in `Tiff` class

---

### 3. `viirs_trend_analysis.m`

#### 📌 Description
Performs statistical trend analysis of nighttime light intensity across 36 ecological ROIs using VIIRS DNB composites. Fits GLMs and other models to summer/fall data (June–September).

#### 📥 Input
- `viirs_subset_2014_2023_sl.mat` — Monthly subsetted VIIRS DNB data
- `SVDNB_202208_75N180W.mat` — August 2022 cloud-free pixel mask
- `SVDNB_202208_75N180W_rad.mat` — August 2022 DNB radiance

#### 📤 Output
- `sum_rad_out` — Summed radiance per ROI/month
- `p_vec`, `s_vec`, `t_vec`, `r2_vec` — GLM stats
- `p_vec_robust`, `s_vec_robust` — Robust regression stats
- `p_vec_mk` — Mann–Kendall p-values
- ROI-specific trend plots (figures)

#### 🗺️ Region of Interest (ROI) Definitions
Covers 36 custom regions:
- Pelagic zones (e.g., Northern, Middle, Southwest Lake Washington)
- Infrastructure (e.g., I-90, SR-520, Boeing-Renton, Ship Canal)
- Urban nearshore (e.g., Kirkland, Mercer Island)
- Natural/tributary zones (e.g., Sammamish Slough)

#### ⚙️ Key Workflow
1. Load monthly VIIRS radiance and cloud coverage
2. Apply polygon masks to extract ROI-specific values
3. Aggregate radiance for summer/fall months
4. Fit trends using:
   - Generalized Linear Models (GLMs)
   - Robust regression
   - Theil–Sen estimator & Mann–Kendall test
5. Plot GLM trends for significant ROIs (`p ≤ 0.05`)

#### 📦 Requirements
- MATLAB R2022a or later
- `m_map` toolbox (for map projections)
- `Mann_Kendall.m` and `TheilSen.m` functions

---

### 4. `match_nightly_viirs.m`

#### 📌 Description
This MATLAB script compares nighttime **in-situ irradiance (C-OPS Ed₀)** to **VIIRS Day/Night Band (DNB)** radiance at coincident spatial locations on Lake Washington. It integrates each C-OPS wavelength channel against the VIIRS spectral response to derive a **spectrally weighted in-situ irradiance**, then compares this with radiance extracted from VIIRS pixels at each C-OPS station. This script produces **Figure 4b–c** in the final publication.

#### 📥 Input
- VIIRS nightly radiance (subset `.mat`)  
- C-OPS nighttime irradiance (`COPS_night_irr_*.mat`)  
- C-OPS sensor response curve (`SpectralResponse_Ed0_SN*.csv`)  
- VIIRS spectral response (`suomi_NPP_onorbit_datathief.csv`)  
- Lake Washington shapefile (`Waterbodies_with_History_and_Jurisdictional_detail_*.shp`)  

#### 📤 Output
- Matched and weighted radiance–irradiance scatter plot  
- `Xvec_norm`: Spectrally weighted in-situ Ed₀  
- `mat_out`: Table of VIIRS/C-OPS matched coordinates and values  
- ROI-based vectors for Figure 4 panels b–c

#### ⚙️ Key Workflow
1. Load VIIRS/DNB radiance for the target night (`viirs_rad_*.mat`)
2. Load in-situ C-OPS nighttime Ed₀ data (`COPS_night_irr_*.mat`)
3. Load and interpolate spectral response curves:
   - C-OPS reference sensor (Ed₀)
   - VIIRS Day/Night Band (DNB)
4. Spectrally weight in-situ Ed₀ data using VIIRS/DNB response
5. Subset VIIRS radiance to Lake Washington using polygon shapefile
6. Extract VIIRS radiance at each in-situ cast location (nearest bin)
7. Assign in-situ stations to predefined ROIs (e.g., Pelagic, Nearshore)
8. Plot spectrally weighted Ed₀ vs. L-VIIRS for matched sites

#### 📦 Requirements
- MATLAB R2022a or later
- `m_map` toolbox (for map projections)
- NASA VIIRS/DNB `.mat` product (from `import_nightly_viirs.m`)

---

## 🧭 Region of Interest Summary

All scripts are focused on the greater Lake Washington and Lake Sammamish watersheds, including urban and pelagic zones, bridges, tributaries, and natural buffers.

