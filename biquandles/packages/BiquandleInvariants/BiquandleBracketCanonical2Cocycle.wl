(* ::Package:: *)

(* Author: Vilas Winstein *)

BeginPackage["BiquandleBracketCanonical2Cocycle`"]
Needs["KnotTheory`"]
Needs["Biquandles`"]
Needs["BiquandleBrackets`"]
Needs["Biquandle2Cocycles`"]

BiquandleBracketCanonical2Cocycle::usage="Return the canonical 2-cocycle for a given biquandle bracket.";
BiquandleBracketCanonical2CocycleInvariantColoringValue::usage="Return the value of the 2-cocycle invariant associated with the canonical 2-cocycle, evaluated on the given colored link.";
BiquandleBracketCanonical2CocycleInvariantValue::usage="Return the multiset of values of the 2-cocycle invariant associated with the canonical 2-cocycle, evaluated on each valid coloring."
BiquandleBracketKernel::usage="Gives a set of generators for G = < q q[x,y]^(-1) : x,y \[Element] X >.";
MultisetQuotientEqualityQ::usage="Check for equality of two multisets with entries in a multiplicative quotient group.";

Begin["Private`"]

BiquandleBracketCanonical2Cocycle[BiquandleBracket[X_Biquandle, Ideal_List, A_List, B_List, \[Delta]_, w_]] := Biquandle2Cocycle[X, A[[1,1]]^(-1) A];

q[A_List, B_List, x_Integer, y_Integer] := -B[[x,y]] / A[[x,y]];

BiquandleBracketKernel[BiquandleBracket[X_Biquandle, Ideal_List, A_List, B_List, \[Delta]_, w_]] := Table[PolynomialMod[q[A,B,1,1]/q[A,B,x,y], Ideal], {x, BiquandleElements[X]}, {y, BiquandleElements[X]}] // Flatten // DeleteDuplicates;

MultiplicativeMod[kernel_List] := #->1& /@ kernel;

MultisetQuotientEqualityQ[mset1_List, mset2_List, kernel_List] := Length[mset1] == Length[mset2] && AllTrue[mset1, Count[Factor[#^(-1) mset1] //. MultiplicativeMod[kernel], 1] == Count[Factor[#^(-1) mset2] //. MultiplicativeMod[kernel], 1] &];

BiquandleBracketCanonical2CocycleInvariantColoringValue[L_PD, coloring_List, \[Beta]_BiquandleBracket] := PolynomialMod[Biquandle2CocycleInvariantColoringValue[L, coloring, BiquandleBracketCanonical2Cocycle[\[Beta]]], GetIdeal[\[Beta]]];

BiquandleBracketCanonical2CocycleInvariantValue[L_PD, \[Beta]_BiquandleBracket] := BiquandleBracketCanonical2CocycleInvariantColoringValue[L, #, \[Beta]]& /@ AllBiquandleColorings[L, GetBiquandle[\[Beta]]];

End[]
EndPackage[]
