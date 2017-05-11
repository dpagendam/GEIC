#' @title Create a vector of integer classes from a vector of character classes.
#' 
#' @description \code{createTrainingSetRGB} creates a vector of integer classes from a vector of character classes.
#' @param \code{classes} a character string of landscape classes (e.g. "Grass", "Trees", "Water", "Road", "Building").
#' @return The function returns a character vector of the same length as \code{classes}, but where each unique string has been replaced by an integer (starting from 1).


classesToIntegers = function(classes)
{
	integerCode = rep(NA, length(classes))
	uniqueVals = unique(classes)
	integerVals = 1:length(uniqueVals)
	for(i in 1:length(uniqueVals))
	{
		ind = which(classes == uniqueVals[i])
		integerCode[ind] = integerVals[i]
	}
	
	return(integerCode)
}