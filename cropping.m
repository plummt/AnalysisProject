function cropping
% CROPPING finds and crops a projects data individually for each CDF file
% This will locate a directory that contains any number of CDF files and
% will load them one at a time, in file order and give the user three
% options, a start and end date option, non-compliance, and sleep will
% apear in that order.
% 
% Sleep dates can be stored in either .m, .xls, .xlsx, or .txt files.
% for .m files the dates must be saved as bedTimes, wakeTimes.
% for .xls and .xlsx the format muse be |day|bedTimes|wakeTimes|
% for .txt tiles the same format must be kept as above but they must be
% seperated by tabs.
% 
% For they first two types of cropping you will be asked to select a start
% and end date. To do this you will be given the option to first zoom in to
% the area of the of the graph you want. Then you need to hit any key on
% the keay board and you will be given the option to select the date and 
% you want. 
%
% After each data set is finished being cropped, it will call RewriteCDF
% and will save the files to the directory the user selects

%% Specify directories
loadpath;
projdir = projectlocator;
if projdir ~= 0
    projectDir = uigetdir(projdir,'Select Project File');
    if projectDir == 0
        return
    end
else
    return
end
oldDir = fullfile(projectDir);

newDir = uigetdir(projdir,'Save Location');
if newDir == 0
    return
end
%% Find CDFs in folder
listing = dir([oldDir,filesep,'*.cdf']);
nCdf = numel(listing);

hCrop = figure('Units','normal');

for i1 = 1:nCdf
    %% New File set up
    cdfPath = fullfile(oldDir,listing(i1).name);
    [~,cdfName,cdfExt] = fileparts(cdfPath);
    newName = [cdfName,'_cropped',cdfExt];
    newPath = fullfile(newDir,newName);
    
    %% Load the data
    DaysimeterData = ProcessCDF(cdfPath);
    subjectID = DaysimeterData.GlobalAttributes.subjectID{1};
    timeArray = DaysimeterData.Variables.time;
    csArray = DaysimeterData.Variables.CS;
    activityArray = DaysimeterData.Variables.activity;
    
    %% Provide GUI for cropping of the data
    logicalArray = true(size(timeArray));
    needsCropping = true;
    %% Start and Stop end points cropping
    while needsCropping
        logicalArray = true(size(timeArray));
        plotcrop(hCrop,timeArray,csArray,activityArray,logicalArray)
        plotcroptitle(subjectID,'Select Start of Data');
        zoom(hCrop,'on');
        pause
        [cropStart,~] = ginput(1);
        zoom(hCrop,'out');
        zoom(hCrop,'on');
        plotcroptitle(subjectID,'Select End of Data');
        pause
        [cropStop,~] = ginput(1);
        logicalArray = (timeArray >= cropStart) & (timeArray <= cropStop);
        plotcrop(hCrop,timeArray,csArray,activityArray,logicalArray)
        plotcroptitle(subjectID,'');
        needsCropping = ~cropdialog('Is this data cropped correctly?','Crop Data');
    end
    %% Compliance Cropping
    complianceArray = true(size(timeArray));
    needsCropping = cropdialog('Is there non-compliance in the data?','Compoliance');
    while needsCropping
        plotcrop(hCrop,timeArray,csArray,activityArray,complianceArray & logicalArray )
        plotcroptitle(subjectID,'Select Start of Data');
        zoom(hCrop,'on');
        pause
        [cropStart,~] = ginput(1);
        zoom(hCrop,'out');
        zoom(hCrop,'on');
        plotcroptitle(subjectID,'Select End of Data');
        pause
        [cropStop,~] = ginput(1);
        temp  = not((timeArray >= cropStart) & (timeArray <= cropStop));
        test = logicalArray & temp & complianceArray;
        plotcrop(hCrop,timeArray,csArray,activityArray,test)
        plotcroptitle(subjectID,'');
        needsCropping = ~cropdialog('Is this data cropped correctly?','Crop Data');
        if needsCropping == false
            needsCropping = cropdialog('Is there more non-compliance in the data?','Compliance');
            complianceArray = complianceArray & temp;
        end
    end
    %% Sleep Cropping
    sleep = cropdialog('Is there a sleep log for this data?','Sleep log');
    temp = true(size(timeArray));
    sleepArray = true(size(timeArray));
    while sleep == true
        [fileName, pathName] = uigetfile(...
            {'*.m; *.xls; *.xlsx; *.txt'},...
            'sleep log location');
        if ~isequal(pathName, 0)
            file = fullfile(pathName, fileName);
            [bedTimes, wakeTimes] = importsleeplog(file);
            %             temp2 = true(size(timeArray));
            for i2 = 1:length(bedTimes)
                temp2 = not(timeArray > bedTimes(i2) & ...
                            timeArray < wakeTimes(i2));
                temp = temp & temp2;
            end
            test = logicalArray & temp & complianceArray;
            plotcrop(hCrop,timeArray,csArray,activityArray,test)
            plotcroptitle(subjectID,'');
        else
            'user canceled';
        end
        sleep = ~cropdialog('Is this data cropped correctly?','Crop Data');
        sleepArray = temp;
    end
    set(hCrop,'Visible','off');
    %% Assign the modified variables
    DaysimeterData.Variables.logicalArray = logicalArray;
    DaysimeterData.Variables.complianceArray = complianceArray;
    DaysimeterData.Variables.sleepArray = sleepArray;
    DaysimeterData.VariableAttributes.description{11,1} = 'complianceArrar';
    DaysimeterData.VariableAttributes.description{11,2} = 'compliance Array';
    DaysimeterData.VariableAttributes.unitPrefix{11,1} = 'complianceArray';
    DaysimeterData.VariableAttributes.unitPrefix{11,2} = '';
    DaysimeterData.VariableAttributes.baseUnit{11,1} = 'complianceArray';
    DaysimeterData.VariableAttributes.baseUnit{11,2} = '1';
    DaysimeterData.VariableAttributes.unitType{11,1} = 'complianceArray';
    DaysimeterData.VariableAttributes.unitType{11,2} = 'logical';
    DaysimeterData.VariableAttributes.otherAttributes{11,1} = 'complianceArray';
    DaysimeterData.VariableAttributes.otherAttributes{11,2} = 'modify';
    DaysimeterData.VariableAttributes.description{12,1} = 'sleepLog';
    DaysimeterData.VariableAttributes.description{12,2} = 'Sleep Log';
    DaysimeterData.VariableAttributes.unitPrefix{12,1} = 'sleepLog';
    DaysimeterData.VariableAttributes.unitPrefix{12,2} = 'time';
    DaysimeterData.VariableAttributes.baseUnit{12,1} = 'SleepLog';
    DaysimeterData.VariableAttributes.baseUnit{12,2} = 'minute';
    DaysimeterData.VariableAttributes.unitType{12,1} = 'sleepArray';
    DaysimeterData.VariableAttributes.unitType{12,2} = 'time';
    DaysimeterData.VariableAttributes.otherAttributes{12,1} = 'sleepArray';
    DaysimeterData.VariableAttributes.otherAttributes{12,2} = 'start time, end time';
    
    % time offset program still needs to be created currently set for
    % Portland Oragon
    value = cropdialog(['Is ' int2str(DaysimeterData.Variables.timeOffset/60/60) ' the correct offset?'], 'Offset');
    
    if value == false
        offset = timezone();
        offset = offset*60*60;
    else
        offset = DaysimeterData.Variables.timeOffset;
    end
    DaysimeterData.Variables.timeOffset = offset;
    %% Save new file
    RewriteCDF(DaysimeterData, newPath);
