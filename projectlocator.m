function output = projectlocator(varargin)
% PROJECTLOCATOR returns a string to the project that the user selects
% 
% this will offer a list of the projects the user has used previously and
% then will retrun a string containing a path to where the file is located.
% 

%  Initialization tasks
f = figure('Visible',           'on',...
           'MenuBar',           'none',...
           'Position',          [360,500,500,275]);
%  Construct the components
bColor = 'w';
workbookFile = 'Project Database.xlsx';
projectDatabase = readtable(workbookFile,'ReadVariableNames',true);
% ListBox construction
str = projectDatabase.ProjectName;
listBox = uicontrol('Style',              'listbox',...
                    'String',             str,...
                    'BackgroundColor',    bColor,...
                    'Position',           [35,40,235,200]);
% Add button construction
bColor = get(f,'Color');
addProj = uicontrol('Style',              'pushbutton',...
                    'String',             'Add New Project', ...
                    'BackgroundColor',    bColor,...
                    'Position',           [350,200,90,25],...
                    'Callback',           {@add_Callback}); %#ok<*NASGU>
% Submit Button Construction
submit = uicontrol('Style',             'pushbutton',...
                   'String',            'Submit', ...
                   'BackgroundColor',   bColor,...
                   'Position',          [350,140,90,25],...
                   'Callback',          {@submit_Callback});
% Close Button Construction
close  = uicontrol('Style',             'pushbutton',...
                   'String',            'Close', ...
                   'BackgroundColor',   bColor,...
                   'Position',          [350,70,90,25],...
                   'Callback',          {@close_Callback});
uiwait(f);               
%  Initialization tasks

%  Callbacks for Project Locator
    function close_Callback(~,~)
        output = 0;
        delete(f);       
    end
    function submit_Callback(~,~)
        projNum = get(listBox, 'Value');
        output = projectDatabase.Location{projNum};
        delete(f);
    end
    function add_Callback(~, ~)
        addproject();
        uiwait;
        workbookFile = 'Project Database.xlsx';
        projectDatabase = readtable(workbookFile,'ReadVariableNames',true);
        newString = projectDatabase.ProjectName;
        set(listBox, 'String',newString);
    end
%  Utility functions for MYGUI
end