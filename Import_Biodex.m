function Tbiodex=Import_Biodex (file)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to import data from biodex to Matlab
% Author: John Jairo Villarejo Mayor, Ph.D.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% How to use
% Input:
%  - fileID: the location of the file with the extension *.txt
%  - Output: Tbiodex, corresponding to the matrix, arranged in columns as follow
%  Col 1: Time
%  Col 2: Torque
%  Col 3: Position
%  Col 4: Velocity

% How to call 
%
% [filename, pathname] = uigetfile( ...
%     {'*.txt','TXT Files (*.txt)';
%     '*.*',  'All files (*.*)'}, ...
%     'Select a MAT file');
% Tbiodex=Import_Biodex (fullfile(pathname,filename));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileID = fopen(file);
% data=textscan(fileID, '%s%s%s%s%s\n %f%f%f%f%f%*[^\n]');
data=textscan(fileID, '%s%s%s%s%s[^\n]');
data=textscan(fileID, '%s%s%s%s%s[^\n]');
data=textscan(fileID, '%s%s%s%s%s[^\n]');
data=textscan(fileID, '%s%s%s%s%s[^\n]');
data=textscan(fileID, '%s%s%s%s%s[^\n]');
data=textscan(fileID, '%s%s%s%s%s[^\n]');
data=textscan(fileID, '%f%f%f%f%f%[^\n\r]');
fclose(fileID)

Tbiodex=[data{1:end-1}];
clear data fileID



