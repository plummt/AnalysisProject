function p = txt2cdf2(file,varargin)
%TXT2CDF Will take a text file and create a CDF file from it.
%   Detailed explanation goes here
p = inputParser;
p.FunctionName = 'txt2cdf';
p.addRequired('file',@(x) exist(x,'file')==2);
addParameter(p,'DeviceType','Day12')
parse(p,file,varargin{:});
end