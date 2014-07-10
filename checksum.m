function checksum
p = mfilename('fullpath');
list = getfiles(fileparts(p));
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
t = table(file,hash);
t2 = readtable('Hashes Database.txt');
l = size(t);
m = size(t2);
logic = zeros(m(2),1);
for i = 1:l(1)
    for j = 1:m(1)
        if strcmp(t.hash(i),t2.hash(j))
            logic(i) = true;
        end
    end
end
j = 1;
isUpToDate = true;
for i = 1:length(logic)
    if logic(i) == false
        isUpToDate = false;
        loc(j) = i; 
        j = j + 1;
    end
end
if isUpToDate == false
    for i = 1:length(loc)
        needsUpdateing(i) = t.file(loc(i));
    end
    disp('The following files are out of date from last commit:');
    disp(needsUpdateing');
else
    disp('All files are the same from last Git update.');
end

end

function folders = getfiles(path)
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