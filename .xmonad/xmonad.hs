import System.Posix.Env (getEnv)
import Data.Maybe (maybe) 
import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Kde
import XMonad.Config.Xfce
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.LayoutHints
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Control.Monad (liftM)
import System.IO

myXmonadBar = "dzen2 -x '1440' -y '0' -h '24' -w '640' -ta 'l' -fg '#FFFFFF' -bg '#1B1D1E'"
myStatusBar = "conky -c /home/benjamin/.xmonad/.conky_dzen | dzen2 -x '2080' -w '1040' -h '24' -ta 'r' -bg '#1B1D1E' -fg '#FFFFFF' -y '0'"
myWorkspaces = ["1:term","2:vim","3:web","4:gis","5:docs","6:ssh","7:vmware"] ++
                map show [8,9];

myTerms = ["XTerm", "Gnome-Terminal"]
myWebBrowsers = ["Firefox", "Opera"]
myVim = ["Gvim"]

myManageHook = composeAll 
    --exec function to move firefox to web window 
    [
      className =? "Firefox"     --> doShift "3:web" 
    , className =? "UXTerm"     --> doShift "1:term" 
    , className =? "Gvim"     --> doShift "2:vim"
    , className =? "Gnome-Terminal"   --> doShift "1:term"
    , className =? "Qgis"   --> doShift "4:gis"
    --float MATLAB and related applications
    , className =? "MATLAB"   --> doFloat
    , className =? "Guake"  --> doFloat
    , className =? "Tilda"  --> doFloat
    , className =? "Evince"   --> doShift "5:docs"
    , className =? "Vmware-view" --> doShift "7:vmware"
    --Does the window title contain "Figure" and is it
    --associated with MATLAB?  If so, float the window
    , (liftM (take 6) title) =? "Figure" <&&>
         className =? "com-mathworks-util-PostVMInit" --> doFloat
    ]

myLayouts = layoutHints (Tall 1 (3/100) (1/2))  ||| Full

myStartupHook = do
             --handle problems with Java non-reparenting WMs
             --for programs such as MATLAB
             setWMName "LG3D"
             spawn "uxterm"
             spawn "xmobar"
             spawn "gvim"
             spawn "firefox"

myLogHook h = do
           fadeInactiveLogHook 0.7     
           dynamicLogWithPP $ defaultPP {
--xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
            ---    dynamicLogWithPP xmobarPP {

                --dynamicLogWithPP xmobarPP
        ppCurrent           =   dzenColor "#ebac54" "#1B1D1E" . pad
      , ppVisible           =   dzenColor "white" "#1B1D1E" . pad
      , ppHidden            =   dzenColor "white" "#1B1D1E" . pad
      , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#1B1D1E" . pad
      , ppUrgent            =   dzenColor "#ff0000" "#1B1D1E" . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      {- , ppLayout            =   dzenColor "#ebac54" "#1B1D1E" .
                                (\x -> case x of
                                    "ResizableTall"             ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Mirror ResizableTall"      ->      "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                                    "Full"                      ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    "Simple Float"              ->      "~"
                                    _                           ->      x
                                ) -}
      , ppTitle             =   (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }
                -- dynamicLogWithPP xmobarPP
                --  { ppOutput = hPutStrLn xmproc
                --  , ppTitle = xmobarColor "green" "" . shorten 50
                --  }
                 
 
main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    xmonad $ defaultConfig {
          modMask = mod4Mask
        , terminal = "uxterm"
        , focusFollowsMouse = False :: Bool
        , workspaces = myWorkspaces
        , startupHook = myStartupHook
        --make layouts respect size hints
        , layoutHook = avoidStruts $ myLayouts
        --, logHook = myLogHook
        , logHook = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd
        --place certain windows in the proper places
        , manageHook = myManageHook <+> manageDocks
                                    <+> manageHook defaultConfig
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "slock") 
        --take a screenshot
        , ((0, xK_Print), spawn "scrot") ]

