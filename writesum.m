function t = writesum
list = getfolders(pwd);
nFiles = numel(list);
s = struct('Method',    'MD5',...
           'Format',    'HEX',...
           'Input',     'File');
for i = 1:nFiles
    file{i} = list{i};
    filePath = fullfile(file{i});
    hash{i} = DataHash(filePath,s);
    
    
end
hash = hash';
file = file';
t=table(file,hash);
writetable(t,'Hashes Database.txt');
end

function folders = getfolders(path)

folders = getAllFiles(path);

for k = length(folders):-1:1
    fname = folders{k};
    [~,name,ext] = fileparts(fname);
    if strcmp(ext,'.asv')
        folders(k) = [ ];
    end
    if strcmp(ext,'.gitignore')
        folders(k) = [ ];
    elseif strcmp(ext,'.gitattributes')
        folders(k) = [ ];
    elseif name(1) == '~'
        folders(k) = [ ];
    elseif strcmp([name,ext], 'Hashes Database.txt')
        folders(k) = [ ];
    end
end
end

function fileList = getAllFiles(dirName)

  dirData = dir(dirName);      %# Get the data for the current directory
  dirIndex = [dirData.isdir];  %# Find the index for directories
  fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
  if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(dirName,x),...  %# Prepend path to files
                       fileList,'UniformOutput',false);
  end
  subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
  validIndex = ~ismember(subDirs,{'.','..','.git','Test_Program'});  %# Find index of subdirectories
                                               %#   that are not '.' or '..'
  for iDir = find(validIndex)                  %# Loop over valid subdirectories
    nextDir = fullfile(dirName,subDirs{iDir});    %# Get the subdirectory path
    fileList = [fileList; getAllFiles(nextDir)];  %# Recursively call getAllFiles
  end

end