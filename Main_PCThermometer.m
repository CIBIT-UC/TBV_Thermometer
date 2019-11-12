%% NEUROFEEDBACK THERMOMETER
% DESCRIPTIVE TEXT
% EXPLAIN HOW FEEDBACK IS CALCULATED
% TODO

%% CHECKLIST
% * NeuroElf
% * TBV Network Plugin v1.71
% * Pre-Load ROIs
% * AutoHide Windows TaskBar

%% Start Clean
clear, clc;
close all;

%% Configuration
addpath('utils')
addpath('functions')
addpath('tbvinterface')

% ===== Select IP =================
configs.TBV_IP = 'localhost';

% ===== Select TR and wait time ===
TR = 1.5; %in seconds
wait_time = 0.05; %in seconds

% ====== Select PRT path ==========
prtPath = 'prt';
prtName = '<>.prt';

% ===== Select NF parameters =====
windowSize = 8;
selected_con = 1;

% ===== Turn On/Off Feedback
FEEDBACK = true;

%% Open TBV Connection
configs.TBV_PORT = 55555;

tbvNetInt = TBVNetworkInterface( TBVclient( configs.TBV_IP, configs.TBV_PORT ) );

tbvNetInt.createConnection();

%% THERMOMETER Display Configuration

% Thermometer size and range
sz = [700 170];
Trange = [-1 1 1];

[ hAx ] = startThermometer( sz , Trange );

%% WAIT FOR DATA
[ n_rois , currentTime , expectedTime ] = waitForData( tbvNetInt , wait_time );

%% INITIALIZE Variables and NF Parameters
shiftBegin = 6 / TR;
shiftEnd = shiftBegin / 3;

time = 0;
counter = 0;
maxcounter = 100;

PearsonCorr = zeros(expectedTime,1);

% Read PRT file
[ cond_names , intervalsPRT , intervals , baseCondIndex ] = readProtocol( prtPath , prtName, expectedTime , TR );

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
        
        if time+1 > windowSize
            
            %--- Get Pearson Corr
            [~ , ~ , PearsonCorr(time+1,:)] = tbvNetInt.tGetPearsonCorrelationAtTimePoint(windowSize,time+1);
            
        end
        
        % Thermometer Title - Condition Name
        if intervals(time+1) ~= 1; fontS = 30; else fontS = 25; end;
        title(cond_names{intervals(time+1)},'FontSize',fontS,'Color','w')
            
        if FEEDBACK % False for Train and Transfer runs
            
            if time+1 > blockDur %Suppress Feedback during first Baseline block
                measure = str2num(sprintf('%.1f',PearsonCorr(time+1,selected_con))); %Value rounded to 0.x (round() does not exist in 2014b)
                thermometer(hAx,measure);
            end
        
        end
        
        fprintf('Time %d\n',time+1);
        
        time = time + 1;
        counter = 0;
    end
    
    currentTime = tbvNetInt.tGetCurrentTimePoint;
    
end