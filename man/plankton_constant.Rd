% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plankton_dynamics.R
\name{plankton_constant}
\alias{plankton_constant}
\title{Keep plankton abundance constant}
\usage{
plankton_constant(params, n, n_pp, n_other, rates, t, dt, ...)
}
\arguments{
\item{params}{A \link{MizerParams} object}

\item{n}{A matrix of species abundances (species x size)}

\item{n_pp}{A vector of the plankton abundance by size}

\item{n_other}{A list with the abundances of other components}

\item{rates}{A list of rates as returned by \code{\link[=getRates]{getRates()}}}

\item{t}{The current time}

\item{dt}{Time step}

\item{...}{Unused}
}
\value{
Vector containing plankton spectrum at next timestep
}
\description{
This function can be used instead of the standard
\code{\link{plankton_semichemostat}} in order to keep the Plankton
spectrum constant over time.
}
\examples{
\dontrun{
params <- newMultispeciesParams(NS_species_params_gears, inter,
                                plankton_dynamics = "plankton_constant")
}
}
