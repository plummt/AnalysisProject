function varargout = plotsubjectname(hFigure,subjectName)
%PLOTSUBJECTNAME Summary of this function goes here
%   hFigure = figure handle

% Create textbox
hName = annotation(hFigure,'textbox');

% Remove box outline and margin
lineStyle = 'none';
set(hName,'LineStyle',lineStyle);

margin = 0;
set(hName,'Margin',margin);

% Add text to box
set(hName,'String',['Subject: ',subjectName]);

% Make sure box resizes to text
fitBoxToText = 'on'; % 'on' or 'off'
set(hName,'FitBoxToText',fitBoxToText);

% Align text in box
horizontalAlignment = 'center';
set(hName,'HorizontalAlignment',horizontalAlignment);

verticalAlignment = 'top';
set(hName,'VerticalAlignment',verticalAlignment);

% Set font properties
fontUnits = 'points';
set(hName,'FontUnits',fontUnits);

fontSize = 24;
set(hName,'FontSize',fontSize);

fontName = 'Helvetica';
set(hName,'FontName',fontName);

fontWeight = 'bold';
set(hName,'FontWeight',fontWeight);

% Position box centered on the bottom of the page
set(hName,'Units','inches');

position = get(hName,'Position'); % get current position and size
paperPosition = get(hFigure,'PaperPosition');

width = position(3);
height = position(4);

paperWidth = paperPosition(3);
paperHeight = paperPosition(4);

left = 0.5*paperWidth - 0.5*width; % Center the textbox
bottom = paperHeight - height;
if bottom < 0
    bottom = 0;
end

position = [left,bottom,width,height];
set(hName,'Position',position);

% Return the text handle if requested
if nargout == 1
    varargout = {hName};
end

end

