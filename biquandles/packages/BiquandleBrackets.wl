(* ::Package:: *)

(* Author: Vilas Winstein *)

BeginPackage["BiquandleBrackets`"]
Needs["KnotTheory`"]
Needs["Biquandles`"]

BiquandleBracket::usage="The symbol type for a biquandle bracket.";
BiquandleBracketAxiom1Q::usage="Returns true if the given BiquandleBracket symbol satisfies biquandle bracket axiom 1, false otherwise.";
BiquandleBracketAxiom2Q::usage="Returns true if the given BiquandleBracket symbol satisfies biquandle bracket axiom 2, false otherwise.";
BiquandleBracketAxiom3Q::usage="Returns true if the given BiquandleBracket symbol satisfies biquandle bracket axiom 3, false otherwise.";
BiquandleBracketQ::usage="Returns true if the given BiquandleBracket symbol satisfies the biquandle bracket axioms, and in addition takes values in a factor of Z[x,y,z,...], false otherwise. Use the Verbose option to see which axiom fails.";
BiquandleBracketColoringValue::usage="Returns the value of the given biquandle bracket on the given link with the given biquandle coloring.";
BiquandleBracketValue::usage="Returns the value (a multiset) of the given biquandle bracket on the given link.";
GetBiquandle::usage="Get the biquandle used by a particular biquandle bracket.";

Begin["Private`"]

(* How to declare a biquandle bracket *)
BiquandleBracket[X_Biquandle, Ideal_List, A_List, B_List, \[Delta], w];

