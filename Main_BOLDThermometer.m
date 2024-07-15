%% NEUROFEEDBACK THERMOMETER
% DESCRIPTIVE TEXT
% EXPLAIN HOW FEEDBACK IS CALCULATED
% TODO

%% CHECKLIST
% * NeuroElf
% * TBV Network Plugin v1.71
% * Pre-Load ROI
% * AutoHide Windows TaskBar

%% Start Clean
clear, clc;
close all;

%% Configuration
addpath('utils')
addpath('functions')
addpath('tbvinterface')

% ===== Select IP =================
configs.TBV_IP = '192.168.238.189'; % MRI Signal-PC
%configs.TBV_IP = 'localhost'; % Computer with TBV IPk

% ===== Select TR and wait time ===
TR = 1; %in seconds
wait_time = 0.05; %in seconds

% ====== Select PRT path ==========
prtPath = 'prt';
prtName = 'Task01_Run01.prt';

% ===== Select NF parameters =====
selected_roi = 1;
maxPSC = 2.5;
ignore = 5;
updateThreshold = 3; %Only updates after having this number of points after shiftBegin

% ===== Turn On/Off Feedback
FEEDBACK = true;

%% Open TBV Connection
configs.TBV_PORT = 55555;

tbvNetInt = TBVNetworkInterface( TBVclient( configs.TBV_IP, configs.TBV_PORT ) );

tbvNetInt.createConnection();

%% THERMOMETER Display Configuration

% Thermometer size and range
sz = [700 170];
Trange = [0 1 1];

[ hAx ] = startThermometer( sz , Trange );

%% WAIT FOR DATA
[ n_rois , currentTime , expectedTime ] = waitForData( tbvNetInt , wait_time );

%% INITIALIZE Variables and NF Parameters
shiftBegin = 6 / TR;
shiftEnd = shiftBegin / 3;

last = ignore + 1;

time = 0;
counter = 0;
maxcounter = 100;

ROImeans = zeros(expectedTime,n_rois);

SignalVar = zeros(expectedTime,1);
Baseline = zeros(expectedTime,1);

BaselineIndexes = zeros(expectedTime,1);
BaselineIndexesUpdate = zeros(expectedTime,1);

% Read PRT file
[ cond_names , intervalsPRT , intervals , baseCondIndex ] = readProtocol( prtPath , prtName, expectedTime , TR );

for i = 1:size(intervalsPRT.(cond_names{baseCondIndex}),1)-1
    BaselineIndexes(intervalsPRT.(cond_names{baseCondIndex})(i,1)+shiftBegin:intervalsPRT.(cond_names{baseCondIndex})(i,2)+shiftEnd) = 1;
    BaselineIndexesUpdate(intervalsPRT.(cond_names{baseCondIndex})(i,1)+shiftBegin+shiftEnd+updateThreshold:intervalsPRT.(cond_names{baseCondIndex})(i,2)+shiftEnd) = 1;
end

BaselineIndexes(1:ignore) = 0;
BaselineIndexesUpdate(1:ignore+shiftBegin+updateThreshold) = 0;

blockDur = intervalsPRT.(cond_names{baseCondIndex})(1,2)-intervalsPRT.(cond_names{baseCondIndex})(1,1)+1;

%% TIME Iteration
while time < expectedTime
    
    if time == currentTime
        if counter == maxcounter
            fprintf('ERROR: No new point received after %i seconds.\n',wait_time*maxcounter);
            beep, close all;
            break;
        end
        
        pause(wait_time)
        counter = counter + 1;
    else
        %---Get Mean ROI
        ROImeans(time+1,:) = getMeanROI(n_rois,tbvNetInt,time);
        
        if time+1 > ignore %Ignore first 5 data points
            
            temp = find(BaselineIndexes(1:time+1) == 1);
            
            if BaselineIndexesUpdate(time+1)   
                Baseline(time+1) = mean( ROImeans( last-shiftBegin+1 : time+1 , selected_roi ) );
            else 
                last = time+1;
                
                if time+1 == ignore + 1 
                    Baseline(time+1) = ROImeans( time , selected_roi );
                else
                    Baseline(time+1) = Baseline(time);
                end
            end
            
           SignalVar(time+1) = calcSignalVar( Baseline(time+1) , ROImeans(time+1,selected_roi) , maxPSC );
            
        end
        
        % Thermometer Title - Condition Name
        if intervals(time+1) == 1; fontS = 25; else fontS = 30; end;
        title(cond_names{intervals(time+1)},'FontSize',fontS,'Color','w')
            
        if FEEDBACK % False for Train and Transfer runs
            
            if time+1 > blockDur && sum(BaselineIndexesUpdate(1:time+1)) > 0 %Suppress Feedback during first Baseline (& Imag) block
                measure = str2num(sprintf('%.1f',SignalVar(time+1))); %Value rounded to 0.x (round() does not exist in 2014b)
                thermometer(hAx,measure);
            end
        
        end
        
        fprintf('Time %d\n',time+1);
        
        time = time + 1;
        counter = 0;
    end
    
    currentTime = tbvNetInt.tGetCurrentTimePoint;
    
end