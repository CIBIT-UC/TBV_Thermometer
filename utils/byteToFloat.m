function [ result ] = byteToFloat( bytes )
%BYTETOFLOAT Summary of this function goes here
%   Detailed explanation goes here

% result = 0;
result = typecast(uint8(bytes(4:-1:1)), 'single');

end

