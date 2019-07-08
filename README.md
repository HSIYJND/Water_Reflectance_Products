# Water Reflectance Products

The scripts given here originates from the first leg of the EN640 cruise
http://strs.unols.org/Public/diu_project_view.aspx?project_id=105682

The L2s_process.m is the "main file"
It should be sufficiently documented.

When ran the script will prompt the user to select betweeen
batch processing or single file.

For "Single File" select any file that ends with '...L2s.mat'
For "Batch Processing" select a folder with files ending in  '...L2s.mat'

For output plots see plot_results_compact.m and plot_results_png.m
For the output file '*.results' see generate_result_file.m

To adjust paramters, see init section of L2s_process.m


## STRUCTURE OF SCRIPTS
```
L2s_process.m               -> Main script, parameters in the init section 
├── L2s_process_dat.m       -> Reading .dat files
│   └── importfile_dat.m    -> Converting .dat file to MATLAB format 
├── L2s_process_mat.m       -> Reading .mat files
├── L2s_filtering.m         -> Script regarding filtering, re-order steps here
└── generate_result_file.m  -> Save .result file for data of intrest
│   ├── NIR_calculations.m  -> save NIR values of filtered data to .result file
│   ├── OC4_calculations.m  -> OC4 using SeaWiFS on median data to .result file
│   └── QAA_calculations.m  -> QAA output from median data to .result file
│   	└── b_bw_lambda.m     -> LUT for backscattering of pure seawater
├── plot_results_compact.m  -> Save intresting plots as .fig from data
└── plot_results_png.m      -> Save intresting plots as .png from data
```


## Potential TODO'S
- LW is denoted LS in the scripts but prints as LW,
  might be confusing. Should convert completely to LW
- OC4_calculations.m does not account for band response of SeaWiFS
- QAA uses SeaWiFS paramters, but does not account for band response of SeaWiFS
- wavelengths of ES and LS/LW does not align perfectly, 
  should interpolate to compute Rrs all the places Rrs is computed
- Could add tresholding to LS/LW in the filtering
- Could add tresholding to ES in the filtering
- Should investigate slope of absorption coefficient for phtyoplankton pigments


## TEXTUAL DESCRIPTION OF METHODS USED
This section is dedicated to describe how the data processing of the acquired 
spectra and accompnaying meta data was performed wrt. preprocessing. 
The preprocessing  was conducted to retrive the most accurate water-leaving
radiance Lw, solar radiance ES, and in turn above surface remote sensing 
reflectance Rrs. The acquired spectra and accompnaying meta data was filtered in 
3 (TBD) stages. 

The inital filter step aimed to remove all missing values, i.e. if any of the 
sensors did not register a data value at a given timestamp the entire entry was 
removed from further processing. This was done as the it was not desriable to 
use any for of interpolation or similar to estimate the values that could have
been.

The second filter step aimed to remove all values that could be associated with
undesirable or unsuitable viewing angles for the spectral sensors. Thus, if the 
absolute viewing angle exceeded 5.0 degrees (TBD) from nadir pointing, the
entire entry was removed from further processing. This was done to ensure that 
the measured solar radiance and water-leaving were not contaiminated by stray
light or similar.

The third and final (TBD) filter step aimed to get the trending of the 
collected data. Quantiles of the solar radiance and water-leaving radiance for 
each respective spectra was computed, and the cumulative probabilities outside 
the interval [20,80] (TBD) was removed from further processing. Thus, if the 
spectra fell outside the quantiles for the water-leaving radiance, but was 
within the quantiles for the solar radiance or vice versa, the entire entry was 
removed. This was done under the assumption that the previous filter steps 
should only leave the desired spectra and spectra contaminated by the sea
surface state and shadows, and that the extreme values and outliers remaining in 
the spectras were not of intrest.

These steps in the given succession yielded a median spectra for the 
water-leaving radiance, solar radiance, and above surface remote sensing 
reflectance as would be expected under the precieved conditions.

The Quasi-Analytical Algorithm with parameters given in ~Lee2002, and OC4 with 
SeaWiFS coefficients were used to derive biophysical parameters of intrest in 
further processing.


For questions contact:
Sivert Bakken
sivert.bakken@ntnu.no
+47 41 61 45 65
