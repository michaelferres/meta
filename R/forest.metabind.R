#' Forest plot to display the result of a meta-analysis
#' 
#' @description
#' Draws a forest plot in the active graphics window (using grid
#' graphics system).
#' 
#' @aliases forest.metabind
#' 
#' @param x An object of class \code{\link{metabind}}.
#' @param leftcols A character vector specifying (additional) columns
#'   to be plotted on the left side of the forest plot or a logical
#'   value (see Details).
#' @param leftlabs A character vector specifying labels for
#'   (additional) columns on left side of the forest plot (see
#'   Details).
#' @param rightcols A character vector specifying (additional) columns
#'   to be plotted on the right side of the forest plot or a logical
#'   value (see Details).
#' @param rightlabs A character vector specifying labels for
#'   (additional) columns on right side of the forest plot (see
#'   Details).
#' @param overall A logical indicating whether overall summaries
#'   should be plotted. This argument is useful in a meta-analysis
#'   with subgroups if summaries should only be plotted on group
#'   level.
#' @param subgroup A logical indicating whether subgroup results
#'   should be shown in forest plot. This argument is useful in a
#'   meta-analysis with subgroups if summaries should not be plotted
#'   on group level.
#' @param hetstat Either a logical value indicating whether to print
#'   results for heterogeneity measures at all or a character string
#'   (see Details).
#' @param overall.hetstat A logical value indicating whether to print
#'   heterogeneity measures for overall treatment comparisons. This
#'   argument is useful in a meta-analysis with subgroups if
#'   heterogeneity statistics should only be printed on subgroup
#'   level.
#' @param lab.NA A character string to label missing values.
#' @param digits Minimal number of significant digits for treatment
#'   effects, see \code{print.default}.
#' @param digits.se Minimal number of significant digits for standard
#'   errors, see \code{print.default}.
#' @param digits.zval Minimal number of significant digits for z- or
#'   t-statistic for test of overall effect, see \code{print.default}.
#' @param digits.pval Minimal number of significant digits for p-value
#'   of overall treatment effect, see \code{print.default}.
#' @param digits.pval.Q Minimal number of significant digits for
#'   p-value of heterogeneity test, see \code{print.default}.
#' @param digits.Q Minimal number of significant digits for
#'   heterogeneity statistic Q, see \code{print.default}.
#' @param digits.tau2 Minimal number of significant digits for
#'   between-study variance, see \code{print.default}.
#' @param digits.tau Minimal number of significant digits for square
#'   root of between-study variance, see \code{print.default}.
#' @param digits.I2 Minimal number of significant digits for I-squared
#'   statistic, see \code{print.default}.
#' @param scientific.pval A logical specifying whether p-values should
#'   be printed in scientific notation, e.g., 1.2345e-01 instead of
#'   0.12345.
#' @param big.mark A character used as thousands separator.
#' @param smlab A label for the summary measurex (printed at top of
#'   figure).
#' @param calcwidth.pooled A logical indicating whether text for fixed
#'   effect and random effects model should be considered to calculate
#'   width of the column with study labels.
#' @param \dots Additional graphical arguments (passed on to
#'   \code{\link{forest.meta}}).
#' 
#' @details
#' A forest plot, also called confidence interval plot, is drawn in
#' the active graphics window. The forest functions in R package
#' \bold{meta} are based on the grid graphics system. In order to
#' print the forest plot, resize the graphics window and either use
#' \code{\link{dev.copy2eps}} or \code{\link{dev.copy2pdf}}. Another
#' possibility is to create a file using \code{\link{pdf}},
#' \code{\link{png}}, or \code{\link{svg}} and to specify the width
#' and height of the graphic (see \code{\link{forest.meta}} examples).
#' 
#' The arguments \code{leftcols} and \code{rightcols} can be used to
#' specify columns which are plotted on the left and right side of the
#' forest plot, respectively.
#' 
#' The arguments \code{leftlabs} and \code{rightlabs} can be used to
#' specify column headings which are plotted on left and right side of
#' the forest plot, respectively. For certain columns predefined
#' labels exist. For other columns, the column name will be used as a
#' label. It is possible to only provide labels for new columns (see
#' \code{\link{forest.meta}} examples). Otherwise the length of
#' \code{leftlabs} and \code{rightlabs} must be the same as the number
#' of printed columns, respectively. The value \code{NA} can be used
#' to specify columns which should use default labels.
#' 
#' Argument \code{hetstat} can be a character string to specify where
#' to print heterogeneity information:
#' \itemize{
#' \item row with results for fixed effect model (\code{hetstat =
#' "fixed"}),
#' \item row with results for random effects model (\code{hetstat =
#' "random"}),
#' \item rows with 'study' information (\code{hetstat = "study"}).
#' }
#' Otherwise, information on heterogeneity is printed in dedicated rows.
#' 
#' @author Guido Schwarzer \email{sc@@imbi.uni-freiburg.de}
#' 
#' @seealso \code{\link{forest.meta}}, \code{\link{metabin}},
#'   \code{\link{metacont}}, \code{\link{metagen}},
#'   \code{\link{metabind}}, \code{\link{settings.meta}}
#' 
#' @keywords hplot
#' 
#' @examples
#' data(Fleiss1993cont)
#' 
#' # Add some (fictitious) grouping variables:
#' #
#' Fleiss1993cont$age <- c(55, 65, 55, 65, 55)
#' Fleiss1993cont$region <- c("Europe", "Europe", "Asia", "Asia", "Europe")
#' 
#' m1 <- metacont(n.psyc, mean.psyc, sd.psyc, n.cont, mean.cont, sd.cont,
#'                data = Fleiss1993cont, sm = "MD")
#'
#' # Conduct two subgroup analyses
#' #
#' mu1 <- update(m1, byvar = age, bylab = "Age group")
#' mu2 <- update(m1, byvar = region, bylab = "Region")
#'
#' # Combine subgroup meta-analyses and show forest plot with subgroup
#' # results
#' #
#' mb1 <- metabind(mu1, mu2)
#' mb1
#' forest(mb1)
#'
#' @method forest metabind
#' @export
#' @export forest.metabind


