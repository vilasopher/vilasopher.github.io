(* ::Package:: *)

(* Authors: WReach (from Mathematica Stack Exchange) and Vilas Winstein *)

BeginPackage["LazyList`"]

LazyList::usage="The symbol for a LazyList.";
LLEmptyQ::usage="Returns true if the LazyList is empty, false otherwise.";
LLHead::usage="Get the first element of a LazyList.";
LLTail::usage="Get the tail of a LazyList.";
LLTake::usage="Get the first few elements of a LazyList.";
LLToList::usage="Convert a LazyList to a List.";
LLFromList::usage="Convert a List to a LazyList.";
LLMap::usage="Map a function onto a LazyList.";
LLSelect::usage="Select elements of a LazyList that match a given condition.";
LLJoin::usage="Concatenate two LazyLists.";
LLFlatten::usaeg="Flatten a doubly-nested LazyList.";
LLIntegers::usage="A LazyList of integers starting with the specified one.";
LLTuples::usage="A LazyList of tuples from a given list of the specified size.";

Begin["Private`"]

SetAttributes[LazyList,{HoldRest,Protected}];
SetAttributes[LLJoin,{HoldRest}];

LLEmptyError[]:=(Message[LazyList::empty];Abort[])
LazyList::empty="Attempt to access beyond the end of a LazyList.";

LLEmptyQ[LazyList[]]:=True
LLEmptyQ[LazyList[_,_]]:=False;

LLHead[LazyList[]]:=LLEmptyError[]
LLHead[LazyList[h_,_]]:=h

LLTail[LazyList[]]:=LLEmptyError[]
LLTail[LazyList[_,t_]]:=t

LLTake[s_LazyList,0]:=LazyList[]
LLTake[s_LazyList,n_]/;n>0:=With[{nn=n-1},LazyList[LLHead[s],LLTake[LLTail[s],nn]]]

LLToList[s_LazyList]:=Module[{tag},Reap[NestWhile[(Sow[LLHead[#],tag];LLTail[#])&,s,!LLEmptyQ[#]&],tag][[2]]/.{l_}:>l]

LLFromList[{}]:=LazyList[]
LLFromList[s_List]:=LazyList[s[[1]], LLFromList[s[[2;;]]]]

LLMap[_, LazyList[]]:=LazyList[]
LLMap[fn_, s_LazyList]:=LazyList[fn[LLHead[s]], LLMap[fn, LLTail[s]]]

LLJoin[LazyList[], t_]:=t
LLJoin[s_LazyList, t_]:=LazyList[LLHead[s], LLJoin[LLTail[s], t]]

LLFlatten[LazyList[]]:=LazyList[]
LLFlatten[s_LazyList]:=LLJoin[LLHead[s], LLFlatten[LLTail[s]]]

LLSelect[s_,pred_]:=NestWhile[LLTail,s,(!LLEmptyQ[#]&&!pred[LLHead[#]])&]/.LazyList[h_,t_]:>LazyList[h,LLSelect[t,pred]]

LLIntegers[n_:1]:=With[{nn=n+1},LazyList[n,LLIntegers[nn]]]

(* TODO: make this better *)
LLTuples[_, 0]:=LazyList[{},LazyList[]]
LLTuples[xs_LazyList, tupSize_Integer]:=LLFlatten[LLMap[Function[tup, LLMap[Function[elem, Append[tup, elem]], xs]], LLTuples[xs, tupSize - 1]]]
LLTuples[xs_List, tupSize_Integer]:=LLTuples[LLFromList[xs], tupSize]

End[]
EndPackage[]
