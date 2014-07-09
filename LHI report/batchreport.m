function batchreport
%BATCHREPORT Summary of this function goes here
%   Detailed explanation goes here

% Enable required libraries
[parentDir,~,~] = fileparts(pwd);
CDFtoolkitDir = fullfile(parentDir,'LRC-CDFtoolkit');
phasorAnalysisDir = fullfile(parentDir,'PhasorAnalysis');

addpath(CDFtoolkitDir,phasorAnalysisDir);

% Select a folder to import
startPath = fullfile([filesep,filesep],'root','projects','GSA_Daysimeter');
% startPath = 'testData';
cdfDir = uigetdir(startPath,'Select folder with CDFs to import');

% Find CDFs in folder
listing = dir([cdfDir,filesep,'*.cdf']);
nCdf = numel(listing);

% Select a folder to save reports to
reportDir = uigetdir(startPath,'Select folder to save reports to');

% Prepare the figures
visible = 'on';
[hFigure,~,~,units] = initializefigure(visible);

% Preallocate Output
Output = struct(...
    'subject',               {[]},...
    'phasorMagnitude',       {[]},...
    'phasorAngleHrs',        {[]},...
    'interdailyStability',   {[]},...
    'intradailyVariability', {[]},...
    'averageActivity',       {[]},...
    'averageCS',             {[]},...
    'averageIlluminance',    {[]});

for i1 = 1:nCdf
    cdfPath = fullfile(cdfDir,listing(i1).name);
    Output(i1,1) = generatereport(reportDir,cdfPath,hFigure,units);
    % Clear figures
    clf(hFigure);
end

close(hFigure);

% Save summarized results to Excel file
OutputDataset = struct2dataset(Output);
outputCell = dataset2cell(OutputDataset);
xlsPath = fullfile(reportDir,['!summary_',datestr(now,'yyyy-mm-dd_HH-MM-SS'),'.xlsx']);
xlswrite(xlsPath,outputCell);

end

