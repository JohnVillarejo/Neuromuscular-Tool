% Import_Delsys_Serial

global pathname
% set(handles.Info2,'String','Current task: Import')

if ~ischar(pathname)
    pathname='';
end

pathname = uigetdir(pathname);

if isequal(pathname,0)

   disp('Selection canceled')
else
    
ldir=dir(pathname);
nameTorque={ldir.name};
for i=3:length(nameTorque)

fileDelsys=fullfile(pathname, nameTorque{i});
disp(['You Selected:', fileDelsys])
set(handles.Info2,'String','Busy...')

try
[datafull,LabelsDatainformation] = xlsread(fileDelsys);
LabelsDatainformation=LabelsDatainformation';
Fs=1/(datafull(2,1)-datafull(1,1)); % Frequency of sampling

if Fs>1000 % to set FS to ~1KHz
datafull=datafull(1:2:end,:);
Fs=1/(datafull(2,1)-datafull(1,1)); % Frequency of sampling
end

for i=1:size(datafull,2) % To remove zeros at the end of the columns
    datafull2{i,1}=removeZerosDelsys(datafull(:,i));
    datafull2{i,2}=size(datafull2{i,1},1);    
end

%%
% % Pos
% ind=[1:10 13 15:20 ...
%     21:30 ...
%     31 33 35:40 ...
%     41 43 45:50 ...
%     51 53 55:60 ...
%     61 63 65 67 69 71 73 74 75 76 ...
%     77 79 81:86 ...
%     87 89 91 93];
% 
% ind=[1:10 13 15:20 ...
%     21:30 ...
%     31 33 35:40 ...
%     41 43 45:50 ...
%     51 53 55:60 ...
%     61 63 65 67 69 71 73 74 75 76 ...
%     77 79 81:86 ...
%     87 89 91 93];
% datafull(:,ind)=[];
% colRMS=[3 5 7 9 11 13 15 17];
% dataRMS=datafull(:,[1 colRMS]);
% datafull(:,colRMS)=[];
%
% DataInformation{1}='Time EMG';
% DataInformation{2}='RFD';
% DataInformation{3}='RFE';
% DataInformation{4}='VMD';
% DataInformation{5}='VME';
% DataInformation{6}='BFD';
% DataInformation{7}='BFE';
% DataInformation{8}='GD';
% DataInformation{9}='GE';
% DataInformation{10}='Sync';
%% Pre

% Toma parcial Pre
% % % % ind=3:2:69;
% % % % ind=[ind 6 8 10 12 20 22 24 26 30 32 34 36 40 42 44 46 52 54 56 58 64 66 68 70];
% ind=[1 18 28 38 50]; % electrodes 5 6 7 9
% datafull=datafull(:,ind);
% LabelsDatainformation=LabelsDatainformation(ind);

% Toma full Pre
ind=3:2:53;
ind=[ind 4 14 24 34 44 54 6 8 10 16 18 20 26 28 30 36 38 40 46 48 50];
datafull(:,ind)=[];
LabelsDatainformation(ind)=[];

% % Pós
% ind2=[2 3 4 5 9 11 12];
% datafull(:,ind2)=[];
% LabelsDatainformation(ind2)=[];   

%%
% Toma 1
% ldat=size(datafull,1);
% datafull(ldat,9)=0;

% Toma 2
% datafull2=datafull;
% clear datafull
% datafull(:,1)=datafull2(:,1);
% datafull(:,6:9)=datafull2(:,2:5);
% clear datafull2

for i=1:size(datafull,2) % To remove zeros at the end of the columns
    datafull2{i,1}=removeZerosDelsys(datafull(:,i));
    datafull2{i,2}=size(datafull2{i,1},1);    
end

% DataInformation{1}='Time EMG';
% DataInformation{2}='EMG 2';
% DataInformation{3}='EMG 4';
% DataInformation{4}='EMG 5';
% DataInformation{5}='EMG 6';
% DataInformation{6}='EMG 7';
% DataInformation{7}='EMG 8';
% DataInformation{8}='EMG 9';
% DataInformation{9}='EMG 11';
% DataInformation{10}='Sync';

DataInformation{1}='Time EMG';
DataInformation{2}='RFD';
DataInformation{3}='RFE';
DataInformation{4}='VMD';
DataInformation{5}='VME';
DataInformation{6}='BFD';
DataInformation{7}='BFE';
DataInformation{8}='GD';
DataInformation{9}='GE';
% DataInformation{10}='Sync';

save (strcat(fileDelsys(1:end-5),'.mat'),'datafull','DataInformation','Fs')

% save (strcat(fileDelsys(1:end-5),'.mat'),'datafull','dataRMS','DataInformation','Fs')
% save (fullfile(pathname, filename),'datafull','DataInformation','Fs','Fs2')
catch
    disp(['Error in:', fileDelsys])

end

end

end