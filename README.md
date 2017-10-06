# webapp-template

[![Build Status](https://travis-ci.org/4e6/webapp-template-hs.svg?branch=master)](https://travis-ci.org/4e6/webapp-template-hs)

Template for a web application.

## Build

``` bash
stack build
```

Result in error:

```
ghc: panic! (the 'impossible' happened)
  (GHC version 8.2.1 for x86_64-unknown-linux):
	Simplifier ticks exhausted
  When trying RuleFired Class op $p2HModify
  To increase the limit, use -fsimpl-tick-factor=N (default 100)
  If you need to do this, let GHC HQ know, and what factor you needed
  To see detailed counts use -ddump-simpl-stats
  Total ticks: 256649
  Call stack:
      CallStack (from HasCallStack):
        prettyCurrentCallStack, called at compiler/utils/Outputable.hs:1133:58 in ghc:Outputable
        callStackDoc, called at compiler/utils/Outputable.hs:1137:37 in ghc:Outputable
        pprPanic, called at compiler/simplCore/SimplMonad.hs:199:31 in ghc:SimplMonad

Please report this as a GHC bug:  http://www.haskell.org/ghc/reportabug
```
