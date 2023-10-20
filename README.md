# Declarative Keybindings for Hammerspoon

A tiny framework for hammerspoon that lets you write keybindings and other functionalities in a very human-friendly way, so that your file is self-documented
and easy to modify.

Because the framework is small, it can also easily be modified and adapted to your needs.

### Why

After going down the rabbit hole of tiling wm in macOS, I was pretty happy with my setup with [yabai](https://github.com/koekeishiya/yabai) + [skhd](https://github.com/koekeishiya/skhd). It was then that I discovered [Hammerspoon](https://www.hammerspoon.org/0), and thought if it was really worth it migrating everything I had just setup with skhd.

If you are reading this, you probably know the answer to that last question. I did appreciate a lot how clear and readable everything was with skhd, and because I wanted an excuse to finaly learn Lua, I started buiding this thing. I just thought it would be useful to share it. You can compare the result in this before|after comparison:

#### Before dkb:

```lua
hs.hotkey.bind(super, hs.keycodes.map["l"], function()
	yabai({ "-m", "window", "--focus", "east" })
end)
```

#### After dkb:

```lua
mod1("l", "-m window --focus east")
```

If you want to know how this magic can happen, refer to [Usage](##Usage)

## Usage

Getting started is pretty easy with just one example. For more advanced usage please refer to the [documentation](https://meisocafe.github.io/hammerspoon-dkb/)

### Quick example

```lua
local keybindings = require("dkb.keybindings")

mod1 = keybindings:bindmod("⌃⌘", print)

mod1("p", "key p pressed")
mod1("g", "key g pressed")
```

## Install

### With [luarocks](https://github.com/luarocks/luarocks) (recommended)

```sh
luarocks install meisocafe.hammerspoon.dkb
```

### From source

Download this project, copy the folder `src` into `$HOME/.hammerspoon` and rename it to `dkb`.

```sh
git clone https://github.com/meisocafe/hammerspoon-dkb.git
mv hammerspoon-dkb/src $HOME/.hammerspoon/dkb
```

## Dependencies

This module has no dependencies except for [Hammerspoon](https://www.hammerspoon.org/0).

## Build

Install [luarocks](https://github.com/luarocks/luarocks) and [ldoc](https://github.com/lunarmodules/LDoc). From the project root directory, run:

```sh
ldoc .
luarocks make meisocafe.hammerspoon.dkb-0.1-0.rockspec
```

## Contribute

### Bugs

I plan to fix any major bugs that are found, but I cannot guarantee that I will take care of everything timely or that I will take care of very situational-hard-to-reproduce bugs. Pleasea understand that this is just a project I made for fun and I wanted to share.

### New Features

I don't plan to expand this project, so please don't submit PR's asking for features unles you are planning to implement them yourself. I would appreciate if you contribute back any changes that you make to the project for your personal use, as long as they make sense outside of your personal needs.

## License

hammerspoon-dkb is available under the [MIT license](https://github.com/meisocafe/hammerspoon-dkb/blob/main/LICENSE)
