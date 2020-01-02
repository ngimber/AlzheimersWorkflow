# AlzheimersWorkflow

This ImageJ macro was specifically written to automate the workflow of dapi and plaque segmentation for the paper Eede et al. 2020. 

Input images were 4-channel maximum projections (ch1=Dapi, ch2=Clec7, ch3=4G8, ch4=Iba1).

Nuclei were segmented from blurred DAPI channels (Gaussian blur, sigma = 720 nm) by histogram-based thresholding (Otsu binarization) followed by watershed segmentation of the Euclidean distance map of the binary image using ImageJ. Plaques were segmented from the blurred 4G8 channel (Gaussian blur, sigma = 7,2 µm) followed by Otsu binarization. Only objects above 720 µm² were regarded as plaques.
Cernters of mass and mean intensities for all channels in the region of the segmented region (nucleus and the cytosole above and below) were exported as csv files. Plaque segmentatons were exported as binary images.

