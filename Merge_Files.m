% Merge_Files

global pathname

%% Serial
if ~ischar(pathname)
    pathname='';
end

[name, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select mumltiple TXT files',pathname,'MultiSelect','on');

if isequal(pathname2,0)

   disp('Selection canceled')
else
    
pathname=pathname2;

% oldFolder = cd(pathname);
% ldir=dir ('*.mat');  % Leitura de arquivos com extensão xlsx
% cd(oldFolder);
% 
% name={ldir.name};
% name=name';
% % name([1:2])=[];

datafullFull=[]; Fs2=[]; DataInformation2={};

for ifile=1:length(name)

Datafile=fullfile(pathname, name{ifile});
disp(['You Selected:', name{ifile}])

load(Datafile)

if isempty(datafullFull)
    datafullFull=datafull(:,1);
end
try
ld1=size(datafullFull,1);
ld2=size(datafull,1);
ld=min([ld1 ld2]);
if ld1~=ld2    
    warndlg(strcat('Channel ', num2str(ifile),' has different size of samples'),'Caution!!') 
end

datafullFull=[datafullFull(1:ld,:) datafull(1:ld,2:end)];
catch Err
   stop=1; 
   warndlg(strcat('Channel ', num2str(ifile),' has problems to merge files'),'Caution!!') 
end
if exist('Fs')
    if isempty(Fs2)
        Fs2=Fs;
    elseif Fs~=Fs2
        warndlg('Sampling Frequencies are different between files!','Caution!!') 
    end
end

if exist('DataInformation2')
    if isempty(DataInformation2)
        DataInformation2=DataInformation;
%     elseif DataInformation2~=DataInformation
%         warndlg('Channel information is different between files!','Caution!!') 
    end
    
end

end


datafull=datafullFull;
DataInformation=DataInformation2;
Fs=Fs2;
clear datafullFull

[filename, pathname] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    strcat(pathname));
    
if isequal(filename,0)
   disp('Selection canceled')
else
   try
   Datafile=fullfile(pathname, filename);
   save (Datafile, 'datafull', 'DataInformation','Fs')
   disp(['You Selected:', fullfile(pathname, filename)])
   catch ME
       errordlg('Please, select a file','Error!')
   end
end

    
end