# ALAN-LakeWashington-
Descriptions for all Matlab programs are described below. 

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
  - 
