# cees_spack_configs
CEES spack configurations (take 3). Focus on environments only (or mostly), and modular configs.

This constitutes a continued effort to find a way to Git-Support and modularize Spack setups. While knowledge is much improved, success
is arguably limited -- alas. The idea is to be able to easily maintain a list of SW that is then compiled over a suite of compiler, mpi, 
architecture types.

A few points:
- Using environments is key.
- Using an `include:` section can help. For example,
```
  include:
  - $spack/../configs/packages_petsc.yaml
  - $spack/../configs/compilers_sherlock_O2.yaml
``` 

might be useful to build `petsc` environments for multiple architectures or compilers. Unfortunatly -- at least at this time, not all sections
can be satisfied as `include` files.
- Compilers remain a challenge...
- If `providers` are specified, optimal (and functional) choices will likely vary for different compilers.

CONVENTIONS:
- Configuration components indicated with `_inc` in name, eg `packages_inc.yaml`. These files should stand alone for non-environment builds 
(not recommended...) or can be included in an `include:` clause of an environment.
- Environment files may be tagged with `_mod` in the name, to indicate a "modular" envorinment, that uses an `include:` section.

