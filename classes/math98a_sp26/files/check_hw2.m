clear all
clc

%% check blocks
A = blocks(2,3);
if class(A) ~= "double"
    error("Output of blocks is not the right type (should be a 'double').")
end

%% check zeromiddle
B = rand(5);
B2 = zeromiddle(B);
if size(B2) ~= size(B)
    error("Output of zeromiddle is not the right type" ... 
    + "(should have the same dimensions as the input).")
end

%% check magicsquare
b = magicsquare(rand(2));
if class(b) ~= "logical" || any(b==[0,1])
    error("Output of magicsquare is not the right type (should be a 'logical', " + ...
        "or at least should only take the values 0 or 1).")
end

%% if no errors so far
fprintf("=========\n Passed the check - does NOT necessarily mean answers are correct\n=========\n")


