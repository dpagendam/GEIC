## GEIC

### Google Earth Image Classification (GEIC)
**Authors**: Dan Pagendam

GEIC is a package for classifying the pixels of a Google Earth aerial photograph into categories/classes such as "Water", "Road", "Grass", "Trees", "Buildings".

The main function of use is called "geic".  To use this function, the user will require data in the form of:

1. A PNG image for the region of interest (on a mac, you can select a region of your Google Earth window to make a PNG screen capture using Cmd-Shift-4).
2. Training data.  This must be in a directory containing a number of folders, each named after different landscape types ("Water", "Road", "Grass" etc), and where each folder contains smaller PNG screen captures of these specific landscape types.

## Package installation

To install the package from GitHub, you will first need to install the devtools package in R using the command:

```install.packages("devtools")```

Once installed, you will need to load the devtools R package and install the GEIC R package using:

```
library(devtools)
install_github("dpagendam/GEIC")
```

## Using this package

To use GEIC with the packaged example data, try:

```
library(GEIC)
packageDataDir = system.file("extdata", package="GEIC")
classified = geic(pathToPNGFile = paste0(packageDataDir, "/Aerial.png"), dirTrain = packageDataDir, neighbourhood = 1, folderNames = c("Road", "Roof", "Grass", "Trees", "Water"))
```

This will take a couple of minutes to run.  Once completed, the classified version of "Aerial.png" will be plotted.  The object named "classified" is a list containing two named items:

1. A raster object (from the R package "raster") containing the classified image.
2. A data frame called "lookupTable" that provides the integer codes for each of the landscape classes.

