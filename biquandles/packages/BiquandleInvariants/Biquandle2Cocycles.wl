(* ::Package:: *)

(* Author: Vilas Winstein *)

BeginPackage["Biquandle2Cocycles`"]
Needs["KnotTheory`"]
Needs["Biquandles`"]

Biquandle2Cocycle::usage="The symbol type for a biquandle 2-cocycle.";
Biquandle2CocycleAxiom1Q::usage="Returns true if the given Biquandle2Cocycle symbol satisfies biquandle 2-cocycle axiom 1, false otherwise.";
Biquandle2CocycleAxiom2Q::usage="Returns true if the given Biquandle2Cocycle symbol satisfies biquandle 2-cocycle axiom 2, false otherwise.";
Biquandle2CocycleQ::usage="Returns true if the given Biquandle2Cocycle symbol satisfies all biquandle 2-cocycle axioms, false otherwise.";
Biquandle2CocycleInvariantColoringValue::usage="Returns the value of the given biquandle 2-cocycle invariant on the given (colored) link."
Biquandle2CocycleInvariantValue::usage="Returns the value (a multiset) of the given biquandle 2-cocycle invariant on the given link.";

Begin["Private`"]

(* How to declare a biquandle 2-cocycle *)
Biquandle2Cocycle[B_Biquandle, \[Phi]_List];

Biquandle2CocycleAxiom1Q[Biquandle2Cocycle[B_Biquandle, \[Phi]_List]] := AllTrue[Table[\[Phi][[i,i]], {i, 1, Length[BiquandleElements[B]]}], #==1&];

Biquandle2CocycleAxiom2Helper[B_Biquandle, \[Phi]_List, List[x_,y_,z_]] := \[Phi][[x,y]] \[Phi][[y,z]] \[Phi][[OvTri[B,x,y], UnTri[B,z,y]]] == \[Phi][[x,z]] \[Phi][[OvTri[B,y,x], OvTri[B,z,x]]] \[Phi][[UnTri[B,x,z], UnTri[B,y,z]]];

Biquandle2CocycleAxiom2Q[Biquandle2Cocycle[B_Biquandle, \[Phi]_List]] := AllTrue[Tuples[BiquandleElements[B],3], Biquandle2CocycleAxiom2Helper[B,\[Phi],#]&];

Biquandle2CocycleQ[\[Phi]_Biquandle2Cocycle] := Biquandle2CocycleAxiom1Q[\[Phi]] && Biquandle2CocycleAxiom2Q[\[Phi]];

(* The value of the invariant on a particular colored crossing *)
Biquandle2CocycleInvariantCrossingValue[X[i_,j_,k_,l_], coloring_List, \[Phi]_List] := If[j-l==1||l-j>1, \[Phi][[coloring[[i]],coloring[[j]]]], 1/\[Phi][[coloring[[k]],coloring[[j]]]]];
Biquandle2CocycleInvariantCrossingValue[Xp[i_,j_,k_,l_], coloring_List, \[Phi]_List] := \[Phi][[coloring[[i]],coloring[[j]]]];
Biquandle2CocycleInvariantCrossingValue[Xm[i_,j_,k_,l_], coloring_List, \[Phi]_List] := 1/\[Phi][[coloring[[k]],coloring[[j]]]];

(* The value of the invariant on a particular colored link *)
Biquandle2CocycleInvariantColoringValue[L_PD, coloring_List, Biquandle2Cocycle[B_Biquandle, \[Phi]_List]] := Times @@ (Biquandle2CocycleInvariantCrossingValue[#,coloring,\[Phi]]& /@ L);

Biquandle2CocycleInvariantValue[L_PD, Biquandle2Cocycle[B_Biquandle, \[Phi]_List]] := Biquandle2CocycleInvariantColoringValue[L, #, Biquandle2Cocycle[B, \[Phi]]]& /@ AllBiquandleColorings[L, B];

End[]
EndPackage[]
