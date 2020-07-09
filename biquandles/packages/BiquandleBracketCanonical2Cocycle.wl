(* ::Package:: *)

(* Author: Vilas Winstein *)

BeginPackage["BiquandleBracketCanonical2Cocycle`"]
Needs["KnotTheory`"]
Needs["Biquandles`"]
Needs["BiquandleBrackets`"]
Needs["Biquandle2Cocycles`"]

BiquandleBracketCanonical2Cocycle::usage="Return the canonical 2-cocycle for a given biquandle bracket.";
BiquandleBracketKernel::usage="Gives a set of generators for G = < q q[x,y]^(-1) : x,y \[Element] X >.";
MultisetQuotientEqualityQ::usage="Check for equality of two multisets with entries in a multiplicative quotient group.";

Begin["Private`"]

BiquandleBracketCanonical2Cocycle[BiquandleBracket[X_Biquandle, Ideal_List, A_List, B_List, \[Delta]_, w_]] := Biquandle2Cocycle[X, A[[1,1]]^(-1) A];

q[A_List, B_List, x_Integer, y_Integer] := -B[[x,y]] / A[[x,y]];

BiquandleBracketKernel[BiquandleBracket[X_Biquandle, Ideal_List, A_List, B_List, \[Delta]_, w_]] := Table[PolynomialMod[q[A,B,1,1]/q[A,B,x,y], Ideal], {x, BiquandleElements[X]}, {y, BiquandleElements[X]}] // Flatten // DeleteDuplicates;

MultiplicativeMod[kernel_List] := #->1& /@ kernel;

MultisetQuotientEqualityQ[mset1_List, mset2_List, kernel_List] := Length[mset1] == Length[mset2] && AllTrue[mset1, Count[Factor[#^(-1) mset1] //. MultiplicativeMod[kernel], 1] == Count[Factor[#^(-1) mset2] //. MultiplicativeMod[kernel], 1] &];

End[]
EndPackage[]
