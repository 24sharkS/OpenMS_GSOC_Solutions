# load the necessary libraries and setting system path for python.
library(reticulate)
library(ggplot2)
use_python("/usr/local/python3")

# import pyOpenms
ropenms = import("pyopenms",convert = F)

# Downloading mzML file from proteosuite. 
download.file("http://www.proteosuite.org/datasets/D-001-iTRAQ-4plex-AB/ksl_1_100re.mzML","ksl.mzML")
file <- "ksl.mzML"

# loading and reading mzML file
mz = ropenms$MzMLFile()
exp = ropenms$MSExperiment()
mz$load(file,exp)

# Extracting all MS2 spectrum.
spectra <- py_to_r(exp$getSpectra())
ms2 = sapply(spectra, function(x) x$getMSLevel()==2)

# The total number of MS2 spectrums.
length(spectra[ms2])

# Extracting the peak details(m/z and Intensity) of a spectrum.Here I have considered the 25th spectrum.
ms2_p = spectra[ms2][[25]]$get_peaks()

# Creating a data frame having details of m/z and intensity values.
ms2_spectrum = data.frame( do.call("cbind", ms2_p))
colnames(ms2_spectrum) = c("M/Z","Intensity")

# Visualising the mass spectrum.
ggplot(ms2_spectrum,aes(x=`M/Z`,y=Intensity)) + geom_segment(aes(x=`M/Z`,xend=`M/Z`,y=0,yend=Intensity)) + theme_minimal()
