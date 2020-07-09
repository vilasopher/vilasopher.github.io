(* ::Package:: *)

(* Author: Vilas Winstein *)

BeginPackage["Biquandles`"]
Needs["KnotTheory`"]

Biquandle::usage="The symbol type for a biquandle.";
BiquandleAxiom1Q::usage="Returns true if the given Biquandle symbol satisfies biquandle axiom 1, false otherwise.";
BiquandleAxiom2Q::usage="Returns true if the given Biquandle symbol satisfies biquandle axiom 2, false otherwise.";
BiquandleAxiom3Q::usage="Returns true if the given Biquandle symbol satisfies biquandle axiom 3, false otherwise.";
BiquandleQ::usage="Returns true if the given Biquandle symbol satisfies the biquandle axioms, false otherwise. Use the Verbose option to see which axiom fails.";
UnTri::usage="Apply the 'Underlined Triangle' operation of a given biquandle to two elements.";
OvTri::usage="Apply the 'Overlined Triangle' operation of a given biquandle to two elements.";
UnTriInverse::usage="Apply the inverse of the 'Underlined Triangle' operation of a given biquandle to two elements.";
UnTriInverse::usage="Apply the inverse of the 'Overlined Triangle' operation of a given biquandle to two elements.";
BiquandleElements::usage="Get a list of the elements of a particular biquandle.";
BiquandleColoringQ::usage="Returns true if the given coloring (with the given biquandle) is valid for the given knot Planar Diagram.";
AllBiquandleColorings::usage="Returns a list of all valid colorings of a given link with a given biquandle.";
BiquandleCountingInvariant::usage="Returns the biquandle counting invariant of the given link with the given biquandle.";

Begin["Private`"]

(* How to declare a biquandle *)
Biquandle[n_Integer,untri_List,ovtri_List];

(* Checks that the shape of operation matrices are correct *)
BiquandleMatrixShapeQ[Biquandle[n_,u_,o_]] := Dimensions[u]=={n,n}&&Dimensions[o]=={n,n};

(* Biquandle Axiom 1 *)
BiquandleAxiom1Q[Biquandle[n_,u_,o_]] := AllTrue[Range[n],Function[x, u[[x,x]]==o[[x,x]]]];

(* Biquandle Axiom 2 *)
(* TODO: Separate this into two helper functions *)
BiquandleAxiom2Q[Biquandle[n_,u_,o_]] := 
	Catch[
		If[Not[AllTrue[Range[n],Function[y, Sort[u[[All,y]]]==Range[n] && Sort[o[[All,y]]]==Range[n]]]],
			Throw[False]
		];
		If[Not[Sort[Thread[List[Flatten[Transpose[o]],Flatten[u]]]]==Tuples[Range[n],2]],
			Throw[False]
		];
		Throw[True];
	];

(* Helper function which tests the exchange laws for a particular triple of biquandle elements *)
ExchangeLawsQ[u_,o_,List[x_,y_,z_]] :=
	Catch[
		Module[{law1, law2, law3},
			law1 = u[[u[[x,y]],u[[z,y]]]]==u[[u[[x,z]],o[[y,z]]]];
			law2 = o[[u[[x,y]],u[[z,y]]]]==u[[o[[x,z]],o[[y,z]]]];
			law3 = o[[o[[x,y]],o[[z,y]]]]==o[[o[[x,z]],u[[y,z]]]];
			Throw[law1&&law2&&law3];
		];
	];

(* Biquandle Axiom 3 *)
BiquandleAxiom3Q[Biquandle[n_,u_,o_]] :=
	Catch[
		Do[
			If[Not[ExchangeLawsQ[u,o,T]], Throw[False]],
			{T, Tuples[Range[n],3]}
		];
		Throw[True];
	];

(* A list of all biquandle axioms *)
BiquandleAxioms = {BiquandleAxiom1Q, BiquandleAxiom2Q, BiquandleAxiom3Q};

(* Function that checks whether a "biquandle" satisfies the biquandle axioms *)
BiquandleQ[X_Biquandle, OptionsPattern[]]:=
	Catch[
		If[Not[BiquandleMatrixShapeQ[X]],
			If[OptionValue[Verbose], Print["Dimensions of operation matrices are incorrect."]];
			Throw[False];
			];
		For[i=1,i<=3,i++,
			If[Not[BiquandleAxioms[[i]][X]],
				If[OptionValue[Verbose], Print["Biquandle fails Axiom " <> ToString[i]]];
				Throw[False];
			];
		];
		Throw[True];
	];

(* By default, BiquandleQ doesn't print anything *)
Options[BiquandleQ] = {Verbose -> False};

(* Given a biquandle, perform the operations *)
UnTri[Biquandle[n_,u_,o_],x_Integer,y_Integer]:=u[[x,y]];
OvTri[Biquandle[n_,u_,o_],x_Integer,y_Integer]:=o[[x,y]];

(* Perform the inverse operations *)
UnTriInverse[Biquandle[n_,u_,o_],x_Integer,y_Integer]:=Position[u[[All,y]],x][[1,1]];
OvTriInverse[Biquandle[n_,u_,o_],x_Integer,y_Integer]:=Position[o[[All,y]],x][[1,1]];

(* Get the elements of a biquandle *)
BiquandleElements[Biquandle[n_,u_,o_]]:=Range[n];

(* See if a particular coloring is valid at a given crossing *)
ColoringSatisfiedAtCrossing[X[i_,j_,k_,l_],B_Biquandle,coloring_List]:=
	If[j-l==1||l-j>1,
		UnTri[B,coloring[[i]],coloring[[j]]]==coloring[[k]]&&OvTri[B,coloring[[j]],coloring[[i]]]==coloring[[l]],
		OvTri[B,coloring[[j]],coloring[[k]]]==coloring[[l]]&&UnTri[B,coloring[[k]],coloring[[j]]]==coloring[[i]]];

ColoringSatisfiedAtCrossing[Xp[i_,j_,k_,l_],B_Biquandle,coloring_List]:=
		UnTri[B,coloring[[i]],coloring[[j]]]==coloring[[k]]&&OvTri[B,coloring[[j]],coloring[[i]]]==coloring[[l]];

ColoringSatisfiedAtCrossing[Xm[i_,j_,k_,l_],B_Biquandle,coloring_List]:=
		OvTri[B,coloring[[j]],coloring[[k]]]==coloring[[l]]&&UnTri[B,coloring[[k]],coloring[[j]]]==coloring[[i]];
		
BiquandleColoringQ[link_PD,B_Biquandle,coloring_List]:=
	AllTrue[link,ColoringSatisfiedAtCrossing[#,B,coloring]&];

NumberOfEdges[link_PD]:=
	Max[Flatten[Map[List @@ # &, List @@ link]]];
	
AllBiquandleColorings[link_PD,B_Biquandle]:=
	Select[Tuples[BiquandleElements[B],NumberOfEdges[link]], BiquandleColoringQ[link,B,#]&];

BiquandleCountingInvariant[link_PD,B_Biquandle]:=Length[AllBiquandleColorings[link,B]];

End[]
EndPackage[]
