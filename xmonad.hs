import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Actions.CopyWindow
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.IO

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/brett/.xmobarrc"
  xmonad $ defaultConfig
    { terminal    = "mrxvt"
    , modMask     = mod4Mask
    , borderWidth = 3
    , manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = avoidStruts  $  layoutHook defaultConfig
    , logHook = dynamicLogWithPP xmobarPP
       { ppOutput = hPutStrLn xmproc
       , ppTitle = xmobarColor "green" "" . shorten 50
       }
--    , keys = myKeys <+> keys defaultConfig
    , keys = newKeys
    }
      
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList
  [ 
    ((modm .|. shiftMask, xK_F12), spawn "xev")
  , ((modm, xK_F3 ), spawn "xev")
  -- @@ run or copy Chrome
  , ((modm, xK_b    ), runOrCopy "google-chrome" (className =? "Google-chrome")) 
  -- @@ Make focused window always visible
  , ((modm, xK_s ), windows copyToAll) 
  -- @@ Toggle window state back
  , ((modm .|. shiftMask, xK_s ),  killAllOtherCopies) 
  -- @@ Close the focused window (not delete if on other ws)
  , ((modm .|. shiftMask, xK_c     ), kill1) 
  ]
newKeys x = myKeys x `M.union` keys defaultConfig x
