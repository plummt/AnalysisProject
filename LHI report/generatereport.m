function Output = generatereport(plotDir,cdfPath,hFigure,units)
%GENERATEREPORT Summary of this function goes here
%   Detailed explanation goes here

%% Preallocate Output struct
Output = struct(...
    'subject',               {[]},...
    'phasorMagnitude',       {[]},...
    'phasorAngleHrs',        {[]},...
    'interdailyStability',   {[]},...
    'intradailyVariability', {[]},...
    'averageActivity',       {[]},...
    'averageCS',             {[]},...
    'averageIlluminance',    {[]});

%% Import data
DaysimeterData = ProcessCDF(cdfPath);

%% Deconstruct data into components
subjectName = DaysimeterData.GlobalAttributes.subjectID{1};

fileName = regexprep([subjectName '_LHI_Report'],'\W','','preservecase');

logicalArray = logical(DaysimeterData.Variables.logicalArray);
timeArray = DaysimeterData.Variables.time(logicalArray);
csArray = DaysimeterData.Variables.CS(logicalArray);
activityArray = DaysimeterData.Variables.activity(logicalArray);
illuminanceArray = DaysimeterData.Variables.illuminance(logicalArray);

%% Analyze data
Phasor = phasoranalysis(timeArray,csArray,activityArray);
Average = daysimeteraverages(csArray,illuminanceArray,activityArray);

%% Specify dimensions of plot areas
x1 = 0.25;
y1 = 3.875-.375;
w1 = 4.5;
h1 = 3+.375;
box1 = [x1,y1,w1,h1];

x2 = 5.375;
y2 = 3.875;
w2 = 4.5;
h2 = 3;
box2 = [x2,y2,w2,h2];

x3 = 0;
y3 = 1.25;
w3 = 5;
h3 = 2;
box3 = [x3,y3,w3,h3];

histWidth = 2;
histHeight = 1.625;

x4 = 5.375;
y4 = 1.25;
w4 = histWidth;
h4 = histHeight;
box4 = [x4,y4,w4,h4];

x5 = 7.875;
y5 = 1.25;
w5 = histWidth;
h5 = histHeight;
box5 = [x5,y5,w5,h5];

x6 = x4;
y6 = .625;
w6 = (x5+histWidth)-x4;
h6 = .125;
box6 = [x6,y6,w6,h6];

%% Make figure active
set(0,'CurrentFigure',hFigure)

%% Plot annotations
plotsubjectname(hFigure,subjectName)

plotfooter(hFigure);

%% Plot data
plotphasorcompass(Phasor.magnitude,Phasor.angleHrs,box1,units);

plotnotes(Phasor,Average,box3,units);

millerplot(timeArray,activityArray,csArray,box2,units);

phasorangdist(Phasor.angleHrs,box4,units)

phasormagdist(Phasor.magnitude,box5,units)

plotnursenote(hFigure,box6,units)

%% Save file to disk
filePath = fullfile(plotDir,fileName);
print(gcf,'-dpdf',filePath,'-painters');

%% Save data to Output struct
Output.subject = subjectName;
Output.phasorMagnitude = Phasor.magnitude;
Output.phasorAngleHrs = Phasor.angleHrs;
Output.interdailyStability = Phasor.interdailyStability;
Output.intradailyVariability = Phasor.intradailyVariability;
Output.averageActivity = Average.activity;
Output.averageCS = Average.cs;
Output.averageIlluminance = Average.illuminance;

end

