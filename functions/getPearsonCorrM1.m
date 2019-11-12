function [ ROICorr ] = getPearsonCorrM1(time,windowSize,ROImeans)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

temp = corr(ROImeans(time-windowSize+2:time+1,:),ROImeans(time-windowSize+2:time+1,:));
n_rois = size(temp,2);

if n_rois == 2
    ROICorr = temp(1,2);
elseif n_rois == 3
    ROICorr = [temp(1,2) ; temp(1,3) ; temp(2,3)];
end

end

