function [ result ] = numToByte( number, nBytes )
%NUMTOBYTE TODO

    result = zeros(1, nBytes);
    for i=0:nBytes-1
        result(end-i) = mod(number, 256);
        number = floor( number / 256 );
    end

end

