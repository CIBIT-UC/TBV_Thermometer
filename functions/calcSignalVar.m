function [ SignalVarFinal ] = calcSignalVar( baseline , value , maxPSC )
%CALCSIGNALVAR Calculates NF Signal.
%   Inputs:
%       - baseline: Double - baseline value for current time point
%       - value: Double - BOLD value at current time point
%       - maxPSC: Double - maximum variation (percent value)
    
    SignalVar = ( value - baseline ) * 100 / baseline ;
    
    SignalVarNorm = SignalVar / maxPSC;
    
    SignalVarFinal = min( max( SignalVarNorm, 0 ), 1 ); 
    
end