end

close(hCrop);

end

function needsCropping = cropdialog(string, title)
% gives the user a choice if the data is cropped correctly, or not.
button = questdlg(string, title,'Yes','No','Yes');
switch button
    case 'Yes'
        needsCropping = true;
    case 'No'
        needsCropping = false;
    otherwise
        needsCropping = false;
end
end

function plotcrop(hCrop,timeArray,csArray,activityArray,logicalArray2)
% adds the plot to the figure, while taking out the values corrosponding to
% logicalArray2 
figure(hCrop)
clf(hCrop)
for i1 = 1:length(logicalArray2)
   if logicalArray2(i1) == 0
       csArray(i1) = 0;
       activityArray(i1) = 0;
   end
end
plot(timeArray,[csArray, activityArray])
datetick2('x');
legend('Circadian Stimulus','Activity');
end

function plotcroptitle(subjectName,subTitle)
% adds a title to the active matlab figure
hTitle = title({subjectName;subTitle});
set(hTitle,'FontSize',16);

end

function [bedTimes, wakeTimes] = importsleeplog(file)
% imports the sleep log given by file.
[~, ~, ext] = fileparts(file);
switch ext
    case '.m'
        load(file);
    case '.xls'
        % Import sleep log as a table
        [~,~,sleepLogCell] = xlsread(file);
        
        % Initialize the data.BedTime and data.WakeTime arrays
        bedTimes = zeros(length(sleepLogCell)-1,1);
        wakeTimes = zeros(length(sleepLogCell)-1,1);
        
        % Load the data from the cell into the struct
        for i1 = 1:length(data.BedTimes)
            bedTimes(i1) = datenum(sleepLogCell{i1 + 1,2});
            wakeTimes(i1) = datenum(sleepLogCell{i1 + 1,3});
        end
    case '.xlsx'
        % Import sleep log as a table
        [~,~,sleepLogCell] = xlsread(file);
        
        % Initialize the data.BedTime and data.WakeTime arrays
        bedTimes = zeros(length(sleepLogCell)-1,1);
        wakeTimes = zeros(length(sleepLogCell)-1,1);
        
        % Load the data from the cell into the struct
        for i1 = 1:length(bedTimes)
            bedTimes(i1) = datenum(sleepLogCell{i1 + 1,2});
            wakeTimes(i1) = datenum(sleepLogCell{i1 + 1,3});
        end
    case '.txt'
        fileID = fopen(file);
        [sleepCell] = textscan(fileID,'%f%s%s%s%s','headerlines',1);
        bedd = sleepCell{2};
        bedt = sleepCell{3};
        waked = sleepCell{4};
        waket = sleepCell{5};
        bedTimes = zeros(size(bedd));
        wakeTimes = zeros(size(bedd));
        for i1 = 1:length(bedd)
            bedTimes(i1) = datenum([bedd{i1} ' ' bedt{i1}]);
            wakeTimes(i1) = datenum([waked{i1} ' ' waket{i1}]);
        end
        fclose(fileID);
    otherwise
        return
end

end