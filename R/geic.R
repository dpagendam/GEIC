#' @title Classify a Google Earth PNG image.
#' 
#' @description \code{createTrainingSetRGB} reads PNG files from folders in a specified directory, where each folder corresponds to a different landscape feature type (e.g. grass, trees, road, building, water).  These PNG files are used to construct training data for use in the classification of pixels in larger (broader area) PNG images.  PNG files for the training set and broader-area for classification can be easily created by taking screen captures of small areas of a Google Earth image (Cmd-Shift-4 on a mac).
#' @param \code{pathToPNGFile} a character string giving the path to the PNG file to perform classification on.
#' @param \code{dirTrain} a character string for the directory in which to look for training sets.  This directory should contain a number of folders with names corresponding to a landscape feature type (e.g. Grass, Trees, Road, Building etc.). Each folder must only contain PNG files and pixels in these PNG files must only correspond to the landscape feature for that folder.
#' @param \code{neighbourhood} is the size of the neighbourhood to use for creating features for each pixel.  A value of 0 corrsponds to using only the RGB values for each pixel; a value of 1 corresponds to using the focal pixel and its 8 adjoining pixels; a value of 2 corresponds to using the focal pixel and its 24 neighbours (8 pixels adjoining the focal pixel and 16 pixels adjoining those).
#' @param \code{folderNames} is an optional character vector containing the names of the folders (corresponding to distinct landscape features) that should be searched for PNG training data.  If this argument is not provided, it is assumed that the directory given by \code{dir} contains no files, only folders and that all of these folders contain PNG files for relevant landscape features.
#' @return The function returns a list with items named "trainingFeatures" and "trainingClasses". The former is a matrix of training features created using the GEIC function \code{png2RGBMatrix} and the latter is a character vector containing the class (from the folder names for the PNG training data) for each row in "trainingFeatures".
#' @examples 
#' packageDataDir = system.file("extdata", package="GEIC")
#' classified = geic(pathToPNGFile = paste0(packageDataDir, "/Aerial.png"), dirTrain = packageDataDir, neighbourhood = 1, folderNames = c("Road", "Roof", "Grass", "Trees", "Water"))
#' @export


geic = function(pathToPNGFile, dirTrain, neighbourhood, folderNames = NULL)
{
	require(ranger)
	require(png)
	require(raster)
	
	# You need the suggested package for this function    
	if (!requireNamespace("ranger", quietly = TRUE))
	{
		stop("You need to install the R package ranger to use this function.", call. = FALSE)
	}
	if (!requireNamespace("png", quietly = TRUE))
	{
		stop("You need to install the R package png to use this function.", call. = FALSE)
	}
	if (!requireNamespace("raster", quietly = TRUE))
	{
		stop("You need to install the R package raster to use this function.", call. = FALSE)
	}
	
	aerial = png::readPNG(pathToPNGFile)
	X2 = png2RGBMatrix(aerial, neighbourhood = neighbourhood)
	
	trainingData = createTrainingSetRGB(dirTrain, neighbourhood, folderNames = folderNames)
	X = as.data.frame(trainingData$trainingFeatures)
	X = cbind(trainingData$trainingClasses, X)
	colnames(X)[1] <- "class"
	rf = ranger::ranger(class ~ ., data = X)
	
	colnames(X2) <- colnames(X)[-1]
	classes = predict(rf, X2)$predictions
	integerClasses = classesToIntegers(classes)
	r = raster::raster(matrix(integerClasses, dim(aerial)[1], dim(aerial)[2], byrow = TRUE))
	plot(r)
	integerVals = unique(sort(integerClasses))
	classVals = c()
	for(i in 1:length(integerVals))
	{
		thisClass = classes[which(integerClasses == integerVals[i])[1]]
		classVals = c(classVals, as.character(thisClass))
	}
	df = data.frame(integer = integerVals, class = classVals)
	return = list(integerClassRaster = r, lookupTable = df)
}


