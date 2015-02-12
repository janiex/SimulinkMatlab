function [ dmrs_result ] = DRMS( input_vector )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
len = length(input_vector);
sum = 0;
    for i=0:len
        sum = sum + (input_vector(i)*input_vector(i));
    end
    dmrs_result = sum/len;
end

