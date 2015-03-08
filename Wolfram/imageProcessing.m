(* ::Package:: *)

#!/usr/local/bin/MathematicaScript -script

color = White;

(*url = ToExpression[Rest[$ScriptCommandLine]];*)
Manipulate[
  RemoveBackground[
    ColorNegate[
      EdgeDetect[
        Import["/Users/Pradyuman/Documents/LiveTrace/images/purdue_campus.jpg"],r,t]], {"Background", color}],{{r,2,"radius"},1,10},{{t,.1,"threshold"}, 0, .5}]
