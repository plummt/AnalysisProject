function varargout = filelocator(varargin)
% FILELOCATOR This will find and save a link to the GITHUB folder for later
% use. It will save the file location inside filelocations.mat inside the
% github\AnalysisProject folder. soon this will be a more robust tool, and
% will be able to look for the files that are passed to it. 

%%  Initialization tasks
f = figure('Visible',   'off',...
           'MenuBar',   'none',...
           'Position',  [360,500,450,100]);
%%  Construct the components
% Text Edit Construction
bColor = 'w';
eText  = uicontrol('Style',             'edit',...
                   'String',            'Click Browse',...
                   'BackgroundColor',   bColor,...
                   'Position',          [135,40,235,20]);
% User instructions Text Construction
bColor = get(f,'Color');
u1Text  = uicontrol('Style',             'text', ...
                    'String',            'GITHUB folder Location:',...
                    'BackgroundColor',   bColor,...
                    'Position',          [5,42.5,125,15]);
instructionsP1 = ['Please select the folder where you have stored the '...
                  'following GitHub Repositories:'];
instructionsP2 = 'LRC-CDFtoolkit and PhasorAnalysis';
instructions =  java_array('java.lang.String', 2);
instructions(1) = java.lang.String(instructionsP1);
instructions(2) = java.lang.String(instructionsP2);
cellInstructions = cell(instructions);
u2Text = uicontrol('Style',             'text', ...
                   'String',            cellInstructions,...
                   'BackgroundColor',   bColor,...
                   'Position',          [5,67.5,445,30]);
% Browse Button Construction
browse = uicontrol('Style',             'pushbutton',...
                   'String',            'Browse', ...
                   'BackgroundColor',   bColor,...
                   'Position',          [375,37.5,70,25],...
                   'Callback',          {@browse_Callback});
% Submit Button Construction
submit = uicontrol('Style',             'pushbutton',...
                   'String',            'Submit', ...
                   'BackgroundColor',   bColor,...
                   'Position',          [301,12.5,70,25],...
                   'Callback',          {@submit_Callback});
% Close Button Construction
close  = uicontrol('Style',             'pushbutton',...
                   'String',            'Close', ...
                   'BackgroundColor',   bColor,...
                   'Position',          [77,12.5,70,25],...
                   'Callback',          {@close_Callback});
%%  Initialization tasks
set(f,'Visible','on');
%%  Callbacks for FILELOCATOR
    function browse_Callback(source,eventdata)
    % this will allow the user to find a directory, and print it to the
    % edit text box. if the user cancels out of the UI then it will print
    % the user canceled.
        startPath = getenv('homepath');
        gitPath = uigetdir(startPath, 'Select GITHUB folder.');
        if gitPath ~= 0
            set(eText, 'String', gitPath); 
        else
            set(eText, 'String', 'User Canceled');
        end
    end

    function submit_Callback(source,eventdata)
    % this function will either put the path from the edit text box into
    % the varargout. If the Directory in the text box is not a valid
    % directory then it will display an error
       gitPath = get(eText,'String');
       if exist(gitPath,'file') == 7
           delete(f);
           varargout = gitPath;
       else
           msgbox('Please Select a proper folder','Error');
       end
    end

    function close_Callback(source,eventdata)
        varargout = 0;
        delete(f);
    end
%%  Utility functions for FILELOCATOR

end