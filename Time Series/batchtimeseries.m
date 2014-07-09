function batchtimeseries
%BATCHTIMESERIES Summary of this function goes here
%   Detailed explanation goes here

% Enable required libraries
[parentDir,~,~] = fileparts(pwd);
% [parentDir,~,~] = fileparts(parentDir);
CDFtoolkitDir = fullfile(parentDir,'LRC-CDFtoolkit');
phasorAnalysisDir = fullfile(parentDir,'PhasorAnalysis');

addpath(CDFtoolkitDir,phasorAnalysisDir,'phasorCompass','phasorDistribution','averaging');

% Select a folder to import
startPath = fullfile([filesep,filesep],'root','public','hulld','Light and Health Institute');
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

for i1 = 1:nCdf
    cdfPath = fullfile(cdfDir,listing(i1).name);
    generatetimeseries(reportDir,cdfPath,hFigure,units);
    % Clear figures
    clf(hFigure);
end

close(hFigure);

end

