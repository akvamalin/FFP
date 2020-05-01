# FFP

## Practical tasks
* 1. Basics of Haskell functions in `1_ex.hs` and `basics.hs`.

## Prerequisites

Install `stack` following the instructions [from docs](https://docs.haskellstack.org/en/stable/install_and_upgrade/#macos).
```sh
$ curl -sSL https://get.haskellstack.org/ | sh
```

Install `hlint`
```sh
$ stack install hlint // with the latest GHC
```

Install and compile language server `hie` as specified [here](https://github.com/haskell/haskell-ide-engine#installation-with-nix).
>: Note, in order hie to work properly, the GHC compiler of version `8.6.5` is required.
```bash
$ stack config set resolver ghc-8.6.5 // sets default compiler version
$ stack setup // downloads and sets up the compiler
$ git clone https://github.com/haskell/haskell-ide-engine --recurse-submodules
$ cd haskell-ide-engine
$ stack ./install.hs hie-8.6.5
```

Add `ghc` to the `PATH` so that `hie` has a compiler to use. 
**.bashrc**
```
export PATH=$PATH:$HOME/.stack/programs/x86_64-osx/ghc-8.6.5/bin
```


Configure Visual Studio Code by installing recommended extensions (suggestion pops up on VSCode startup)
```json
{
    "recommendations": [
        "hoovercj.haskell-linter",
        "justusadam.language-haskell",
        "alanz.vscode-hie-server",
        "formulahendry.code-runner",
        "maxgabriel.brittany"
    ]
}
```

* haskell-linter - shows warnings, errors, code improvements.
* language-haskell - Haskell language syntax highlighting.
* vscode-hie-server - Haskell documentation, haskell-linter errors etc.
* code-runner - runs the Haskell scripts directly from VSCode easily.
* britanny - formating code on save.

Add `settings.json` under `.vscode`:
```json
{
    "code-runner.executorMap": {
        "haskell": "stack runghc"
    },
    "haskell.hlint.run": "onType",
    "editor.formatOnSave": true,
}
```

Now opening VSCode palette `Command + Shift + P` and typing "Run code" will execute the scripts. 
