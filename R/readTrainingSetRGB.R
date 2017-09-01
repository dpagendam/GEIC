#' @title Read PNG data from directories to construct training data set.
#' 
#' @description \code{createTrainingSetRGB} reads PNG files from folders in a specified directory, where each folder corresponds to a different landscape feature type (e.g. grass, trees, road, building, water).  These PNG files are used to construct training data for use in the classification of pixels in larger (broader area) PNG images.  PNG files for the training set and broader-area for classification can be easily created by taking screen captures of small areas of a Google Earth image (Cmd-Shift-4 on a mac).
#' @param \code{dir} a character string for the directory in which to look for training sets.  This directory should contain a number of folders with names corresponding to a landscape feature type (e.g. Grass, Trees, Road, Building etc.). Each folder must only contain PNG files and pixels in these PNG files must only correspond to the landscape feature for that folder.
#' @param \code{neighbourhood} is the size of the neighbourhood to use for creating features for each pixel.  A value of 0 corrsponds to using only the RGB values for each pixel; a value of 1 corresponds to using the focal pixel and its 8 adjoining pixels; a value of 2 corresponds to using the focal pixel and its 24 neighbours (8 pixels adjoining the focal pixel and 16 pixels adjoining those).
#' @param \code{folderNames} is an optional character vector containing the names of the folders (corresponding to distinct landscape features) that should be searched for PNG training data.  If this argument is not provided, it is assumed that the directory given by \code{dir} contains no files, only folders and that all of these folders contain PNG files for relevant landscape features.
#' @return The function returns a list with items named "trainingFeatures" and "trainingClasses". The former is a matrix of training features created using the GEIC function \code{png2RGBMatrix} and the latter is a character vector containing the class (from the folder names for the PNG training data) for each row in "trainingFeatures".


createTrainingSetRGB = function(dir, neighbourhood, folderNames = NULL)
{
	require(png)
	if (!requireNamespace("png", quietly = TRUE))
	{
		stop("You need to install the R package png to use this function.", call. = FALSE)
	}
	cat("\n")
	cat("Processing training data ... ")
	
	if(is.null(folderNames))
	{
		folderNames = list.files(dir)
	}
	
	trainingFeatures = matrix(NA, 0, 4*((2*neighbourhood + 1)^2))
	trainingClasses = c()
	for(folder in folderNames)
	{
		s = strsplit(dir, "")[[1]]
		if(s[length(s)] == "/")
		{
			thisDir = paste0(dir, folder)
		}
		else
		{
			thisDir = paste0(dir, "/", folder)
		}
		
		rasterFiles = list.files(thisDir)
		
		for(i in 1:length(rasterFiles))
		{
			thisRaster = png2RGBMatrix(png::readPNG(paste0(thisDir, "/", rasterFiles[i])), neighbourhood)
			trainingFeatures = rbind(trainingFeatures, thisRaster)
			trainingClasses = c(trainingClasses, rep(folder, nrow(thisRaster)))
		}
	}
	cat("Done. \n")
	return(list(trainingFeatures = trainingFeatures, trainingClasses = trainingClasses))
}