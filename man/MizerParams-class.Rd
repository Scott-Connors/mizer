% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MizerParams-class.R
\docType{class}
\name{MizerParams-class}
\alias{MizerParams-class}
\title{A class to hold the parameters for a size based model.}
\description{
MizerParams objects can be created using a range of constructor functions.
}
\details{
Dynamic simulations are performed using the \code{\link{project}} function on
objects of this class.
}
\section{Slots}{

\describe{
\item{\code{w}}{The size grid for the fish part of the spectrum. An increasing
vector of weights (in grams) running from the smallest egg size to the
largest asymptotic size.}

\item{\code{dw}}{The spacing in the size grid. So dw[i] = w[i+1] - w[i]. A vector 
the same length as the w_full slot. The last entry is not determined by
the w slot but represents the size of the last size bin.}

\item{\code{w_full}}{The size grid for the full size range including the plankton
spectrum. An increasing vector of weights (in grams) running from the
smallest plankton size to the largest asymptotic size of fish. The
last entries of the vector have to be equal to the content of the w slot.}

\item{\code{dw_full}}{The spacing in the full size grid. 
So dw_full[i] = w_full[i+1] - w_full[i]. The last entries have to be
equal to the content of the dw slot.}

\item{\code{w_min_idx}}{A vector holding the index of the weight of the egg size
of each species}

\item{\code{maturity}}{An array (species x size) that holds the proportion of
individuals of each species at size that are mature. This enters in the
calculation of the spawning stock biomass with \code{\link{getSSB}}. Set 
with \code{\link{setReproduction}}.}

\item{\code{psi}}{An array (species x size) that holds the allocation to reproduction
for each species at size, \eqn{\psi_i(w)}. Changed with 
\code{\link{setReproduction}}.}

\item{\code{intake_max}}{An array (species x size) that holds the maximum intake for
each species at size. Changed with \code{\link{setIntakeMax}}.}

\item{\code{search_vol}}{An array (species x size) that holds the search volume for
each species at size. Changed with \code{\link{setSearchVolume}}.}

\item{\code{metab}}{An array (species x size) that holds the metabolism
for each species at size. Changed with \code{\link{setMetab}}.}

\item{\code{mu_b}}{An array (species x size) that holds the background death 
\eqn{\mu_{b.i}(w)}. Changed with \code{\link{setBMort}}.}

\item{\code{pred_kernel}}{An array (species x predator size x prey size) that holds
the predation coefficient of each predator at size on each prey size. If
this is NA then the following two slots will be used. Changed with 
\code{\link{setPredKernel}}.}

\item{\code{ft_pred_kernel_e}}{An array (species x log of predator/prey size ratio)
that holds the Fourier transform of the feeding kernel in a form
appropriate for evaluating the encounter rate integral. If this is NA
then the \code{pred_kernel} will be used to calculate the available 
energy integral. Changed with \code{\link{setPredKernel}}.}

\item{\code{ft_pred_kernel_p}}{An array (species x log of predator/prey size ratio)
that holds the Fourier transform of the feeding kernel in a form
appropriate for evaluating the predation mortality integral. If this is NA
then the \code{pred_kernel} will be used to calculate the integral.
Changed with \code{\link{setPredKernel}}.}

\item{\code{rr_pp}}{A vector the same length as the w_full slot. The size specific
growth rate of the plankton spectrum. Changed with \code{\link{setPlankton}}.}

\item{\code{cc_pp}}{A vector the same length as the w_full slot. The size specific
carrying capacity of the plankton spectrum. Changed with 
\code{\link{setPlankton}}.}

\item{\code{plankton_dynamics}}{Name of the function for projecting the plankton abundance
density by one timestep. The default is 
\code{\link{plankton_semichemostat}}. 
Changed with \code{\link{setPlankton}}.}

\item{\code{other_dynamics}}{A named list of functions for projecting the
values of other dynamical components of the ecosystem that may be modelled
by a mizer extensions you have installed. The names of the list entries
are the names of those components.}

\item{\code{other_encounter}}{A named list of functions for calculating the 
contribution to the encounter rate from each other dynamical component.}

\item{\code{other_mort}}{A named list of functions for calculating the 
contribution to the mortality rate from each other dynamical components.}

\item{\code{other_params}}{A list containing the parameters needed by any mizer
extensions you may have installed to model other dynamical components of
the ecosystem.}

\item{\code{rates_func}}{A string with the name of the function that should be used to
calculate the rates needed by `project()`. By default this will be set to
"getRates" so that the built-in `getRates()` function is used.}

\item{\code{sc}}{The community abundance of the scaling community}

\item{\code{species_params}}{A data.frame to hold the species specific parameters.
See \code{\link{newMultispeciesParams}} for details.}

\item{\code{interaction}}{The species specific interaction matrix, \eqn{\theta_{ij}}.
Changed with \code{\link{setInteraction}}.}

\item{\code{srr}}{String holding the name of the function to calculate the realised
(density dependent) recruitment. The function should have two arguments
which are rdi and species_params.}

\item{\code{selectivity}}{An array (gear x species x w) that holds the selectivity of
each gear for species and size, \eqn{S_{g,i,w}}. Changed with 
\code{\link{setFishing}}.}

\item{\code{catchability}}{An array (gear x species) that holds the catchability of
each species by each gear, \eqn{Q_{g,i}}. Changed with 
\code{\link{setFishing}}.}

\item{\code{initial_effort}}{A vector containing the initial fishing effort for each
gear. Changed with \code{\link{setFishing}}.}

\item{\code{initial_n}}{An array (species x size) that holds the initial abundance of
each species at each weight.}

\item{\code{initial_n_pp}}{A vector the same length as the w_full slot that describes
the initial plankton abundance at each weight.}

\item{\code{initial_n_other}}{A list with the initial abundances of all other
ecosystem components. Has length zero if there are no other components.}

\item{\code{plankton_params}}{Parameters for plankton. See \code{\link{setPlankton}}.}

\item{\code{A}}{Abundance multipliers.}

\item{\code{linecolour}}{A named vector of colour values, named by species.
Used to give consistent colours in plots.}

\item{\code{linetype}}{A named vector of linetypes, named by species. 
Used to give consistent line types in plots.}
}}

\note{
The \linkS4class{MizerParams} class is fairly complex with a large number of
  slots, many of which are multidimensional arrays. The dimensions of these
  arrays is strictly enforced so that \code{MizerParams} objects are
  consistent in terms of number of species and number of size classes.
  
  Although it is possible to build a \code{MizerParams} object by hand it is
  not recommended and several constructors are available.
  
  The \code{MizerParams} class does not hold any dynamic information, e.g.
  abundances or harvest effort through time. These are held in
  \linkS4class{MizerSim} objects.
}
\seealso{
\code{\link{project}} \code{\link{MizerSim}}
  \code{\link{emptyParams}} \code{\link{newMultispeciesParams}}
  \code{\link{newCommunityParams}}
  \code{\link{newTraitParams}}
}
