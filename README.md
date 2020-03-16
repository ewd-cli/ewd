# ewd - **E**xecute **W**orking **D**irectory

ewd is a tool for saving commands you do frequently in the working directory to short names. This allows you to only remember the short name rather than the whole command.

## Installation

## Usage

`$ ewd --set carthage "carthage update --platform iOS --no-use-binaries"`

Then typing:

`$ ewd carthage`

Would be the equivilant of:

`$ carthage update --platform iOS --no-use-binaries`

### execute command
`ewd <command>`

### set command
`ewd --set <command> "<value>"`

### show command
`ewd --show <command>`

### list all commands
`ewd --list`

### delete command
`ewd --delete <command>`

## zsh 

A basic zsh completion is included

## Backup

Your ewd commands are stored in `~/.ewd`.
