(* ::Package:: *)

#!/usr/local/bin/MathematicaScript -script

color = White;

(*url = ToExpression[Rest[$ScriptCommandLine]];*)
i = RemoveBackground[
ColorNegate[
 EdgeDetect[
 Import["/Users/Pradyuman/Documents/LiveTrace/PurdueEngineering.jpg"]]], {"Background", color}]



