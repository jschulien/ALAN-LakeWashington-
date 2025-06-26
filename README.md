# ALAN-LakeWashington-
Descriptions for all Matlab programs are described below. 

## 📬 Contact
Jennifer A. Schulien
[jennifer@schulcon.com](mailto:jennifer@schulcon.com)  
Schulien Consulting

## For import_cops.m
# C-OPS Irradiance Processing and Kd Calculation
This script processes hyperspectral irradiance profiles collected using a **Compact Optical Profiling System (C-OPS)**. It performs quality control, corrects for instrument dark noise, and calculates diffuse attenuation coefficients (Kd) by wavelength and depth.

## 📂 Script Summary

### Main Functions:
- **Import C-OPS `.csv` files**: Parses multiple `*URC.csv` files exported from the Biospherical Instruments software.
- **Quality Control**:
  - Filters out dark casts by cast number.
  - Visualizes pitch and roll histograms for reference and in-water sensors.
  - Removes scans where pitch or roll exceed ±5°.
- **Dark Correction**:
  - Computes mean dark profile.
  - Subtracts dark noise from in-water data.
- **Smoothing**:
  - Applies a 50-sample moving average to all corrected irradiance data.
- **Averaging & Interpolation**:
  - Groups replicate casts by station.
  - Interpolates irradiance onto a common depth grid (0.1–40 m).
- **Kd Calculation**:
  - Calculates vertical diffuse attenuation coefficient (Kd) from smoothed, interpolated Edz profiles.
  - Filters out non-physical values (Kd > 2 or Kd ≤ 0).
 
## 📦 Requirements

- MATLAB R2022a or later
- TIFF reading capability (built-in `Tiff` class)

## For viirs_dnb_monthly_reader_2014_2023.m
# VIIRS DNB Monthly Reader (2014–2023)
This MATLAB script loads, subsets, and stores monthly VIIRS Day/Night Band (DNB) radiance composites for the Pacific Northwest from **2014 to 2023**. It is designed for time-series analysis of nighttime light across multiple years and months.

## 📄 Script Summary  

### 🛠️ Main Functions:
- Iteratively loads monthly `.tif` files from 2014 to 2023.
- Parses:
  - `*.avg_rade9h.tif`: DNB radiance values
  - `*.cf_cvg.tif`: Cloud-free pixel coverage masks
- Subsets each raster to a fixed region of interest:
  - **Latitude**: 45.5° to 50°
  - **Longitude**: −125° to −116.45°
- Stores each month’s radiance and pixel coverage values in cell arrays.

### ⚠️ Notes on Data Coverage:
- The **stray-light corrected DNB product** is not available for 2012–2013, so this script excludes those years.


## 🗂️ Directory Structure

The input directory (`/data/VIIRS/VIIRS_2014_2023`) is expected to contain subfolders named after each monthly composite (e.g., `202001`, `202002`, etc.), each with:
- `*.avg_rade9h.tif` — Monthly average radiance
- `*.cf_cvg.tif` — Cloud-free pixel coverage

## 📊 Output

At the end of the script, the following variables are available in the workspace:

- `lat_cell`, `lon_cell` — Vectors of latitude/longitude for each month
- `rad_cell` — Monthly VIIRS DNB radiance arrays
- `cf_cvg_cell` — Monthly cloud-free pixel coverage arrays

Each cell in the arrays corresponds to one monthly composite.

## 💾 Input Details

- **Spatial resolution**: ~500 m (15 arc-second grid)
- **Units**: Radiance in nW·cm⁻²·sr⁻¹

 ## 🧭 Region of Interest

Subset window:
- **Longitude**: −125° to −116.45°
- **Latitude**: 45.5° to 50°

This area includes **Seattle, Puget Sound, Lake Washington**, and adjacent watersheds.

## 📦 Requirements

- MATLAB R2022a or later
- TIFF reading capability (built-in `Tiff` class)
