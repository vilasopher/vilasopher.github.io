clear all

%% check fizzbuzz
fizzbuzz

%% check factorsoftwo
[n, B] = factorsoftwo(6);
if mod(n,1) ~= 0 || mod(B,1) ~= 0
    error("Output of factorsoftwo is not the right type (n, B should be integers).")
end

%% check primesearch
primesearch

if exist("myprime",'var') ~= 1
    error("'primesearch' does not create the variable 'myprime'")
end

%% check collatz
n = longest_collatz_sequence(3);
if mod(n,1) ~= 0
    error("Output of longest_collatz_sequence is not the right type (n, B should be integers).")
end

%% if no errors so far
fprintf("=========\n Passed the check - does NOT necessarily mean answers are correct\n=========\n")

