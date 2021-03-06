#' Cochrane review: Summary of meta-analyses
#' 
#' @description
#' Calculate and print a summary of all meta-analyses in a Cochrane
#' review.
#' 
#' @param object An object of class \code{rm5}.
#' @param x An object of class \code{summary.rm5}.
#' @param comp.no Comparison number.
#' @param outcome.no Outcome number.
#' @param ... Additional arguments (passed on to \code{metacr}).
#' 
#' @details
#' This function can be used to redo all or selected meta-analyses of
#' a Cochrane Review.
#' 
#' Review Manager 5 (RevMan 5) is the current software used for
#' preparing and maintaining Cochrane Reviews
#' (\url{http://community.cochrane.org/tools/review-production-tools/revman-5}).
#' In RevMan 5, subgroup analyses can be defined and data from a
#' Cochrane review can be imported to R using the function
#' \code{read.rm5}.
#' 
#' The R function \code{\link{metacr}} is called internally.
#' 
#' @author Guido Schwarzer \email{sc@@imbi.uni-freiburg.de}
#' 
#' @seealso \code{\link{summary.meta}}, \code{\link{metacr}},
#'   \code{\link{read.rm5}}, \code{\link{metabias.rm5}}
#' 
#' @references
#' Higgins, J.P.T and S. Green (2011):
#' \emph{Cochrane Handbook for Systematic Reviews of Interventions
#'   Version 5.1.0 [Updated March 2011]}.
#' The Cochrane Library: http://www.cochrane-handbook.org
#' 
#' @examples
#' # Locate export data file "Fleiss1993_CR.csv"
#' # in sub-directory of package "meta"
#' #
#' filename <- system.file("extdata", "Fleiss1993_CR.csv", package = "meta")
#' Fleiss1993_CR <- read.rm5(filename)
#' 
#' # Print summary results for all meta-analysis
#' #
#' summary(Fleiss1993_CR)
#' 
#' # Print summary results only for second outcome of first comparison
#' #
#' summary(Fleiss1993_CR, comp.no = 1, outcome.no = 2)
#' 
#' @rdname summary.rm5
#' @export
#' @export summary.rm5


summary.rm5 <- function(object, comp.no, outcome.no, ...) {
  
  
  ##
  ##
  ## (1) Check for rm5 object
  ##
  ##
  chkclass(object, "rm5")
  
  
  if (missing(comp.no))
    comp.no <- unique(object$comp.no)
  ##
  res <- list()
  ##
  n <- 1
  ##
  for (i in comp.no) {
    if (missing(outcome.no))
      jj <- unique(object$outcome.no[object$comp.no == i])
    else
      jj <- outcome.no
    for (j in jj) {
      ##
      res[[n]] <- summary(metacr(object, i, j, ...))
      ##
      n <- n + 1
      ##
    }
  }
  ##
  class(res) <- "summary.rm5"
  
  
  res
}





#' @rdname summary.rm5
#' @method print summary.rm5
#' @export
#' @export print.summary.rm5


print.summary.rm5 <- function(x, ...) {
  
  ##
  ##
  ## (1) Check for summary.rm5 object
  ##
  ##
  chkclass(x, "summary.rm5")
  
  
  n <- 1
  for (i in 1:length(x)) {
    if (n > 1)
      cat("\n*****\n\n")
    print(x[[i]])
    n <- n + 1
  }
  
  
  invisible(NULL)
}
