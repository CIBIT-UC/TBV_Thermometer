function [ n_rois , currentTime , expectedTime ] = waitForData( tbvNetInt , wait_time )
%WAITFORDATA Control function
%Waits for all correct initial parameters to run the thermometer
%	Inputs:
%       - tbvNetInt: TBVNetworkInterface
%       - wait_time: Double - pause() argument in seconds
%   Outputs:
%       - n_rois: Int - number of ROIs in TBV
%       - currentTime: Int - current volume
%       - expectedTime: Int - number of volumes of run

currentTime = tbvNetInt.tGetCurrentTimePoint;
expectedTime = tbvNetInt.tGetExpectedNrOfTimePoints;

counter = 0;
maxcounter = 500;

% Case 1: Previous data in memory
% Case 2: First run after starting TBV
while currentTime == expectedTime || currentTime > 3
    
    if counter == 0
        disp('Waiting for new data...')
    elseif counter == maxcounter
        fprintf('ERROR: No new data found after %i seconds.\n',wait_time*maxcounter);
        close all;
        error('Script Terminated.');
    end
    
    pause(wait_time)
    counter = counter+1;
    
    currentTime = tbvNetInt.tGetCurrentTimePoint;
    expectedTime = tbvNetInt.tGetExpectedNrOfTimePoints;
    
end

counter = 0;
n_rois = tbvNetInt.tGetNrOfROIs();
maxcounter = 100;

% Case 3: No ROI selected
while n_rois == 0
   
    if counter == 0
        disp('Waiting for ROI load...')
    elseif counter == maxcounter
        fprintf('ERROR: ROI was not Pre-Loaded on TBV after %i seconds.\n',wait_time*maxcounter);
        close all;
        error('Script Terminated.');
    end
    
    pause(wait_time);
    counter = counter + 1;
    n_rois = tbvNetInt.tGetNrOfROIs();
    
end

counter = 0;

% Case 4: After Network plugin restart
while currentTime < 1
     if counter == 0
        disp('Waiting for data...')
    elseif counter == maxcounter
        fprintf('ERROR: No new data found after %i seconds.\n',wait_time*maxcounter);
        close all;
        error('Script Terminated.');
    end
    
    pause(wait_time)
    currentTime = tbvNetInt.tGetCurrentTimePoint;
    counter = counter+1;
end

end

