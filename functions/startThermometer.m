function [ hAx ] = startThermometer( sz , Trange )
%STARTTHERMOMETER Initialize the thermometer window.
%   Inputs:
%       - sz: Int Vector (2 x 1) - thermometer size in pixels
%       - Trange: Int Vector (1 x 3) - [min step max] values
%   Outputs:
%       - hAx: Axes

% Screen Properties
screensize = get(0,'ScreenSize');
xpos = ceil((screensize(3)-sz(2))/2); % center the figure on the screen horizontally
ypos = ceil((screensize(4)-sz(1))/2); % center the figure on the screen vertically

% Figure
fig = figure('Position',[0, 0, screensize(3), screensize(4)],...
    'Toolbar','none', ...
    'MenuBar','none', ...
    'NumberTitle','off');

set(gcf,'color','k');

hAx = gca;

set(hAx,'Box','on',...
    'units','pixels',...
    'Position',[xpos, ypos, sz(2), sz(1)]);

thermometer(hAx,Trange);

title('Baseline','FontSize',25,'Color','w')

end

