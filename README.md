# j-bob in Racket

The main entry point is `(J-Bob/define initial-defs defs`).
`initial-defs` are taken as axioms. Each def in the second list is checked. If checks are successful the `def-axioms` are extended with `defs`.

If some wrapper is used for j-bob, then some axioms are taken first and then all other definitions are defined and checked.

So, j-bob is an engine that works based on supplied axioms.

## Modules

- `j-bob-lang` - the basic language j-bob is based upon. The language provided following minimalistic constructs:
  - `(atom x)` - returns `'t` if `x` is an atom, `'nil` otherwise.
  - `(car x)` - returns the first element of `x` if `x` is a pair, `'()` otherwise.
  - `(cdr x)` - returns the second element of `x` if `x` is a pair, `'()` nil otherwise.
  - `(equal x y)` - returns `'t` if `x` and `y` are equal, `'nil` otherwise.
  - `(natp x)` - returns `'t ` if `x` is a non-negative number, `'nil` otherwise
  - `(< x y)`
  - `(+ x y)`
  - `(cons a b)`
  - `(defun name args body)`
  - `(dethm name args body)`
  - `(if Q A E)` - `'nil` is falsy, everything else is true
  - `(size x)` - `0` for atoms, ...
- `j-bob` - the engine.
- `little-prover` - examples from the book.

## Testing

The current implementation of `J-Bob/define` is total. If proofs do not pass
the checker, it returns the initial environment. So, the easiest and most robust
way to test is to check that the transformed environment contains all passed
definitions.

Correspondingly, we also need to check that j-bob doesn't accept blindly all
proofs, - the easiest way to check is to mutate a proof and check that it is not
accepted.
