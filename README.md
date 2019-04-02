# Coupled MCMC in BEAST 2

Nicola F. Müller<sup>1,2</sup> and Remco Bouckaert<sup>3</sup>

<sup>1</sup>ETH Zurich, Department of Biosystems Science and Engineering, 4058 Basel, Switzerland

<sup>2</sup>Swiss Institute of Bioinformatics (SIB), Switzerland

<sup>3</sup>University of Auckland, Auckland, New Zealand



## Abstract
Coupled MCMC has long been used to speed up phylogenetic analyses and to make use of multi-core CPUs. Coupled MCMC uses a number of heated chains with increased acceptance probabilities that are able to traverse unfavourable intermediate states more easily than non heated chains and can be used to propose new states. While more and more complex models are used to study evolution, one of the main software platforms to do so, BEAST 2, was lacking this functionality. Here, we describe an implementation of the coupled MCMC algorithm for the Bayesian phylogenetics platform BEAST 2. This implementation is able to exploit multiple-core CPUs while working with all models and packages in BEAST 2 that affect the likelihood or the priors and not directly the MCMC machinery. We show that the implemented coupled MCMC approach is exploring the same posterior probability space as regular MCMC when MCMC behaves well. We also show our implementation is able to retrieve more consistent estimates of tree distributions on a dataset where convergence with MCMC is problematic.

## Tutorial
A tutorial on how to use coupledMCMC with different BEAST 2 packages can be found here: (https://taming-the-beast.org/tutorials/CoupledMCMC-Tutorial/)[https://taming-the-beast.org/tutorials/CoupledMCMC-Tutorial/]

## License
The content of this project is licensed under the [Creative Commons Attribution 3.0 license](http://creativecommons.org/licenses/by/3.0/us/deed.en_US),
