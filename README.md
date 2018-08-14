# PureScript for Working Stiffs

This is a workshop introduction to the PureScript language.

The goal of this workshop is to get attendees started with practical web app development using PureScript. The focus is on application of PureScript concepts over theoretical understanding.

## Pre-requisites
No prior PureScript knowledge is required. Familiarity with JavaScript, JavaScript tooling, and functional programming is helpful.

## Outline

This workshop has a series of exercises building up to creating a Hacker News Reader app. The first four exercises are a sequence of TDD-style exercises designed to illustrate various aspects of the PureScript language and ecosystem. The fifth exercise builds on a small web application built using the Pux UI library.

Each exercise is preceded by a short presentation of related PureScript language concepts and the project setup and is followed by a presentation of the solution.

1. Introduction
1. Exercises
    1. [Exercise #1: Types, functions, and Hacker News](./exercise1/README.md)
    1. [Exercise #2: ADTs, sorting, and filtering](./exercise2/README.md)
    1. [Exercise #3: Time and the Foreign Function Interface (FFI)](./exercise3/README.md)
    1. [Exercise #4: The network is calling for monads](./exercise4/README.md)
    1. [Exercise #5: Pux web application](./exercise5/README.md)
1. Conclusion & discussion

The presentation slides can be viewed [here](https://reaktor.github.io/purescript-workshop). The source code for the slides is [in the slides directory](./slides). Solutions for all exercises are contained in the [solutions](./solutions) directory.

## Getting started

### Clone this repository

Clone this repository and cd into the first exercise directory (`exercise1/`):

```
git clone https://github.com/reaktor/purescript-workshop
cd purescript-workshop/exercise1
```

### Install dependencies

Install the npm/Node version listed in .nvmrc. Newer versions of Node will also probably work. If you are using nvm, you can install it with
```
nvm install
```

Install Node and psc-package dependencies, including PureScript itself and PureScript build tools:

```
npm install
```

### Set up your editor

Editor support is not strictly necessary but is quite useful for tools like syntax highlighting, in-line compiler errors, and automatic imports.

For the Atom editor, you can set it up as follows:

- [Download and install Atom](https://atom.io/)
- Install the packages ide-purescript and language-purescript (under Edit -> Preferences -> Install)
- In Edit -> Preferences -> Packages -> ide-purescript -> Settings:
  - Make sure the option "Use npm bin directory" is checked.
  - Make sure the option "Add psc-package sources" is checked.
- Select File -> Add Project Folder and select the directory cloned from this repository.
- Open exercise1/test/Exercise1.purs, add a syntax error, and verify that the syntax error is underlined in red in your editor. If it is not, the IDE server may not have been started. Restarting Atom may help.

There is also support for Vim, Emacs, and other editors. [See the instructions here](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md), but you are on your own for the other editors.

### Start the exercises

Verify your setup is working by running the build command for the first exercise:

```
cd exercise1
npm start
```

You should see the PureScript compiler run and then the results of a failing test.

Now head over to the [Exercise1 README](./exercise1/README.md) to get started on the first exercise.

## Helpful Resources

* [The PureScript Book](https://leanpub.com/purescript/read)
* [Pursuit](https://pursuit.purescript.org/)
  * PureScript language and library API documentation
* [Pux library documentation](http://purescript-pux.org/docs/architecture/)
  * Pux is the UI library used in this workshop.
* [PureScript Language Reference](https://github.com/purescript/documentation/blob/master/language/README.md)
  * The quick, show me the syntax version of "what can PureScript do"

