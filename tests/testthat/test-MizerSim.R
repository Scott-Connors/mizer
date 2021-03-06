context("MizerSim constructor dimension checks")
params <- newMultispeciesParams(NS_species_params_gears, inter)

test_that("basic constructor sets dimensions properly",{
    # check dimension against t input arguments
    # Make MizerSims with t_max and t_save
    t_max <- 5
    t_save <- 1
    sim <- MizerSim(params, t_max = t_max, t_save = t_save)
    expect_that(dim(sim@effort)[1], equals(1+ t_max / t_save))
    expect_that(dimnames(sim@effort)[[1]], is_identical_to(as.character(seq(from = 0, to = t_max, by = t_save))))
    expect_true(all(dimnames(sim@effort)[[2]] %in% dimnames(params@selectivity)$gear))
    expect_that(dim(sim@n)[1], equals(1 + (t_max / t_save)))
    expect_that(dimnames(sim@n)[[1]], is_identical_to(dimnames(sim@effort)[[1]]))

    t_max <- 4
    t_save <- 2
    sim <- MizerSim(params, t_max = t_max, t_save = t_save)
    expect_that(dim(sim@effort)[1], equals(1 + t_max / t_save))
    expect_that(dimnames(sim@effort)[[1]], is_identical_to(as.character(seq(from = 0, to = t_max, by = t_save))))
    expect_true(all(dimnames(sim@effort)[[2]] %in% dimnames(params@selectivity)$gear))
    expect_that(dim(sim@n)[1], equals(1 + (t_max / t_save)))
    expect_that(dimnames(sim@n)[[1]], is_identical_to(dimnames(sim@effort)[[1]]))

    # Test for warning if t_save is not integer multiple of dt
    expect_error(MizerSim(params, t_save = 15, dt = 2))

    # Make MizerSim using t_dimnames
    t_dimnames <- seq(from = 1990, to = 2000, by = 1)
    sim <- MizerSim(params, t_dimnames = t_dimnames)
    expect_that(dim(sim@effort)[1], equals(length(t_dimnames)))
    expect_that(dimnames(sim@effort)[[1]], is_identical_to(as.character(t_dimnames)))
    expect_true(all(dimnames(sim@effort)[[2]] %in% dimnames(params@selectivity)$gear))
    expect_that(dim(sim@n)[1], equals(length(t_dimnames)))
    expect_that(dimnames(sim@n)[[1]], is_identical_to(as.character(t_dimnames)))

    # Check error if t_dimnames is not numeric or not sorted
    expect_error(MizerSim(params, t_dimnames = c("x","y","z")))
    expect_error(MizerSim(params, t_dimnames = as.character(1:3)))
    expect_error(MizerSim(params, t_dimnames = 3:1))
})



