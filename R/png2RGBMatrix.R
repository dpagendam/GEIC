#' @title Create a matrix of feature variables from a Portable Network Graphic (PNG) file.
#' 
#' @description \code{png2RGBMatrix} creates a matrix of feaure variables (columns) from pixels in a PNG file.  Each row in the resulting matrix corresponds to a pixel in the original PNG file.  The feature variables consist of the red, green and blue intensities for each pixel and its local neighbourhood.  
#' @param \code{pngObject} is a PNG object as returned by the function \code{readPNG} in the \code{png} R package.
#' @param \code{neighbourhood} is the size of the neighbourhood to use for creating features for each pixel.  A value of 0 corrsponds to using only the RGB values for each pixel; a value of 1 corresponds to using the focal pixel and its 8 adjoining pixels; a value of 2 corresponds to using the focal pixel and its 24 neighbours (8 pixels adjoining the focal pixel and 16 pixels adjoining those).
#' @return a matrix whose rows correspond to pixels and whose columns give the red, green and blue intensities for the pixel and nearby pixels.  This matrix can be used as a matrix of predictors in classifying each pixel as belonging to a certain type of landscape feature.


png2RGBMatrix = function(pngObject, neighbourhood = 1)
{
	require(png)
	if (!requireNamespace("png", quietly = TRUE))
	{
		stop("You need to install the R package png to use this function.", call. = FALSE)
	}
	dimPNG = dim(pngObject)
	RGB = matrix(NA, dimPNG[1]*dimPNG[2], 4*((2*neighbourhood + 1)^2))
	counter = 1
	for(i in 1:dimPNG[1])
	{
		for(j in 1:dimPNG[2])
		{
			neighbourCounter = 0
			for(k in -neighbourhood:neighbourhood)
			{
				for(l in -neighbourhood:neighbourhood)
				{
					rowInd = i + k
					colInd = j + l
					featureInds = neighbourCounter + 1:4
					if(rowInd >= 1 & rowInd <= dimPNG[1] & colInd >= 1 & colInd <= dimPNG[2])
					{
						RGB[counter, featureInds] = pngObject[rowInd, colInd, ]
					}
					else
					{
						RGB[counter, featureInds] = pngObject[i, j, ]
					}
					neighbourCounter = neighbourCounter + 4
				}
			}
			counter = counter + 1
		}
	}
	return(RGB)
}
