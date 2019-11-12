function [] = thermometer(hAx,Trange,Tinit)
% THERMOMETER      Turn an axes into a graphical thermometer display

if ~strcmp(get(hAx,'Type'),'axes')
    error('With 2 or 3 input arguments, the first argument must be an axis handle');
end

if length(Trange)==2 || length(Trange)==3 % --- Case 1: Limits Definition
    
    if length(Trange)==3
        incr = Trange(2);
        Trange = Trange([1 3]);
    else
        incr=5;
    end
    
    if nargin==2    %Did not specify initial temperature
        Tinit = 0;
    end
    
    localInitAxes(hAx,Trange,incr,Tinit);
    
elseif length(Trange)==1 % --- Case 2: Set Temperature
    
    Tnew = Trange;
    localUpdate(hAx,Tnew);   %Trange is now the new temperature
    
else % --- Case 3: Error
    error('Second input argument must be [Tmin Tmax] or Tnew');
end

end

function hPatch = localInitAxes(hAx,Trange,incr,Tinit)
%Are there any thermometer patches on this axis already?  If so, delete
%them
therms = findobj(hAx,'Type','patch','Tag','Thermometer');
if ~isempty(therms)
    delete(therms)
end

set(hAx, ...
    'Color','k', ...
    'XLim',[0 1], ...
    'XTick',[], ...
    'YLim',Trange, ...
    'YTick',0,...
    'LineWidth',2,...
    'XColor','w',...
    'YColor','w');

hPatch = patch([0 1 1 0],[0 0 Tinit Tinit],[0 0 0.5],'Tag','Thermometer');

for i=-0.1+Trange(1):0.1:Trange(2)
    line([0 1],[i i],'Color','w','LineWidth',2);
end

setappdata(hAx,'PatchHandle',hPatch);

end

function hPatch = localUpdate(hAx,T)

hPatch = getappdata(hAx,'PatchHandle');

%Force within valid temperature range
yl = get(hAx,'YLim');
if T < yl(1)
    T = yl(1);
elseif T > yl(2)
    T = yl(2);
end

set(hPatch,'YData',[0 0 T T]);

if T >= 0
    set(hPatch,'FaceColor',[0.7 0.7 0.7]);
else
    set(hPatch,'FaceColor',[0 0 0.5]);
end

end
