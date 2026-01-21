%% Instructions
% Place this script in the same folder as all the files for your homework
% submission. Then run the script in your command window.
%
% - If there are NO errors, that means your files have the correct behavior. 
%   It does not necessarily mean that your solutions are correct. Think of
%   it like this: if a homework problem asks you to show me a specific cat,
%   this script verifies that you are showing me some sort of cat (instead
%   of a dog) but it does not verify that you are showing me the correct
%   cat!
%
% - If there ARE errors, that means at least one of your files is not doing
%   what was asked. See if you can figure out what's going on, or ask on
%   Ed, or a friend, or come to office hours!

%% check sumsquare
sumsquaredifference

if exist("mydiff", 'var') ~= 1
    error("'sumsquaredifference' does not create the variable 'mydiff'")
end

clear all
%% check piestimate
piestimate

if exist("mypi",'var') ~= 1
    error("'piestimate' does not create the variable 'mypi'")
end

%% if no errors so far
fprintf("=========\n Passed the check - does NOT necessarily mean answers are correct\n=========\n")
