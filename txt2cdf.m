function output = txt2cdf(file,varargin)
%TXT2CDF Will take a text file and create a CDF file from it.
%   Detailed explanation goes here
p = inputParser;
p.FunctionName = 'txt2cdf';
p.addRequired('file',@(x) exist(x,'file')==2);
addParameter(p,'deviceType','Day12');
parse(p,file,varargin{:});
input = p.Results;
if strcmp(input.deviceType, 'Day12')
    [out,path] = day12(input);
end
try
    RewriteCDF(out,path);
catch err
    error('txt2cdf:CDFpreExists', ['The CDF file already exists']);
end
end

function [output,newFilePath]= day12(input)
[path,name] = fileparts(input.file);
output = createstruct();
text = strsplit(name,'_');
SN = text{1};
SerialNumber = SN(4:end);
sn = str2num(SerialNumber)+12000;
RGB = importRGBval(SerialNumber);
date = [text{2} '_' text{3}];
output.GlobalAttributes.creationDate={datenum(date,'yymmdd_HHMM')};
output.GlobalAttributes.deviceModel={'Day12'};
output.GlobalAttributes.deviceSN={num2str(sn)};
output.GlobalAttributes.redCalibration={RGB(1)};
output.GlobalAttributes.greenCalibration={RGB(2)};
output.GlobalAttributes.blueCalibration={RGB(3)};
data = readtable(input.file,'Delimiter','\t');
time = timeconvert(data.Time,'mm/dd/yyyy HH:MM:SS');
output.Variables.time=time;
output.Variables.logicalArray = true(size(time));
output.Variables.illuminance=data.Lux;
output.Variables.CLA=data.CLA;
output.Variables.CS=data.CS;
output.Variables.activity=data.Activity;
newFilePath = [path '\' name '_' getenv('USERNAME') '.cdf'];
end

function output = createstruct()
output = struct('Variables',            [],...
                'GlobalAttributes',     [],...
                'VariableAttributes',   []);
output.GlobalAttributes = struct('creationDate',[],...
                                 'deviceModel',[],...
                                 'deviceSN',[],...
                                 'redCalibration',[],...
                                 'greenCalibration',[],...
                                 'blueCalibration',[],...
                                 'subjectID',{{'NA'}},...
                                 'subjectSex',{{'None'}},...
                                 'subjectDateOfBirth',{{'None'}},...
                                 'subjectMass',{{'0'}});
output.VariableAttributes = struct('description',[],...
                                   'unitPrefix',[],...
                                   'baseUnit',[],...
                                   'unitType',[],...
                                   'otherAttributes',[]);
output.Variables = struct('time', [],...
                          'timeOffset',[],...
                          'logicalArray',[],...
                          'red',[],...
                          'blue',[],...
                          'green',[],...
                          'illuminance',[],...
                          'CLA',[],...
                          'CS',[],...
                          'activity',[]);
output.VariableAttributes.description = {'time','Time of data values collection';
                                         'timeOffset','Offset from UTC';
                                         'logicalArray','True = subject was supposed to be wearing the device';
                                         'red','';
                                         'green','';
                                         'blue','';
                                         'illuminance','Calculated Lux';
                                         'CLA','Circadian Light';
                                         'CS','Circadian Stimulus';
                                         'activity','activity';};
output.VariableAttributes.unitPrefix = {'time','day';
                                        'timeOffset','sec';
                                        'logicalArray','logical';
                                        'red','';
                                        'green','';
                                        'blue','';
                                        'illuminance','lux';
                                        'CLA','lux';
                                        'CS','';
                                        'activity','m\s';};
output.VariableAttributes.baseUnit = {'time','d';
                                      'timeOffset','s';
                                      'logicalArray','';
                                      'red','lx';
                                      'green','lx';
                                      'blue','lx';
                                      'illuminance','lx';
                                      'CLA','CLA';
                                      'CS','CS';
                                      'activity','g_n';};
output.VariableAttributes.unitType = {'time','baseSI';
                                      'timeOffset','baseSI';
                                      'logicalArray','';
                                      'red','namedSI';
                                      'green','namedSI';
                                      'blue','namedSI';
                                      'illuminance','namedSI';
                                      'CLA','nonSI';
                                      'CS','nonSI';
                                      'activity','nonSI';};
output.VariableAttributes.otherAttributes = {'time','';
                                             'timeOffset','Needs to be calculated';
                                             'logicalArray','Needs cropping';
                                             'red','Estimated from illuminance';
                                             'green','Estimated from illuminance';
                                             'blue','Estimated from illuminance';
                                             'illuminance','';
                                             'CLA','model';
                                             'CS','model';
                                             'activity','method';};
end

function newTime = timeconvert(time, format)
    newTime = zeros(size(time));
    for i = 1:length(newTime)
        newTime(i) = datenum(time{i},format);
    end
end

function RGB = importRGBval(id)
path = '\\root\projects\DaysimeterAndDimesimeterReferenceFiles\data\Day12 RGB Values.txt';
RGBval = readtable(path, 'Delimiter','\t');
RGB(1) = RGBval.R(str2num(id));
RGB(2) = RGBval.G(str2num(id));
RGB(3) = RGBval.B(str2num(id));
end