function [ROImeansM1,timeM1] = getMeanROI(n_rois,tbvNetInt,timePoint)
%GETMEANROI Retrieves Mean ROI Activation for all rois.
%   Inputs:
%       - n_rois: Int - number of rois
%       - tbvNetInt: TBVNetworkInterface
%       - timePoint: Int - time point to retrieve (0-based)
%   Outputs:
%       - ROImeansM1: Double Vector (1 x n_rois)
%       - timeM1: Double - elapsed time

tic

ROImeansM1 = zeros(1,n_rois);

for i=1:n_rois
    ROImeansM1(i) = tbvNetInt.tGetMeanOfROIAtTimePoint( i-1 , timePoint );
end

timeM1 = toc;

end