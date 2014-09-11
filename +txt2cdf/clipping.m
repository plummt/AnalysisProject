function clipping(  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

files = txt2cdf.utilityfunctions.getdelimnamedfiles('header');
for ifile = 1:numel(files)
  table = readtable(files{ifile,1}{1,1},'Delimiter','\t','HeaderLines',5);
  for row = size(table):-1:1
     if (table.Red(row)==13107)&&(table.Green(row)==13107)&&(table.Blue(row)==13107)&&(table.Activity(row)==32767)
        table(row,:) = [];
     end
  end
  % add a rewrite script here for these files, check with greg about header
  % lines
end

end
