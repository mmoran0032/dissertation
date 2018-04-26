.. Kings County 2.5 yr peated bourbon (Brooklyn, NY)

Analysis
========

The angular acceptance of St. George can be determined by comparing the
expected yield from the reaction at the desired energies to the actual counts
measured at the detector plane. If we assume a symmetric angular acceptance,
the opening angle of the acceptance cone can be directly calculated and
compared to the anticipated angular acceptance opening angle of 40 mrad. The
angular acceptance and its uncertainty for each energy can be determined
independently of the other points. The angular acceptance is based on the
properties of the target, incident beam, detector, and recoil separator and
the decisions relating to the experiment itself.

All code was written using the scientific Python stack (numpy, scipy,
matplotlib, pandas, pymc3). An analysis framework pyne was developed
concurrently in python to aide in direct analysis of the run information from
the raw data files.


Target Properties
-----------------

A self-supporting *27Al* target was used for the entirety of the experiment.
The target thickness was measured using an offline detector station and a mixed
*241Am*/*148Gd* alpha-particle source. The target thickness was measured by
observing the energy loss of the two alpha peaks as compared to the direct
detection of the alpha particles by the detector. That energy loss is converted
to a target thickness in ug/cm^2 which can be used to determine the energy loss
for other particles at any energy. The measured thickness was 63.8 (+2.0/-1.7)
ug/cm^2.

.. see foil_thickness/target_thickness_20180403.ipynb

Two runs were performed, one without the target in place and one with the
target in place, using an annular Si detector placed within a vacuum chamber.
Each run lasted approximately 600 s and were performed immediately following
each other. The detector was calibrated using the spectrum from the first run
without the target in place, using the known energies of the peaks (see Table
XX). The energy calibration parameters were determined through a combined
Monte Carlo and Bayesian procedure:

#.  New spectra were simulated by sampling a single value for each bin from
    the Poisson distribution n ~ Poisson(lambda), where n is the simulated
    counts in that bin and lambda is the scale parameter for the distribution,
    which is taken to be the detected counts for that bin. A total of 2000
    spectra were generated in this fashion.
#.  The two largest peaks were identified first through a continuous wavelet
    transformation to get an approximate peak center. The final peak center
    was determined by taking a weighted average of the eleven bins centered on
    the selected bin to get the final bin value for the peak center.
#.  A linear regression is fit, using the peaks found from the simulations and
    the known calibration energies of the alpha peaks. By fitting the entire
    sample of peak locations, we determine a global fit for our detector. The
    linear model used is a Bayesian model described by::

        E ~ Normal(mu, sigma)
        u = alpha + beta B
        alpha ~ Normal(28, 10)
        beta ~ Normal(5, 5)
        sigma ~ Lognormal(2, 10)

    The Bayesian model allows for the uncertainty on the fit to be propagated
    forward.

Table XX: Alpha-particle energies for the 241Am/148Gd mixed source::

    148Gd   3182.69     100
    241Am   5388          1.6
            5442.8       13.1
            5485.56      84.8

From the linear model, an energy calibration can be applied to the in-target
run to determine the energy of the two largest peaks. Due to the lower count
rate due to the target being in place, only the largest peaks could be
identified. The procedure to determine the energy loss is similar to that
previously described for the energy calibration:

#.  New spectra based on the spectrum with the target in place were generated
    in the same manner as before. A total of 2000 spectra were generated.
#.  For each spectra, a linear model was sampled from the fitted Bayesian
    linear model and applied to the spectra to convert the bin numbers to
    energy.
#.  The two largest peaks were identified first with a continuous wavelet
    transformation then a weighted average of the counts to find the central
    energy of the peak.
.. the last point here was done, but didn't go into the calculations
#.  The energy of the peaks were subtracted from the known energies of the
    peaks to determine the energy loss through the sample for two known
    input energies. The uncertainty in the sample alpha energies was assumed
    to be negligible and was not considered in the calculations.

This energy loss may be related to the target thickness through the use of the
computer code SRIM. The stopping and range table for alpha particles passing
through *27Al* was generated. A linear spline (i.e. each data point from the
range table connected by a linear fit) was generated for the range, and the
range for each fitted peak energy from the spectra generated from the in-target
run was determined. This range was subtracted from the alpha ranges for the
known calibration energies and multiplied by the density of aluminium to
getthe thickness in ug/cm^2. The uncertainties in the calibration alpha
energies and in the SRIM data were assumed to be negligible and were not
considered during the analysis.

Finally, as each simulated spectra was assumed to be an independent sample, the
two thicknesses determined from the two alpha peaks were averaged to get a
single value for the thickness from each iteration. The thickness distribution
generated in this case was compared against the dsitribution of 4000 samples
(2 dependent thickness measurements for each of the 2000 samples), with the
averaged thickness case exhibiting a slightly narrower distribution. The
averaged thickness samples were used for the remainder of the analysis. The
thickness of 63.8 (+2.0/-1.7) ug/cm^2 is the mean and 95% confidence interval
from this distribution of thickness samples. For subsequent calculations, the
thickness used was sampled from this distribution.

The uncertainties present in each step of the procedure laid out above are
automatically propagated forward due to the methods chosen. The stoichastic
nature of the process allows the influence of the base assumptions of the
underlying data (e.g. the counts in each bin are drawn from a Poisson
distribution) to be seemlessly brought forward without the need of clumbersome
mathematics that can potentially hide wrong assumptions about the values in
question, such as that all of the data is normally distributed.

For most of the following calculations, the number of target nuclei per square
centimeter is used instead of the thickness in ug/cm^2. Our target thickness is
then 1.42 (+0.06/-0.06) x 10^18 nuclei/cm^2. This value is useful for
calculating the energy loss of the proton through the target, as that relies on
the number density of the target and the stopping power of the material. The
energy loss of the beam will be discussed in the next section.


Beam Properties
---------------

The incident proton beam was produced by the 5U and delivered to the St. George
target area. The beam energy and resolution were determined through a series of
accelerator and beamline commissioning experiments performed before this
experiment was performed.

.. Similar experiments showed that the energy resolution
.. of the beam is approximately 300 keV. To be conservative, a value of 500 keV
.. was used for all runs.

The beam energy was determined from the calibration of the 5U analyzing magnet
performed during a different experiment. During the experiment, the magentic
changes were performed slowly such that the magnetic field did not appreciably
drift during the runs. The energy resolution can also be determined from the
calibration runs, where the resolution is given by the energy width of the
leading edge of the resonance scan. Values of approximately 300 eV were
commonly observed, with a conservative value of 500 eV adopted for this
experiment since no direct energy calibration was performed with our specific
experimental setup. The uncertainty in the analyzing magnet field is accounted
for within this uncertainty and is not considered separately.
.. While the uncertainty in the field strength recorded is
.. not completely negligible, it is included within the beam energy resolution
.. and is not considered separately.

The beam current was relatively stable during the experiment. During the longer
runs, the beam current was measured every 15 minutes in order to monitor its
change during the run. For each run, the current uncertainty was determined by
the measured values for cases where multiple current measurements were
performed, or 5%. For all runs, the final current uncertainty was between 5 and
12%. Ideally, an offset Si detector at the target location would be used to
monitor the beam current during the entirety of the run by measuring the
current of the scattered beam particles at a fixed angle. As this setup was not
available for the target chamber, periodic direct measurements of the current
using the Faraday cup at the target location were required to measure the beam
intensity.


Detector Properties
-------------------

A 16-strip Si detector was used to detect the produced alpha particles during
the experiment. A calibration run was performed following the experiment using
the same detector and data acquisition settings as used during the experiment.
A *241Am/148Gd* mixed alpha source was used for calibrating the energy
conversion and energy resolution of each strip separately. All of the strips
were similar with approximately 2 keV/bin for the calibration and approximately
2.75% (90 keV) for the energy resolution.

The calibration run resulted in a single spectrum. Due to the poor energy
resolution of the detector resulting from the lower-than-optimal bias voltage
setting used during the experiment, only the two highest intensity peaks could
be resolved above the background. As the alpha peak resulting from *148Gd* is
closer in energy to the alpha particles produced in the experiment, The alpha
peaks also exhibit long low-energy tails such that the particles produced in
the reaction are smeared out in energy. For the experimental run, an energy
threshold was set to exclude incident proton counts, where counts appearing
above the threshold are considered to be from alpha particles. That threshold
was set by the following::

    E_proton + 3 sigma_beam + 3 sigma_resolution

The detector efficiency was not directly measured and assumed to be 100%.
Efficiency measurements performed during the commissioning work supporting the
St. George detector system resulted in efficiencies above 99% for all strips.

A simulation of the expected energy spectrum at the target location was
performed using SRIM data tables. The simulation looked at the known energy
loss within the target of the incident beam, the expected cross section within
the energy limits of the target, the energy loss of the produced alpha
particles through the remainder of the target, and the energy resolution of the
detector to generate an expected energy spectrum. The procedure for this
simulation is as follows:

#.  An energy deviation drawn from the Normal(0, sigma) distribution (where
    sigma is the beam energy resolution) for 2000 particles. This energy
    deviation is the difference in energy from the central energy.
#.  SRIM files for the central energy were generated for fractional depths
    within the target, where the output is the beam energy profile at that
    target depth.
#.  Using the expected cross section from the AZURE2 R-matrix calculation, a
    depth for each of the simulated particles was generated to determine the
    location within the target that the reaction takes place.
#.  A beam energy E_d is generated from the distribution of beam energies at
    the given depth, and the initial deviation for that particle is added to
    the energy to give the final beam energy.
#.  The beam energy is converted to the produced alpha particle energy through
    the kinematic equation ..math::

        E_alpha = E_target * m_ratio [get actual equation]

#.  The deviation of the alpha particle from a known alpha energy (used to
    generate SRIM files at various depths) was recorded.
#.  An alpha energy was generated for each particle based on the remainder of
    the target that it needs to travel through from the final energy
    distribution generated for particles traveling through that thickness.
#.  The energy deviation is added back to the alpha particle's energy to give
    its final energy.

This procedure generates an alpha-particle energy spectrum following the target
location given the known parameters about the target thickness and the cross
section, and incorporates the known energy resolution of the incident alpha
beam and the stoichastic nature of the energy loss and reaction within the
target. Finally, using the known energy resolution of the detector, a final
energy spectrum can be generated by drawing new alpha particle energies from
the distribution::

    E_alpha,detector ~ Normal(E_alpha,sigma_detector)

An example of the output of this procedure is given in [FIGURE], where the
agreement between the location and width of the alpha peak can be seen in the
normalized spectra. Note that the low energy tailing of the detected particles
is not modeled in our simulated spectrum, as we don't know the full
characteristics for the detector response.


Additional Parameters
---------------------

Additional inputs into the final calculation of the acceptance of St. George
are the cross section determined from an R-matrix fit on several low-lying
resonances, the stopping power of protons in aluminium from SRIM, the run time,
and the counts at the detector. For those parameters that are derived from
external programs (AZURE2 and SRIM), the uncertainty is assumed to be
negligible. The uncertainty in the time was assumed to be 10 seconds for those
runs that only lasted for a single 15-minute span, and higher for those runs
that required the periodic measurement of the beam current which resulted in
stopping the incident beam for an unspecified duration of time.

The counts at each detector were the sum of all events above the threshold
defined by the beam energy and detector resolution. The counts are Poisson
distributed, with the length of time for the run was such that the uncertainty
from the counts at the detector was not above 5%, with most runs having a count
uncertainty of a much lower value. The direct uncertainty of the counts at the
detector is partially convolved with the run time; a lower counting uncertainty
requires a longer run time and potentially a larger time uncertainty.

The direct beam reduction by St. George must be on the order of 10^10-10^14 in
order to avoid damaging the Si detector and to measure lower value regions of
the cross section. This requirement is within the designed capabilities of St.
George when tuned for heavy recoil transmission to the final detector plane,
but must be verified experimentally due to the altered tune and different
detector plane required for this experiment. During the experiment, count rates
at the detector were monitored, and potential counts from the direct proton
beam were excluded from the final counts with the energy discriminator
previously described.

.. newsroom.fb.com -- why and how FB follows people not logged in/no accounts
.. web plugin: disconnect -- block 3rd party trackers


Final Acceptance Measurements
-----------------------------

The acceptance of St. George can be found for each energy value by comparing
the detected counts to the expected yield for that incident beam energy. The
yield is found from::

    Y(E) = N_r / N_b,

where N_r is the number of reaction products produced and N_b is the number
of incident beam particles. We can determine N_b from the beam current and
the total run time. The value for N_r is determined by the total counts at
the detector (for the experimental yield) or the integration of target and
cross section properties following::

    Y(E) = \int sigma/epsilon (look up equation in Iliadis)

In both cases, the detector efficiency and St. George transport efficiency
are 100%, as previously discussed.

The acceptance in mrad is given by::

    theta = arccos(1 - 2 * Y_experiment / Y_theory)

The angular acceptance can be calculated in this way for each run individually,
as shown in {FIGURE] and [TABLE]. The process for calculating the uncertainty
bounds is given by the following, repeated 2000 times to have enough confidence
in the final values:

#.  The beam energy, beam current, and time are sampled from a normal
    distribution N(mu,sigma), where mu and sigma are for the value (energy,
    current, or time) in question.
#.  The incident number of particles is calculated from the current and time.
#.  The target thickness in energy is calculated from finding the stopping
    power at the incident beam energy from the SRIM tables, and sampling from
    the distribution of target thicknesses in terms of atoms / cm^2.
#.  The yield is determined by integrating [EQUATION] between the entrance
    energy and the lower energy given by that entrance energy minus the target
    thickness.
#.  The experimental yield is drawn from a poisson distribution Poisson(c),
    where c is the number of counts detected.
#.  The acceptance for the iteration is caluclated by [EQUATION].

The distribution of values generated by the process above can be used to find
the acceptance and confidence intervals for the run in question. Each run has
an acceptance described by its distribution, which is the run for that
particular setting of St. George.

.. Things to do: generate tables for held variables for all runs
.. generate table for the finasl uncertainties/acceptances
