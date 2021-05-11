import XMonad
import XMonad.Hooks.SetWMName

myTerminal = "alacritty"
myBorderWidth = 1
myStartupHook = setWMName "LG3D"

main = xmonad def
  {
    terminal = myTerminal,
    borderWidth = myBorderWidth,
    startupHook = myStartupHook
  }
