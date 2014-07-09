function varargout = plotphasorcompass(phasorMagnitude,phasorAngle,position,units)
%PLOTPHASORCOMPASS Summary of this function goes here
%   Detailed explanation goes here

% Create axes to plot on
hAxes = axes;
set(hAxes,'Units',units);
set(hAxes,'OuterPosition',position);
set(hAxes,'Units','normalized'); % Return to default

phasorplot(phasorMagnitude,phasorAngle,.75,3,6,'top','left',.1);

title(hAxes,'Circadian Stimulus/Activity Phasor');

% Eliminate excess white space
set(hAxes, 'Position', get(gca, 'OuterPosition') - ...
    get(hAxes, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);

% Return the axes handle if requested
if nargout == 1
    varargout = {hAxes};
end

end

