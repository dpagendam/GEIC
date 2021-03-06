% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/png2RGBMatrix.R
\name{png2RGBMatrix}
\alias{png2RGBMatrix}
\title{Create a matrix of feature variables from a Portable Network Graphic (PNG) file.}
\usage{
png2RGBMatrix(pngObject, neighbourhood = 1)
}
\arguments{
\item{\code{pngObject}}{is a PNG object as returned by the function \code{readPNG} in the \code{png} R package.}

\item{\code{neighbourhood}}{is the size of the neighbourhood to use for creating features for each pixel.  A value of 0 corrsponds to using only the RGB values for each pixel; a value of 1 corresponds to using the focal pixel and its 8 adjoining pixels; a value of 2 corresponds to using the focal pixel and its 24 neighbours (8 pixels adjoining the focal pixel and 16 pixels adjoining those).}
}
\value{
a matrix whose rows correspond to pixels and whose columns give the red, green and blue intensities for the pixel and nearby pixels.  This matrix can be used as a matrix of predictors in classifying each pixel as belonging to a certain type of landscape feature.
}
\description{
\code{png2RGBMatrix} creates a matrix of feaure variables (columns) from pixels in a PNG file.  Each row in the resulting matrix corresponds to a pixel in the original PNG file.  The feature variables consist of the red, green and blue intensities for each pixel and its local neighbourhood.
}
