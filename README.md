# ewd - Execute Working Directory

ewd is a tool for saving commands you do frequently in the working directory to short names. This allows you to only remember the short name rather than the whole command.

## Installation

```terminal
$ brew tap ewd-cli/formulae; brew install ewd
```

## Usage

```terminal
$ ewd --set carthage "carthage update --platform iOS --no-use-binaries"
```

Then typing:

```terminal
$ ewd carthage
```

Would be the equivilant of:

```terminal
$ carthage update --platform iOS --no-use-binaries
```

## zsh 

A basic zsh completion is included 

## Backup

Your ewd commands are stored in `~/.ewd`.