(* Another biquandle bracket constructor that doesn't require you to specify \[Delta] or w *)
BiquandleBracket[X_Biquandle, Ideal_List, A_List, B_List] :=
	BiquandleBracket[X, Ideal, A, B, \[Delta], PolynomialMod[\[Delta] A[[1,1]]+B[[1,1]], Ideal]] /.\[Delta] -> PolynomialMod[-A[[1,1]]/B[[1,1]]-B[[1,1]]/A[[1,1]], Ideal];
	
(* Function for checking whether two things are equal mod an ideal *)
PolynomialModEquality[p_, q_, Ideal_] := PolynomialMod[p - q, Ideal] === 0;

(* Biquandle bracket Axiom 1 *)
BiquandleBracketAxiom1Q[BiquandleBracket[X_Biquandle, Ideal_List, A_List, B_List, \[Delta]_, w_]] :=
	Catch[
		Do[
			If[Not[PolynomialModEquality[\[Delta] A[[x,x]] + B[[x,x]], w, Ideal]], Throw[False]];
			If[Not[PolynomialModEquality[\[Delta]/A[[x,x]] + 1/B[[x,x]], 1/w, Ideal]], Throw[False]],
			{x, BiquandleElements[X]}
		];
		Throw[True];
	]; 

(* Helper method for Axiom 2 *)
BiquandleBracketAxiom2Condition[Ideal_List, A_List, B_List, \[Delta]_, List[x_, y_]] := PolynomialModEquality[\[Delta], -A[[x,y]]/B[[x,y]]-B[[x,y]]/A[[x,y]], Ideal];

(* Biquandle bracket Axiom 2 *)
BiquandleBracketAxiom2Q[BiquandleBracket[X_Biquandle, Ideal_List, A_List, B_List, \[Delta]_, w_]] :=
	Catch[
		Do[
			If[Not[BiquandleBracketAxiom2Condition[Ideal, A, B, \[Delta], T]], Throw[False]],
			{T, Tuples[BiquandleElements[X], 2]}
		];
		Throw[True];
	];

(* Helper function for the first group of conditions in axiom 3--requires additional input of order type *)
BiquandleBracketAxiom3ConditionGroup1[X_Biquandle, Ideal_List, List[L1_List, L2_List, L3_List, R1_List, R2_List, R3_List], List[x_, y_, z_]] :=
	PolynomialModEquality[L1[[x,y]] L2[[y,z]] L3[[UnTri[X,x,y], OvTri[X,z,y]]], R1[[x,z]] R2[[OvTri[X,y,x], OvTri[X,z,x]]] R3[[UnTri[X,x,z], UnTri[X,y,z]]], Ideal];

(* Helper function for the fourth condition in axiom 3 *)
BiquandleBracketAxiom3Condition4[X_Biquandle, Ideal_List, A_List, B_List, \[Delta]_, List[x_, y_, z_]] :=
	PolynomialModEquality[A[[x,y]] A[[y,z]] B[[UnTri[X,x,y], OvTri[X,z,y]]], A[[x,z]] B[[OvTri[X,y,x], OvTri[X,z,x]]] A[[UnTri[X,x,z], UnTri[X,y,z]]] + A[[x,z]] A[[OvTri[X,y,x], OvTri[X,z,x]]] B[[UnTri[X,x,z], UnTri[X,y,z]]] + \[Delta] A[[x,z]] B[[OvTri[X,y,x], OvTri[X,z,x]]] B[[UnTri[X,x,z], UnTri[X,y,z]]] + B[[x,z]] B[[OvTri[X,y,x], OvTri[X,z,x]]] B[[UnTri[X,x,z], UnTri[X,y,z]]], Ideal];

(* Helper function for the fifth condition in axiom 3 *)
BiquandleBracketAxiom3Condition5[X_Biquandle, Ideal_List, A_List, B_List, \[Delta]_, List[x_, y_, z_]] :=
	PolynomialModEquality[B[[x,y]] A[[y,z]] A[[UnTri[X,x,y], OvTri[X,z,y]]] + A[[x,y]] B[[y,z]] A[[UnTri[X,x,y], OvTri[X,z,y]]] + \[Delta] B[[x,y]] B[[y,z]] A[[UnTri[X,x,y], OvTri[X,z,y]]] + B[[x,y]] B[[y,z]] B[[UnTri[X,x,y], OvTri[X,z,y]]], B[[x,z]] A[[OvTri[X,y,x], OvTri[X,z,x]]] A[[UnTri[X,x,z], UnTri[X,y,z]]], Ideal];

(* Biquandle bracket Axiom 3 *)
BiquandleBracketAxiom3Q[BiquandleBracket[X_Biquandle, Ideal_List, A_List, B_List, \[Delta]_, w_]] :=
	Catch[
		Module[{condGroup1Types},
			condGroup1Types = { {A, A, A, A, A, A}, {A, B, B, B, B, A}, {B, A, B, B, A, B} };
			Do[
				For[i=1,i<=3,i++,
					If[Not[BiquandleBracketAxiom3ConditionGroup1[X, Ideal, A, B, condGroup1Types[i], T]], Throw[False]]
				];
				If[Not[BiquandleBracketAxiom3Condition4[X, Ideal, A, B, \[Delta], T]], Throw[False]];
				If[Not[BiquandleBracketAxiom3Condition5[X, Ideal, A, B, \[Delta], T]], Throw[False]],
				{T, Tuples[BiquandleElements[X],3]}
			];
			Throw[True];
		];
	];
	
(* Helper function for checking whether the bracket values are invertible over a factor of Z[x,y,z,...] *)
BiquandleBracketParticularValueInvertibleOverIPR[Ideal_List, A_List, B_List, List[x_, y_]] :=
	Catch[
		Module[{p, pInv, vars},
			Do[
				p = PolynomialMod[M[[x,y]], Ideal];
				vars = Variables[p];
				If[Not[AllTrue[Flatten[{CoefficientList[p, vars]}], IntegerQ]], Throw[False]];
				pInv = PolynomialMod[1/p, Ideal];
				If[Not[PolynomialQ[pInv, vars]], Throw[False]];
				If[Not[AllTrue[Flatten[{CoefficientList[pInv, vars]}], IntegerQ]], Throw[False]],
				{M, {A,B}}
			];
			Throw[True];
		];
	];

(* Checks whether the bracket values are invertible over a factor of Z[x,y,z,...] *)
BiquandleBracketValuesInvertibleOverIntegerPolynomialRingQ[BiquandleBracket[X_Biquandle, Ideal_List, A_List, B_List, \[Delta]_, w_]] :=
	Catch[
		Module[{vars, wInv},
			vars = Variables[\[Delta]];
			If[Not[AllTrue[Flatten[{CoefficientList[\[Delta], vars]}], IntegerQ]], Throw[False]];
			vars = Variables[w];
			If[Not[AllTrue[Flatten[{CoefficientList[w, vars]}], IntegerQ]], Throw[False]];
			wInv = PolynomialMod[1/w, Ideal];
			If[Not[PolynomialQ[PolynomialMod[wInv, Ideal], vars]], Throw[False]];
			If[Not[AllTrue[Flatten[{CoefficientList[wInv, vars]}], IntegerQ]], Throw[False]];
			Do[
				If[Not[BiquandleBracketParticularValueInvertibleOverIPR[Ideal, A, B, T]], Throw[False]],
				{T, Tuples[BiquandleElements[X], 2]}
			];
			Throw[True];
		];	
	];

(* A list of all biquandle bracket axioms *)
BiquandleBracketAxioms = {BiquandleBracketAxiom1Q, BiquandleBracketAxiom2Q, BiquandleBracketAxiom3Q};

(* Check whether the "biquandle bracket" satisfies the biquandle bracket axioms and takes values in a factor of Z[x,y,z,...]  *)
BiquandleBracketQ[AB_BiquandleBracket, OptionsPattern[]] :=
	Catch[
		For[i=1,i<=3,i++,
			If[Not[BiquandleBracketAxioms[[i]][AB]],
				If[OptionValue[Verbose], Print["Biquandle bracket fails Axiom " <> ToString[i]]];
				Throw[False];
			];
		];
		(* This part is currently commented out because its currently broken.
		If[Not[BiquandleBracketValuesInvertibleOverIntegerPolynomialRingQ[AB]],
			If[OptionValue[Verbose], Print["Biquandle bracket doesn't take values in a factor of Z[x,y,z,...]"]];
			Throw[False];
		];
		*)
		Throw[True];
	];

(* Default verbosity for BiquandleBracketQ *)
Options[BiquandleBracketQ] = {Verbose -> False};

(* Self explanatory but I have these useless comments everywhere else so here's one for posterity *)
GetBiquandle[BiquandleBracket[X_Biquandle,_,_,_,_,_]] := X;

(* Section involving computing values of biquandle brackets below *)
SetAttributes[BBPP, Orderless];

(* Represents the value of a biquandle bracket at a particular smoothing *)
Smoothing[link_PD,state_List, crossingColors_List, A_List,B_List,\[Delta]_,Ideal_List] :=
	Module[{t1,t2,t3,t4,t5},
		t1 = Thread[{List @@ link, state, crossingColors}];
		t2 = t1 /. {
				{X[i_,j_,k_,l_],0,{x_,y_}}:>If[j-l==1||l-j>1,A[[x,y]],1/B[[x,y]]] BBPP[i,j] BBPP[k,l],
				{X[i_,j_,k_,l_],1,{x_,y_}}:>If[j-l==1||l-j>1,B[[x,y]],1/A[[x,y]]] BBPP[i,l] BBPP[j,k],
				{Xp[i_,j_,k_,l_],0,{x_,y_}}:> A[[x,y]]BBPP[i,j]BBPP[k,l],
				{Xp[i_,j_,k_,l_],1,{x_,y_}}:> B[[x,y]]BBPP[i,l]BBPP[j,k],
				{Xm[i_,j_,k_,l_],0,{x_,y_}}:>(1/B[[x,y]])BBPP[i,j]BBPP[k,l],
				{Xm[i_,j_,k_,l_],1,{x_,y_}}:>(1/A[[x,y]])BBPP[i,l]BBPP[j,k]
			};
		t3 = Times @@ t2;
		t4 = t3 //. {BBPP[i_,j_]BBPP[j_,k_]:>BBPP[i,k]};
		t5 = t4/.BBPP[_,_]^2:>\[Delta];
		Return[PolynomialMod[t5,Ideal]];
	];

(* Returns a list of pairs of colors for each crossing of a link *)
CrossingColors[link_PD,coloring_List] :=
	List@@(link/.{
				X[i_,j_,k_,l_]:>If[j-l==1||l-j>1,{coloring[[i]],coloring[[j]]},{coloring[[k]],coloring[[j]]}],
				Xp[i_,j_,k_,l_]:>{coloring[[i]],coloring[[j]]},
				Xm[i_,j_,k_,l_]:>{coloring[[k]],coloring[[j]]}
				});
				
(* Return the number of positive and negative crossings respectively *)
BBnp[link_PD] := Count[link,X[i_,j_,k_,l_]/;j-l==1||l-j>1]+Count[link,x_Xp];
BBnm[link_PD] := Count[link,X[i_,j_,k_,l_]/;l-j==1||j-l>1]+Count[link,x_Xm];

(* Get the value of a biquandle bracket on a particular colored link *)
BiquandleBracketColoringValue[BiquandleBracket[_,Ideal_List,A_List,B_List,\[Delta]_,w_], link_PD, coloring_List] :=
	PolynomialMod[Total[Map[Smoothing[link,#,CrossingColors[link,coloring],A,B,\[Delta],Ideal]&,Tuples[{0,1},Length[link]]]]*w^(BBnm[link]-BBnp[link]),Ideal];

(* Get the (multiset) value of a biquandle bracket on a particular link *)
BiquandleBracketValue[AB_BiquandleBracket, link_PD] :=
	Map[BiquandleBracketColoringValue[AB, link, #]&, AllBiquandleColorings[link, GetBiquandle[AB]]];

End[]
EndPackage[]
