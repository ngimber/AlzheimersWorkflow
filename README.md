# ImageJ Macro for DAPI and Plaque Segmentation

This ImageJ macro automates the workflow for DAPI and plaque segmentation as described in the following papers:

- **Version 1.0.0:** Eede et al., 2020. [https://doi.org/10.15252/embr.201948530](https://doi.org/10.15252/embr.201948530)  
- **Version 2.0.0:** Geesdorf et al., 2025 

---

## Requirements

- **Radial Profile Function:** From Eede et al., 2020: [https://github.com/ngimber/RadialProfile2D](https://github.com/ngimber/RadialProfile2D)  
- **StarDist for ImageJ:** Schmidt et al., 2018: [Stardist](https://imagej.net/plugins/stardist)

---

## Workflow Details

### Version 2.0.0

- **Input Format:**
  - **4-channel maximum projections (TIF format):**
    
  - **ch1:** DAPI  
  - **ch2:** 4G8  
  - **ch3:** Clec7  
  - **ch4:** Iba1
    
**DAPI Signal Processing:**  
1. **De-noising:** Frequency filtering in Fourier space to remove structures larger than 2.6 µm.  
2. **Blurring:** Gaussian blur applied with sigma = 520 nm.  
3. **Nuclei Segmentation:** Used StarDist ('versatile fluorescent nuclei model') for nuclei segmentation.  
4. **Separation of Merged Nuclei:** Watershed segmentation of the Euclidean distance map on binary images to separate nuclei.  

**Plaque Segmentation:**  
1. **De-noising:** Frequency filtering to remove structures larger than 26 µm.  
2. **Background Subtraction:** Rolling ball method (radius = 52 µm).  
3. **Binarization:** Applied Otsu thresholding.  
4. **Plaque Identification:** Objects larger than 130 µm² were classified as plaques.  
     
---

### Version 1.0.0

- **Input Format:**
  - **4-channel maximum projections (TIF format):** 

  - **ch1:** DAPI  
  - **ch2:** Clec7
  - **ch3:** 4G8   
  - **ch4:** Iba1  
  
**DAPI Signal Processing:**  
1. **Blurring:** Gaussian blur applied with sigma = 720 nm.  
2. **Nuclei Segmentation:** Otsu binarization for thresholding, followed by watershed segmentation on the Euclidean distance map.  

**Plaque Segmentation:**  
1. **Blurring:** Gaussian blur applied with sigma = 7.2 µm.  
2. **Binarization:** Applied Otsu thresholding.  
3. **Plaque Identification:** Objects larger than 720 µm² were classified as plaques.  

---

## Data Export
- Exported nuclei centers of mass and mean intensities for all channels and objects (nucleus and cytosol) as CSV.  
- Plaque segmentations exported as binary images.

---

## Release Notes

- **Release 1:** Initial workflow for DAPI and plaque segmentation.  
- **Release 2:** Enhanced segmentation accuracy by using StarDist for nuclei segmentation.


---

**For further details, please refer to the methods sections of the papers indicated above.**

