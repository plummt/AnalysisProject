function varargout = addproject(varargin)
% ADDPROJECT MATLAB code for addproject.fig
%      ADDPROJECT, by itself, creates a new ADDPROJECT or raises the existing
%      singleton*.
%
%      H = ADDPROJECT returns the handle to a new ADDPROJECT or the handle to
%      the existing singleton*.
%
%      ADDPROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADDPROJECT.M with the given input arguments.
%
%      ADDPROJECT('Property','Value',...) creates a new ADDPROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before addproject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to addproject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help addproject

% Last Modified by GUIDE v2.5 08-Jul-2014 10:51:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @addproject_OpeningFcn, ...
                   'gui_OutputFcn',  @addproject_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

end
% --- Executes just before addproject is made visible.
function addproject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to addproject (see VARARGIN)

% Choose default command line output for addproject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes addproject wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = addproject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - tobe defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


function projectDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to projectDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projectDirectory as text
%        str2double(get(hObject,'String')) returns contents of projectDirectory as a double
end

% --- Executes during object creation, after setting all properties.
function projectDirectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
startPath = getenv('homepath');
gitPath = uigetdir(startPath, 'Select Project Directory.');
if gitPath ~= 0
    set(handles.projectDirectory, 'String', gitPath);
else
    set(handles.projectDirectory, 'String', 'User Canceled');
end
end

% --- Executes on selection change in deviceType.
function deviceType_Callback(hObject, eventdata, handles)
% hObject    handle to deviceType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns deviceType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from deviceType
end

% --- Executes during object creation, after setting all properties.
function deviceType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deviceType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
workbookFile = 'Project Database.xlsx';
[~,~,subjects] = xlsread(workbookFile,'Device Type');
subjects = [{'Device Type'};subjects];
set(hObject,'String',subjects);
end

% --- Executes on selection change in subjectType.
function subjectType_Callback(hObject, eventdata, handles)
% hObject    handle to subjectType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subjectType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subjectType

end

% --- Executes during object creation, after setting all properties.
function subjectType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
workbookFile = 'Project Database.xlsx';
[~,~,subjects] = xlsread(workbookFile,'Subjects');
subjects = [{'Subject Type'};subjects];
set(hObject,'String',subjects);
end


function projectName_Callback(hObject, eventdata, handles)
% hObject    handle to projectName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projectName as text
%        str2double(get(hObject,'String')) returns contents of projectName as a double
end

% --- Executes during object creation, after setting all properties.
function projectName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in submit.
function submit_Callback(hObject, eventdata, handles)
% hObject    handle to submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
workbookFile = 'Project Database.xlsx';
projectDatabase = readtable(workbookFile,'ReadVariableNames',true);
projName = cellstr(get(handles.projectName,'String'));
projDir = cellstr(get(handles.projectDirectory,'String'));
contents = cellstr(get(handles.deviceType,'String'));
deviceType = contents(get(handles.deviceType,'Value'));
contents = cellstr(get(handles.subjectType,'String'));
subjectType = contents(get(handles.subjectType,'Value'));
Title = 'Error';
test1 = strcmp(projName,'Project Name') ||...
        ismember(projName,projectDatabase.ProjectName);
test2 = exist(projDir{1}, 'dir') ~= 7 ||...
        ismember(projDir,projectDatabase.Location);
test3 = strcmp(deviceType, 'Device Type');
test4 = strcmp(deviceType, 'Subject Type');
if test1
    Message = ['Please Select an Unused Project Name'];
    msgbox(Message,Title);
elseif test2
    Message = ['Please Select an Unused Valid Directory'];
    msgbox(Message,Title);
elseif test3
    Message = ['Please Select a Device Type'];
    msgbox(Message,Title);
elseif test4
    Message = ['Please Select a Subject Type'];
    msgbox(Message,Title);
else
    projectDatabase.ProjectName(end+1) = projName;
    projectDatabase.Location(end) = projDir;
    projectDatabase.DeviceType(end) = deviceType;
    projectDatabase.SubjectType(end) = subjectType;
    sortrows(projectDatabase,1);
    writetable(projectDatabase,workbookFile,'Sheet', 'Project Information');
    close;
end
end

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;
end