forest.metabind <- function(x,
                            leftcols,
                            leftlabs,
                            rightcols = c("effect", "ci"),
                            rightlabs,
                            ##
                            overall = FALSE,
                            subgroup = FALSE,
                            hetstat = if (any(x$is.subgroup)) FALSE else "study",
                            overall.hetstat = FALSE,
                            ##
                            lab.NA = "",
                            ##
                            digits = gs("digits.forest"),
                            digits.se = gs("digits.se"),
                            digits.zval = gs("digits.zval"),
                            digits.pval = max(gs("digits.pval") - 2, 2),
                            digits.pval.Q = max(gs("digits.pval.Q") - 2, 2),
                            digits.Q = gs("digits.Q"),
                            digits.tau2 = gs("digits.tau2"),
                            digits.tau = gs("digits.tau"),
                            digits.I2 = max(gs("digits.I2") - 1, 0),
                            ##
                            scientific.pval = gs("scientific.pval"),
                            big.mark = gs("big.mark"),
                            ##
                            smlab,
                            calcwidth.pooled = overall,
                            ...) {
  
  
  ##
  ##
  ## (1) Check and set arguments
  ##
  ##
  chkclass(x, "metabind")
  ##
  chklogical(overall)
  chklogical(subgroup)
  chklogical(overall.hetstat)
  ##
  chkchar(lab.NA)
  ##
  chknumeric(digits, min = 0, length = 1)
  chknumeric(digits.se, min = 0, length = 1)
  chknumeric(digits.zval, min = 0, length = 1)
  chknumeric(digits.pval, min = 1, length = 1)
  chknumeric(digits.pval.Q, min = 1, length = 1)
  chknumeric(digits.Q, min = 0, length = 1)
  chknumeric(digits.tau2, min = 0, length = 1)
  chknumeric(digits.tau, min = 0, length = 1)
  chknumeric(digits.I2, min = 0, length = 1)
  ##
  chklogical(scientific.pval)
  chklogical(calcwidth.pooled)
  ##
  addargs <- names(list(...))
  ##
  idx <- charmatch(tolower(addargs), "hetstat", nomatch = NA)
  if (!is.na(idx) && length(idx) > 0)
    if (list(...)[["hetstat"]])
      stop("Argument 'hetstat' must be FALSE for metabind objects.")
  ##
  idx <- charmatch(tolower(addargs), "comb.fixed", nomatch = NA)
  if (!is.na(idx) && length(idx) > 0)
    stop("Argument 'comb.fixed' cannot be used with metabind objects.")
  ##
  idx <- charmatch(tolower(addargs), "comb.random", nomatch = NA)
  if (!is.na(idx) && length(idx) > 0)
    stop("Argument 'comb.random' cannot be used with metabind objects.")
  
  x$k.w.orig <- x$k.w
  
  x$k.w <- x$k.all.w <- as.vector(table(x$data$name)[unique(x$data$name)])
  
  
  missing.leftcols <- missing(leftcols)
  ##
  if (missing.leftcols) {
    leftcols <- c("studlab", "k")
    if (any(x$is.subgroup))
      leftcols <- c(leftcols, "pval.Q.b")
  }
  ##
  if (!is.logical(rightcols)) {
    if ("pval.Q.b" %in% rightcols & "pval.Q.b" %in% leftcols)
      leftcols <- leftcols[leftcols != "pval.Q.b"]
    ##
    if ("k" %in% rightcols & "k" %in% leftcols)
      leftcols <- leftcols[leftcols != "k"]
  }
  ##
  label.studlab <- ifelse(any(x$is.subgroup), "Subgroup", "Meta-Analysis")
  ##
  if (missing(leftlabs)) {
    leftlabs <- rep(NA, length(leftcols))
    leftlabs[leftcols == "studlab"] <- label.studlab
    leftlabs[leftcols == "k"] <- "Number of\nStudies"
    leftlabs[leftcols == "Q.b"] <- "Q.b"
    leftlabs[leftcols == "tau2"] <- "Between-study\nvariance"
    leftlabs[leftcols == "tau"] <- "Between-study\nSD"
    leftlabs[leftcols == "pval.Q.b"] <- "Interaction\nP-value"
    leftlabs[leftcols == "I2"] <- "I2"
  }
  ##
  if (missing(rightlabs)) {
    rightlabs <- rep(NA, length(rightcols))
    rightlabs[rightcols == "studlab"] <- label.studlab
    rightlabs[rightcols == "k"] <- "Number of\nStudies"
    rightlabs[rightcols == "Q.b"] <- "Q.b"
    rightlabs[rightcols == "tau2"] <- "Between-study\nvariance"
    rightlabs[rightcols == "tau"] <- "Between-study\nSD"
    rightlabs[rightcols == "pval.Q.b"] <- "Interaction\nP-value"
    rightlabs[rightcols == "I2"] <- "I2"
  }


  ##
  ## Set test for interaction
  ##
  if (any(x$is.subgroup)) {
    if (x$comb.fixed) {
      x$data$Q.b <- x$data$Q.b.fixed
      x$data$pval.Q.b <- x$data$pval.Q.b.fixed
    }
    else {
      x$data$Q.b <- x$data$Q.b.random
      x$data$pval.Q.b <- x$data$pval.Q.b.random
    }
  }
  
  
  ##
  ## Round and round ...
  ##
  if (any(x$is.subgroup)) {
    x$data$Q.b <- round(x$data$Q.b, digits.Q)
    x$data$pval.Q.b <- formatPT(x$data$pval.Q.b,
                                lab = FALSE,
                                digits = digits.pval.Q,
                                scientific = scientific.pval,
                                lab.NA = lab.NA)
    x$data$pval.Q.b <- rmSpace(x$data$pval.Q.b)
  }
  ##
  x$data$tau2 <- formatPT(x$data$tau2, digits = digits.tau2,
                          big.mark = big.mark,
                          lab = FALSE, lab.NA = lab.NA)
  ##
  x$data$tau <- formatPT(x$data$tau, digits = digits.tau,
                         big.mark = big.mark,
                         lab = FALSE, lab.NA = lab.NA)
  ##
  I2.na <- is.na(x$data$I2)
  x$data$I2 <- formatN(round(100 * x$data$I2, digits.I2),
                       digits.I2, "")
  x$data$lower.I2 <- formatN(round(100 * x$data$lower.I2,
                                   digits.I2),
                             digits.I2, "")
  x$data$upper.I2 <- formatN(round(100 * x$data$upper.I2,
                                   digits.I2),
                             digits.I2, "")
  ##
  x$data$I2 <- paste0(x$data$I2, ifelse(I2.na, "", "%"))
  x$data$lower.I2 <- paste0(x$data$lower.I2, ifelse(I2.na, "", "%"))
  x$data$upper.I2 <- paste0(x$data$upper.I2, ifelse(I2.na, "", "%"))
  ##
  x$data$tau2 <- rmSpace(x$data$tau2)
  x$data$tau <- rmSpace(x$data$tau)
  ##
  x$data$I2 <- rmSpace(x$data$I2)
  x$data$lower.I2 <- rmSpace(x$data$lower.I2)
  x$data$upper.I2 <- rmSpace(x$data$upper.I2)
  ##
  x$data$k <- as.character(x$data$k)
  
  
  if (missing(smlab))
    smlab <- paste0(if (x$comb.fixed)
                      "Fixed Effect Model"
                    else
                      "Random Effects Model",
                    if (x$sm != "")
                      paste0("\n(", xlab(x$sm, x$backtransf), ")"))
  
  
  class(x) <- c("meta", "is.metabind")
  
  
  forest(x,
         leftcols = leftcols, leftlabs = leftlabs,
         rightcols = rightcols, rightlabs = rightlabs,
         overall = overall, subgroup = subgroup,
         hetstat = hetstat, overall.hetstat = overall.hetstat,
         calcwidth.pooled = calcwidth.pooled,
         lab.NA = lab.NA, smlab = smlab,
         ##
         digits = digits,
         digits.se = digits.se,
         digits.zval = digits.zval,
         digits.pval = digits.pval,
         digits.pval.Q = digits.pval.Q,
         digits.Q = digits.Q,
         digits.tau2 = digits.tau2,
         digits.tau = digits.tau,
         digits.I2 = digits.I2,
         ##
         scientific.pval = scientific.pval,
         big.mark = big.mark,
         ...)
  
  
  invisible(NULL)
}
