% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MizerParams-class.R
\name{setParams}
\alias{setParams}
\title{Set or change any model parameters}
\usage{
setParams(
  params,
  rr_pp = NULL,
  cc_pp = NULL,
  r_pp = params@plankton_params[["r_pp"]],
  kappa = params@plankton_params[["kappa"]],
  lambda = params@plankton_params[["lambda"]],
  n = params@plankton_params[["n"]],
  w_pp_cutoff = params@plankton_params[["w_pp_cutoff"]],
  plankton_dynamics = NULL,
  interaction = NULL,
  pred_kernel = NULL,
  search_vol = NULL,
  intake_max = NULL,
  metab = NULL,
  mu_b = NULL,
  z0pre = 0.6,
  z0exp = n - 1,
  maturity = NULL,
  repro_prop = NULL,
  srr = params@srr,
  initial_effort = NULL
)
}
\arguments{
\item{params}{A \linkS4class{MizerParams} object}

\item{rr_pp}{Optional. Vector of plankton intrinsic growth rates}

\item{cc_pp}{Optional. Vector of plankton intrinsic carrying capacity}

\item{r_pp}{Coefficient of the intrinsic growth rate}

\item{kappa}{Coefficient of the intrinsic carrying capacity}

\item{lambda}{Scaling exponent of the intrinsic carrying capacity}

\item{n}{Scaling exponent of the intrinsic growth rate}

\item{w_pp_cutoff}{The upper cut off size of the plankton spectrum. 
Default is 10 g.}

\item{plankton_dynamics}{Function that determines plankton dynamics by
calculating the plankton spectrum at the next time step from the current
state.}

\item{interaction}{Interaction matrix of the species (predator by prey).
Entries should be numbers between 0 and 1. See "Setting interactions"
section below.}

\item{pred_kernel}{Optional. An array (species x predator size x prey size)
that holds the predation coefficient of each predator at size on each prey
size. If not supplied, a default is set as described in section "Setting
predation kernel".}

\item{search_vol}{Optional. An array (species x size) holding the search volume
for each species at size. If not supplied, a default is set as described in
the section "Setting search volume".}

\item{intake_max}{Optional. An array (species x size) holding the maximum
intake rate for each species at size. If not supplied, a default is set as
described in the section "Setting maximum intake rate".}

\item{metab}{Optional. An array (species x size) holding the metabolic rate
for each species at size. If not supplied, a default is set as described in
the section "Setting metabolic rate".}

\item{mu_b}{Optional. An array (species x size) holding the background
mortality rate.}

\item{z0pre}{If \code{z0}, the mortality from other sources, is not a column
in the species data frame, it is calculated as z0pre * w_inf ^ z0exp.
Default value is 0.6.}

\item{z0exp}{If \code{z0}, the mortality from other sources, is not a column
in the species data frame, it is calculated as \code{z0pre * w_inf ^ z0exp}.
Default value is \code{n-1}.}

\item{maturity}{Optional. An array (species x size) that holds the proportion
of individuals of each species at size that are mature. If not supplied, a
default is set as described in the section "Setting reproduction".}

\item{repro_prop}{Optional. An array (species x size) that holds the
proportion of consumed energy that a mature individual allocates to
reproduction for each species at size. If not supplied, a default is set as
described in the section "Setting reproduction".}

\item{srr}{The name of the stock recruitment function. Defaults to 
\code{\link{srrBevertonHolt}}.}

\item{initial_effort}{Optional. A number or a named numeric vector specifying
the fishing effort. If a number, the same effort is used for all gears. If
a vector, must be named by gear.}
}
\value{
A \linkS4class{MizerParams} object
}
\description{
This is a convenient wrapper function calling each of the following
functions
\itemize{
\item \code{\link{setPredKernel}}
\item \code{\link{setSearchVolume}}
\item \code{\link{setInteraction}}
\item \code{\link{setIntakeMax}}
\item \code{\link{setMetab}}
\item \code{\link{setBMort}}
\item \code{\link{setReproduction}}
\item \code{\link{setFishing}}
\item \code{\link{setPlankton}}
}
See the Details section below for a discussion of how to use this function.
}
\details{
Usually, if you are happy with the way mizer calculates its model functions
from the species parameters and only want to change the values of some
species parameters, you would make those changes in the \code{species_params} data
frame contained in the \code{params} object and then call the \code{setParams()}
function to effect the change. Note that just changing the species parameters
by themselves is not changing the model until you call \code{setParams()} or the
appropriate one of its sub-functions. Here is an example which assumes that
you have have a MizerParams object \code{params} in which you just want to change
one parameter of the third species:\preformatted{params@species_params$gamma[3] <- 1000
params <- setParams(params)
}

Because of the way the R language works, \code{setParams} does not make the
changes to the \code{params} object that you pass to it but instead returns a new
params object. So to affect the change you call the function in the form
\code{params <- setParams(params, ...)}.

If you are not happy with the assumptions that mizer makes by default about
the shape of the model functions, for example if you want to change one of
the allometric scaling assumptions, you can do this by providing your
choice as an array in the appropriate argument to \code{setParams()}. The
sections below discuss all the model functions that you can change this way.

This function will use the species parameters in the \code{params} object to reset
the values of all the model functions that you do not specify explicitly when
calling this function, unless you have protected the corresponding slots with
a comment. If you have changed any of the model functions in the
\code{params} object previously and now want to make changes to a different slot,
you will want to call the appropriate change function individually. So in the
above example you would have used \code{params <- setSearchVolume(params)}
instead of \code{params <- setParams(params)}.

If you have added a comment to a slot of the params object, then setParams()
and its subfunctions will not recalculate the value for that slot from the
species parameters. For example after\preformatted{comment(params@search_vol) <- "This should not change"
params@species_params$gamma <- 10
params <- setParams(params)
}

will just issue a warning "The search volume has been commented and therefore
will not be recalculated from the species parameters". You can remove the
comment, and therefore allow recalculation of the slot, with
\code{comment(params@search_vol) <- NULL}.
}
\section{Units in mizer}{

Mizer uses grams to measure weight, centimetres to measure lengths, and
years to measure time.

Mizer is agnostic about whether abundances are given as
\enumerate{
\item numbers per area,
\item numbers per volume or
\item total numbers for the entire study area.
}

You should make the choice most convenient for your application and then
stick with it. If you make choice 1 or 2 you will also have to choose a unit
for area or volume. Your choice will then determine the units for some of
the parameters. This will be mentioned when the parameters are discussed in
the sections below.

You choice will also affect the units of the quantities you may want to
calculate with the model. For example, the yield will be in grams/year/m^2 in
case 1 if you choose m^2 as your measure of area, in grams/year/m^3 in case 2
if you choose m^3 as your unit of volume, or simply grams/year in case 3. The
same comment applies for other measures, like total biomass, which will be
grams/area in case 1, grams/volume in case 2 or simply grams in case 3. When
mizer puts units on axes, for example in \code{plotBiomass}, it will simply
put grams, as appropriate for case 3.

You can convert between these choices. For example, if you use case 1, you
need to multiply with the area of the ecosystem to get the total quantity.
If you work with case 2, you need to multiply by both area and the thickness
of the productive layer. In that respect, case 2 is a bit cumbersome.
}

\section{Setting interactions}{


The species interaction matrix \eqn{\theta_{ij}}, is used when calculating the
food encounter rate in \code{\link{getEncounter}} and the predation mortality rate in
\code{\link{getPredMort}}. Its entries are dimensionless numbers between
0 and 1 that characterise the strength at which predator species \eqn{i}
predates on prey species \eqn{j}. 

This function checks that the supplied interaction
matrix is valid and then stores it in the \code{interaction} slot of the
params object before returning that object.

The order of the columns and rows of the \code{interaction} argument should be the 
same as the order in the species params dataframe in the \code{params} object.
If you supply a named array then the function will check the order and warn 
if it is different.

The interaction of the species with the plankton are set via a column
\code{interaction_p} in the \code{species_params} data frame. Again the entries
have to be numbers between 0 and 1. By default this column is set to all
1s.
}

\section{Setting predation kernel}{

\strong{Kernel dependent on predator to prey size ratio}

If the \code{pred_kernel} argument is not supplied, then this function sets a
predation kernel that depends only on the ratio of predator mass to prey
mass, not on the two masses independently. The shape of that kernel is then
determined by the \code{pred_kernel_type} column in species_params.

The default pred_kernel_type is "lognormal". This will call the function
\code{\link{lognormal_pred_kernel}} to calculate the predation kernel.
An alternative pred_kernel type is "box", implemented by the functions
\code{\link{box_pred_kernel}}. These functions require certain species
parameters in the species_params data frame. For the lognormal kernel these
are \code{beta} and \code{sigma}, for the box kernel they are
\code{ppmr_min} and \code{ppmr_max}. They are explained in the help pages
for the kernel functions. No defaults are set for these parameters. If they
are missing from the species_params data frame then mizer will issue an
error message.

You can use any other string as the type. If for example you choose "my" then
you need to define a function \code{my_pred_kernel} that you can model on the
existing functions like \code{\link{lognormal_pred_kernel}}.

When using a kernel that depends on the predator/prey size ratio only, mizer
does not need to store the entire three dimensional array in the MizerParams
object. Such an array can be very big when there is a large number of size
bins. Instead, mizer only needs to store two two-dimensional arrays that hold
Fourier transforms of the feeding kernel function that allow the encounter
rate and the predation rate to be calculated very efficiently. However, if
you need the full three-dimensional array you can calculate it with the
\code{\link{getPredKernel}} function.

\strong{Kernel dependent on both predator and prey size}

If you want to work with a feeding kernel that depends on predator mass and
prey mass independently, you can specify the full feeding kernel as a
three-dimensional array (predator species x predator size x prey size).
The dimensions are thus (no_sp, no_w, no_w_full). 

You should use this option only if a kernel dependent only on the
predator/prey mass ratio is not appropriate. Using a kernel dependent on
predator/prey mass ratio only allows mizer to use fast Fourier transform
methods to significantly reduce the running time of simulations.

The order of the predator species in \code{pred_kernel} should be the same
as the order in the species params dataframe in the `params` object. If you
supply a named array then the function will check the order and warn if it is
different.
}

\section{Setting search volume}{

The search volume \eqn{\gamma_i(w)} of an individual of species \eqn{i}
and weight \eqn{w} multiplies the predation kernel when
calculating the encounter rate in \code{\link{getEncounter}} and the 
predation rate in \code{\link{getPredRate}}.

The name "search volume" is a bit misleading, because \eqn{\gamma_i(w)} does
not have units of volume. It is simply a parameter that determines the rate
of predation. Its units depend on your choice, see section "Units in mizer".
If you have chose to work with total abundances, then it is a rate with units
1/year. If you have chosen to work with abundances per m^2 then it has units
of m^2/year. If you have chosen to work with abundances per m^3 then it has
units of m^3/year.

If the \code{search_vol} argument is not supplied, then the search volume is 
set to
\deqn{\gamma_i(w) = \gamma_i w^q_i.} 
The values of \eqn{\gamma_i} (the search volume at 1g) and \eqn{q_i} (the
allometric exponent of the search volume) are taken from the \code{gamma} and
\code{q} columns in the species parameter dataframe. If the \code{gamma}
column is not supplied in the species parameter dataframe, a default is
calculated by the \code{\link{get_gamma_default}} function. Note that only
for predators of size \eqn{w = 1} gram is the value of the species parameter
\eqn{\gamma_i} the same as the value of the search volume \eqn{\gamma_i(w)}.
}

\section{Setting maximum intake rate}{

The maximum intake rate \eqn{h_i(w)} of an individual of species \eqn{i} and
weight \eqn{w} determines the feeding level, calculated with
\code{\link{getFeedingLevel}}. It is measured in grams/year.

If the \code{intake_max} argument is not supplied, then the maximum intake
rate is set to \deqn{h_i(w) = h_i w^n_i.} 
The values of \eqn{h_i} (the maximum intake rate of an individual of size 1
gram) and \eqn{n_i} (the allometric exponent for the intake rate) are taken
from the \code{h} and \code{n} columns in the species parameter dataframe. If
the \code{h} column is not supplied in the species parameter dataframe, it is
calculated by the \code{\link{get_h_default}} function, using \code{f0} and
the \code{k_vb} column, if they are supplied.

If \eqn{h_i} is set to \code{Inf}, fish will consume all encountered food.
}

\section{Setting metabolic rate}{

The metabolic rate is subtracted from the energy income rate to calculate
the rate at which energy is available for growth and reproduction, see
\code{\link{getEReproAndGrowth}}. It is measured in grams/year.

If the \code{metab} argument is not supplied, then for each species the
metabolic rate \eqn{k(w)} for an individual of size \eqn{w} is set to
\deqn{k(w) = ks w^p + k w,}
where \eqn{ks w^p} represents the rate of standard metabolism and \eqn{k w}
is the rate at which energy is expended on activity and movement. The values
of \eqn{ks}, \eqn{p} and \eqn{k} are taken from the \code{ks}, \code{p} and
\code{k} columns in the species parameter dataframe. If any of these
parameters are not supplied, the defaults are \eqn{k = 0}, \eqn{p = n} and
\deqn{ks = f_c h \alpha w_{mat}^{n-p},}{ks = f_c * h * alpha * w_mat^(n - p),}
where \eqn{f_c} is the critical feeding level taken from the \code{fc} column
in the species parameter data frame. If the critical feeding level is not
specified, a default of \eqn{f_c = 0.2} is used.
}

\section{Setting background mortality rate}{

The background mortality is all the mortality that is not due to either
predation or fishing. It is a rate with units 1/year.

The \code{mu_b} argument allows you to specify a background mortality rate
that depends on species and body size. You can see an example of this in
the Examples section of the help page for \code{\link{setBMort}}.

If the \code{mu_b} argument is not supplied, then the background mortality
is assumed to depend only on the asymptotic size of the species, not on the
size of the individual: \eqn{\mu_{b.i}(w) = z_{0.i}}. The value of the
constant \eqn{z_0} for each species is taken from the \code{z0} column of the
species_params data frame, if that column exists. Otherwise it is calculated
as 
\deqn{z_{0.i} = {\tt z0pre}_i\, w_{inf}^{\tt z0exp}.}{z_{0.i} = z0pre_i w_{inf}^{z0exp}.}
}

\section{Setting reproduction}{


\subsection{Investment}{
For each species and at each size, the proportion of the available energy 
that is invested into reproduction is the product of two factors: the
proportion \code{maturity} of individuals that are mature and the proportion
\code{repro_prop} of the energy available to a mature individual that is 
invested into reproduction.

If the \code{maturity} argument is not supplied, then it is set to a sigmoidal 
maturity ogive that changes from 0 to 1 at around the maturity size:
\deqn{{\tt maturity}(w) = \left[1+\left(\frac{w}{w_{mat}}\right)^{-U}\right]^{-1}.}{
  maturity(w) = [1+(w/w_mat)^(-U)]^(-1)}
(To avoid clutter, we are not showing the species index in the equations.)
The maturity weights are taken from the \code{w_mat} column of the 
species_params data frame. Any missing maturity weights are set to 1/4 of the
asymptotic weight in the \code{w_inf} column.
The exponent \eqn{U} determines the steepness of the maturity ogive. By
default it is chosen as \eqn{U = 10}, however this can be overridden by
including a column \code{w_mat25} in the species parameter dataframe that
specifies the weight at which 25\% of individuals are mature, which sets
\eqn{U = \log(3) / \log(w_{mat} / w_{25}).}{U = log(3) / log(w_mat / w_25).}

The sigmoidal function given above would strictly reach 1 only asymptotically.
Mizer instead sets the function equal to 1 already at the species' 
maximum size, taken from the compulsory \code{w_inf} column in the
\code{species_params} data frame.

If the \code{repro_prop} argument is not supplied, it is set to the
allometric form
\deqn{{\tt repro\_prop}(w) = \left(\frac{w}{w_{inf}}\right)^{m-n}.}{
  repro_prop = (w/w_inf)^(m - n).}
Here \eqn{n} is the scaling exponent of the energy income rate. Hence
the exponent \eqn{m} determines the scaling of the investment into
reproduction for mature individuals. By default it is chosen to be 
\eqn{m = 1} so that the rate at which energy is invested into reproduction 
scales linearly with the size. This default can be overridden by including a 
column \code{m} in the species parameter dataframe. The asymptotic sizes
are taken from the compulsory \code{w_inf} column in the species_params
data frame.
}

\subsection{Efficiency}{
The reproductive efficiency, i.e., the proportion of energy allocated to
reproduction that results in egg biomass, is set from the \code{erepro}
column in the species_params data frame. If that is not provided, the default
is set to 1 (which you will want to override). The offspring biomass divided
by the egg biomass gives the rate of egg production, returned by
\code{\link{getRDI}}.
}

\subsection{Density dependence}{
The stock-recruitment relationship is an emergent phenomenon in mizer, with
several sources of density dependence. Firstly, the amount of energy invested
into reproduction depends on the energy income of the spawners, which is
density-dependent due to competition for prey. Secondly, the proportion of
larvae that grow up to recruitment size depends on the larval mortality,
which depends on the density of predators, and on larval growth rate, which
depends on density of prey.

Finally, the proportion of eggs that are viable and hatch to larvae can be
density dependent. Somewhat misleadingly, mizer refers to this relationship
between the number of eggs and the number of hatched larvae as the
stock-recruitment relationship, even though it is only one part of the full
stock-recruitment relationship. However it is the only part that can be set
independently, while the other parts are already determined by the predation
parameters and other model parameters. Thus in practice this part of the
density dependence is used to encode all the density dependence that is not
already included in the other two sources of density dependence.

To calculate the density-dependent rate of larvae production, mizer puts the
the density-independent rate of egg production through a "stock-recruitment"
function. The result is returned by \code{\link{getRDD}}. The name of the
stock-recruitment function is specified by the \code{srr} argument. The
default is the Beverton-Holt function \code{\link{srrBevertonHolt}}, which
requires an \code{R_max} column in the species_params data frame giving the
maximum egg production rate. If this column does not exist, it is initialised
to \code{Inf}, leading to no density-dependence. Other functions provided by
mizer are \code{\link{srrRicker}} and \code{\link{srrSheperd}} and you can
easily use these as models for writing your own functions.
}
}

\section{Setting fishing}{


\strong{Gears}

In \code{mizer}, fishing mortality is imposed on species by fishing gears. The
total fishing mortality is obtained by summing over the mortality from all
gears,
\deqn{\mu_{f.i}(w) = \sum_g F_{g,i}(w),}
where the fishing mortality \eqn{F_{g,i}(w)} imposed by gear \eqn{g} on
species \eqn{i} at size \eqn{w} is calculated as:
\deqn{F_{g,i}(w) = S_{g,i}(w) Q_{g,i} E_{g},}
where \eqn{S} is the selectivity by species, gear and size, \eqn{Q} is the
catchability by species and gear and \eqn{E} is the fishing effort by gear.

At the moment a species can only be selected by one fishing gear, although
each gear can select more than one species (this is a limitation with the
current package that will be developed in future releases). The gear
selecting each species can be specified in the \code{gear} column in the
species_params data frame. If no gear is specified, the default gear is
"knife_edge_gear".

\strong{Selectivity}

The selectivity at size of each gear has a range between 0 (not selected at
that size) to 1 (fully selected at that size). It is given by a selectivity
function. The name of the selectivity function is given by the \code{sel_func}
column in the species parameters data frame. Some selectivity functions are
included in the package: \code{knife_edge()}, \code{sigmoid_length()},
\code{double_sigmoid_length()}, and \code{sigmoid_weight()}. New functions can be defined
by the user. Each
gear has the same selectivity function for all the species it selects, but
the parameter values for each species may be different, e.g. the lengths of
species that a gear selects may be different.

Each selectivity function has a range of parameters. Values for these
parameters must be included as columns in the species parameters data.frame.
The names of the columns must exactly match the names of the corresponding
arguments of the selectivity function. For example, the default selectivity
function is \code{knife_edge()} which has sudden change of selectivity from 0 to 1
at a certain size. In its help page you can see that the \code{knife_edge()}
function has arguments \code{w} and \code{knife_edge_size} The first argument, \code{w}, is
size (the function calculates selectivity at size). All selectivity functions
must have \code{w} as the first argument. The values for the other arguments must
be found in the species parameters data.frame. So for the \code{knife_edge()}
function there should be a \code{knife_edge_size} column. Because \code{knife_edge()}
is the default selectivity function, the \code{knife_edge_size} argument has a
default value = \code{w_mat}.

\strong{Catchability}

Catchability is used as an additional scalar to make the link between gear
selectivity, fishing effort and fishing mortality. For example, it can be set
so that an effort of 1 gives a desired fishing mortality.
In this way effort can then be specified relative to a 'base effort', e.g.
the effort in a particular year.

Because currently mizer only allows one gear to select each species, the
catchability matrix \eqn{Q_{g,i}} reduces to a catchability vector
\eqn{Q_{i}}, and this is given as a column \code{catchability} in the species
parameter data frame. If it is not specified, it defaults to 1.

\strong{Effort}

The initial fishing effort is stored in the \code{MizerParams} object. If it is
not supplied, it is set to zero. The initial effort can be overruled when
the simulation is run with \code{project()}, where it is also possible to specify
an effort that varies through time.
}

\section{Setting plankton dynamics}{

By default, mizer uses a semichemostat model to describe the plankton
dynamics in each size class independently. This semichemostat dynamics is implemented
by the function \code{\link{plankton_semichemostat}}. You can change the
plankton dynamics by writing your own function, modelled on
\code{\link{plankton_semichemostat}}, and then passing the name of your
function in the \code{plankton_dynamics} argument.

The \code{rr_pp} argument is a vector specifying the intrinsic plankton
growth rate for each size class. If it is not supplied, then the intrinsic growth
rate \eqn{r_p(w)} at size \eqn{w}
is set to \deqn{r_p(w) = r_p\, w^{n-1}.}{r_p(w) = r_p w^{n-1}}
The values of \eqn{r_p} and \eqn{n} are taken from the \code{r_pp}
and \code{n} arguments.

The \code{cc_pp} argument is a vector specifying the intrinsic plankton
carrying capacity for each size class. If it is not supplied, then the intrinsic carrying
capacity \eqn{c_p(w)} at size \eqn{w}
is set to \deqn{c_p(w) = \kappa\, w^{-\lambda}}{c_p(w) = \kappa w^{-\lambda}}
for all \eqn{w} less than \code{w_pp_cutoff} and zero for larger sizes.
The values of \eqn{\kappa} and \eqn{\lambda} are taken from the \code{kappa}
and \code{lambda} arguments.
}

\examples{
\dontrun{
params <- newTraitParams()
params@species_params$gamma[3] <- 1000
params <- setParams(params)
}
}
\seealso{
Other functions for setting parameters: 
\code{\link{setBMort}()},
\code{\link{setFishing}()},
\code{\link{setInitial}()},
\code{\link{setIntakeMax}()},
\code{\link{setInteraction}()},
\code{\link{setMetab}()},
\code{\link{setPlankton}()},
\code{\link{setPredKernel}()},
\code{\link{setReproduction}()},
\code{\link{setSearchVolume}()}
}
\concept{functions for setting parameters}
