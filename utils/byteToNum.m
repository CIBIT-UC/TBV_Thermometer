function [ result ] = byteToNum( bytes )
%BYTETONUM TODO
    result = 0;
    for i=0:length(bytes)-1
        result = result + double(bytes(end-i))* 256^i ;
    end
end

