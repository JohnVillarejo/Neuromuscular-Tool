function varargout = EMGFatigue(varargin)
% EMGFATIGUE MATLAB code for EMGFatigue.fig
%      EMGFATIGUE, by itself, creates a new EMGFATIGUE or raises the existing
%      singleton*.
%
%      H = EMGFATIGUE returns the handle to a new EMGFATIGUE or the handle to
%      the existing singleton*.
%
%      EMGFATIGUE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EMGFATIGUE.M with the given input arguments.
%
%      EMGFATIGUE('Property','Value',...) creates a new EMGFATIGUE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EMGFatigue_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EMGFatigue_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EMGFatigue

% Last Modified by GUIDE v2.5 17-Mar-2021 19:49:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EMGFatigue_OpeningFcn, ...
                   'gui_OutputFcn',  @EMGFatigue_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before EMGFatigue is made visible.
function EMGFatigue_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EMGFatigue (see VARARGIN)

% Choose default command line output for EMGFatigue
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global Datafile
set(handles.Info,'String',Datafile)

if ~isempty(Datafile)
    
end

% UIWAIT makes EMGFatigue wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EMGFatigue_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in A_Load.
function A_Load_Callback(hObject, eventdata, handles)
% hObject    handle to A_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Datafile filename 

%% Loading Noused1

if ~ischar(pathname)
    pathname='';
end
[filename, pathname] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a MAT file',pathname);

if isequal(filename,0)

   disp('Selection canceled')
else
   disp(['You Selected:', fullfile(pathname, filename)])
   Datafile=strcat(pathname,filename);
   set(handles.Info,'String',Datafile)

load (Datafile)

%%
if exist('datafull','var')

sizeData=size(datafull);
set(handles.Panel_Info1,'Visible','off')
set(handles.Panel_Info2,'Visible','on')
set(handles.I1,'String',{['Data size: ',num2str(sizeData)]})
set(handles.PanelFigure,'Visible','on');
set(handles.PanelFigure2,'Visible','off');
set(handles.PanelFigure3,'Visible','off');

% Fs=1/datafull(2,1); % Frequency of sampling

% flagEstimulus = questdlg('Do you want to M_load the trigger?','Select to continue');
% if strcmp(flagEstimulus,'Yes')

%% Detect EMG channels
lch=length(DataInformation);
flag=false;
indEMG=[];
txtEMG={'Select EMG Channel'};

flagerror=0;

for i=1:lch
    try
    flag=strcmp(DataInformation{i}(1:3),'EMG');
    if flag
        indEMG=[indEMG i];
        txtEMG=[txtEMG DataInformation{i}];
%     else
%         flag=true;
    end
    catch
        warndlg('EMG channels can not be detected','Warning') 
    end
end

if length(indEMG)>1
    
    set(handles.selectionEMGchannel,'String',txtEMG)
    
elseif isempty(indEMG)
    warndlg({['EMG channels are missing!: F',filename]}','Warning!')
end

%% Graphic

GraphicAxes

% figure

% 
% axes(handles.axes3), hold on
% plot(datafull(:,1),datafull(:,2)), axis tight
% ylabel(DataInformation{2})
% axis([datafull(1,1) datafull(end,1) min(datafull(:,2))*1.1 max(datafull(:,2))*1.1])
% if exist('marks') && sizeData(2)>=5 
%     plot(datafull(:,1),datafull(:,5)*max(datafull(:,2)),'c')
% if ~isempty(marks)
%     plot(marks/Fs+datafull(1,1),0,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
% end
% end
% 
% if sizeData(2)>=3 
% axes(handles.axes4), hold on
% plot(datafull(:,1),datafull(:,3)), axis tight
% ylabel(DataInformation{3})
% axis([datafull(1,1) datafull(end,1) min(datafull(:,3))*1.1 max(datafull(:,3))*1.1])
% if exist('marks') && sizeData(2)>=5 
%     plot(datafull(:,1),datafull(:,5)*max(datafull(:,3)),'c')
%     if ~isempty(marks)
%         plot(marks/Fs+datafull(1,1),0,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
%     end
% end
% end
% 
% if sizeData(2)>=4
% axes(handles.axes5), hold on
% plot(datafull(:,1),datafull(:,4)), axis tight
% xlabel('Time [s]')
% ylabel(DataInformation{4})
% if exist('marks') && sizeData(2)>=5 
%     plot(datafull(:,1),datafull(:,5)*max(datafull(:,4)),'c')
%     if ~isempty(marks)
%         plot(marks/Fs+datafull(1,1),0,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
%     end
% end
% end
%%
set(handles.t1,'String',['Ch1: ',DataInformation{1}])
try set(handles.t2,'String',['Ch2: ',DataInformation{2}]), catch set(handles.t5,'String','Ch5: Empty'), end
try set(handles.t3,'String',['Ch3: ',DataInformation{3}]), catch set(handles.t5,'String','Ch5: Empty'), end
try set(handles.t4,'String',['Ch4: ',DataInformation{4}]), catch set(handles.t5,'String','Ch5: Empty'), end
try set(handles.t5,'String',['Ch5: ',DataInformation{5}]), catch set(handles.t5,'String','Ch5: Empty'), end
try set(handles.t6,'String',['Ch6: ',DataInformation{6}]), catch set(handles.t6,'String','Ch6: Empty'), end

[a,b]=size(datafull);
set(handles.t7,'String',['Mat Data: ',num2str(a),'X',num2str(b)])
set(handles.t8,'String',['Fs: ',num2str(Fs),' Hz'])


% else

% axes(handles.axes3)
% axes(handles.axes4)
% plotchannel(datafull(:,1),datafull(:,3)), axis tight
% ylabel('EMG')
% axes(handles.axes5)
% plotchannel(datafull(:,1),datafull(:,4)), axis tight
% xlabel('Time [s]')
% ylabel('Torque [Nm]')

% end
set(handles.A_AnalysisMenu,'Enable','on')

else    
    warndlg('The file is invalid: The variable "datafull" is missing')
end

end


function Info_Callback(hObject, eventdata, handles)
% hObject    handle to Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Info as text
%        str2double(get(hObject,'String')) returns contents of Info as a double


% --- Executes during object creation, after setting all properties.
function Info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in A_peaks.
function A_peaks_Callback(hObject, eventdata, handles)
% hObject    handle to A_peaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Datafile pathname

set(handles.A_filtering,'Enable','off')
set(handles.B_CalTorque,'Enable','off')
set(handles.A_AnalysisMenu,'Enable','off')
set(handles.A_peaks,'Enable','off')
set(handles.B_Onset_Hilbert,'Enable','off')
set(handles.removePeak,'Enable','off')
set(handles.A_Load,'Enable','off')

% ch=2;
ch=get(handles.popchPeak,'Value'); % Get the channel from the interface
load (Datafile)
set(handles.Info,'String',Datafile)
set(handles.Info2,'String','Current task: Peaks')

if size(datafull,2)>=ch
    
lsig=size(datafull(:,ch),1); % channel of EMG used to detect peaks

[trigger,marks]=peakdetection (datafull(:,ch),Fs,handles);
% trigger(find(~trigger))=-inf;
% marks=marks+datafull(1,1); % correção no caso de não começar em 0s

datafull(:,5)=trigger; % new column with times of peaks
sizeData=size(datafull);

set(handles.Panel_Info1,'Visible','off')
set(handles.Panel_Info2,'Visible','on')
set(handles.I1,'String',{['Datafull size: ',num2str(sizeData)]})
set(handles.I2,'String',{['Num peaks: ',num2str(length(marks))]})

% Figures to show peaks
axes(handles.axes1),cla
axes(handles.axes2),cla
axes(handles.axes3),cla
axes(handles.axes4),cla
axes(handles.axes5),cla
axes(handles.axes6),cla

set(handles.axes3,'Visible','off')
set(handles.axes4,'Visible','off')
set(handles.axes5,'Visible','off')
set(handles.axes1,'Visible','on')
set(handles.axes2,'Visible','on')
set(handles.axes6,'Visible','on')
threshold=str2num(get(handles.input1,'String'));
th = max(abs(datafull(:,ch)))*threshold;

axes(handles.axes1)
cla
hold on
plot([datafull(1,1) datafull(end,1)],ones(2,1)*th,'r') % threshold
plot(datafull(:,1),abs(datafull(:,ch))), axis tight
hold off
% ylabel('Torque [Nm]')
ylabel(DataInformation{ch})
axis([datafull(1,1) datafull(end,1) min(abs(datafull(:,ch))) max(abs(datafull(:,ch)))])
legend({'Treshold'})

axes(handles.axes2)
plot(datafull(:,1),datafull(:,5)) % Peaks
axis([datafull(1,1) datafull(end,1) 0 max(datafull(:,5))])

set(handles.axes6,'Visible','on')
axes(handles.axes6),cla
cla, hold on   
% subplot(211)
plot(datafull(:,1),datafull(:,ch),'c') 
% y=get(gca,'ylim');
% stem(repelem(datafull(marks,1),2),repmat(y,1,length(marks))), 
% get(gca,'YLim')
% 
plot(datafull(:,1),datafull(:,5)*max(datafull(:,ch)))
if ~isempty(marks)
    plot(marks/Fs+datafull(1,1),0,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
    plot(marks/Fs+datafull(1,1),0,'sk','MarkerFaceColor',[.1 .49 .30],'MarkerSize',5)
end
axis([datafull(1,1) datafull(end,1) min(datafull(:,ch))-min(datafull(:,ch))*0.3 max(datafull(:,ch))*1.05])
xlabel('Time [s]')
title('Peaks')
legend({strcat('',DataInformation{ch}),'Peaks'})
% % figure
% % subplot(311)
% % % plotchannel(datafull(:,1),datafull(:,2))
% % plotchannel(datafull(:,1),trigger)
% % subplot(312)
% % plotchannel(datafull(:,1),emgdata)
% % subplot(313)
% % % plotchannel(datafull(:,1),datafull(:,4))
% % plotchannel(datafull(:,1),torque)
% subplot(311)
% plotchannel(datafull(:,1),datafull(:,2)), axis tight
% ylabel('Elect Stim')
% subplot(312)
% plotchannel(datafull(:,1),datafull(:,3)), axis tight
% ylabel('EMG')
% subplot(313)
% plotchannel(datafull(:,1),datafull(:,4)), axis tight
% xlabel('Time [s]')
% ylabel('Torque [Nm]')

% Datafile=strcat(Datafile(1:end-4),'2');
% save(Datafile,'datafull','trigger','emgdata','torque','marks','DataInformation','Fs')

if strcmp(Datafile(end-8:end-4),'Peaks')
    name=Datafile;
else
    name=strcat(Datafile(1:end-4),'_Peaks');
end
[filename, pathname] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    name);
    
if isequal(filename,0)
   disp('Selection canceled')
else
   Datafile=fullfile(pathname, filename);
   try
   save(Datafile,'datafull','marks','DataInformation','Fs')
   disp(['You Selected:', fullfile(pathname, filename)])
   set(handles.Info,'String',fullfile(pathname, filename))
   set(handles.Info2,'String','The file was successfully saved!')
   catch ME
       errordlg('Please, select a file','Error!')
   end  
end

else
    errordlg('The channel for peaks detection is invalid!')
end

set(handles.A_filtering,'Enable','on')
set(handles.B_CalTorque,'Enable','on')
set(handles.A_AnalysisMenu,'Enable','on')
set(handles.A_peaks,'Enable','on')
set(handles.B_Onset_Hilbert,'Enable','on')
set(handles.removePeak,'Enable','on')
set(handles.A_Load,'Enable','on')

% --- Executes on button press in A_import.
function A_import_Callback(hObject, eventdata, handles)
% hObject    handle to A_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Datafile flagEstimulus 
set(handles.Info2,'String','Current task: Import')

if ~ischar(pathname)
    pathname='';
end
[filename, pathname2] = uigetfile( ...
    {'*.txt','TXT Files (*.txt)';
    '*.*',  'All files (*.*)'}, ...
    'Select the TXT file',pathname);

if isequal(filename,0)
   
   disp('Selection canceled')
else

pathname=pathname2;
disp(['You Selected:', fullfile(pathname, filename)])
[data]=import_txt(pathname,filename);
% [eje_f,mag_ss]=espectro(datafull(:,4),2000);   

remove=find(isnan(data(1,:))); % search for NaN in the first line 
data(:,remove)=[];
sizeData=size(data);
% flagEstimulus = questdlg('To load the the first channel','Select to continue');
% if strcmp(flagEstimulus,'Yes')

set(handles.Panel_Info1,'Visible','off')
set(handles.Panel_Info2,'Visible','on')
set(handles.I1,'String',{['Data size: ',num2str(sizeData)]})
%% Labels and channels configuration
if strcmp(get(handles.PanelEdit,'Visible'),'off')
    set(handles.PanelEdit,'Visible','on')
end
% Conf Lindomar
% set(handles.CH1,'String','Time')
% set(handles.CH2,'String','Torque')
% set(handles.CH3,'String','Sync')
% set(handles.CH4,'String','EMG RE')
% set(handles.CH5,'String','EMG VM')
% set(handles.CH6,'String','EMG VL')
% set(handles.CH7,'String','None')
% set(handles.popch1,'Value',2);
% set(handles.popch2,'Value',3);
% set(handles.popch3,'Value',4);
% set(handles.popch4,'Value',5);
% set(handles.popch5,'Value',6);
% set(handles.popch6,'Value',7);
% set(handles.popch7,'Value',1);

% % config Vinicius
% set(handles.CH1,'String','Time')
% set(handles.CH2,'String','Torque')
% set(handles.CH3,'String','EMG VL')
% set(handles.CH4,'String','EMG BF')
% set(handles.CH5,'String','None')
% set(handles.CH6,'String','None')
% set(handles.CH7,'String','None')
% set(handles.popch1,'Value',2);
% set(handles.popch2,'Value',3);
% set(handles.popch3,'Value',4);
% set(handles.popch4,'Value',5);
% set(handles.popch5,'Value',1);
% set(handles.popch6,'Value',1);
% set(handles.popch7,'Value',1);

% config Luana
% set(handles.CH1,'String','Time')
% set(handles.CH2,'String','Torque')
% set(handles.CH3,'String','Sync')
% set(handles.CH4,'String','EMG VL')
% set(handles.CH5,'String','EMG BF')
% set(handles.CH6,'String','None')
% set(handles.CH7,'String','None')
% set(handles.popch1,'Value',2);
% set(handles.popch2,'Value',3);
% set(handles.popch3,'Value',4);
% set(handles.popch4,'Value',5);
% set(handles.popch5,'Value',1);
% set(handles.popch6,'Value',1);
% set(handles.popch7,'Value',1);

% Conf Mariane

% datafull(:,1)=data(:,ch1); % Time
% datafull(:,2)=data(:,ch3); % Sync
% datafull(:,3)=data(:,ch4); % EMG RE
% datafull(:,4)=data(:,ch2); % Torque
% datafull(:,5)=data(:,ch5); % EMG VM
% datafull(:,6)=data(:,ch6); % EMG VL

% DataInformation{ch1}='Time';
% DataInformation{ch2}='EMG BF';
% DataInformation{ch3}='EMG VL';
% DataInformation{ch4}='Torque';   
% datafull(:,1)=data(:,ch1); % Time
% datafull(:,2)=data(:,ch2); % EMG BF
% datafull(:,3)=data(:,ch3); % EMG VL
% datafull(:,4)=data(:,ch4); % Torque
%%
if iscell(data)
    disp('Error: Data is a cell instead a matrix!')
end

ch1=get(handles.popch1,'Value')-1;
DataInformation{ch1}=get(handles.CH1,'String');
datafull(:,1)=data(:,ch1);
if sizeData(2)>=2 
    ch2=get(handles.popch2,'Value')-1; 
    DataInformation{ch2}=get(handles.CH2,'String');
    datafull(:,2)=data(:,ch2);
end
if sizeData(2)>=3 
    ch3=get(handles.popch3,'Value')-1; 
    DataInformation{ch3}=get(handles.CH3,'String');
    datafull(:,3)=data(:,ch3);
end
if sizeData(2)>=4 
    ch4=get(handles.popch4,'Value')-1; 
    DataInformation{ch4}=get(handles.CH4,'String');
    datafull(:,4)=data(:,ch4);
end
if sizeData(2)>=5 
    ch5=get(handles.popch5,'Value')-1; 
    DataInformation{ch5}=get(handles.CH5,'String');
    datafull(:,5)=data(:,ch5);
end
if sizeData(2)>=6 
    ch6=get(handles.popch6,'Value')-1; 
    DataInformation{ch6}=get(handles.CH6,'String');
    datafull(:,6)=data(:,ch6);
end
if sizeData(2)>=7 
    ch7=get(handles.popch7,'Value')-1; 
    DataInformation{ch7}=get(handles.CH7,'String');
    datafull(:,7)=data(:,ch7);
end

% DataInformation{ch1}=get(handles.CH1,'String');
% if sizeData>=2 DataInformation{ch2}=get(handles.CH3,'String'); end
% if sizeData>=3 DataInformation{ch3}=get(handles.CH4,'String'); end
% if sizeData>=4 DataInformation{ch4}=get(handles.CH2,'String'); end
% if sizeData>=5 DataInformation{ch5}=get(handles.CH5,'String'); end
% if sizeData>=6 DataInformation{ch6}=get(handles.CH6,'String'); end
% if sizeData>=7 DataInformation{ch7}=get(handles.CH7,'String'); end

%%
clear data

Fs=1/(datafull(2,1)-datafull(1,1)); % Frequency of sampling
% if Fs==2000 % to make resampling, from 2k to 1k
%     datafull=datafull(1:2:end,:);
%     Fs=1/(datafull(2,1)-datafull(1,1)); % Frequency of sampling
% end
set(handles.I2,'String',{['Sampling [Hz]: ',num2str(Fs)]})

%% Graphic

GraphicAxes

% axes(handles.axes1),cla,ylabel('')
% axes(handles.axes2),cla,ylabel('')
% axes(handles.axes3),cla,ylabel('')
% axes(handles.axes4),cla,ylabel('')
% axes(handles.axes5),cla,ylabel('')
% axes(handles.axes6),cla,ylabel('')
% 
% set(handles.axes1,'Visible','off')
% set(handles.axes2,'Visible','off')
% set(handles.axes3,'Visible','on')
% set(handles.axes4,'Visible','on')
% set(handles.axes5,'Visible','on')
% set(handles.axes6,'Visible','off')
% 
% if sizeData(2) >=2
%     axes(handles.axes3)
%     plot(datafull(:,1),datafull(:,2)), axis tight
%     % ylabel('EMG')
%     ylabel(DataInformation{ch2})
%     axis([datafull(1,1) datafull(end,1) min(datafull(:,2))*1.1 max(datafull(:,2))*1.1])
% end
% if sizeData(2) >=3
%     axes(handles.axes4)
%     plot(datafull(:,1),datafull(:,3)), axis tight
%     % ylabel('EMG')
%     ylabel(DataInformation{ch3})
%     axis([datafull(1,1) datafull(end,1) min(datafull(:,3))*1.1 max(datafull(:,3))*1.1])
% end
% if sizeData(2) >=4
%     axes(handles.axes5)
%     plot(datafull(:,1),datafull(:,4)), axis tight
%     xlabel('Time [s]')
%     % ylabel('Torque [Nm]')
%     ylabel(DataInformation{ch4})
%         
% end
%%
% flag = questdlg('Do you want to cut the signal?','Select to continue');
% 
% if strcmp(flag,'Yes')
%     [x,y]=ginput(1);
%     x=round(x*1000);
%     datafull=datafull(x:end,:);
% end

[filename, pathname] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    strcat(pathname,filename(1:end-4)));
    
if isequal(filename,0)
   disp('Selection canceled')
else
   try
   Datafile=fullfile(pathname, filename);
   save (Datafile, 'datafull', 'DataInformation','Fs')
   disp(['You Selected:', fullfile(pathname, filename)])
   set(handles.Info,'String',fullfile(pathname, filename))
   set(handles.Info2,'String','The file was successfully saved!')
   catch ME
       errordlg('Please, select a file','Error!')
   end
end
set(handles.PanelEdit,'Visible','off')

end


% --- Executes on button press in B_Edit.
function B_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to B_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Datafile
set(handles.Info2,'String','Current task: Spectrum')

if ~isempty(Datafile)
    
load(Datafile) % Load the file with the data
set(handles.Info,'String',Datafile)

if ~exist('Fs','var')
    Fs=1/(datafull(2,1)-datafull(1,1)); % Frequency of sampling
end
for i=2:size(datafull,2)
    [ejef,s]=espectro(datafull(:,i),Fs,1);
%     figure,spectrogram(datafull(:,i),256,128,1024,Fs);
end

else
    errordlg('Select the file to be loaded!')
end

% --- Executes on button press in B_Edit.
function B_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to B_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Datafile pathname
set(handles.Info2,'String','Current task: Spectrum')

if ~ischar(pathname)
    pathname='';
end
[filename, pathname] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a MAT file',pathname);

if isequal(filename,0)

   disp('Selection canceled')
else
   disp(['You Selected:', fullfile(pathname, filename)])
   Datafile=strcat(pathname,filename);
   set(handles.Info,'String',Datafile)

load (Datafile)

% if ~exist('Fs')
%     Fs=1/(datafull(2,1)-datafull(1,1)); % Frequency of sampling
% end
% for i=2:size(datafull,2)
%     [ejef,s]=espectro(datafull(:,i),Fs,1);
% end
    
set(handles.PanelFigure,'Visible','on');
set(handles.PanelFigure2,'Visible','off');
% datafull(:,2:end)=datafull(:,2:end)*1E06;
% Frms(:,2:end)=Frms(:,2:end)*1E06;
sized=size(datafull,2);

for ch=2:sized
maincicle=1;

while maincicle
% % espectro(datafull(:,ch),Fs,1);    
% n=1;
% cut=[58 62];
% [z,p,k] = butter(n,cut/(Fs/2),'stop');
% [b,a] = zp2tf(z,p,k);
% datafull(:,ch) = filtfilt(b,a,datafull(:,ch));
% % espectro(datafull(:,ch),Fs,1);
    
axes(handles.axes3)
cla
[eje_f,mag_ss]=espectro(datafull(:,ch),Fs,0);
plot(eje_f,mag_ss(1:length(eje_f)),'r')
xlabel('Frequency [Hz]')
ylabel('Power Spectrum')
clear mag_ss eje_f

axes(handles.axes6)
cla, hold on   
% subplot(211)
plot(datafull(:,1),datafull(:,ch),'g') 
% plot(Frms(:,1),Frms(:,ch),'r')
% ipt = findchangepts(Frms(:,ch));
% alarm = envelop_hilbert(Frms(:,ch),2,1,1,0);
onset = envelop_hilbert(datafull(:,ch),100,1,50,0);
xl=length(onset); xonset=(1/xl:1/xl:1)*Frms(end,1);
plot(xonset,onset*max(datafull(:,ch)),'-k')
axis tight

xlabel('Time [s]')
ylabel(DataInformation{ch})
title('')
legend({DataInformation{ch},'RMS'})

% [x,y]=ginput(2);
% x=round(x*Fs);
% seg=datafull(x(1):x(2),ch);
% axes(handles.axes3), cla
% [eje_f,mag_ss]=espectro(seg,Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% pause()
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
button=questdlg('Edit signals?','','FFT','Remove','Continue','Cancel');

switch button

    case 'FFT'
        spec=1;
        while spec
            [x,y]=ginput(2);
            x=round(x*Fs);
            seg=datafull(x(1):x(2),ch);
            axes(handles.axes3), cla
            [eje_f,mag_ss]=espectro(seg,Fs,0);
            plot(eje_f,mag_ss(1:length(eje_f)),'r')
            button=questdlg('Do you want to repeat?','','Yes','No','No');
            if strcmp(button,'No')
                spec=0;
            end
        end
    case 'Remove'
        rem=1;
        while rem
            [x,y]=ginput(2);

            [a,samp1]=min(abs(Frms(:,1)-x(1)));
            [a,samp2]=min(abs(Frms(:,1)-x(2)));

            x=round(x*Fs);
            lx=x(2)-x(1);
            datafulltemp=datafull;
            Frmstemp=Frms;
            datafull(x(1):x(2),ch)=zeros(lx+1,1);

            Frms(samp1:samp2,ch)=zeros(samp2-samp1+1,1);

            axes(handles.axes6)
            cla, hold on   
            plot(datafull(:,1),datafull(:,ch),'b') 
            plot(Frms(:,1),Frms(:,ch),'r')
            axis tight
            button=questdlg('It is OK?','','Yes','No','Yes');
            if strcmp(button,'Yes')
                rem=0;
            else
                datafull=datafulltemp;
                Frms=Frmstemp;
                plot(datafull(:,1),datafull(:,ch),'g') 
                onset = envelop_hilbert(datafull(:,ch),100,1,50,0);
                xl=length(onset); xonset=(1/xl:1/xl:1)*Frms(end,1);
                plot(xonset,onset*max(datafull(:,ch)),'-k')
                axis tight
                clear datafulltemp Frmstemp
            end
        end
    case 'Continue'
        maincicle=0;
end


end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set(handles.PanelFigure,'Visible','on');
% set(handles.PanelFigure2,'Visible','off');
% 
% for ch=2:sized-4
% 
% axes(handles.axes3)
% cla
% [eje_f,mag_ss]=espectro(datafull(:,ch),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% xlabel('Frequency [Hz]')
% ylabel('Power Spectrum')
% clear mag_ss eje_f
% 
% axes(handles.axes6)
% cla, hold on   
% % subplot(211)
% plot(datafull(:,1),datafull(:,ch),'b') 
% plot(Frms(:,1),Frms(:,ch),'r')
% axis tight
% 
% xlabel('Time [s]')
% ylabel(DataInformation{ch})
% title('')
% legend({DataInformation{ch},'RMS'})
% 
% button=questdlg('Spectrum by segments?','','Yes','No','No');
% 
% if strcmp(button,'Yes')
%     [x,y]=ginput(2);
%     x=round(x*Fs);
%     seg=datafull(x(1):x(2),ch);
%     axes(handles.axes3), cla
%     [eje_f,mag_ss]=espectro(seg,Fs,0);
%     plot(eje_f,mag_ss(1:length(eje_f)),'r')
% end
% 
% cont=0;
% while ~cont
% button=questdlg('Do you want to remove a segment?','','Yes','No','Yes');
% if strcmp(button,'Yes')
%     [x,y]=ginput(2);
% 
%     [a,samp1]=min(abs(Frms(:,1)-x(1)));
%     [a,samp2]=min(abs(Frms(:,1)-x(2)));
%     
%     x=round(x*Fs);
%     lx=x(2)-x(1);
%     datafull(x(1):x(2),ch)=zeros(lx+1,1);
%     
%     Frms(samp1:samp2,ch)=zeros(samp2-samp1+1,1);
%     
%     axes(handles.axes6)
%     cla, hold on   
%     plot(datafull(:,1),datafull(:,ch),'b') 
%     plot(Frms(:,1),Frms(:,ch),'r')
%     axis tight
% 
% elseif strcmp(button,'No')
%     cont=1;
% end
% 
% end
% 
% % button=questdlg('Do you want to cut other segment?','','Yes','No','Yes');
% 
% 
% % plot([x x],[min(datafull(:,ch)) max(datafull(:,ch))],'--k')
% % plot([x-0.25 x-0.25],[min(datafull(:,ch)) max(datafull(:,ch))],'-r')
% % plot([x+0.25 x+0.25],[min(datafull(:,ch)) max(datafull(:,ch))],'-r')
% % 
% % legend({DataInformation{ch},'RMS','Center'})
% 
% hold off
% end
% 
% end


Datafile=strcat(Datafile(1:end-4),'_Edit.mat');

try
    save(Datafile,'datafull','DataInformation','Fs','Frms','Param','onset','xonset')
    set(handles.Info,'String',Datafile)
    disp(['You Selected:', Datafile])
    set(handles.Info2,'String','The file was successfully saved!')
catch
   errordlg('Error saving file','Error')
end


end


% --- Executes on button press in A_filtering.
function A_filtering_Callback(hObject, eventdata, handles)
% hObject    handle to A_filtering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Datafile pathname
set(handles.Info2,'String','Current task: Filtering')

set(handles.Info,'String',Datafile)

if ~isempty(Datafile)
    load (Datafile)
    set(handles.Info,'String',Datafile)

    if exist('datafull','var')     
        
set(handles.A_filtering,'Enable','off')
set(handles.B_CalTorque,'Enable','off')
set(handles.A_AnalysisMenu,'Enable','off')
set(handles.A_peaks,'Enable','off')
set(handles.B_Onset_Hilbert,'Enable','off')
set(handles.removePeak,'Enable','off')
set(handles.A_Load,'Enable','off')

%% Troca de canais durante os testes
% temp=datafull(:,2);
% datafull(:,2)=datafull(:,4);
% datafull(:,4)=temp;
% clear temp


%% Detect Torque channel
indTorque=length(DataInformation);
flag=false;
while ~flag
    flag=strcmp(DataInformation{indTorque},'Torque');
    if ~flag
        indTorque=indTorque-1;
%     else
%         flag=true;
    end
end

%%
sizeData=size(datafull);
cleaner=0;
while cleaner==1

    figure
    plot(datafull(:,indTorque),'k')  
    title('Select the start and end points to cut the signal')
    axis tight
    
    button = questdlg('Do you want to cut the signal?','Select to continue');
    if strcmp(button,'Yes')
        warndlg('Press any key to continue!','Heim!!')         
        pause
        [x,y] = ginput(2);        
        x=round(x);
        plot(datafull(x(1):x(2)),datafull(x(1):x(2),3),'k')

    button = questdlg('Do you want to Continue?','Select to continue');
    if strcmp(button,'Yes')
        datafullTemp=datafull;
        clear datafull
%         datafull(:,1)=datafullTemp(x(1):x(2),1);
%         datafull(:,2)=sig(x(1):x(2));
%         datafull(:,3)=datafullTemp(x(1):x(2),3);
%         datafull(:,4)=datafullTemp(x(1):x(2),4);
        datafull=datafullTemp(x(1):x(2),:);
        datafull(:,1)=datafull(:,1)-round(x(1))/1000;
        
        cleaner=0;
    end
    
    else 
        cleaner=0;
    end
end

% if Fs==1000
% n=8;
% cut=8;
% [z,p,k] = butter(n,cut/(Fs/2));
% [b,a] = zp2tf(z,p,k);
% torque = filtfilt(b,a,datafull(:,indTorque));
% elseif Fs==2000
% n=2;
% cut=100;
% [z,p,k] = butter(n,cut/(Fs/2));
% [b,a] = zp2tf(z,p,k);
% torque = filtfilt(b,a,datafull(:,indTorque));
% % figure;plot(torque)
% end
n=8;
cut=8;
[z,p,k] = butter(n,cut/(Fs/2));
[b,a] = zp2tf(z,p,k);
torque = filtfilt(b,a,datafull(:,indTorque));

datafull(:,indTorque)=torque;

cleaner=0;
while cleaner==1

%     axes(handles.axes3), hold off
%     plot(datafull(:,1),datafull(:,2)), axis tight
%     ylabel('Stimulus')
%     axes(handles.axes4), hold off
%     plot(datafull(:,1),datafull(:,3)), axis tight
%     ylabel('EMG')
%     axes(handles.axes5), hold off
%     plot(datafull(:,1),datafull(:,4)), axis tight
%     xlabel('Time [s]')
%     ylabel('Torque [Nm]')

    axes(handles.axes3), hold off
    plot(datafull(:,1),datafull(:,2)), axis tight
    ylabel(DataInformation{2})
    axis([datafull(1,1) datafull(end,1) min(datafull(:,2))*1.1 max(datafull(:,2))*1.1])
    if sizeData(2) >=3
    axes(handles.axes4), hold off
    plot(datafull(:,1),datafull(:,3)), axis tight
    ylabel(DataInformation{3})
    axis([datafull(1,1) datafull(end,1) min(datafull(:,3))*1.1 max(datafull(:,3))*1.1])
    end
    if sizeData(2) >=4
    axes(handles.axes5), hold off
    plot(datafull(:,1),datafull(:,4)), axis tight
    xlabel('Time [s]')
    ylabel(DataInformation{4})
    end

    button = questdlg('Do you want to cut the signal?','Select to continue'); 
    str=('Select the start and the end points to cut the signal');
    set(handles.textaxes5,'Visible','on','String',str)
    if strcmp(button,'Yes')
        warndlg({'Select the start and the end points to cut the signal','Press any key to continue!'},'Heim!!') 
        pause
        [x1,y] = ginput(1);
        hold on
        plot([x1 x1+.1],[min(datafull(:,4)) max(datafull(:,4))],'-.k')
        [x2,y] = ginput(1);
        plot([x2 x2+.1],[min(datafull(:,4)) max(datafull(:,4))],'-.k')
        hold off
        pause(.1)        
        x=round([x1 x2]-datafull(1,1))*Fs;
        
        axes(handles.axes3)
        plot(datafull(x(1):x(2),1),datafull(x(1):x(2),2),'k'), axis tight
        axes(handles.axes4)
        plot(datafull(x(1):x(2),1),datafull(x(1):x(2),3),'k'), axis tight
        axes(handles.axes5)
        plot(datafull(x(1):x(2),1),datafull(x(1):x(2),4),'k'), axis tight

    button = questdlg({'Select "Yes" to continue','Press "No" to repeat'},...
        'Select to continue','Yes','No','Yes');
    if strcmp(button,'Yes')
        datafullTemp = datafull;
        clear datafull
%         datafull(:,1)=datafullTemp(x(1):x(2),1);
%         datafull(:,2)=sig(x(1):x(2));
%         datafull(:,3)=datafullTemp(x(1):x(2),3);
%         datafull(:,4)=datafullTemp(x(1):x(2),4);
        datafull=datafullTemp(x(1):x(2),:);
        datafull(:,1)=datafull(:,1)-round(x(1))/Fs;
        
        cleaner=0;
    end
    
    else 
        cleaner=0;
    end
end

% dataf=EMGFilter(datafull);

set(handles.textaxes5,'Visible','off')
clear datafullTemp
%% Graphic

GraphicAxes

% axes(handles.axes3)
% plot(datafull(:,1),datafull(:,2)), axis tight
% ylabel(DataInformation{2})
% if sizeData(2) >=3
%     axes(handles.axes4)
%     plot(datafull(:,1),datafull(:,3)), axis tight
%     ylabel(DataInformation{3})
% end
% if sizeData(2) >=4
%     axes(handles.axes5)
%     plot(datafull(:,1),datafull(:,4)), axis tight
%     xlabel('Time [s]')
%     ylabel(DataInformation{4})
% end
% save(Datafile,'datafull','trigger','emgdata','torque','marks','DataInformation','Fs')
% save(Datafile,'datafull','DataInformation','Fs')

[filename, pathname] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    strcat(Datafile(1:end-4),'_filtered'));
    
if isequal(filename,0)
   disp('Selection canceled')
else
   
   Datafile=fullfile(pathname, filename);
   try
   save(Datafile,'datafull','DataInformation','Fs')
   set(handles.Info,'String',Datafile)
   disp(['You Selected:', fullfile(pathname, filename)])
   set(handles.Info2,'String','The file was successfully saved!')
   catch
       errordlg('Error saving file','Error')
   end

end

set(handles.A_filtering,'Enable','on')
set(handles.B_CalTorque,'Enable','on')
set(handles.A_AnalysisMenu,'Enable','on')
set(handles.A_peaks,'Enable','on')
set(handles.B_Onset_Hilbert,'Enable','on')
set(handles.removePeak,'Enable','on')
set(handles.A_Load,'Enable','on')
    else    
        warndlg('The file is invalid: The variable "datafull" is missing')
    end

else
    errordlg('Please, select a file','Error!')

end

function B_Cut_Callback(hObject, eventdata, handles)
global Datafile pathname filename 


if ~isempty(Datafile)
    load(Datafile)
    set(handles.Info,'String',Datafile)

    if exist('datafull','var')    
        sizeData=size(datafull);

cleaner=1;
while cleaner==1
    
    GraphicAxes

    set(handles.A_filtering,'Enable','off')
    set(handles.A_peaks,'Enable','off')

    str=('Select the start point to cut the signal');
    set(handles.textaxes5,'Visible','on','String',str)
    pause(.1)
    [x1,y] = ginput(1);
    hold on
    plot([x1 x1+.1],[min(datafull(:,4)) max(datafull(:,4))],'-.k')
    str=('Select the end point to cut the signal');
    set(handles.textaxes5,'Visible','on','String',str)
    pause(.1)
    [x2,y] = ginput(1);
    plot([x2 x2+.1],[min(datafull(:,4)) max(datafull(:,4))],'-.k')
    hold off
    pause(.1)
    set(handles.A_filtering,'Enable','on')
    set(handles.A_peaks,'Enable','on')
    x=round(([x1 x2]-datafull(1,1))*Fs);

    axes(handles.axes3), hold off
    plot(datafull(x(1):x(2),1),datafull(x(1):x(2),2),'k'), axis tight
    ylabel(DataInformation{2})
    
    if sizeData(2) >=3
        axes(handles.axes4), hold off
        plot(datafull(x(1):x(2),1),datafull(x(1):x(2),3),'k'), axis tight
        ylabel(DataInformation{3})        
    end
    if sizeData(2) >=4
        axes(handles.axes5), hold off
        plot(datafull(x(1):x(2),1),datafull(x(1):x(2),4),'k'), axis tight
        xlabel('Time [s]')
        ylabel(DataInformation{4})
    end
    
    
    button = questdlg({'Select: "Yes" to continue','"No" to repeat'},...
        'Select to continue','Yes','No','Yes');
    if strcmp(button,'Yes')
        datafullTemp = datafull;
        clear datafull
        datafull=datafullTemp(x(1):x(2),:);
        datafull(:,1)=datafull(:,1)-round(x(1))/Fs;

        cleaner=0;
    end

end

set(handles.textaxes5,'Visible','off')
clear datafullTemp
%% Graphic

GraphicAxes

[filename, pathname] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    Datafile);
    
if isequal(filename,0)
   disp('Selection canceled')
else
   
   Datafile=fullfile(pathname, filename);
   try
       save(Datafile,'datafull','DataInformation','Fs')
       set(handles.Info,'String',Datafile)
       disp(['You Selected:', fullfile(pathname, filename)])
       set(handles.Info2,'String','The file was successfully saved!')
   catch
       errordlg('Error saving file','Error')
   end

end
    
    else    
        warndlg('The file is invalid: The variable "datafull" is missing')
    end

end


% --- Executes on button press in B_Cut.
function B_Plateau_Callback(hObject, eventdata, handles)
% hObject    handle to B_Cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Datafile pathname filename 

%% Loading Noused1

if ~ischar(pathname)
    pathname='';
end
[filename, pathname] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a MAT file',pathname);

if isequal(filename,0)

   disp('Selection canceled')
else
   disp(['You Selected:', fullfile(pathname, filename)])
   Datafile=strcat(pathname,filename);
   set(handles.Info,'String',Datafile)

% DataInformation{1}='Time';
% DataInformation{2}='Trigger';
% DataInformation{3}='EMG';
% DataInformation{4}='Torque';

load (Datafile)

if exist('datafull','var')
    
% Fs=1/datafull(2,1); % Frequency of sampling
axes(handles.axes1),cla
axes(handles.axes2),cla
axes(handles.axes3),cla
axes(handles.axes4),cla
axes(handles.axes5),cla
axes(handles.axes6),cla

set(handles.axes1,'Visible','off')
set(handles.axes2,'Visible','off')
set(handles.axes3,'Visible','on')
set(handles.axes4,'Visible','on')
set(handles.axes5,'Visible','on')
set(handles.axes6,'Visible','off')

axes(handles.axes3)
plot(datafull(:,1),datafull(:,2)), axis tight
ylabel('Elect Stim')
axes(handles.axes4)
plot(datafull(:,1),datafull(:,3)), axis tight
ylabel('EMG')
axes(handles.axes5)
plot(datafull(:,1),datafull(:,4)), axis tight
xlabel('Time [s]')
ylabel('Torque [Nm]')


set(handles.A_AnalysisMenu,'Enable','on')

pause()

%% Torque
lsig=length(datafull(:,3));
th = max(datafull(:,3))*0.3;

pulseSig=zeros(1,lsig);
pulseSig(find(datafull(:,3)>th))=1;

pk=find(pulseSig);

i=1;
a=1;
clear peak
while a
s=datafull(pk(1):pk(1)+500,4);
peak(i)=max(s);
t(i)=datafull(pk(1),1);

ind=find(pk>pk(1)+500);
if ~isempty(ind)
    pk=(pk(ind(1):end));
    i=i+1;
else
    a=0;
    break
end

end


%% EMG
th = max(datafull(:,3))*0.5;

pulseSig2=zeros(1,lsig);
pulseSig2(find(datafull(:,3)>th))=1;

pk2=find(pulseSig2);

i=1;
a=1;
clear peak2
while a
s=datafull(pk2(1):pk2(1)+500,3);
peak2(i)=max(s);
pm=min(s);
t2(i)=datafull(pk2(1),1);

ind2=find(pk2>pk2(1)+500);
if ~isempty(ind2)
    pk2=(pk2(ind2(1):end));
    i=i+1;
else
    break
end

end

peak2D=peak2-pm;


%%
axes(handles.axes4),cla
% subplot(212)
plot(t,peak)
ylabel('Torque [Nm]')
axis([datafull(1,1) datafull(end,1) min(peak)*0.9 max(peak)*1.2])
% subplot(211)
axes(handles.axes5),cla
plot(t2,peak2D)
axis([datafull(1,1) datafull(end,1) min(peak2)*0.9 max(peak2D)*1.2])
ylabel('EMG [uV]')
xlabel('Time [s]')

axes(handles.axes3),cla
plot(datafull(:,1),datafull(:,3))
hold on
plot(datafull(:,1),datafull(:,4)), axis tight
% xlabel('Time [s]')
% ylabel('Torque [Nm]')
title('Incremental Test')


disp(num2str(peak))
disp(num2str(peak2D))

else    
    warndlg('The file is invalid: The variable "datafull" is missing')
end

end


% --- Executes on button press in B_CalTorque.
function B_CalTorque_Callback(hObject, eventdata, handles)
% hObject    handle to B_CalTorque (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Datafile filename 
set(handles.Info2,'String','Current task: Calibration')

%% Loading Noused1

if ~ischar(pathname)
    pathname='';
    if ~isempty(Datafile)
    load (Datafile)
    
    if ~exist('datafull','var')
        
        [filename, pathname] = uigetfile( ...
            {'*.mat','MAT Files (*.mat)';
            '*.*',  'All files (*.*)'}, ...
            'EMG System file. Select the MAT file',pathname);

        if isequal(filename,0)

           disp('Selection canceled')
        else
           disp(['You Selected:', fullfile(pathname, filename)])
           Datafile=strcat(pathname,filename);
           set(handles.Info,'String',Datafile)

            load (Datafile)

            if ~exist('datafull','var')
                errordlg('File wrong. Datafull is missing','Error')
                
            end
        end
    end
    
    else
        
        [filename, pathname] = uigetfile( ...
            {'*.mat','MAT Files (*.mat)';
            '*.*',  'All files (*.*)'}, ...
            'EMG System file. Select the MAT file',pathname);

        if isequal(filename,0)

           disp('Selection canceled')
        else
           disp(['You Selected:', fullfile(pathname, filename)])
           Datafile=strcat(pathname,filename);
           set(handles.Info,'String',Datafile)

        load (Datafile)
        end
    end

else
    load (Datafile)
    
end

if exist('datafull','var')
    
    
[filename2, pathname] = uigetfile( ...
    {'*.txt','Text files (*.txt)';...
    '*.mat','MAT Files (*.mat)';...
    '*.*',  'All files (*.*)'}, ...
    'Biodex file. Select the text file',pathname);

if isequal(filename2,0)

   disp('Selection canceled')
else
   disp(['You Selected:', fullfile(pathname, filename2)])
   Datafile2=strcat(pathname,filename2);
   set(handles.Info,'String',Datafile2)

if strcmp(strcat(Datafile2(end-3:end)),'.txt')
   Tbiodex=Import_Biodex (Datafile2);
elseif strcmp(strcat(Datafile2(end-3:end)),'.mat')
   load(Datafile2)
end

% to corret the offset on the torque from biodex
if sum(Tbiodex(490:500,2))==0
    offset=Tbiodex(501,2);
    Tbiodex(:,2)=Tbiodex(:,2)-offset;
end

Tbiodex(find(Tbiodex(:,2)<0),2)=0; % to remove all the negative data


save(strcat(Datafile2(1:end-4)),'Tbiodex')

%% Detect Torque channel
indTorque=length(DataInformation);
flag=false;
while ~flag
    flag=strcmp(DataInformation{indTorque},'Torque');
    if ~flag
        indTorque=indTorque-1;
%     else
%         flag=true;
    end
end

if min(datafull(:,indTorque))<0
    datafull(:,indTorque)=abs(datafull(:,indTorque));
end
%%
% T_cal=calibration_Biodex([datafull(1:35000,1) datafull(1:35000,4)],Tbiodex(1:3500,:));
T_cal=calibration_Biodex([datafull(:,1) datafull(:,indTorque)],Tbiodex(:,:));
datafull(:,indTorque)=T_cal;

[filename, pathname] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    strcat(pathname,strcat(Datafile(1:end-4),'_Cal')));
    
if isequal(filename,0)
   disp('Selection canceled')
else
   
   Datafile=fullfile(pathname, filename);
   
   try
   save(Datafile,'datafull','DataInformation','Fs')
   disp(['You Selected:', fullfile(pathname, filename)])
   set(handles.Info,'String',Datafile)
   set(handles.Info2,'String','The file was successfully saved!')
   catch ME
       disp()
       warndlg(ME.identifier,'Warning')
       
       [filename, pathname] = uiputfile( ...
            {'*.mat','MAT Files (*.mat)';
            '*.*',  'All files (*.*)'}, ...
            'Select a file',...
            strcat(pathname,strcat(Datafile(1:end-4),'_Cal')));

        if isequal(filename,0)
           disp('Selection canceled')
        else
           
           Datafile=fullfile(pathname, filename);
           
           try
           save(Datafile,'datafull','DataInformation','Fs')
           disp(['You Selected:', fullfile(pathname, filename)])
           set(handles.Info2,'String','The file was successfully saved!')
           set(handles.Info,'String',Datafile)
           
           catch ME
               errordlg('Error saving file','Error!')
           end
        end      
       
   end   
   
end

end
end



% global Datafile pathname
% if isempty(Datafile)
%     errordlg('Select the Noused1 containing the data','Error')
% else
% M_load (Datafile)
% 
% if ~isstring(pathname)
%     pathname='';
% end
% [filename, pathname] = uigetfile( ...
%     {'*.mat','MAT Files (*.mat)';
%     '*.*',  'All files (*.*)'}, ...
%     'm_load the torque from Biodex',pathname);
% 
% if isequal(filename,0)
% 
%    disp('Selection canceled')
% else
%    disp(['You Selected:', fullfile(pathname, filename)])
%    M_load(fullfile(pathname, filename))
% end
% 
% 
% cleaner=1;
% while cleaner==1
% 
%     figure
%     plotchannel(datafull(:,4))  
%     title('Select the start and end points to cut the signal')
%     axis tight
%     
%     button = questdlg('Do you want to cut the signal?','Select to continue') 
%     if strcmp(button,'Yes')
%         warndlg('Press any key to continue!','Heim!!') 
%         pause
%         [x,y] = ginput(2);
%         plotchannel(datafull(x(1):x(2)),datafull(x(1):x(2),4),'k')
% 
%     button = questdlg('Do you want to Continue?','Select to continue');
%     if strcmp(button,'Yes')
%         datafullTemp=datafull;
%         clear datafull
% %         datafull(:,1)=datafullTemp(x(1):x(2),1);
% %         datafull(:,2)=sig(x(1):x(2));
% %         datafull(:,3)=datafullTemp(x(1):x(2),3);
% %         datafull(:,4)=datafullTemp(x(1):x(2),4);
%         datafull(:,1)=datafullTemp(x(1):x(2),4);
%         
%         cleaner=0;
%     end
%     
%     else 
%         cleaner=0;
%     end
% end
% 
% c=15; % is the delay from the two capture between both equipments
% figure
% hold on 
% plotchannel(datafull(10000:end,1),datafull(10000:end,4))
% plotchannel(Tbiodex(1:55000,1)/1000+c,Tbiodex(1:55000,2),'r')
% 
% tEMG=datafull(10000:end-20000,4);
% te=datafull(10000:end-20000,1);
% torque=Tbiodex(1:55000,2);
% tb=Tbiodex(1:55000,1)/1000;
% 
% b=2; % by inspection in the Torque from datafull (EMG System)
% Me=max(tEMG);
% Mt=max(torque);
% me=b;
% % me=min(tEMG);
% mt=min(torque);
% 
% A2=(Mt-mt)/(Me-me);
% B2=mt-me*A2;
% 
% tEMG = tEMG*A2+B2;
% 
% figure
% hold on 
% plotchannel(te,tEMG)
% plotchannel(tb+c,torque,'r')
%  c56 
% 
% end


% --- Executes on selection change in A_AnalysisMenu.
function A_AnalysisMenu_Callback(hObject, eventdata, handles)
% hObject    handle to A_AnalysisMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns A_AnalysisMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from A_AnalysisMenu

contents = cellstr(get(hObject,'String'));
sel=get(hObject,'Value');

switch sel
    
    case 2
        A_AnalysisT(hObject, eventdata, handles)
    case 3
        A_criticalTorque(hObject, eventdata, handles)
    case 4
        A_AnalysisMwave(hObject, eventdata, handles)
    case 5
        A_AnalysisEMG(hObject, eventdata, handles)
    case 6
        A_FreqAnalisis(hObject, eventdata, handles)
    case 7
        Multiple_Analysis_multiple_Act(hObject, eventdata, handles)
%         PrePos_Analysis_multiple(hObject, eventdata, handles)
%         PrePos_Analysis_single(hObject, eventdata, handles)
%         PrePos_Analysis_Last(hObject, eventdata, handles)
%         Geral(hObject, eventdata, handles)
%         PrePos_Analysis_multiple_TCsub(hObject, eventdata, handles)
    case 8
%         set(handles.PanelControl,'Visible','off')
        set(handles.PanelEMG,'Visible','on')
        set(handles.popupmenu29,'Visible','on')
        set(handles.PanelEMG2,'Visible','on')
%         set(handles.PanelConfiguration,'Visible','off')
    case 9
        H_Reflex(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function A_AnalysisMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A_AnalysisMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in removePeak.
function removePeak_Callback(hObject, eventdata, handles)
% hObject    handle to removePeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Datafile pathname

set(handles.Info2,'String','Current task: Filtering')
set(handles.Info,'String',Datafile)

if ~isempty(Datafile)
    load (Datafile)
    set(handles.Info,'String',Datafile)

    if exist('datafull','var')  
        
sizeData=size(datafull);
lsig=size(datafull,1);
ch=get(handles.popchPeak,'Value'); % Get the channel from the interface
chEMG=4;

set(handles.A_filtering,'Enable','off')
set(handles.B_CalTorque,'Enable','off')
set(handles.A_AnalysisMenu,'Enable','off')
set(handles.A_peaks,'Enable','off')
set(handles.B_Onset_Hilbert,'Enable','off')
set(handles.removePeak,'Enable','off')
set(handles.A_Load,'Enable','off')

axes(handles.axes1),cla
axes(handles.axes2),cla
axes(handles.axes3),cla
axes(handles.axes4),cla
axes(handles.axes5),cla
axes(handles.axes6),cla

set(handles.axes3,'Visible','off')
set(handles.axes4,'Visible','off')
set(handles.axes5,'Visible','off')
set(handles.axes1,'Visible','on')
set(handles.axes2,'Visible','on')
set(handles.axes6,'Visible','on')

if sizeData(2)>=4 
    axes(handles.axes1)
    cla
    hold on
    plot(datafull(:,1),datafull(:,ch)), axis tight
    hold off
    ylabel('Torque [Nm]')
    try
        axis([datafull(1,1) datafull(end,1) min(datafull(:,ch)) max(datafull(:,ch))])
    end

end

if sizeData(2)>=5
    axes(handles.axes2)
    plot(datafull(:,1),datafull(:,5))
    xlabel('Time [s]')
    axis([datafull(1,1) datafull(end,1) 0 max(datafull(:,5))])
end

if sizeData(2)>=5 
    set(handles.axes6,'Visible','on')
    axes(handles.axes6)
    cla, hold on   
    plot(datafull(:,1),datafull(:,chEMG),'c') 
    plot(datafull(:,1),datafull(:,5)*max(datafull(:,chEMG)))
    axis([datafull(1,1) datafull(end,1) min(datafull(:,chEMG)) max(datafull(:,chEMG))*1.05])
end


flag=1;

while flag
    set(handles.textaxes5,'Visible','on')
    set(handles.textaxes5,'String','Make a zoom around the peak to remove!')
    zoom on
    pause()
    set(handles.textaxes5,'String','Select the peak to remove!')

    % figure,plotchannel(datafull(:,1),datafull(:,5))
    [x,y] = ginput(1);
    set(handles.textaxes5,'String','')
    set(handles.textaxes5,'Visible','off')

    p1=round((x-datafull(1,1)-0.1)*Fs); % 2 seconds less
    p2=round((x-datafull(1,1)+0.1)*Fs); % 2 seconds after
    if p1<1
        p1=1;
    end
    if p2>size(datafull,1)
        p2=size(datafull,1);
    end
    ind=find(datafull(p1:p2,5)==1);
    % % % corte
    % c1=1139059;
    % c2=1385552;
    % datafull1=datafull(c1:end-(c2-c1+1),1);
    % datafull(c1:c2,:)=[];
    % datafull(c1:end,1)=datafull1;

    if ~isempty(ind)

    if logical(datafull(ind(1)+p1-1,5))
        datafull(ind(1)+p1-1,5)=0;
        marks(find(marks==ind(1)+p1-1))=[];
        h=msgbox('Peak removed','Success!');
        pause(1)
        close (h)

        cla
        set(handles.axes6,'Visible','on')
        axes(handles.axes6)
        cla, hold on   
        % subplot(211)
        plot(datafull(:,1),datafull(:,chEMG),'c') 
        plot(datafull(:,1),datafull(:,5)*max(datafull(:,chEMG)))
        if ~isempty(marks)
            plot(marks/Fs+datafull(1,1),0,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
            plot(marks/Fs+datafull(1,1),0,'sk','MarkerFaceColor',[.1 .49 .30],'MarkerSize',5)
        end
        axis([datafull(1,1) datafull(end,1) min(datafull(:,chEMG)) max(datafull(:,chEMG))*1.05])
        legend('off')
    else
        waitfor(warndlg('The peak was not removed','Warning'));
    %     pause(.5)
    end

    else
        waitfor(warndlg({'Select the point' 'with more accuracy'},'Warning'));
    %     pause(.5)
    end

    flagText = questdlg('Do you want to remove another peak?','Select to continue');
    if ~strcmp(flagText,'Yes')
        flag=0;
    end
        
end

set(handles.Panel_Info1,'Visible','off')
set(handles.Panel_Info2,'Visible','on')
set(handles.I1,'String',{['Datafull size: ',num2str(sizeData)]})
set(handles.I2,'String',{['Num peaks: ',num2str(length(marks))]})

% save(Datafile,'datafull','marks','DataInformation','Fs')
[filename, pathname] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    Datafile);
    
if isequal(filename,0)
   disp('Selection canceled')
else
   
   Datafile=fullfile(pathname, filename);
   save(Datafile,'datafull','marks','DataInformation','Fs')
   set(handles.Info2,'String','The file was successfully saved!')
   disp(['You Selected:', fullfile(pathname, filename)])
   set(handles.Info,'String',fullfile(pathname, filename))
end

set(handles.A_filtering,'Enable','on')
set(handles.B_CalTorque,'Enable','on')
set(handles.A_AnalysisMenu,'Enable','on')
set(handles.A_peaks,'Enable','on')
set(handles.B_Onset_Hilbert,'Enable','on')
set(handles.removePeak,'Enable','on')
set(handles.A_Load,'Enable','on')

    else    
        warndlg('The file is invalid: The variable "datafull" is missing')
    end

else
    errordlg('Please, select a file','Error!')
end


function shift_Callback(hObject, eventdata, handles)
% hObject    handle to shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shift as text
%        str2double(get(hObject,'String')) returns contents of shift as a double


% --- Executes during object creation, after setting all properties.
function shift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function window_Callback(hObject, eventdata, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window as text
%        str2double(get(hObject,'String')) returns contents of window as a double


% --- Executes during object creation, after setting all properties.

function window_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

 
% --------------------------------------------------------------------
function Noused1_Callback(hObject, eventdata, handles)
% hObject    handle to Noused1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Noused3_Callback(hObject, eventdata, handles)
% hObject    handle to Noused3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Noused4_Callback(hObject, eventdata, handles)
% hObject    handle to Noused4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Noused5_Callback(hObject, eventdata, handles)
% hObject    handle to Noused5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_about_Callback(hObject, eventdata, handles)
% hObject    handle to M_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_torqueAnalisis_Callback(hObject, eventdata, handles)
% hObject    handle to M_torqueAnalisis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_criticalTorque_Callback(hObject, eventdata, handles)
% hObject    handle to M_criticalTorque (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_mwave_Callback(hObject, eventdata, handles)
% hObject    handle to M_mwave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_frequencyAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to M_frequencyAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_emgAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to M_emgAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_TorqueCalibration_Callback(hObject, eventdata, handles)
% hObject    handle to M_TorqueCalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_filter_Callback(hObject, eventdata, handles)
% hObject    handle to M_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_Peaks_Callback(hObject, eventdata, handles)
% hObject    handle to M_Peaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_load_Callback(hObject, eventdata, handles)
% hObject    handle to M_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Datafile filename indCH

if ~ischar(pathname)
    pathname='';
end
[filename, pathname] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a MAT file',pathname);

if isequal(filename,0)

   disp('Selection canceled')
else
   disp(['You Selected:', fullfile(pathname, filename)])
   Datafile=strcat(pathname,filename);
   set(handles.Info,'String',Datafile)

load (Datafile)

%%
if exist ('DataCellFull','var')
    datafull = DataCellFull;
end
if exist('datafull','var')

datafull=datafull(50:end,:);
sizeData=size(datafull);

%% Baseline
t1 = 0.3; % seconds
t2 = 0.6; % seconds
nt1 = round(t1*Fs);
nt2 = round(t2*Fs);

baseline = mean (datafull(nt1:nt2,2:end));

datafull(:,2:end) = datafull(:,2:end)-baseline;

%%
% xV = Onset_IMU(datafull(:,1),datafull(:,4),t1,t2,Fs);
% xV=xV(1)+50;
% td1 = datafull(xV:end,1)-datafull(xV);
% datafull=[td1 datafull(xV:end,2:end)];

%% Subsampling
smpl=0; % Flag to apply subsampling
if smpl
SubFs = Fs / 100; % to obtain 100 Hz
datafull = datafull(1:SubFs:end,:);
Fs=100;

set(handles.Panel_Info1,'Visible','off')
set(handles.Panel_Info2,'Visible','on')
set(handles.I1,'String',{['Data size: ',num2str(sizeData)]})
% Fs=1/datafull(2,1); % Frequency of sampling

end
% flagEstimulus = questdlg('Do you want to M_load the trigger?','Select to continue');
% if strcmp(flagEstimulus,'Yes')

%% Protokinetics

% xsync = find(~Sync(:,2));
% Sync(xsync(1),1)
% tsegs=[];
% mAc=min(min(datafull(:,2:4)));
% MAc=max(max(datafull(:,2:4)));
% 
% plot([tsegs([1 2 7 8 13]) tsegs([1 2 7 8 13])],[mAc MAc],'k--')
% plot([tsegs([3:6 9:12]) tsegs([3:6 9:12])],[mAc MAc],'b--')
% 
% FsPk = 1 / (Sync(2,1)-Sync(1,1));
% SubFsPk = FsPk / 100; % to obtain 100 Hz
% 
% Sync = Sync(1:SubFsPk:end,:);
% FsPk=100;
% T=1/100;
% t100=(Sync(1,1):length(Sync(:,1))-1)*Sync(end,1)/length(Sync(:,1));
% [y, Ty] = resample(Sync(:,2),t100);


%%
cleaner=1;
while cleaner==1

    axes(handles.axes25),cla, hold on
    plot(datafull(:,1),datafull(:,2)), axis tight
    plot(datafull(:,1),datafull(:,3)), axis tight
    plot(datafull(:,1),datafull(:,4)), axis tight
    xlabel('Time [s]')
    ylabel(DataInformation{4})
    
    button = questdlg('Do you want to cut the signal?','Select to continue'); 
    str=('Select the start and the end points to cut the signal');
    set(handles.textaxes5,'Visible','on','String',str)
    if strcmp(button,'Yes')
        warndlg({'Select the start and the end points to cut the signal','Press any key to continue!'},'Heim!!') 
        pause
        x1=datafull(2,1);
%         [x1,y] = ginput(1);
%         hold on
%         plot([x1 x1],[min(datafull(:,2)) max(datafull(:,2))],'-.k')
        [x2,y] = ginput(1);
        plot([x2 x2],[min(datafull(:,4)) max(datafull(:,4))],'-.k')
        hold off
        pause(.1)        
        x=round(([x1 x2]-datafull(1,1))*Fs);
        
        cla, hold on
        
        plot(datafull(x(1):x(2),1),datafull(x(1):x(2),2),'k'), axis tight
        plot(datafull(x(1):x(2),1),datafull(x(1):x(2),3),'k'), axis tight
        plot(datafull(x(1):x(2),1),datafull(x(1):x(2),4),'k'), axis tight

    button = questdlg({'Select "Yes" to continue','Press "No" to repeat'},...
        'Select to continue','Yes','No','Yes');
    if strcmp(button,'Yes')
        datafullTemp = datafull;
        clear datafull
%         datafull(:,1)=datafullTemp(x(1):x(2),1);
%         datafull(:,2)=sig(x(1):x(2));
%         datafull(:,3)=datafullTemp(x(1):x(2),3);
%         datafull(:,4)=datafullTemp(x(1):x(2),4);
        datafull=datafullTemp(x(1):x(2),:);
        datafull(:,1)=datafull(:,1)-x(1)/Fs;
        
        cleaner=0;
    end
    
    else 
        cleaner=0;
    end
end

%% Detecting IMU channels
lch=length(DataInformation);
flag=false;
Sens={'a','g','deg'};
txt={'CH'};
indCH={};
ju=1;

%%
jj=ju;
indCH{1}=[];
txtCH='';
flagerror=0;

for i=1:lch
    try
    flag=strcmp(DataInformation{i}(1),Sens{jj});
    if flag
        indCH{jj}=[indCH{jj} i];
        if isempty(txtCH)
            txtCH=DataInformation{i}(1:2);
        else
            txtCH=strcat(txtCH,' / ',DataInformation{i}(1:2));
        end
    end
    catch
        warndlg('Accelerometer channels can not be detected','Warning') 
    end
end

txt=[txt txtCH];

if ~isempty(indCH{jj})
    ju=ju+1;
end
%%
jj=ju;
indCH{ju}=[];
txtCH='';
flagerror=0;

for i=1:lch
    try
    flag=strcmp(DataInformation{i}(1),Sens{jj});
    if flag
        indCH{jj}=[indCH{jj} i];
        if isempty(txtCH)
            txtCH=DataInformation{i}(1:2);
        else
            txtCH=strcat(txtCH,' / ',DataInformation{i}(1:2));
        end
    end
    catch
        warndlg('Giroscope channels can not be detected','Warning') 
    end
end

txt=[txt txtCH];
if ~isempty(indCH{jj})
    ju=ju+1;
end

%%
jj=ju;
indCH{jj}=[];
txtCH='';
flagerror=0;

for i=1:lch
    try
        if length(DataInformation{i})>=5
            flag=strcmp(DataInformation{i}(3:5),Sens{jj});
        else
            flag=false;
        end
    if flag
        indCH{jj}=[indCH{jj} i];
        if isempty(txtCH)
            txtCH=DataInformation{i};
        else
            txtCH=strcat(txtCH,' / ',DataInformation{i});
        end
    end
    catch
        warndlg('Magnetometer channels can not be detected','Warning') 
    end
end

txt=[txt txtCH];
if ~isempty(indCH{jj})
    ju=ju+1;
end

%%
jj=ju;
Sens{ju}='h';
indCH{jj}=[];
txtCH='';
flagerror=0;

for i=1:lch
    try
        if length(DataInformation{i})>=5
            flag=strcmp(DataInformation{i}(1),Sens{jj});
        else
            flag=false;
        end
    if flag
        indCH{jj}=[indCH{jj} i];
        if isempty(txtCH)
            txtCH=DataInformation{i};
        else
            txtCH=strcat(txtCH,' / ',DataInformation{i});
        end
    end
    catch
        warndlg('X channels can not be detected','Warning') 
    end
end

txt=[txt txtCH];
if ~isempty(indCH{jj})
    ju=ju+1;
end
%%
jj=ju;
Sens{ju}='q';
indCH{jj}=[];
txtCH='';
flagerror=0;

for i=1:lch
    try
    flag=strcmp(DataInformation{i}(1),Sens{jj});
    if flag
        indCH{jj}=[indCH{jj} i];
        if isempty(txtCH)
            txtCH=DataInformation{i};
        else
            txtCH=strcat(txtCH,' / ',DataInformation{i});
        end
    end
    catch
        warndlg('X channels can not be detected','Warning') 
    end
end

txt=[txt txtCH];
if ~isempty(indCH{jj})
    ju=ju+1;
end

%%
jj=ju;
Sens{ju}='m';
indCH{jj}=[];
txtCH='';
flagerror=0;

for i=1:lch
    try
    flag=strcmp(DataInformation{i}(1),Sens{jj});
    if flag
        indCH{jj}=[indCH{jj} i];
        if isempty(txtCH)
            txtCH=DataInformation{i};
        else
            txtCH=strcat(txtCH,' / ',DataInformation{i});
        end
    end
    catch
        warndlg('X channels can not be detected','Warning') 
    end
end

txt=[txt txtCH];
if ~isempty(indCH{jj})
    ju=ju+1;
end

%%
if length(indCH)>1
    
    set(handles.SelCH1,'String',txt)
    set(handles.SelCH2,'String',txt)
    set(handles.SelCH3,'String',txt)
    set(handles.SelCH4,'String',txt)
    
elseif isempty(indCH)
    warndlg({['IMU channels are missing!: F',filename]}','Warning!')
end

%% Graphic

GraphicAxesIMU
% GraphicAxesIMU_Figure
%%
set(handles.I1,'String',{['Data size: ',num2str(sizeData)]})

% set(handles.I1,'String',['Ch1: ',DataInformation{1}])
% try set(handles.I2,'String',['Ch2: ',DataInformation{2}]), catch set(handles.I5,'String','Ch5: Empty'), end
% try set(handles.I3,'String',['Ch3: ',DataInformation{3}]), catch set(handles.I5,'String','Ch5: Empty'), end
% try set(handles.I4,'String',['Ch4: ',DataInformation{4}]), catch set(handles.I5,'String','Ch5: Empty'), end
% try set(handles.I5,'String',['Ch5: ',DataInformation{5}]), catch set(handles.I5,'String','Ch5: Empty'), end
% try set(handles.I6,'String',['Ch6: ',DataInformation{6}]), catch set(handles.I6,'String','Ch6: Empty'), end

[a,b]=size(datafull);
set(handles.I2,'String',['Mat Data: ',num2str(a),'X',num2str(b)])
set(handles.I3,'String',['Fs: ',num2str(Fs),' Hz'])


% else

% axes(handles.axes3)
% axes(handles.axes4)
% plotchannel(datafull(:,1),datafull(:,3)), axis tight
% ylabel('EMG')
% axes(handles.axes5)
% plotchannel(datafull(:,1),datafull(:,4)), axis tight
% xlabel('Time [s]')
% ylabel('Torque [Nm]')

% end
set(handles.A_AnalysisMenu,'Enable','on')

else    
    warndlg('The file is invalid: The variable "datafull" is missing')
end

end

% --------------------------------------------------------------------
function B_M_ImportEMGSystem_Callback(hObject, eventdata, handles)
% hObject    handle to B_M_ImportEMGSystem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A_import_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function B_M_ImportBiodex_Callback(hObject, eventdata, handles)
% hObject    handle to B_M_ImportBiodex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname

FlagSerial=1;

if FlagSerial==1

pathname = uigetdir(pathname);

if isequal(pathname,0)

   disp('Selection canceled')
else
    
ldir=dir(pathname);
name={ldir.name};
for i=3:length(name)
    
Datafile2=fullfile(pathname,name{i});

Tbiodex=Import_Biodex (Datafile2);
% to corret the offset on the torque from biodex
if sum(Tbiodex(490:500,2))==0
    offset=Tbiodex(501,2);
    Tbiodex(:,2)=Tbiodex(:,2)-offset;
end

Tbiodex(find(Tbiodex(:,2)<0),2)=0; % to remove all the negative data

Tbiodex2=Tbiodex;
Tbiodex=Tbiodex2(1:10000,:);
save(strcat(Datafile2(1:end-4),'_1'),'Tbiodex')
Tbiodex=Tbiodex2(10000:20000,:);
save(strcat(Datafile2(1:end-4),'_2'),'Tbiodex')
Tbiodex=Tbiodex2(20000:end,:);
save(strcat(Datafile2(1:end-4),'_3'),'Tbiodex')

end

end
else

if ~ischar(pathname)
    pathname='';
end
[filename2, pathname] = uigetfile( ...
    {'*.txt','MAT Files (*.txt)';
    '*.*',  'All files (*.*)'}, ...
    'Biodex file. Select the text file',pathname);

if isequal(filename2,0)

   disp('Selection canceled')
else
   disp(['You Selected:', fullfile(pathname, filename2)])
   Datafile2=strcat(pathname,filename2);
   set(handles.Info,'String',Datafile2)
   
Tbiodex=Import_Biodex (Datafile2);
save(strcat(Datafile2(1:end-4)),'Tbiodex')

end

end


% --------------------------------------------------------------------
function B_M_ExportDataExcel_Callback(hObject, eventdata, handles)
% hObject    handle to B_M_ExportDataExcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname

if ~ischar(pathname)
    pathname='';
end
[filename, pathname] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a MAT file',pathname);

if isequal(filename,0)

   disp('Selection canceled')
else
   disp(['You Selected:', fullfile(pathname, filename)])
   Datafile=strcat(pathname,filename);
   set(handles.Info,'String',Datafile)

load (Datafile)

%%
if exist('datafull','var')

sizeData=size(DataInformation);

end

write=1;
Datafile=fullfile(pathname,'Data.xlsx');

if exist(Datafile, 'file')
    [filename2, pathname] = uiputfile( ...
        {'*.xlsx','Excel Files (*.xlsx)';
        '*.*',  'All files (*.*)'}, ...
        'Select a file',...
        strcat(pathname,'\Data.xlsx'));

    if isequal(filename2,0)
       disp('Selection canceled')
       write=0;
    else
       Datafile=fullfile(pathname,filename2);
    end

end

if write==1
xlRange = 'A2';
xlswrite(Datafile,datafull,filename(1:end-4),xlRange)

xlRange = 'A1';
xlswrite(Datafile,DataInformation,filename(1:end-4),xlRange)

disp(['You Selected:', Datafile])
set(handles.Panel_Info1,'Visible','on')
set(handles.Panel_Info2,'Visible','off')
set(handles.Info2,'String','The file was successfully exported!')

end

end

% --------------------------------------------------------------------
function B_M_ExportExcel_Callback(hObject, eventdata, handles)
% hObject    handle to B_M_ExportExcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname

if ~ischar(pathname)
    pathname='';
end

pathname = uigetdir(pathname);

if isequal(pathname,0)
   disp('Selection canceled')
else

oldFolder = cd(pathname);
ldir=dir ('*Results*.mat');
% ldir=dir ('*CT*.mat');
cd(oldFolder);

clear Tfile Mfile
T_Total=[]; M_Total=[]; ResTotal=[]; RowTLabel=[];
j=1; k=1; m=1;
name={ldir.name};

for i=1:length(name)

    Datafile=fullfile(pathname,name{i});
    load (Datafile)
    
    if exist('ResT','var')
        T_Total=[T_Total; ResT];
        L=size(ResT,1);
        clear ResT
        Tfile{j,1}=name{i};
        for jj=1:L-1
            j=j+1;
            Tfile{j,1}={'_'};          
        end
        j=j+1;
        
%         T_Total(j,:)=ResT(1,:);
%         clear ResT
%         Tfile{j,1}=name{i};
%         j=j+1;
    end
    if exist('ResM','var')
        M_Total=[M_Total; ResM];
        L=size(ResM,1);
        clear ResM
        Mfile{k,1}=name{i};
        for jj=1:L-1
            k=k+1;
            Mfile{k,1}={'_'};          
        end
        k=k+1;
%         M_Total(k,:)=ResM(1,:);
%         clear ResM
%         Mfile{k,1}=name{i};
%         k=k+1;
    end
    if exist('Results','var')
        ResTotal=[ResTotal; Results];
        if exist('RowLabel')
            RowTLabel=[RowTLabel; RowLabel];
        end
        L=size(Results,1);
        clear Results
        Resfile{m,1}=name{i};
        for jj=1:L-1
            m=m+1;
            Resfile{m,1}={'_'};          
        end
        m=m+1;
    end
    
    % For analysis previous to 06/17/2020
    if exist('ResCT','var')
        ResTotal=[ResTotal; ResCT];
        if exist('RowLabel')
            RowTLabel=[RowTLabel; RowLabel];
        else
            RowLabel=[];
        end
        L=size(ResCT,1);
        clear ResCT
        Resfile{m,1}=name{i};
        for jj=1:L-1
            m=m+1;
            Resfile{m,1}={'_'};          
        end
        m=m+1;
    end

end

write=1;
Datafile=fullfile(pathname,'Results.xls');

if exist(Datafile, 'file')
    [filename, pathname] = uiputfile( ...
        {'*.xls','Excel Files (*.xls)';
        '*.*',  'All files (*.*)'}, ...
        'Select a file',...
        strcat(pathname,'\Results.xls'));

    if isequal(filename,0)
       disp('Selection canceled')
       write=0;
    else
       Datafile=fullfile(pathname,filename);
    end

end

if write==1
if ~isempty(T_Total)
    xlRange = 'A2';
    xlswrite(Datafile,Tfile,'Torque',xlRange)
%     xlRange = 'A1';
%     xlswrite(Datafile,'File','Torque',xlRange)
    xlRange = 'B1';
    xlswrite(Datafile,ResTInformation,'Torque',xlRange)
    xlRange = 'B2';
    xlswrite(Datafile,T_Total,'Torque',xlRange)
end

if ~isempty(M_Total)
    xlRange = 'A2';
    xlswrite(Datafile,Mfile,'MWave',xlRange)
%     xlRange = 'A1';
%     xlswrite(Datafile,'File','Torque',xlRange)
    xlRange = 'B1';
    xlswrite(Datafile,ResMInformation,'MWave',xlRange)
    xlRange = 'B2';
    xlswrite(Datafile,M_Total,'MWave',xlRange)
end

if ~isempty(ResTotal)
    if exist('test','var')
        xlRange = 'A1';
        sheet=string(test);
        xlswrite(Datafile,test,sheet,xlRange)
    else
        test='Res';
        sheet='Test';
    end
    
    if ~isempty(RowTLabel)
        xlRange = 'B2';
        xlswrite(Datafile,RowTLabel,sheet,xlRange)
    end
    if ~exist('ResultsInformation','var')
        if exist('ResCTInformation','var')
        ResultsInformation=ResCTInformation;
        end
    end
    
    xlRange = 'A2';
    xlswrite(Datafile,Resfile,sheet,xlRange)
%     xlRange = 'A1';
%     xlswrite(Datafile,'File','Torque',xlRange)
    xlRange = 'C2';
    xlswrite(Datafile,ResTotal,sheet,xlRange)
    if exist('ResultsInformation','var')
    xlRange = 'C1';
    xlswrite(Datafile,string(ResultsInformation),sheet,xlRange)
    end
end

disp(['You Selected:', Datafile])
set(handles.Panel_Info1,'Visible','on')
set(handles.Panel_Info2,'Visible','off')
set(handles.Info2,'String','The file was exported successfully!')
msgbox('The file was exported successfully!','Success')
end

end


% --------------------------------------------------------------------
function M_plateau_Callback(hObject, eventdata, handles)
% hObject    handle to M_plateau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function M_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to M_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Noused2_Callback(hObject, eventdata, handles)
% hObject    handle to Noused2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function B_M_reset_Callback(hObject, eventdata, handles)
% hObject    handle to B_M_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plotChannel.
function plotChannel_Callback(hObject, eventdata, handles)
% hObject    handle to plotChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Datafile pathname filename

try
    load (Datafile)
catch
    warndlg('Please, load a file.')
end
if exist('datafull','var') && exist('DataInformation','var')
    
sizeData=size(DataInformation);
sizeData2=size(datafull);
nCh=sizeData(2)-1; % To avoid time column

if ~exist('marks','var')     
    warndlg('Peaks are missing')
end

figure
for jj=1:nCh 
    subplot(nCh,1,jj)
    hold on
    plot(datafull(:,1),datafull(:,jj+1)), axis tight
    
    axis([datafull(1,1) datafull(end,1) min(datafull(:,jj+1)) max(datafull(:,jj+1))])
    xlabel('Time [s]')
    ylabel(DataInformation{jj+1})
    if exist('marks','var') && sizeData2(2)>=5 
        plot(datafull(:,1),datafull(:,5)*max(datafull(:,jj+1)),'c')
        if ~isempty(marks)
            plot(marks/Fs+datafull(1,1),0,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
        end
    end
end

else    
    warndlg('The file is invalid: Data is missing')
end


% --- Executes on button press in plotPeaks.
function plotPeaks_Callback(hObject, eventdata, handles)
% hObject    handle to plotPeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Datafile pathname filename

try
    load (Datafile)
catch
    warndlg('Please, load a file.')
end
if exist('datafull','var')
    
sizeData=size(datafull);
nCh=sizeData(2); 

if ~exist('marks','var')     
    nCh=nCh-1; % To remove column of Time
    warndlg('Peaks are missing')
else
    nCh=nCh-2; % To remove columns of Time and Marks
end

figure
for jj=1:nCh 
    subplot(nCh,1,jj)
    hold on
    plot(datafull(:,1),datafull(:,jj+1)), axis tight
    
    axis([datafull(1,1) datafull(end,1) min(datafull(:,jj+1)) max(datafull(:,jj+1))])
    xlabel('Time [s]')
    ylabel(DataInformation{jj+1})
    if exist('marks','var') && sizeData(2)>=5 
        plot(datafull(:,1),datafull(:,5)*max(datafull(:,jj+1)))
        if ~isempty(marks)
            plot(marks/Fs+datafull(1,1),0,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
        end
    end
end

else    
    warndlg('The file is invalid: Data is missing')
end


% --- Executes on button press in plotUpdate.
function plotUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to plotUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Datafile filename 

try
    load (Datafile)

    if exist('datafull','var') && exist('DataInformation')    
        %% Graphic

        GraphicAxes

        set(handles.A_AnalysisMenu,'Enable','on')

    else    
        warndlg('The file is invalid: Data is missing')
    end

end



function input3_Callback(hObject, eventdata, handles)
% hObject    handle to input3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input3 as text
%        str2double(get(hObject,'String')) returns contents of input3 as a double


% --- Executes during object creation, after setting all properties.
function input3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input4_Callback(hObject, eventdata, handles)
% hObject    handle to input4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input4 as text
%        str2double(get(hObject,'String')) returns contents of input4 as a double


% --- Executes during object creation, after setting all properties.
function input4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input1_Callback(hObject, eventdata, handles)
% hObject    handle to input1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input1 as text
%        str2double(get(hObject,'String')) returns contents of input1 as a double


% --- Executes during object creation, after setting all properties.
function input1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input2_Callback(hObject, eventdata, handles)
% hObject    handle to input2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input2 as text
%        str2double(get(hObject,'String')) returns contents of input2 as a double


% --- Executes during object creation, after setting all properties.
function input2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input5_Callback(hObject, eventdata, handles)
% hObject    handle to input5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input5 as text
%        str2double(get(hObject,'String')) returns contents of input5 as a double


% --- Executes during object creation, after setting all properties.
function input5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.A_filtering,'Enable','on')
set(handles.B_CalTorque,'Enable','on')
set(handles.A_AnalysisMenu,'Enable','on')
set(handles.A_peaks,'Enable','on')
set(handles.B_Onset_Hilbert,'Enable','on')
set(handles.removePeak,'Enable','on')
set(handles.A_Load,'Enable','on')




function input7_Callback(hObject, eventdata, handles)
% hObject    handle to input7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input7 as text
%        str2double(get(hObject,'String')) returns contents of input7 as a double


% --- Executes during object creation, after setting all properties.
function input7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input8_Callback(hObject, eventdata, handles)
% hObject    handle to input8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input8 as text
%        str2double(get(hObject,'String')) returns contents of input8 as a double


% --- Executes during object creation, after setting all properties.
function input8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input6_Callback(hObject, eventdata, handles)
% hObject    handle to input6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input6 as text
%        str2double(get(hObject,'String')) returns contents of input6 as a double


% --- Executes during object creation, after setting all properties.
function input6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input9_Callback(hObject, eventdata, handles)
% hObject    handle to input9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input9 as text
%        str2double(get(hObject,'String')) returns contents of input9 as a double


% --- Executes during object creation, after setting all properties.
function input9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function MEPlotscale_Callback(data)
% hObject    handle to MEPlotEEGscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% x1=str2num(get(handles.PlotiSample,'String'));
% x2=str2num(get(handles.PlotWindow,'String'));
% y=str2num(get(handles.PlotYscale,'String'));

Fs=1/(data(2,1)-data(1,1));

f=figure;
plotMultAxes(f,data(:,2:end),Fs,'',[0 3 0],'b','',1)
title({''},'Interpreter', 'none')

x1 = 0;
x2 = 60;
y = 100;
% fa=gca;
% axis([x1 x1+x2 min(fa.YTick) max(fa.YTick)])


% --------------------------------------------------------------------
function B_M_ImportDelsys_Callback(hObject, eventdata, handles)
% hObject    handle to B_M_ImportDelsys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname flagEstimulus
set(handles.Info2,'String','Current task: Import')

FlagSerial=get(handles.MultiFiles,'Value');
% FlagSerial=1;

if FlagSerial==1
    
    Import_Delsys_Serial; % Trabalho Bárbara
else

if ~ischar(pathname)
    pathname='';
end


[filename, pathname2] = uigetfile( ...
    {'*.xlsx','Excel Files (*.xlsx)';'*.xls','Excel Files (*.xlsx)';...
    '*.csv','CSV Files';'*.*',  'All files (*.*)'}, ...
    'Select the TXT file',pathname);

if isequal(pathname2,0)
   disp('Selection canceled')
   return
end 
    
pathname=pathname2;
disp(['You Selected: ', filename])
%     [datafull]=import_txt(pathname,filename);
fileDelsys=fullfile(pathname, filename);
%     SDelsys = xlsread(fileDelsys,'BI2:BJ65536')
set(handles.Info2,'String','Busy...')
try
data = xlsread(fileDelsys);

set(handles.Info2,'String','Current task: Import')

catch ME
set(handles.Info2,'String',strcat('Error:',ME.message))
end

ch1=get(handles.popch1,'Value')-1;
ch2=get(handles.popch2,'Value')-1;
ch3=get(handles.popch3,'Value')-1;
ch4=get(handles.popch5,'Value')-1;

% Configuraçaõ Tese André
ch3=7;
ch4=8;

% DataInformation{ch1}='Time EMG';
% DataInformation{ch2}='EMG VL';
% DataInformation{ch3}='Torque [Nm]';
% DataInformation{ch4}='Time Torque';
DataInformation{ch1}=get(handles.CH1,'String');
DataInformation{ch2}=get(handles.CH2,'String');
DataInformation{ch3}=get(handles.CH3,'String');
DataInformation{ch4}=get(handles.CH4,'String'); 

datafull(:,1)=data(:,ch1); % Time
datafull(:,2)=data(:,ch2); % EMG VL
datafull(:,3)=data(:,ch3); % Time torque
datafull(:,4)=data(:,ch4); % Torque

% datafull(:,1)=data(:,ch1); % Time
% datafull(:,2)=data(:,ch2); % EMG BF
% datafull(:,3)=data(:,ch3); % EMG VL
% datafull(:,4)=data(:,ch4); % Torque

clear data

%% 

% Detecting sampling frequency
Fs=1/(datafull(2,1)-datafull(1,1)); % Frequency of sampling
Fs2=1/(datafull(2,3)-datafull(1,3)); % Frequency of sampling

% Removing zero data at the end (because Delsys fill with zeros at the end)
torque=removeZerosDelsys (datafull(:,4));
% indzero=find(~datafull(:,4));
% indEndSignal=find(diff(indzero)>1);
% torque=datafull(:,3:4);
% torque(indzero(indEndSignal(end)+1):end,:)=[];

emg=removeZerosDelsys (datafull(:,2));
% indzero=find(~datafull(:,2));
% indEndSignal=find(diff(indzero)>1);
% emg=datafull(:,1:2);
% emg(indzero(indEndSignal(end)+1):end,:)=[];

clear datafull
[a,b]=min([emg(end,1) torque(end,1)]);

if b==2
    % torque tem menos dados
    xq=0:1/1000:torque(end,1);
    xq=xq';
    torque2=interp1(torque(:,1),torque(:,2),xq);
    
    [c,d]=min(abs(emg(:,1)-xq(end,1)));    
%     xqemg=0:1/1000:emg(d,1);
%     xqemg=xqemg';
    emg2=interp1(emg(1:d,1),emg(1:d,2),xq);
    datafull=[xq emg2 emg2 torque2];
    
elseif b==1
    % emg tem menos dados
    xq=0:1/1000:emg(end,1);
    xq=xq';
    emg2=interp1(emg(:,1),emg(:,2),xq);
    
    [c,d]=min(abs(torque(:,1)-xq(end,1)));    
%     xqemg=0:1/1000:emg(d,1);
%     xqemg=xqemg';
    torque2=interp1(torque(1:d,1),torque(1:d,2),xq);
    datafull=[xq emg2 emg2 torque2];
end

Fs=1/(datafull(2,1)-datafull(1,1)); % Frequency of sampling

DataInformation{1}='Time EMG';
DataInformation{2}='EMG  VL';
DataInformation{3}='Time Torque';
DataInformation{4}='Torque [Nm]';

% DataInformation{5}='Sync';

% %% To identify the last data, when vector is filled with zeros
% % It is assumed that first column has equal or more data than other columns
% 
% % Removing the last zeros of all columns using the first one as reference
% ind=find(datafull(:,1)==0);
% if length(ind)>1
%     ind2=diff(ind);
%     if ~isempty(ind2)
%         ind3=diff(ind2);
%         ind4=find(abs(ind3)>0);
%         limite1=ind2(ind4(end));
%     end
% end
% 
% datafull(limite1+1:end,:)=[];
% 
% % Removing the invalid data from other columns from the 3rd and 4th
% ind=find(datafull(:,3)==0);
% if length(ind)>1
%     ind2=diff(ind);
%     if ~isempty(ind2)
%         ind3=diff(ind2);
%         ind4=find(abs(ind3)>0);
%         limite2=ind2(ind4(end));
%     end
% end
% 
% datafull(limite2+1:end,3:4)=NaN;

% %%
% axes(handles.axes3)
% plot(datafull(:,1),datafull(:,2)), axis tight
% ylabel('EMG [V]')
% axis([datafull(1,1) datafull(limite1,1) -.01 .01])
% axes(handles.axes6)
% plot(datafull(1:limite2,3),datafull(1:limite2,4)), axis tight
% ylabel('Torque [Nm]')
% axis([datafull(1,3) datafull(limite2,3) min(datafull(1:limite2,4))*1.1 max(datafull(1:limite2,4))*1.1])
% % axes(handles.axes5)
% % plot(datafull(:,3),datafull(:,5)), axis tight
% % axis([datafull(1,1) datafull(limite,1) 0 0.5])
% xlabel('Time [s]')
% ylabel('Sync')

%%
%%
axes(handles.axes3)
plot(datafull(:,1),datafull(:,2)), axis tight
ylabel('EMG [V]')
axis([datafull(1,1) datafull(end,1) -.01 .01])
axes(handles.axes6)
plot(datafull(:,1),datafull(:,4)), axis tight
ylabel('Torque [Nm]')
axis([datafull(1,1) datafull(end,1) min(datafull(:,4))*1.1 max(datafull(:,4))*1.1])
% axes(handles.axes5)
% plot(datafull(:,3),datafull(:,5)), axis tight
% axis([datafull(1,1) datafull(limite,1) 0 0.5])
xlabel('Time [s]')


% flag = questdlg('Do you want to cut the signal?','Select to continue');
% 
% if strcmp(flag,'Yes')
%     [x,y]=ginput(1);
%     x=round(x*1000);
%     datafull=datafull(x:end,:);
% end

[filename, pathname] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    strcat(pathname,filename(1:end-4)));
    
if isequal(filename,0)
   disp('Selection canceled')
else
   try
   save (fullfile(pathname, filename),'datafull','DataInformation','Fs','Fs2')
   disp(['You Selected:', fullfile(pathname, filename)])
   set(handles.Info,'String',fullfile(pathname, filename))
   set(handles.Info2,'String','The file was successfully saved!')
   catch ME
       errordlg('Please, select a file','Error!')
   end
end



end
set(handles.Info2,'String','Ready Import!')

% --------------------------------------------------------------------
function B_M_ImportIMU_Callback(hObject, eventdata, handles)
% hObject    handle to B_M_ImportIMU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname flagEstimulus
set(handles.Info2,'String','Current task: Import')
FlagSerial=get(handles.MultiFiles,'Value');
% FlagSerial=1;

if FlagSerial==1
    
    Import_Delsys_Serial; % Trabalho Bárbara
else

if ~ischar(pathname)
    pathname='';
end


[filename, pathname2] = uigetfile( ...
    {'*.csv','CSV Files';'*.xlsx','Excel Files (*.xlsx)';'*.xls','Excel Files (*.xlsx)';...
    '*.*','All files (*.*)'}, ...
    'Select the TXT file',pathname,'MultiSelect','on');

if isequal(pathname2,0)
   disp('Selection canceled')
   return
end

pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

for i=1:length(Datafile)   
    
try
% [data, dataText] = xlsread(Datafile{i});
if strcmp(Datafile{i}(end-3:end),'.csv')
    T=readtable(Datafile{i},'Delimiter',',');
else
    T=readtable(Datafile{i});
end
% data = table2array(T(:,2:end));
data = table2array(T);
dataText=T.Properties.VariableNames;

if strcmp('unix',dataText{1}(1:4))
    datafull=data(:,2:end);
    dataText=dataText(2:end);
else
    datafull=data;
end

set(handles.Info,'String',filename{i})
disp(['You Selected:', filename{i}])
set(handles.Info2,'String','Current task: Import')

catch ME
set(handles.Info2,'String',strcat('Error:',ME.message))
end

% ch1=get(handles.popch1,'Value')-1;
% ch2=get(handles.popch2,'Value')-1;
% ch3=get(handles.popch3,'Value')-1;
% ch4=get(handles.popch4,'Value')-1;
% ch5=get(handles.popch5,'Value')-1;
% ch6=get(handles.popch6,'Value')-1;
% ch7=get(handles.popch7,'Value')-1;
% ch8=get(handles.popch8,'Value')-1;


DataInformation = dataText;
% DataInformation{ch1}=get(handles.CH1,'String');
% DataInformation{ch2}=get(handles.CH2,'String');
% DataInformation{ch3}=get(handles.CH3,'String');
% DataInformation{ch4}=get(handles.CH4,'String'); 
% DataInformation{ch5}=get(handles.CH5,'String');
% DataInformation{ch6}=get(handles.CH6,'String');
% DataInformation{ch7}=get(handles.CH7,'String');
% DataInformation{ch8}=get(handles.CH8,'String'); 

% datafull(:,1)=data(:,ch1); % Time
% datafull(:,2)=data(:,ch2); % 
% datafull(:,3)=data(:,ch3); % 
% datafull(:,4)=data(:,ch4); % 
% try; datafull(:,5)=data(:,ch5); end
% try; datafull(:,6)=data(:,ch6); end
% try; datafull(:,7)=data(:,ch7); end 
% try; datafull(:,8)=data(:,ch8); end

clear data

%% Detecting sampling frequency
Fs=1/(datafull(2,1)-datafull(1,1)); % Frequency of sampling
% Fs2=1/(datafull(2,3)-datafull(1,3)); % Frequency of sampling

%% Baseline
t1 = 2; % seconds
t2 = 3; % seconds
nt1 = round(t1*Fs);
nt2 = round(t2*Fs);

%% Cutting from the synchronization cue
ff=0; % Delaty to avoid peaks of sync cue
sensCode = 1522; % Code for brest sensor (synch)

trialCode = filename{i}(9:10);
if strcmp(trialCode(2),'_') % For numbers with two digits > 9
    trialCode(2)=[]; 
    sens = str2num(filename{i}(15:18));
else
    sens = str2num(filename{i}(16:19));
end
tt = str2num (trialCode);

if sens==sensCode
    
xV = Onset_IMU(datafull(:,1),datafull(:,4),t1,t2,Fs);

if ~isempty(xV)
    xV=xV(1)+ff;
else
    xV=1;
    warning('Cutting threshold was empty','Warning')
    warndlg('Cutting threshold was empty','Warning')
end

trial(tt)=xV;

else
    xV = trial(tt);
end

td1 = datafull(xV:end,1)-datafull(xV,1);
datafull=[td1 datafull(xV:end,2:end)];



    
%%%%%%%%%%%%%%%%%
% [filename, pathname] = uiputfile( ...
%     {'*.mat','MAT Files (*.mat)';
%     '*.*',  'All files (*.*)'}, ...
%     'Select a file',...
%     strcat(pathname,filename{i}(1:end-4)));
% if isequal(filename{i},0)
%    disp('Selection canceled')
% else
%     
% end
   saveFile = strcat(pathname,filename{i}(1:end-4),'.mat');

   try
   save (saveFile,'datafull','DataInformation','Fs')
   disp(['You Selected:', fullfile(pathname, filename{i})])
   set(handles.Info,'String',fullfile(pathname, filename{i}))
   set(handles.Info2,'String','The file was successfully saved!')
   catch ME
       errordlg('Please, select a file','Error!')
   end

%    GraphicAxesIMU
%    B_LoadIMU_Callback(hObject, eventdata, handles)


end


end

set(handles.Info2,'String','Ready Import!')


% --- Executes on button press in B_Load.
function B_LoadIMU_Callback(hObject, eventdata, handles)
% hObject    handle to B_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Datafile filename 

FlagSerial=get(handles.MultiFiles,'Value');
% FlagSerial=1;

% prompt = {'Type of muscle'};
%     dlg_title = 'Muscle';
%     num_lines = 1;
%     def = {'1'};
%     answ = inputdlg(prompt,dlg_title,num_lines,def);
%     
% if ~isempty(answ)
%     chsel=str2num(answ{1});
% end

if ~ischar(pathname)
    pathname='';
end
[filename, pathname] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a MAT file',pathname);

if isequal(filename,0)

   disp('Selection canceled')
else
   disp(['You Selected:', fullfile(pathname, filename)])
   Datafile=strcat(pathname,filename);
   set(handles.Info,'String',Datafile)
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.Info2,'String','Busy...')
set(handles.PanelFigure,'Visible','off');
set(handles.PanelFigure2,'Visible','off');
set(handles.PanelFigure3,'Visible','on');

try
    load(Datafile)
    set(handles.Info,'String',Datafile)

    if ~exist('datafull','var')
               
    end
    
% if exist('Frms')

% datafull(:,2:end)=datafull(:,2:end)*1E06;
% Frms(:,2:end)=Frms(:,2:end)*1E06;
sized=size(datafull,2);
cont=0;
cont2=0;

Nchannel=size(datafull,2);
Nsamples=size(datafull,1);

while ~cont
MEPlotscale_Callback(datafull)
GraphicAxesIMU

if ~cont2
    button=questdlg('Do you want to cut the signal?','','Yes','No','Yes');
    if strcmp(button,'Yes')
    
    [x,y]=ginput(1);
    x(2)=x(1)+2;
    x(1)=x(1)-0.5;
    
    [a,samp1]=min(abs(Frms(:,1)-x(1)));
    [a,samp2]=min(abs(Frms(:,1)-x(2)));
    x=round(x*Fs); 
    lx=x(2)-x(1)+1;
    ls=samp2-samp1+1;
    
    datafulltemp=datafull;
    Frmstemp=Frms; 
    clear datafull Frms
    datafull(1:lx,1)=datafulltemp(1:lx,1);
    datafull(:,2:sized)=datafulltemp(x(1):x(2),2:sized);
    Frms(1:ls,1)=Frmstemp(1:ls,1);
    Frms(:,2:sized)=Frmstemp(samp1:samp2,2:sized);
    
    cont2=1;

%     Datafile=strcat(Datafile(1:end-4),'_Cutted.mat');
% 
%     try
%         save(Datafile,'datafull','DataInformation','Fs','Frms','Param')
%         set(handles.Info,'String',Datafile)
%         disp(['You Selected:', Datafile])
%         set(handles.Info2,'String','The file was successfully saved!')
%     catch
%        errordlg('Error saving file','Error')
%     end
    
    
    else   
        cont=1;           
    end
else
    
button=questdlg('It is OK?','','Yes','No','Yes');
if strcmp(button,'Yes')
    
    Datafile=strcat(Datafile(1:end-4),'_Cutted.mat');

    try
        save(Datafile,'datafull','DataInformation','Fs','Frms','Param')
        set(handles.Info,'String',Datafile)
        disp(['You Selected:', Datafile])
        set(handles.Info2,'String','The file was successfully saved!')
    catch
       errordlg('Error saving file','Error')
    end    
    
    cont=1;    
else
    datafull=datafulltemp;
    Frms=Frmstemp;
    cont2=0;
end

end



end

% end
catch MEL
    disp(strcat(MEL.identifier,'. Error in Load'))
end
end

clear datafulltemp Frmstemp datafull
set(handles.Info2,'String','Ready...')


% --- Executes on button press in plotFigure.
function plotFigure_Callback(hObject, eventdata, handles)
% hObject    handle to plotFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotFigure


% --------------------------------------------------------------------
function Noused6_Callback(hObject, eventdata, handles)
% hObject    handle to Noused6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in PanelEMGClose.
function PanelEMGClose_Callback(hObject, eventdata, handles)
% hObject    handle to PanelEMGClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.PanelEMG2,'Visible','off')
set(handles.PanelConfiguration,'Visible','on')

% --- Executes on button press in B_FilterEMG.
function B_FilterEMG_Callback(hObject, eventdata, handles)
% hObject    handle to B_FilterEMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Trabalho Bárbara UTFPR
global Datafile pathname

FlagSerial=get(handles.MultiFiles,'Value');
% FlagSerial=1;

FlagSerial=1;

if FlagSerial==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Serial
if ~ischar(pathname)
    pathname='';
end

% pathname = uigetdir(pathname);
% 
% if isequal(pathname,0)
% 
%    disp('Selection canceled')
% else
%     
% ldir=dir(pathname);
% name={ldir.name};
% for i=3:length(name)
[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple files',pathname,'MultiSelect','on');

if isequal(pathname2,0)
   disp('Selection canceled')
   return
end 

pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

for i=1:length(Datafile)


Datafile=fullfile(pathname, filename{i});
disp(['You Selected:', filename])
set(handles.Info2,'String','Busy...')

try
    clear datafull
    load(Datafile)
    set(handles.Info,'String',Datafile)

    if ~exist('datafull','var')
       continue        
    end

    datafull=removeZerosDelsys(datafull);
    dataf=EMGFilter(datafull(:,2:end),Fs,0); % flag=0 to dont pictures
    datafull=[datafull(:,1) dataf datafull(:,10:end)];
    clear dataf
        
    Datafilesave=strcat(Datafile(1:end-4),'_filt.mat');
    
   try
   save(Datafilesave,'datafull','DataInformation','Fs')
   set(handles.Info,'String',Datafilesave)
   disp(['File saved:', Datafilesave])
   set(handles.Info2,'String','The file was successfully saved!')
   catch
       errordlg('Error saving file','Error')
   end

catch
    errordlg('Error loadin file','Error')
end
end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%% Single
else
    
set(handles.Info2,'String','Current task: Filtering')

set(handles.Info,'String',Datafile)
    if ~isempty(Datafile)
    load (Datafile)
    set(handles.Info,'String',Datafile)

    if ~exist('datafull','var')
               
    end

    dataf=EMGFilter(datafull(:,2:end-1),Fs,1); % flag=0 to dont pictures / Revisar trabalho de Bárbara: dataf=EMGFilter(datafull(:,2:9),Fs,1);
    datafull=[datafull(:,1) dataf datafull(:,10:end)];
    clear dataf
        
[filename, pathname] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    strcat(pathname,strcat(Datafile(1:end-4),'_filtered')));
    
if isequal(filename,0)
   disp('Selection canceled')
else
   
   Datafile=fullfile(pathname, filename);
   try
   save(Datafile,'datafull','DataInformation','Fs')
   set(handles.Info,'String',Datafile)
   disp(['You Selected:', fullfile(pathname, filename)])
   set(handles.Info2,'String','The file was successfully saved!')
   catch
       errordlg('Error saving file','Error')
   end

end
    
    else
        errordlg('Please, select a file','Error!')
        
    end
    
end

% --- Executes on selection change in popupmenu24.
function popupmenu24_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu24 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu24


% --- Executes during object creation, after setting all properties.
function popupmenu24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in B_RMS.
function B_RMS_Callback(hObject, eventdata, handles)
% hObject    handle to B_RMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% trabalho Bárbara UTFPR
global Datafile pathname
set(handles.Info2,'String','Current task: Filtering')

FlagSerial=get(handles.MultiFiles,'Value');
% FlagSerial=0;
FlagSerial=1;

if FlagSerial==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Serial

if ~ischar(pathname)
    pathname='';
end

% pathname = uigetdir(pathname);
% 
% if isequal(pathname,0)
% 
%    disp('Selection canceled')
% else
%     
% ldir=dir(pathname);
% name={ldir.name};
[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple files',pathname,'MultiSelect','on');

if isequal(pathname2,0)
   disp('Selection canceled')
   return
end 

pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

for i=1:length(Datafile)


try
    load(Datafile{i})
    set(handles.Info,'String',filename{i})
    disp(['You Selected:', filename{i}])
    set(handles.Info2,'String','Busy in RMS...')
    
    % to avoid the walking files: Trabalho Arthur-Renata
    if strcmp(Datafile{i}(end-4),'7') || strcmp(Datafile{i}(end-4),'8') || strcmp(Datafile{i}(end-5:end-4),'13') || strcmp(Datafile{i}(end-5:end-4),'14') || strcmp(Datafile{i}(end-5),'W')
    
    else
    if exist('datafull','var')           


%% Rectification
Nchannel=size(datafull,2);
Nsamples=size(datafull,1);
clear datafRec
for ch=2:Nchannel
%         dataf(:,ch)=dataf(:,ch)-mean(dataf(:,ch));
    datafRec(:,ch)=abs(datafull(:,ch));       
end

%% RMS 
clear Frms
Param.w=str2num(get(handles.RMS_w,'String')); 
Param.shiftw=str2num(get(handles.RMS_shiftw,'String'));
[trms,Frms]=RMSvalue(datafRec,Fs,Param.w,Param.shiftw);
Frms(:,1)=trms';

clear trms datafRec

% Datafile=strcat(Datafile(1:end-4),'_RMS.mat');
DatafileSave=fullfile(pathname, strcat('RMS_',filename{i}));

try
save(DatafileSave,'datafull','DataInformation','Fs','Frms','Param')
set(handles.Info,'String',DatafileSave)
disp(['File Saved:', DatafileSave])
set(handles.Info2,'String','The file was successfully saved!')
catch
   errordlg('Error saving file','Error')
end


    else
        errordlg('Datafull is missing','Error')
    end
    end
catch
    errordlg('Error loading file','Error')
end

end

% end

else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Individual

set(handles.Info,'String',Datafile)
    if ~isempty(Datafile)
    load (Datafile)
    set(handles.Info,'String',Datafile)

    if ~exist('datafull','var')
               
    end


%% Rectification
Nchannel=size(datafull,2)-4;
Nsamples=size(datafull,1);
for ch=2:Nchannel
%         dataf(:,ch)=dataf(:,ch)-mean(dataf(:,ch));
    datafRec(:,ch)=abs(datafull(:,ch));       
end

%% RMS 
Param.w=str2num(get(handles.RMS_w,'String')); 
Param.shiftw=str2num(get(handles.RMS_shiftw,'String'));
[trms,Frms]=RMSvalue(datafRec,Fs,Param.w,Param.shiftw);
Frms(:,1)=trms';

clear trms datafRec
% %% moving RMS Filter
% resol=200; medmovil=100; res_corte=3000; kcut=20; k=5; % umbral=str2num(get(handles.umbral,'String'))/100;
% clear dataTemp
% shiftw=100;
% trms=[floor(w/2)/Fs:shiftw/Fs:Nsamples/Fs-floor(shiftw/2)/Fs];
% 
% for ch=2:Nchannel
%     data=datafRec(:,ch);
%     j=1;
% for i=medmovil:shiftw:size(data,1)
%     dataTemp(j)=mean(data(i-medmovil+1:i,1));
%     j=j+1;
% end
% 
% dataRMS(:,ch)=dataTemp;
% % espectro(dataf(:,ch),Fs);
% 
% if flagPlot
%     axes(handles.axes1),cla
%     plot(t,datafull_norm(:,ch)), axis tight
%     title('Normalized EMG signal')
%     ylabel('Magnitude')
%     axes(handles.axes2),cla
%     plot(t,dataf(:,ch)), axis tight
%     title('Filtered EMG signal')
%     ylabel('Magnitude')
%     axes(handles.axes3),cla
%     plot(t,datafRec(:,ch),'c'), axis tight
%     hold on
%     plot(trms,dataRMS(:,ch),'k'), axis tight
%     title('RMS filter')
%     ylabel('Magnitude')
%     xlabel('Seconds [s]')
%     axes(handles.axes4),cla
%     [f,mag]=espectro(dataf(:,ch),Fs);
%     plot(f,mag), axis tight
%     title('EMG spectrum')
%     ylabel('Magnitude')
%     xlabel('Frequency [Hz]')
%     
%     set(handles.Info2,'String',['Subject: ',num2str(sub)])
%     set(handles.Info3,'String',['Rep: ',TT,' CH: ',num2str(ch)])
% 
%     set(handles.apply,'Enable','Off')
%     pause()
% end
% 
% 
% end

[filename, pathname] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    strcat(pathname,strcat(Datafile(1:end-4),'_RMS')));
    
if isequal(filename,0)
   disp('Selection canceled')
else
   
   Datafile=fullfile(pathname, filename);
   try
   save(Datafile,'datafull','DataInformation','Fs','Frms','Param')
   set(handles.Info,'String',Datafile)
   disp(['You Selected:', fullfile(pathname, filename)])
   set(handles.Info2,'String','The file was successfully saved!')
   catch
       errordlg('Error saving file','Error')
   end

end
        
    else
        errordlg('Please, select a file','Error!')
        
    end
    
end

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3

% --- Executes on button press in B_MVC.
function B_MVC_Callback(hObject, eventdata, handles)
% hObject    handle to B_MVC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Datafile filename 

MVC=[];
FlagSerial=get(handles.MultiFiles,'Value');
% FlagSerial=1;

set(handles.PanelFigure,'Visible','on');
set(handles.PanelFigure2,'Visible','off');

FlagSerial=1;

if FlagSerial==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Serial
if ~ischar(pathname)
    pathname='';
end

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple files',pathname,'MultiSelect','on');

if isequal(pathname2,0)
   disp('Selection canceled')
   return
end 

pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

chsel=[0 0 0 0];

% for i=1:length(Datafile)

    
try
    

%     if exist('datafull','var')
%     if exist('Frms')

set(handles.PanelFigure,'Visible','on');
set(handles.PanelFigure2,'Visible','off');
set(handles.PanelFigure3,'Visible','off');

for ch=1:length(Datafile)

load(Datafile{ch})
set(handles.Info,'String',Datafile)
disp(['You Selected:', filename{ch}])
set(handles.Info2,'String','Busy...') 

chi=str2num(Datafile{ch}(end-9))+1;

if chsel(ch)==chi-1
    errordlg(strcat('The Channel ',num2str(ch), 'has already processed'),'Error!')
    break
else
    chsel(ch)=chi-1;
end

axes(handles.axes1),cla
axes(handles.axes2),cla
axes(handles.axes3),cla
axes(handles.axes4),cla
axes(handles.axes5),cla
axes(handles.axes6),cla

set(handles.axes4,'Visible','off')
set(handles.axes5,'Visible','off')
set(handles.axes1,'Visible','off')
set(handles.axes2,'Visible','off')
set(handles.axes6,'Visible','on')
set(handles.axes3,'Visible','on')

axes(handles.axes3)
cla
[eje_f,mag_ss]=espectro(datafull(:,chi),Fs,0);
plot(eje_f,mag_ss(1:length(eje_f)),'r')
xlabel('Frequency [Hz]')
ylabel('Power Spectrum')
clear mag_ss eje_f

axes(handles.axes6)
cla, hold on   
% subplot(211)
plot(datafull(:,1),datafull(:,chi),'c')
plot(Frms(:,1),Frms(:,chi),'r')
axis tight

xlabel('Time [s]')
title('MVC')
legend({DataInformation{chi},'RMS'})

cont=1;
while cont
% if sum(ch==chsel)>0 % To identify if this channel should be processed

for triali=1:3

[x,y]=ginput(1);
plot([x x],[min(datafull(:,chi)) max(datafull(:,chi))],'--k')
plot([x-0.25 x-0.25],[min(datafull(:,chi)) max(datafull(:,chi))],'-r')
plot([x+0.25 x+0.25],[min(datafull(:,chi)) max(datafull(:,chi))],'-r')

pause(0.5)

[a,samp]=min(abs(Frms(:,1)-x));
FsRMS=1/(Frms(2,1)-Frms(1,1));
% samp=x*Fs/Param.w;
center{chi-1,triali}=Frms(samp-round(0.25*FsRMS):samp+round(0.25*FsRMS),chi);
MVC(chi-1,triali)=mean(center{chi-1,triali});

MVCm(chi-1) = mean(MVC(chi-1,triali));

end

% plot([x-0.25 x+0.25],[mean(center) mean(center)],'r')
plot([datafull(1,1) datafull(end,1)],[MVCm(chi-1) MVCm(chi-1)],'--k')
legend({DataInformation{chi},'RMS','MVC'})

button=questdlg('Continue to the next channel?','','Yes','Repeat','Yes');
if strcmp(button,'Yes')
    cont=0;    
else
    axes(handles.axes1),cla
    axes(handles.axes2),cla
    axes(handles.axes3),cla
    axes(handles.axes4),cla
    axes(handles.axes5),cla
    axes(handles.axes6),cla
end

end
%     chi=chi+1;
    hold off
end

Datafilesave=fullfile(pathname, strcat('MVC_',filename{ch}));
try
save(Datafilesave,'datafull','DataInformation','Fs','Frms','Param','MVC','center','filename')
set(handles.Info,'String',Datafilesave)
disp(['You Selected:', Datafilesave])
set(handles.Info2,'String','The file was successfully saved!')
   
catch
    errordlg(strcat('The file could not be saved:',Datafile),'Error')
end
   
%     end
%    
%     else
%         errordlg('Datafull is missing!','Error')
%     end
catch
    waitfor(errordlg('Error in MVC!','Error'))
end

% end

% end

% end

else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Individual

if ~ischar(pathname)
    pathname='';
end

load (Datafile)

if exist('Frms')
    
axes(handles.axes1),cla
axes(handles.axes2),cla
axes(handles.axes3),cla
axes(handles.axes4),cla
axes(handles.axes5),cla
axes(handles.axes6),cla

set(handles.axes3,'Visible','off')
set(handles.axes4,'Visible','off')
set(handles.axes5,'Visible','off')
set(handles.axes1,'Visible','on')
set(handles.axes2,'Visible','on')
set(handles.axes6,'Visible','on')

set(handles.axes6,'Visible','on')
axes(handles.axes6)

for ch=2:size(datafull,2)-4
if sum(ch==chsel)>0
cla, hold on   
% subplot(211)
plot(datafull(:,1),datafull(:,ch),'b') 
plot(Frms(:,1),Frms(:,ch),'r')
axis tight

xlabel('Time [s]')
title('MVC')
legend({DataInformation{ch},'RMS'})
    
[x,y]=ginput(1);
plot([x x],[min(datafull(:,ch)) max(datafull(:,ch))],'--k')
legend({DataInformation{ch},'RMS','Center'})
pause(0.5)

[a,samp]=min(abs(Frms(:,1)-x));
FsRMS=1/(Frms(2,1)-Frms(1,1));
% samp=x*Fs/Param.w;
center=Frms(samp-round(0.25*FsRMS):samp+round(0.25*FsRMS),ch);
MVC(ch-1)=mean(center);

hold off
end
end
    
[filename, pathname] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    strcat(pathname,strcat(Datafile(1:end-4),'_MVC')));
    
if isequal(filename,0)
   disp('Selection canceled')
else
   
   Datafile=fullfile(pathname, filename);
   try
   save(Datafile,'datafull','DataInformation','Fs','Frms','Param','MVC','center','name','i')
   set(handles.Info,'String',Datafile)
   disp(['You Selected:', fullfile(pathname, filename)])
   set(handles.Info2,'String','The file was successfully saved!')
   catch
       errordlg('Error saving file','Error')
   end

end

set(handles.A_AnalysisMenu,'Enable','on')

else    
    warndlg('The file is invalid: The variable "datafull" is missing')
end

end

% % --- Executes on button press in B_MVC.
% function B_MVCBK_Callback(hObject, eventdata, handles)
% % hObject    handle to B_MVC (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% global pathname Datafile filename 
% 
% MVC=[];
% FlagSerial=get(handles.MultiFiles,'Value');
% % FlagSerial=1;
% 
% % prompt = {'Type of muscle'};
% %     dlg_title = 'Muscle';
% %     num_lines = 1;
% %     def = {'1'};
% %     answ = inputdlg(prompt,dlg_title,num_lines,def);
% %     
% % if ~isempty(answ)
% %     chsel=str2num(answ{1});
% % end
% set(handles.PanelFigure,'Visible','on');
% set(handles.PanelFigure2,'Visible','off');
% 
% 
% if FlagSerial==1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Serial
% if ~ischar(pathname)
%     pathname='';
% end
% 
% % pathname = uigetdir(pathname);
% % 
% % if isequal(pathname,0)
% % 
% %    disp('Selection canceled')
% % else
% %     
% % ldir=dir(pathname);
% % name={ldir.name};
% % for i=3:length(name)
% [filename, pathname2] = uigetfile( ...
%     {'*.mat','MAT Files (*.mat)';
%     '*.*',  'All files (*.*)'}, ...
%     'Load multiple files',pathname,'MultiSelect','on');
% 
% if isequal(pathname,0)
%    disp('Selection canceled')
%    return
% end 
% 
% pathname=pathname2;
% 
% Datafile=fullfile(pathname, filename);
% if ~iscell(Datafile)
%     Datafile2{1}=Datafile;
%     filename2{1}=filename;
%     clear Datafile filename
%     Datafile=Datafile2;
%     filename=filename2;
%     clear Datafile2 filename2
% end
% 
% for i=1:length(Datafile)
% 
% 
% Datafile=fullfile(pathname, filename{i});
% disp(['You Selected:', filename{i}])
% set(handles.Info2,'String','Busy...')
% 
% % % Trabalho Renata
% % % Suj=[1 2 3 5 6 7 9 12 13 14 17 18 19 26 28 32 33 42]; 
% % Suj=[1 2 3 5 6 7 9 12 13 14 17 18 19 26 32 33 42]; 
% % ident=str2num(name{i}(8:9));
% % if isempty(ident)
% %     ident=str2num(name{i}(8));
% % end
% % if sum(Suj==ident)>0    
%     
% try
%     load(Datafile)
%     set(handles.Info,'String',Datafile)
% 
%     if exist('datafull','var')
%     
%     if exist('Frms')
%     
% if strcmp(strcat(name{i}(1:3)),'FQD')
%     chsel=[2 4 6];
% elseif strcmp(strcat(name{i}(1:3)),'FQE')
%     chsel=[3 5 7];
% elseif strcmp(strcat(name{i}(1:3)),'FJD')
%     chsel=[2 4 6];
% elseif strcmp(strcat(name{i}(1:3)),'FJE')
%     chsel=[3 5 7];
% elseif strcmp(strcat(name{i}(1:3)),'EQD')
%     chsel=[2 4 6];
% elseif strcmp(strcat(name{i}(1:3)),'EQE')
%     chsel=[3 5 7];
% elseif strcmp(strcat(name{i}(1:3)),'EJD')
%     chsel=[2 4 6];   
% elseif strcmp(strcat(name{i}(1:3)),'EJE')
%     chsel=[3 5 7];
% elseif strcmp(strcat(name{i}(1:3)),'GD_')
%     chsel=[8];      
% elseif strcmp(strcat(name{i}(1:3)),'GE_')
%     chsel=[9];     
%     
% % Trabalho Arthur-Renata
% elseif strcmp(strcat(name{i}(end-5:end-4)),'F1') 
%     chsel=[2 3];  
%     jr=1;
% elseif strcmp(strcat(name{i}(end-5:end-4)),'F3')
%     chsel=[2 3];  
%     jr=3;
% elseif strcmp(strcat(name{i}(end-5:end-4)),'F5')
%     chsel=[2 3];  
%     jr=5;
% elseif strcmp(strcat(name{i}(end-5:end-4)),'F2') 
%     chsel=[4];  
%     jr=7;
% elseif strcmp(strcat(name{i}(end-5:end-4)),'F4')
%     chsel=[4];  
%     jr=8;
% elseif strcmp(strcat(name{i}(end-5:end-4)),'F6')
%     chsel=[4];  
%     jr=9;
% elseif strcmp(strcat(name{i}(end-5:end-4)),'F9')
%     chsel=[5]; 
%     jr=10;
% elseif strcmp(strcat(name{i}(end-5:end-4)),'11')
%     chsel=[5]; 
%     jr=11;
% elseif strcmp(strcat(name{i}(end-5:end-4)),'10')
%     chsel=[6];  
%     jr=12;
% elseif strcmp(strcat(name{i}(end-5:end-4)),'12')
%     chsel=[6];  
%     jr=13;
% else
%     chsel=[];
% end
% 
% clear DataInformation
% 
% % Trabalho Arthur e Renata
% DataInformation{1}='Time';
% DataInformation{2}='Gastro';
% DataInformation{3}='Soleus';
% DataInformation{4}='Tibial';
% DataInformation{5}='Vastus';
% DataInformation{6}='Biceps';
% DataInformation{7}='Sync';
% 
% for ch=2:size(datafull,2)
% if sum(ch==chsel)>0 % To identify if this channel should be processed
% axes(handles.axes1),cla
% axes(handles.axes2),cla
% axes(handles.axes3),cla
% axes(handles.axes4),cla
% axes(handles.axes5),cla
% axes(handles.axes6),cla
% 
% set(handles.axes4,'Visible','off')
% set(handles.axes5,'Visible','off')
% set(handles.axes1,'Visible','off')
% set(handles.axes2,'Visible','off')
% set(handles.axes6,'Visible','on')
% set(handles.axes3,'Visible','on')
% 
% axes(handles.axes3)
% cla
% [eje_f,mag_ss]=espectro(datafull(:,ch),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% xlabel('Frequency [Hz]')
% ylabel('Power Spectrum')
% clear mag_ss eje_f
% 
% axes(handles.axes6)
% cla, hold on   
% % subplot(211)
% plot(datafull(:,1),datafull(:,ch),'c') 
% plot(Frms(:,1),Frms(:,ch),'r')
% axis tight
% 
% xlabel('Time [s]')
% title('MVC')
% legend({DataInformation{ch},'RMS'})
% 
% [x,y]=ginput(1);
% plot([x x],[min(datafull(:,ch)) max(datafull(:,ch))],'--k')
% plot([x-0.25 x-0.25],[min(datafull(:,ch)) max(datafull(:,ch))],'-r')
% plot([x+0.25 x+0.25],[min(datafull(:,ch)) max(datafull(:,ch))],'-r')
% 
% legend({DataInformation{ch},'RMS','Center'})
% pause(0.5)
% 
% [a,samp]=min(abs(Frms(:,1)-x));
% FsRMS=1/(Frms(2,1)-Frms(1,1));
% % samp=x*Fs/Param.w;
% center=Frms(samp-round(0.25*FsRMS):samp+round(0.25*FsRMS),ch);
% MVC(jr,ident)=mean(center);
% 
% plot([x-0.25 x+0.25],[mean(center) mean(center)],'r')
% 
% jr=jr+1;
% hold off
% end
% end
% 
% Datafile=fullfile(pathname, strcat('MVC_',name{i}));
% try
% save(Datafile,'datafull','DataInformation','Fs','Frms','Param','MVC','center','name','i')
% set(handles.Info,'String',Datafile)
% disp(['You Selected:', fullfile(pathname, filename)])
% set(handles.Info2,'String','The file was successfully saved!')
%    
% catch
%     errordlg(strcat('The file could not be saved:',Datafile),'Error')
% end
%    
%     end
%    
%     else
%         errordlg('Datafull is missing!','Error')
%     end
% catch
%     waitfor(errordlg('Error in MVC!','Error'))
% end
% 
% % end
% 
% end
% 
% % end
% 
% else
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Individual
% 
% if ~ischar(pathname)
%     pathname='';
% end
% 
% load (Datafile)
% 
% if exist('Frms')
%     
% axes(handles.axes1),cla
% axes(handles.axes2),cla
% axes(handles.axes3),cla
% axes(handles.axes4),cla
% axes(handles.axes5),cla
% axes(handles.axes6),cla
% 
% set(handles.axes3,'Visible','off')
% set(handles.axes4,'Visible','off')
% set(handles.axes5,'Visible','off')
% set(handles.axes1,'Visible','on')
% set(handles.axes2,'Visible','on')
% set(handles.axes6,'Visible','on')
% 
% set(handles.axes6,'Visible','on')
% axes(handles.axes6)
% 
% for ch=2:size(datafull,2)-4
% if sum(ch==chsel)>0
% cla, hold on   
% % subplot(211)
% plot(datafull(:,1),datafull(:,ch),'b') 
% plot(Frms(:,1),Frms(:,ch),'r')
% axis tight
% 
% xlabel('Time [s]')
% title('MVC')
% legend({DataInformation{ch},'RMS'})
%     
% [x,y]=ginput(1);
% plot([x x],[min(datafull(:,ch)) max(datafull(:,ch))],'--k')
% legend({DataInformation{ch},'RMS','Center'})
% pause(0.5)
% 
% [a,samp]=min(abs(Frms(:,1)-x));
% FsRMS=1/(Frms(2,1)-Frms(1,1));
% % samp=x*Fs/Param.w;
% center=Frms(samp-round(0.25*FsRMS):samp+round(0.25*FsRMS),ch);
% MVC(ch-1)=mean(center);
% 
% hold off
% end
% end
%     
% [filename, pathname] = uiputfile( ...
%     {'*.mat','MAT Files (*.mat)';
%     '*.*',  'All files (*.*)'}, ...
%     'Select a file',...
%     strcat(pathname,strcat(Datafile(1:end-4),'_MVC')));
%     
% if isequal(filename,0)
%    disp('Selection canceled')
% else
%    
%    Datafile=fullfile(pathname, filename);
%    try
%    save(Datafile,'datafull','DataInformation','Fs','Frms','Param','MVC','center','name','i')
%    set(handles.Info,'String',Datafile)
%    disp(['You Selected:', fullfile(pathname, filename)])
%    set(handles.Info2,'String','The file was successfully saved!')
%    catch
%        errordlg('Error saving file','Error')
%    end
% 
% end
% 
% set(handles.A_AnalysisMenu,'Enable','on')
% 
% else    
%     warndlg('The file is invalid: The variable "datafull" is missing')
% end
% 
% end


% --- Executes on button press in B_Onset_Hilbert.
function B_Onset_Hilbert_Callback(hObject, eventdata, handles)
% hObject    handle to B_Onset_Hilbert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Datafile filename 

MVC=[];
FlagSerial=get(handles.MultiFiles,'Value');
% FlagSerial=1;

% prompt = {'Type of muscle'};
%     dlg_title = 'Muscle';
%     num_lines = 1;
%     def = {'1'};
%     answ = inputdlg(prompt,dlg_title,num_lines,def);
%     
% if ~isempty(answ)
%     chsel=str2num(answ{1});
% end

set(handles.B_Onset_Hilbert,'Enable','off')

FlagSerial=1;

if FlagSerial==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Serial

if ~ischar(pathname)
    pathname='';
end

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple files',pathname,'MultiSelect','on');

if isequal(pathname2,0)
   disp('Selection canceled')
   return
end

pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

for i=1:length(Datafile)

    load(Datafile{i})
    set(handles.Info,'String',filename{i})
    disp(['You Selected:', filename{i}])
    set(handles.Info2,'String','Busy in Onset/Offset...')

    if ~exist('datafull','var')
               
    end

Nchannel=size(datafull,2);
Nsamples=size(datafull,1);

% if ~exist('Frms')
    
set(handles.PanelFigure,'Visible','off');
set(handles.PanelFigure2,'Visible','off');
set(handles.PanelFigure3,'Visible','on');

Param.w=str2num(get(handles.RMS_w,'String')); 
Param.shiftw=str2num(get(handles.RMS_shiftw,'String'));

% datafull(:,2:end)=datafull(:,2:end)*1E06;
% Frms(:,2:end)=Frms(:,2:end)*1E06;
sized=size(datafull,2);
cont=0;
cont2=0;
jons=1; clear onset
% while ~cont

% Frms(:,1)=Frms(:,1)-Frms(1,1);

%% RMS
clear datafRec
datafRec=abs(datafull);  
[trms,Frms]=RMSvalue(datafRec,Fs,Param.w,Param.shiftw);

%% Onset/Offset detection
for col=2:Nchannel
    onset(:,col) = envelop_hilbert(datafull(:,col),Param.w,1,Param.shiftw,0);
end
xl=size(onset,1);
onset(:,1)=(1/xl:1/xl:1)*datafull(end,1)-1/xl;

%%
GraphicAxesP3

clear ind ind2 timeOnset timeOffset sampOnset sampOffset
for ch=2:Nchannel
    onsetDiff=diff(onset(:,ch));
    j=ch-1;
    ind{j}=(find(onsetDiff==1));
%     timeOnset(1:length(ind{j}),j)=onset(ind{j},1);
    timeOnset{j}=onset(ind{j},1);
%     sampOnset(1:length(ind{j}),j)=ind{j}; % is not useful because values does not corresponds with time
    
    ind2{j}=(find(onsetDiff==-1));
    timeOffset{j}=onset(ind2{j},1);
%     sampOffset(1:length(ind{j}),j)=ind2{j}; % is not useful because values does not corresponds with time
end


%%
% pause()
Datafilesave=fullfile(pathname,strcat('Onset_',filename{i}));
% Datafile=strcat('MVC',Datafile);
try
save(Datafilesave,'datafull','DataInformation','Fs','trms','Frms','Param','onset','timeOnset','timeOffset')
set(handles.Info,'String',Datafilesave)
disp(['You Selected:', strcat('MVC_',filename{i})])
set(handles.Info2,'String','The file was successfully saved!')
   
catch MEsaved
    errordlg(strcat(MEsaved.identifier,'. Error saving file.',Datafilesave),'Error')
end
%    

% else
%     errordlg('Please, run "RMS EMG" before!:','RMS is missing! ')
%     break
% end

% catch
%     warndlg('There was an error!')
% end

% end

end
set(handles.B_Onset_Hilbert,'Enable','on')
set(handles.Info2,'String','Process completed!')

else  

if ~ischar(pathname)
    pathname='';
end

load (Datafile)

if exist('Frms')
    
axes(handles.axes1),cla
axes(handles.axes2),cla
axes(handles.axes3),cla
axes(handles.axes4),cla
axes(handles.axes5),cla
axes(handles.axes6),cla

set(handles.axes3,'Visible','off')
set(handles.axes4,'Visible','off')
set(handles.axes5,'Visible','off')
set(handles.axes1,'Visible','on')
set(handles.axes2,'Visible','on')
set(handles.axes6,'Visible','on')

set(handles.axes6,'Visible','on')
axes(handles.axes6)

for ch=2:size(datafull,2)-4
if sum(ch==chsel)>0
cla, hold on   
% subplot(211)
plot(datafull(:,1),datafull(:,ch),'b') 
plot(Frms(:,1),Frms(:,ch),'r')
axis tight

xlabel('Time [s]')
title('MVC')
legend({DataInformation{ch},'RMS'})
    
[x,y]=ginput(1);
plot([x x],[min(datafull(:,ch)) max(datafull(:,ch))],'--k')
legend({DataInformation{ch},'RMS','Center'})
pause(0.5)

[a,samp]=min(abs(Frms(:,1)-x));
FsRMS=1/(Frms(2,1)-Frms(1,1));
% samp=x*Fs/Param.w;
center=Frms(samp-round(0.25*FsRMS):samp+round(0.25*FsRMS),ch);
MVC(ch-1)=mean(center);

hold off
end
end
    
[filename, pathname] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    strcat(pathname,strcat(Datafile(1:end-4),'_MVC')));
    
if isequal(filename,0)
   disp('Selection canceled')
else
   
   Datafile=fullfile(pathname, filename);
   try
   save(Datafile,'datafull','DataInformation','Fs','Frms','Param','MVC','center','name','ifile')
   set(handles.Info,'String',Datafile)
   disp(['You Selected:', fullfile(pathname, filename)])
   set(handles.Info2,'String','The file was successfully saved!')
   catch
       errordlg('Error saving file','Error')
   end

end

set(handles.A_AnalysisMenu,'Enable','on')

else    
%     warndlg('The file is invalid: The variable "datafull" is missing')
    errordlg('Please, run "RMS EMG" before!:','RMS is missing! ')
    return
end



end
set(handles.B_Onset_Hilbert,'Enable','on')

%% Trabalho Anterior 25/11/2020
% MVC=[];
% FlagSerial=get(handles.MultiFiles,'Value');
% % FlagSerial=1;
% 
% % prompt = {'Type of muscle'};
% %     dlg_title = 'Muscle';
% %     num_lines = 1;
% %     def = {'1'};
% %     answ = inputdlg(prompt,dlg_title,num_lines,def);
% %     
% % if ~isempty(answ)
% %     chsel=str2num(answ{1});
% % end
% 
% set(handles.B_Onset_Hilbert,'Enable','off')
% 
% if FlagSerial==1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Serial
% 
% if ~ischar(pathname)
%     pathname='';
% end
% 
% % load (Datafile)
% % 
% if ~ischar(pathname)
%     pathname='';
% end
% 
% pathname = uigetdir(pathname);
% 
% % if isequal(pathname,0)
% % 
% %    disp('Selection canceled')
% % else
% %     
% ldir=dir(pathname);
% filenameList={ldir.name};
% for ifile=3:length(filenameList)
% 
% Datafile=fullfile(pathname, filenameList{ifile});
% disp(['You Selected:', filenameList{ifile}])
% set(handles.Info2,'String','Busy...')
% 
% % try
%     load(Datafile)
%     set(handles.Info,'String',Datafile)
% 
%     if ~exist('datafull','var')
%                
%     end
% 
%     
% if exist('Frms')
%     
% axes(handles.axes1),cla
% axes(handles.axes2),cla
% axes(handles.axes3),cla
% axes(handles.axes4),cla
% axes(handles.axes5),cla
% axes(handles.axes6),cla
% 
% set(handles.axes4,'Visible','off')
% set(handles.axes5,'Visible','off')
% set(handles.axes1,'Visible','off')
% set(handles.axes2,'Visible','off')
% set(handles.axes6,'Visible','on')
% set(handles.axes3,'Visible','on')
% set(handles.axes7,'Visible','off')
% 
% set(handles.PanelFigure,'Visible','off');
% set(handles.PanelFigure2,'Visible','on');
% 
% axes(handles.axes9),cla
% axes(handles.axes10),cla
% axes(handles.axes11),cla
% axes(handles.axes12),cla
% axes(handles.axes13),cla
% axes(handles.axes14),cla
% axes(handles.axes15),cla
% axes(handles.axes16),cla
% axes(handles.axes17),cla
% axes(handles.axes18),cla
% axes(handles.axes19),cla
% axes(handles.axes20),cla
% axes(handles.axes21),cla
% axes(handles.axes22),cla
% axes(handles.axes23),cla
% axes(handles.axes24),cla
% 
% % DataInformation{1}='Time EMG';
% % DataInformation{2}='RFD';
% % DataInformation{3}='RFE';
% % DataInformation{4}='VMD';
% % DataInformation{5}='VME';
% % DataInformation{6}='BFD';
% % DataInformation{7}='BFE';
% % DataInformation{8}='GD';
% % DataInformation{9}='GE';
% % DataInformation{10}='Sync';
% 
% 
% % datafull(:,2:end)=datafull(:,2:end)*1E06;
% % Frms(:,2:end)=Frms(:,2:end)*1E06;
% sized=size(datafull,2);
% cont=0;
% cont2=0;
% jons=1; clear onset xonset
% % while ~cont
% 
% Frms(:,1)=Frms(:,1)-Frms(1,1);
% axes(handles.axes9)
% col=2;
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% plot(Frms(:,1),Frms(:,col),'r')
% onset(:,col) = envelop_hilbert(datafull(:,col),100,1,50,0);
% xl=length(onset(:,col)); 
% onset(:,1)=(1/xl:1/xl:1)*datafull(end,1)-1/xl;
% plot(onset(:,1),onset(:,col)*max(datafull(:,col)),'-k')
% % plot(datafull(:,1),datafull(:,11)/max(datafull(:,11))*max(datafull(:,col)),'k')
% ylabel(DataInformation{2})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% jons=jons+1;
% col=3;
% axes(handles.axes10)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% plot(Frms(:,1),Frms(:,col),'r')
% onset(:,col) = envelop_hilbert(datafull(:,col),100,1,50,0);
% xl=length(onset(:,col)); 
% plot(onset(:,1),onset(:,col)*max(datafull(:,col)),'-k')
% ylabel(DataInformation{3})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% jons=jons+1;
% col=4;
% axes(handles.axes11)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% plot(Frms(:,1),Frms(:,col),'r')
% onset(:,col) = envelop_hilbert(datafull(:,col),100,1,50,0);
% xl=length(onset(:,col)); 
% plot(onset(:,1),onset(:,col)*max(datafull(:,col)),'-k')
% ylabel(DataInformation{4})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% jons=jons+1;
% col=5;
% axes(handles.axes12)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% plot(Frms(:,1),Frms(:,col),'r')
% onset(:,col) = envelop_hilbert(datafull(:,col),100,1,50,0);
% xl=length(onset(:,col)); 
% plot(onset(:,1),onset(:,col)*max(datafull(:,col)),'-k')
% ylabel(DataInformation{5})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% jons=jons+1;
% col=6;
% axes(handles.axes13)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% plot(Frms(:,1),Frms(:,col),'r')
% onset(:,col) = envelop_hilbert(datafull(:,col),100,1,50,0);
% xl=length(onset(:,col)); 
% plot(onset(:,1),onset(:,col)*max(datafull(:,col)),'-k')
% ylabel(DataInformation{6})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% jons=jons+1;
% col=7;
% axes(handles.axes14)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% plot(Frms(:,1),Frms(:,col),'r')
% onset(:,col) = envelop_hilbert(datafull(:,col),100,1,50,0);
% xl=length(onset(:,col)); 
% plot(onset(:,1),onset(:,col)*max(datafull(:,col)),'-k')
% ylabel(DataInformation{7})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% jons=jons+1;
% col=8;
% axes(handles.axes15)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% plot(Frms(:,1),Frms(:,col),'r')
% onset(:,col) = envelop_hilbert(datafull(:,col),100,1,50,0);
% xl=length(onset(:,col)); 
% plot(onset(:,1),onset(:,col)*max(datafull(:,col)),'-k')
% ylabel(DataInformation{8})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% jons=jons+1;
% col=9;
% axes(handles.axes16)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% plot(Frms(:,1),Frms(:,col),'r')
% onset(:,col) = envelop_hilbert(datafull(:,col),100,1,50,0);
% xl=length(onset(:,col)); 
% plot(onset(:,1),onset(:,col)*max(datafull(:,col)),'-k')
% ylabel(DataInformation{9})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% xlabel('Time [s]')
% clear ind ind2 timeOnset timeOffset
% for i=2:9
%     onsetDiff=diff(onset(:,i));
%     j=i-1;
%     ind{j}=(find(onsetDiff==1));
%     timeOnset(1:length(ind{j}),j)=onset(ind{j},1);
%     sampOnset(1:length(ind{j}),j)=ind{j}; % is not useful because values does not corresponds with time
%     
%     ind2{j}=(find(onsetDiff==-1));
%     timeOffset(1:length(ind{j}),j)=onset(ind2{j},1);
%     sampOffset(1:length(ind{j}),j)=ind2{j}; % is not useful because values does not corresponds with time
% end
% 
% axes(handles.axes17)
% col=2;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes18)
% col=3;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes19)
% col=4;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes20)
% col=5;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes21)
% col=6;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes22)
% col=7;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes23)
% col=8;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes24)
% col=9;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% 
% %% MVC for Onsets
% 
% Param.w=str2num(get(handles.RMS_w,'String')); 
% Param.shiftw=str2num(get(handles.RMS_shiftw,'String'));
% % clear RMSval timeOnsetRMS
% 
% for ch=1:size(timeOnset,2)
%     for item=1:size(timeOnset,1)
%         sub=datafull(:,1)-timeOffset(item,ch);
%         [mval,b]=min(abs(sub));
%         sub=datafull(:,1)-timeOnset(item,ch);
%         [mval,a]=min(abs(sub));
%         if b-a>50
%             pulse=datafull(a:b,ch+1);
% %           [trms,pulseRMS]=RMSvalue(pulse,Fs,Param.w,Param.shiftw);
%             PorcPulse=round((b-a)*0.15);
%             RMSval{ifile}(item,ch)=rms(pulse(PorcPulse:end-PorcPulse));
%             timeOnsetRMS{ifile}(item,ch)=timeOnset(item,ch);
%         end
%     end
% end
% 
% %%
% pause()
% Datafile=fullfile(pathname,strcat('MVC_',filenameList{ifile}));
% % Datafile=strcat('MVC',Datafile);
% try
% % save(Datafile,'datafull','DataInformation','Fs','Frms','Param','onset','timeOnset','timeOffset','RMSval','timeOnsetRMS')
% set(handles.Info,'String',Datafile)
% disp(['You Selected:', strcat('MVC_',filenameList{ifile})])
% set(handles.Info2,'String','The file was successfully saved!')
%    
% catch
%     errordlg(strcat('The file could not be saved:',Datafile),'Error')
% end
% %    
% 
% else
%     errordlg('Please, run "RMS EMG" before!:','RMS is missing! ')
%     break
% end
% 
% % catch
% %     warndlg('There was an error!')
% % end
% 
% % end
% 
% end
% set(handles.B_Onset_Hilbert,'Enable','on')
% 
% else  
% 
% if ~ischar(pathname)
%     pathname='';
% end
% 
% load (Datafile)
% 
% if exist('Frms')
%     
% axes(handles.axes1),cla
% axes(handles.axes2),cla
% axes(handles.axes3),cla
% axes(handles.axes4),cla
% axes(handles.axes5),cla
% axes(handles.axes6),cla
% 
% set(handles.axes3,'Visible','off')
% set(handles.axes4,'Visible','off')
% set(handles.axes5,'Visible','off')
% set(handles.axes1,'Visible','on')
% set(handles.axes2,'Visible','on')
% set(handles.axes6,'Visible','on')
% 
% set(handles.axes6,'Visible','on')
% axes(handles.axes6)
% 
% for ch=2:size(datafull,2)-4
% if sum(ch==chsel)>0
% cla, hold on   
% % subplot(211)
% plot(datafull(:,1),datafull(:,ch),'b') 
% plot(Frms(:,1),Frms(:,ch),'r')
% axis tight
% 
% xlabel('Time [s]')
% title('MVC')
% legend({DataInformation{ch},'RMS'})
%     
% [x,y]=ginput(1);
% plot([x x],[min(datafull(:,ch)) max(datafull(:,ch))],'--k')
% legend({DataInformation{ch},'RMS','Center'})
% pause(0.5)
% 
% [a,samp]=min(abs(Frms(:,1)-x));
% FsRMS=1/(Frms(2,1)-Frms(1,1));
% % samp=x*Fs/Param.w;
% center=Frms(samp-round(0.25*FsRMS):samp+round(0.25*FsRMS),ch);
% MVC(ch-1)=mean(center);
% 
% hold off
% end
% end
%     
% [filename, pathname] = uiputfile( ...
%     {'*.mat','MAT Files (*.mat)';
%     '*.*',  'All files (*.*)'}, ...
%     'Select a file',...
%     strcat(pathname,strcat(Datafile(1:end-4),'_MVC')));
%     
% if isequal(filename,0)
%    disp('Selection canceled')
% else
%    
%    Datafile=fullfile(pathname, filename);
%    try
%    save(Datafile,'datafull','DataInformation','Fs','Frms','Param','MVC','center','name','ifile')
%    set(handles.Info,'String',Datafile)
%    disp(['You Selected:', fullfile(pathname, filename)])
%    set(handles.Info2,'String','The file was successfully saved!')
%    catch
%        errordlg('Error saving file','Error')
%    end
% 
% end
% 
% set(handles.A_AnalysisMenu,'Enable','on')
% 
% else    
% %     warndlg('The file is invalid: The variable "datafull" is missing')
%     errordlg('Please, run "RMS EMG" before!:','RMS is missing! ')
%     return
% end
% 
% 
% 
% end
% set(handles.B_Onset_Hilbert,'Enable','on')

% --- Executes on button press in B_ClearOnsetD.
function B_ClearOnsetD_Callback(hObject, eventdata, handles)
% hObject    handle to B_ClearOnsetD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Datafile filename 

if ~ischar(pathname)
    pathname='';
end

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple files',pathname,'MultiSelect','on');

if isequal(pathname2,0)
   disp('Selection canceled')
   return
end

pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

factor = str2num(get(handles.Edit_ClearOnset,'String'))/1000;

for i=1:length(Datafile)

    load(Datafile{i})
    set(handles.Info,'String',filename{i})
    disp(['You Selected:', filename{i}])
    set(handles.Info2,'String','Busy in Onset/Offset...')

% if ~exist('datafull','var')
% 
% Nchannel=size(datafull,2);
% Nsamples=size(datafull,1);

% clear RMSval timeOnsetRMS

Nchannel=size(onset,2);
Nsamples=size(onset,1);
% onset = datafull(:,1);

%         if b-a > factor
%             pulse=datafull(a:b,ch+1);
% %           [trms,pulseRMS]=RMSvalue(pulse,Fs,Param.w,Param.shiftw);
%             PorcPulse=round((b-a)*0.15);
%             RMSval{ifile}(item,ch)=rms(pulse(PorcPulse:end-PorcPulse));
%             timeOnsetRMS{ifile}(item,ch)=timeOnset(item,ch);
%         end
for ch=1:Nchannel-1
    onset(1:Nsamples,ch+1) = zeros(Nsamples,1);
    
%     ix2 = [];
%     for item=1:length(timeOnset{ch})-1
%         if timeOnset{ch}(item+1) - timeOffset{ch}(item) < factor
%             ix2 = [ix2 item];
%         end
% 
%     end
%     timeOnset{ch}(ix2+1) = [];
%     timeOffset{ch}(ix2) = [];
    
    ix = [];
    for item=1:length(timeOnset{ch})
        try
        if timeOffset{ch}(item) - timeOnset{ch}(item) < factor
            ix = [ix item];
        end
        end
    end
    timeOnset{ch}(ix) = [];
    timeOffset{ch}(ix) = [];
    
    for jj=1:length(timeOnset{ch})
        try
        [y,x1] = min(abs((datafull(:,1)-timeOnset{ch}(jj))));
        [y,x2] = min(abs((datafull(:,1)-timeOffset{ch}(jj))));
        
        onset(x1:x2,ch+1)=1;
        end
    end
    
end    
    
GraphicAxesP3

%% Saving file
Datafilesave=fullfile(pathname,strcat('cD',filename{i}));
% Datafile=strcat('MVC',Datafile);
try
save(Datafilesave,'datafull','DataInformation','Fs','trms','Frms','Param','onset','timeOnset','timeOffset')
set(handles.Info,'String',Datafilesave)
disp(['You Selected:', strcat('MVC_',filename{i})])
set(handles.Info2,'String','The file was successfully saved!')
   
catch MEsaved
    errordlg(strcat(MEsaved.identifier,'. Error saving file.',Datafilesave),'Error')
end
    
    


% end

end

% --- Executes on button press in B_ClearOnsetU.
function B_ClearOnsetU_Callback(hObject, eventdata, handles)
% hObject    handle to B_ClearOnsetU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Datafile filename 

if ~ischar(pathname)
    pathname='';
end

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple files',pathname,'MultiSelect','on');

if isequal(pathname2,0)
   disp('Selection canceled')
   return
end

pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

factor = str2num(get(handles.Edit_ClearOnset,'String'))/1000;
set(handles.PanelFigure,'Visible','off');
set(handles.PanelFigure2,'Visible','off');
set(handles.PanelFigure3,'Visible','on');

for i=1:length(Datafile)

    load(Datafile{i})
    set(handles.Info,'String',filename{i})
    disp(['You Selected:', filename{i}])
    set(handles.Info2,'String','Busy in Onset/Offset...')

% if ~exist('datafull','var')
% 
% Nchannel=size(datafull,2);
% Nsamples=size(datafull,1);

% clear RMSval timeOnsetRMS

Nchannel=size(datafull,2);
Nsamples=size(datafull,1);
% onset = datafull(:,1);

%         if b-a > factor
%             pulse=datafull(a:b,ch+1);
% %           [trms,pulseRMS]=RMSvalue(pulse,Fs,Param.w,Param.shiftw);
%             PorcPulse=round((b-a)*0.15);
%             RMSval{ifile}(item,ch)=rms(pulse(PorcPulse:end-PorcPulse));
%             timeOnsetRMS{ifile}(item,ch)=timeOnset(item,ch);
%         end
for ch=1:Nchannel-1
    onset(1:Nsamples,ch+1) = zeros(Nsamples,1);
    
    ix2 = [];
    for item=1:length(timeOnset{ch})-1
        if timeOnset{ch}(item+1) - timeOffset{ch}(item) < factor
            ix2 = [ix2 item];
        end

    end
    timeOnset{ch}(ix2+1) = [];
    timeOffset{ch}(ix2) = [];
    
%     ix = [];
%     for item=1:length(timeOnset{ch})
%         if timeOffset{ch}(item) - timeOnset{ch}(item) < factor
%             ix = [ix item];
%         end
%     end
%     timeOnset{ch}(ix) = [];
%     timeOffset{ch}(ix) = [];
    
    for jj=1:length(timeOnset{ch})
        [y,x1] = min(abs((datafull(:,1)-timeOnset{ch}(jj))));
        [y,x2] = min(abs((datafull(:,1)-timeOffset{ch}(jj))));
        
        onset(x1:x2,ch+1)=1;
    end
    
end    

GraphicAxesP3

%% Saving file
Datafilesave=fullfile(pathname,strcat('cU',filename{i}));
% Datafile=strcat('MVC',Datafile);
try
save(Datafilesave,'datafull','DataInformation','Fs','trms','Frms','Param','onset','timeOnset','timeOffset')
set(handles.Info,'String',Datafilesave)
disp(['You Selected:', strcat('MVC_',filename{i})])
set(handles.Info2,'String','The file was successfully saved!')
   
catch MEsaved
    errordlg(strcat(MEsaved.identifier,'. Error saving file.',Datafilesave),'Error')
end
    
    


% end

end


% --- Executes on button press in B_Onset_RMS.
function B_Onset_RMS_Callback(hObject, eventdata, handles)
% hObject    handle to B_Onset_RMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Datafile filename 

if ~ischar(pathname)
    pathname='';
end

[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Load multiple files',pathname,'MultiSelect','on');

if isequal(pathname2,0)
   disp('Selection canceled')
   return
end

pathname=pathname2;

Datafile=fullfile(pathname, filename);
if ~iscell(Datafile)
    Datafile2{1}=Datafile;
    filename2{1}=filename;
    clear Datafile filename
    Datafile=Datafile2;
    filename=filename2;
    clear Datafile2 filename2
end

factor = str2num(get(handles.Edit_ClearOnset,'String'))/1000;
set(handles.PanelFigure,'Visible','off');
set(handles.PanelFigure2,'Visible','off');
set(handles.PanelFigure3,'Visible','on');

for i=1:length(Datafile)

    load(Datafile{i})
    set(handles.Info,'String',filename{i})
    disp(['You Selected:', filename{i}])
    set(handles.Info2,'String','Busy in Onset/Offset...')

    
Param.w=str2num(get(handles.RMS_w,'String')); 
Param.shiftw=str2num(get(handles.RMS_shiftw,'String'));

%% RMS
clear datafRec
datafRec=abs(datafull);  
[trms,Frms]=RMSvalue(datafRec,Fs,Param.w,Param.shiftw);

Nchannel=size(datafull,2);
Nsamples=size(datafull,1);
onset = datafull(:,1);
onset(Nsamples,Nchannel) = 0;

caseth = get(handles.thperc,'Value');

if caseth==1
    % Percentual
    th=str2num(get(handles.thrms,'String'))/100;
    thrms=max(Frms(:,2:end))*th;
else
    % Magnitude
    thrms=str2num(get(handles.thrms,'String'));
end


for ch=1:Nchannel-1
        
    valHigh=Frms(:,ch+1) > thrms;
    lth=length(valHigh);
    ovalHighDiff=diff(valHigh);
    
    timeOnset{ch}=trms(find(ovalHighDiff==1))';
    timeOffset{ch}=trms(find(ovalHighDiff==-1))';
    
    for jj=1:length(timeOnset{ch})
        try
        [y,x1] = min(abs((datafull(:,1)-timeOnset{ch}(jj))));
        [y,x2] = min(abs((datafull(:,1)-timeOffset{ch}(jj))));
        
        onset(x1:x2,ch+1)=1;
        end
    end
    
end    

GraphicAxesP3

clear ind ind2 timeOnset timeOffset sampOnset sampOffset
for ch=2:Nchannel
    onsetDiff=diff(onset(:,ch));
    j=ch-1;
    ind{j}=(find(onsetDiff==1));
%     timeOnset(1:length(ind{j}),j)=onset(ind{j},1);
    timeOnset{j}=onset(ind{j},1);
%     sampOnset(1:length(ind{j}),j)=ind{j}; % is not useful because values does not corresponds with time
    
    ind2{j}=(find(onsetDiff==-1));
    timeOffset{j}=onset(ind2{j},1);
%     sampOffset(1:length(ind{j}),j)=ind2{j}; % is not useful because values does not corresponds with time
end


%% Saving file
Datafilesave=fullfile(pathname,strcat('RMS',filename{i}));
% Datafile=strcat('MVC',Datafile);
try
save(Datafilesave,'datafull','DataInformation','Fs','trms','Frms','Param','onset','timeOnset','timeOffset')
set(handles.Info,'String',Datafilesave)
disp(['You Selected:', strcat('MVC_',filename{i})])
set(handles.Info2,'String','The file was successfully saved!')
   
catch MEsaved
    errordlg(strcat(MEsaved.identifier,'. Error saving file.',Datafilesave),'Error')
end
    
    


% end

end


function RMS_shiftw_Callback(hObject, eventdata, handles)
% hObject    handle to RMS_shiftw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RMS_shiftw as text
%        str2double(get(hObject,'String')) returns contents of RMS_shiftw as a double


% --- Executes during object creation, after setting all properties.
function RMS_shiftw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RMS_shiftw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RMS_w_Callback(hObject, eventdata, handles)
% hObject    handle to RMS_w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RMS_w as text
%        str2double(get(hObject,'String')) returns contents of RMS_w as a double


% --- Executes during object creation, after setting all properties.
function RMS_w_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RMS_w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MultiFiles.
function MultiFiles_Callback(hObject, eventdata, handles)
% hObject    handle to MultiFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MultiFiles


% --- Executes on button press in B_Load.
function B_Load_Callback(hObject, eventdata, handles)
% hObject    handle to B_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname Datafile filename 

FlagSerial=get(handles.MultiFiles,'Value');
% FlagSerial=1;

% prompt = {'Type of muscle'};
%     dlg_title = 'Muscle';
%     num_lines = 1;
%     def = {'1'};
%     answ = inputdlg(prompt,dlg_title,num_lines,def);
%     
% if ~isempty(answ)
%     chsel=str2num(answ{1});
% end

if ~ischar(pathname)
    pathname='';
end
[filename, pathname] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a MAT file',pathname);

if isequal(filename,0)

   disp('Selection canceled')
else
   disp(['You Selected:', fullfile(pathname, filename)])
   Datafile=strcat(pathname,filename);
   set(handles.Info,'String',Datafile)
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.Info2,'String','Busy...')
set(handles.PanelFigure,'Visible','off');
set(handles.PanelFigure2,'Visible','off');
set(handles.PanelFigure3,'Visible','on');

try
    load(Datafile)
    set(handles.Info,'String',Datafile)

    if ~exist('datafull','var')
               
    end
    
% if exist('Frms')

% datafull(:,2:end)=datafull(:,2:end)*1E06;
% Frms(:,2:end)=Frms(:,2:end)*1E06;
sized=size(datafull,2);
cont=0;
cont2=0;

Nchannel=size(datafull,2);
Nsamples=size(datafull,1);

while ~cont
MEPlotscale_Callback(datafull)
GraphicAxesP3

if ~cont2
    button=questdlg('Do you want to cut the signal?','','Yes','No','Yes');
    if strcmp(button,'Yes')
    
    [x,y]=ginput(1);
    x(2)=x(1)+2;
    x(1)=x(1)-0.5;
    
    [a,samp1]=min(abs(Frms(:,1)-x(1)));
    [a,samp2]=min(abs(Frms(:,1)-x(2)));
    x=round(x*Fs); 
    lx=x(2)-x(1)+1;
    ls=samp2-samp1+1;
    
    datafulltemp=datafull;
    Frmstemp=Frms; 
    clear datafull Frms
    datafull(1:lx,1)=datafulltemp(1:lx,1);
    datafull(:,2:sized)=datafulltemp(x(1):x(2),2:sized);
    Frms(1:ls,1)=Frmstemp(1:ls,1);
    Frms(:,2:sized)=Frmstemp(samp1:samp2,2:sized);
    
    cont2=1;

%     Datafile=strcat(Datafile(1:end-4),'_Cutted.mat');
% 
%     try
%         save(Datafile,'datafull','DataInformation','Fs','Frms','Param')
%         set(handles.Info,'String',Datafile)
%         disp(['You Selected:', Datafile])
%         set(handles.Info2,'String','The file was successfully saved!')
%     catch
%        errordlg('Error saving file','Error')
%     end
    
    
    else   
        cont=1;           
    end
else
    
button=questdlg('It is OK?','','Yes','No','Yes');
if strcmp(button,'Yes')
    
    Datafile=strcat(Datafile(1:end-4),'_Cutted.mat');

    try
        save(Datafile,'datafull','DataInformation','Fs','Frms','Param')
        set(handles.Info,'String',Datafile)
        disp(['You Selected:', Datafile])
        set(handles.Info2,'String','The file was successfully saved!')
    catch
       errordlg('Error saving file','Error')
    end    
    
    cont=1;    
else
    datafull=datafulltemp;
    Frms=Frmstemp;
    cont2=0;
end

end



end

% end
catch MEL
    disp(strcat(MEL.identifier,'. Error in Load'))
end
end

clear datafulltemp Frmstemp datafull
set(handles.Info2,'String','Ready...')

%% Trabajo Barbara
% FlagSerial=get(handles.MultiFiles,'Value');
% % FlagSerial=1;
% 
% % prompt = {'Type of muscle'};
% %     dlg_title = 'Muscle';
% %     num_lines = 1;
% %     def = {'1'};
% %     answ = inputdlg(prompt,dlg_title,num_lines,def);
% %     
% % if ~isempty(answ)
% %     chsel=str2num(answ{1});
% % end
% 
% if ~ischar(pathname)
%     pathname='';
% end
% [filename, pathname] = uigetfile( ...
%     {'*.mat','MAT Files (*.mat)';
%     '*.*',  'All files (*.*)'}, ...
%     'Select a MAT file',pathname);
% 
% if isequal(filename,0)
% 
%    disp('Selection canceled')
% else
%    disp(['You Selected:', fullfile(pathname, filename)])
%    Datafile=strcat(pathname,filename);
%    set(handles.Info,'String',Datafile)
% 
% % DataInformation{1}='Time';
% % DataInformation{2}='Trigger';
% % DataInformation{3}='EMG';
% % DataInformation{4}='Torque';
%         
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% set(handles.Info2,'String','Busy...')
% 
% try
%     load(Datafile)
%     set(handles.Info,'String',Datafile)
% 
%     if ~exist('datafull','var')
%                
%     end
% 
%     
% % if exist('Frms')
%     
% axes(handles.axes1),cla
% axes(handles.axes2),cla
% axes(handles.axes3),cla
% axes(handles.axes4),cla
% axes(handles.axes5),cla
% axes(handles.axes6),cla
% 
% set(handles.axes4,'Visible','off')
% set(handles.axes5,'Visible','off')
% set(handles.axes1,'Visible','off')
% set(handles.axes2,'Visible','off')
% set(handles.axes6,'Visible','on')
% set(handles.axes3,'Visible','on')
% set(handles.axes7,'Visible','off')
% 
% set(handles.PanelFigure,'Visible','off');
% set(handles.PanelFigure2,'Visible','on');
% 
% axes(handles.axes9),cla
% axes(handles.axes10),cla
% axes(handles.axes11),cla
% axes(handles.axes12),cla
% axes(handles.axes13),cla
% axes(handles.axes14),cla
% axes(handles.axes15),cla
% axes(handles.axes16),cla
% axes(handles.axes17),cla
% axes(handles.axes18),cla
% axes(handles.axes19),cla
% axes(handles.axes20),cla
% axes(handles.axes21),cla
% axes(handles.axes22),cla
% axes(handles.axes23),cla
% axes(handles.axes24),cla
% 
% 
% % DataInformation{1}='Time EMG';
% % DataInformation{2}='RFD';
% % DataInformation{3}='RFE';
% % DataInformation{4}='VMD';
% % DataInformation{5}='VME';
% % DataInformation{6}='BFD';
% % DataInformation{7}='BFE';
% % DataInformation{8}='GD';
% % DataInformation{9}='GE';
% % DataInformation{10}='Sync';
% 
% 
% % datafull(:,2:end)=datafull(:,2:end)*1E06;
% % Frms(:,2:end)=Frms(:,2:end)*1E06;
% sized=size(datafull,2);
% cont=0;
% cont2=0;
% 
% while ~cont
%     
% Maxis=max(datafull(:,2:end));
% maxis=min(datafull(:,2:end));
% % Maxis=[0.05 0.4 0.1 0.1];
% % maxis=[-0.05 -0.4 -0.1 -0.1];
% 
% 
% % C1 -0.04;0.05
% % C2 -0.4; 0.3
% % C3 -0.1;0.5
% % C4 -0.1;0.1
% 
% axes(handles.axes9)
% col=2;
% plot(datafull(:,1),datafull(:,col),'b'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{2})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis([datafull(1,1) datafull(end,1) maxis(col-1) Maxis(col-1)])
% % axis tight, 
% hold off
% 
% col=3;
% axes(handles.axes10)
% plot(datafull(:,1),datafull(:,col),'b'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{3})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis([datafull(1,1) datafull(end,1) maxis(col-1) Maxis(col-1)])
% % axis tight, 
% hold off
% 
% col=4;
% axes(handles.axes11)
% plot(datafull(:,1),datafull(:,col),'b'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{4})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis([datafull(1,1) datafull(end,1) maxis(col-1) Maxis(col-1)])
% % axis tight, 
% hold off
% 
% try
% col=5;
% axes(handles.axes12)
% plot(datafull(:,1),datafull(:,col),'b'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{5})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis([datafull(1,1) datafull(end,1) maxis(col-1) Maxis(col-1)])
% % axis tight, 
% hold off
% end
% 
% try
% col=6;
% axes(handles.axes13)
% plot(datafull(:,1),datafull(:,col),'b'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{6})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis([datafull(1,1) datafull(end,1) maxis(col-1) Maxis(col-1)])
% % axis tight, 
% hold off
% end
% 
% try
% col=7;
% axes(handles.axes14)
% plot(datafull(:,1),datafull(:,col),'b'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{7})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis([datafull(1,1) datafull(end,1) maxis(col-1) Maxis(col-1)])
% % axis tight, 
% hold off
% end
% 
% try
% col=8;
% axes(handles.axes15)
% plot(datafull(:,1),datafull(:,col),'b'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{8})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis([datafull(1,1) datafull(end,1) maxis(col-1) Maxis(col-1)])
% % axis tight, 
% hold off
% end
% 
% try
% col=9;
% axes(handles.axes16)
% plot(datafull(:,1),datafull(:,col),'b'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{9})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis([datafull(1,1) datafull(end,1) maxis(col-1) Maxis(col-1)])
% % axis tight, 
% hold off
% 
% end
% xlabel('Time [s]')
% 
% 
% axes(handles.axes17)
% col=2;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% try
% axes(handles.axes18)
% col=3;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% end
% 
% try
% axes(handles.axes19)
% col=4;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% end
% 
% try
% axes(handles.axes20)
% col=5;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% end
% 
% try
% axes(handles.axes21)
% col=6;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% end
% 
% try
% axes(handles.axes22)
% col=7;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% end
% 
% try
% axes(handles.axes23)
% col=8;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% end
% 
% try
% axes(handles.axes24)
% col=9;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% end
% 
% 
% if ~cont2
%     button=questdlg('Do you want to cut the signal?','','Yes','No','Yes');
%     if strcmp(button,'Yes')
%     
%     [x,y]=ginput(1);
%     x(2)=x(1)+2;
%     x(1)=x(1)-0.5;
%     
%     [a,samp1]=min(abs(Frms(:,1)-x(1)));
%     [a,samp2]=min(abs(Frms(:,1)-x(2)));
%     x=round(x*Fs); 
%     lx=x(2)-x(1)+1;
%     ls=samp2-samp1+1;
%     
%     datafulltemp=datafull;
%     Frmstemp=Frms; 
%     clear datafull Frms
%     datafull(1:lx,1)=datafulltemp(1:lx,1);
%     datafull(:,2:sized)=datafulltemp(x(1):x(2),2:sized);
%     Frms(1:ls,1)=Frmstemp(1:ls,1);
%     Frms(:,2:sized)=Frmstemp(samp1:samp2,2:sized);
%     
%     cont2=1;
% 
% %     Datafile=strcat(Datafile(1:end-4),'_Cutted.mat');
% % 
% %     try
% %         save(Datafile,'datafull','DataInformation','Fs','Frms','Param')
% %         set(handles.Info,'String',Datafile)
% %         disp(['You Selected:', Datafile])
% %         set(handles.Info2,'String','The file was successfully saved!')
% %     catch
% %        errordlg('Error saving file','Error')
% %     end
%     
%     
%     else   
%         cont=1;           
%     end
% else
%     
% button=questdlg('It is OK?','','Yes','No','Yes');
% if strcmp(button,'Yes')
%     
%     Datafile=strcat(Datafile(1:end-4),'_Cutted.mat');
% 
%     try
%         save(Datafile,'datafull','DataInformation','Fs','Frms','Param')
%         set(handles.Info,'String',Datafile)
%         disp(['You Selected:', Datafile])
%         set(handles.Info2,'String','The file was successfully saved!')
%     catch
%        errordlg('Error saving file','Error')
%     end    
%     
%     cont=1;    
% else
%     datafull=datafulltemp;
%     Frms=Frmstemp;
%     cont2=0;
% end
% 
% end
% 
% 
% 
% end
% 
% % end
% catch
%     disp('Error in Load')
% end
% end
% 
% clear datafulltemp Frmstemp datafull
% set(handles.Info2,'String','Ready...')


% --- Executes on button press in B_Plot.
function B_Plot_Callback(hObject, eventdata, handles)
% hObject    handle to B_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pathname Datafile filename 

FlagSerial=get(handles.MultiFiles,'Value');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if ~ischar(pathname)
%     pathname='';
% end
% [filename, pathname] = uigetfile( ...
%     {'*.mat','MAT Files (*.mat)';
%     '*.*',  'All files (*.*)'}, ...
%     'Select a MAT file',pathname);
% 
% if isequal(filename,0)
% 
%    disp('Selection canceled')
% else
%    disp(['You Selected:', fullfile(pathname, filename)])
%    Datafile=strcat(pathname,filename);
%    set(handles.Info,'String',Datafile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if FlagSerial==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Serial

if ~ischar(pathname)
    pathname='';
end

pathname = uigetdir(pathname);

if isequal(pathname,0)

   disp('Selection canceled')
else
    
ldir=dir(pathname);
name={ldir.name};
for i=3:length(name)

Datafile=fullfile(pathname, name{i});
disp(['You Selected:', Datafile])
set(handles.Info2,'String','Busy in Plot...')
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    load(Datafile)
    set(handles.Info,'String',Datafile)
%% Trabalho Arthur-Renata
clear datafull
datafull(:,2)=Signals.Gastro;
datafull(:,3)=Signals.Soleo;
datafull(:,4)=Signals.Tibial;
datafull(:,5)=Signals.Vasto;
datafull(:,6)=Signals.Biceps;
datafull(:,7)=Signals.Sync;
Fs=1000; % Revisar
ld=size(datafull,1); % length data
t=0:1/Fs:1/Fs*(ld-1);
datafull(:,1)=t';

DataInformation{1}='Time';
DataInformation{2}='Gastro';
DataInformation{3}='Soleus';
DataInformation{4}='Tibial';
DataInformation{5}='Vastus';
DataInformation{6}='Biceps';
DataInformation{7}='Sync';

clear Signals

if exist('datafull','var')
    
% if exist('Frms')
 
sized=size(datafull,2);
cont=0;
cont2=0;

% axes(handles.axes1),cla
% axes(handles.axes2),cla
% axes(handles.axes3),cla
% axes(handles.axes4),cla
% axes(handles.axes5),cla
% axes(handles.axes6),cla
% 
% set(handles.axes4,'Visible','off')
% set(handles.axes5,'Visible','off')
% set(handles.axes1,'Visible','off')
% set(handles.axes2,'Visible','off')
% set(handles.axes6,'Visible','on')
% set(handles.axes3,'Visible','on')
% set(handles.axes7,'Visible','off')
% 
% set(handles.PanelFigure,'Visible','off');
% set(handles.PanelFigure2,'Visible','on');
% 
% axes(handles.axes9),cla
% axes(handles.axes10),cla
% axes(handles.axes11),cla
% axes(handles.axes12),cla
% axes(handles.axes13),cla
% axes(handles.axes14),cla
% axes(handles.axes15),cla
% axes(handles.axes16),cla
% axes(handles.axes17),cla
% axes(handles.axes18),cla
% axes(handles.axes19),cla
% axes(handles.axes20),cla
% axes(handles.axes21),cla
% axes(handles.axes22),cla
% axes(handles.axes23),cla
% axes(handles.axes24),cla


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

% while ~cont
    
% axes(handles.axes9)
% col=2;
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{2})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% col=3;
% axes(handles.axes10)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{3})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% col=4;
% axes(handles.axes11)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{4})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% col=5;
% axes(handles.axes12)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{5})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% col=6;
% axes(handles.axes13)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{6})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% col=7;
% axes(handles.axes14)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{7})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% 
% % col=8;
% % axes(handles.axes15)
% % plot(datafull(:,1),datafull(:,col),'c'), axis tight
% % hold on
% % % plot(Frms(:,1),Frms(:,col),'r')
% % ylabel(DataInformation{8})
% % % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% % axis tight, hold off
% 
% col=7;
% axes(handles.axes16)
% plot(datafull(:,1),datafull(:,col),'c'), axis tight
% hold on
% % plot(Frms(:,1),Frms(:,col),'r')
% ylabel(DataInformation{9})
% % axis([datafull(1,1) datafull(end,1) min(datafull(:,col))*1.1 max(datafull(:,col))*1.1])
% axis tight, hold off
% xlabel('Time [s]')
% 
% 
% 
% axes(handles.axes17)
% col=2;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes18)
% col=3;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes19)
% col=4;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes20)
% col=5;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes21)
% col=6;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes22)
% col=7;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% % axes(handles.axes23)
% % col=8;
% % [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% % plot(eje_f,mag_ss(1:length(eje_f)),'r')
% 
% axes(handles.axes24)
% col=7;
% [eje_f,mag_ss]=espectro(datafull(:,col),Fs,0);
% plot(eje_f,mag_ss(1:length(eje_f)),'r')



% if ~cont2
%     button=questdlg('Do you want to cut the signal?','','Yes','No','Yes');
%     if strcmp(button,'Yes')
%     
%     [x,y]=ginput(2);
%     [a,samp1]=min(abs(Frms(:,1)-x(1)));
%     [a,samp2]=min(abs(Frms(:,1)-x(2)));
%     x=round(x*Fs); 
%     lx=x(2)-x(1)+1;
%     ls=samp2-samp1+1;
%     
%     datafulltemp=datafull;
%     Frmstemp=Frms; 
%     clear datafull Frms
%     datafull(1:lx,1)=datafulltemp(1:lx,1);
%     datafull(:,2:sized-4)=datafulltemp(x(1):x(2),2:sized-4);
%     Frms(1:ls,1)=Frmstemp(1:ls,1);
%     Frms(:,2:sized-4)=Frmstemp(samp1:samp2,2:sized-4);
%     
%     cont2=1;
% 
%     Datafile=strcat(Datafile(1:end-4),'_Cutted.mat');
% 
%     try
%         save(Datafile,'datafull','DataInformation','Fs','Frms','Param','onset','xonset')
%         set(handles.Info,'String',Datafile)
%         disp(['You Selected:', Datafile])
%         set(handles.Info2,'String','The file was successfully saved!')
%     catch
%        errordlg('Error saving file','Error')
%     end
%     
%     
%     else   
%         cont=1;           
%     end
% else
%     
% button=questdlg('It is OK?','','Yes','No','Yes');
% if strcmp(button,'Yes')
% %     Datafile=strcat(Datafile(1:end-4),'_Cutted.mat');
% % 
% %     try
% %         save(Datafile,'datafull','DataInformation','Fs','Frms','Param','onset','xonset')
% %         set(handles.Info,'String',Datafile)
% %         disp(['You Selected:', Datafile])
% %         set(handles.Info2,'String','The file was successfully saved!')
% %     catch
% %        errordlg('Error saving file','Error')
% %     end    
%     cont=1;    
% else
%     datafull=datafulltemp;
%     Frms=Frmstemp;
%     cont2=0;
% end
% 
% end

try
%     Datafile=strcat(Datafile(1:end-4),'_Rev.mat');
    Datafile=fullfile(pathname, strcat('R_',name{i}));

    save(Datafile,'datafull','DataInformation','Fs')
    set(handles.Info,'String',Datafile)
    disp(['You Selected:', Datafile])
    set(handles.Info2,'String','The file was successfully saved!')
catch
   errordlg('Error saving file','Error')
end

% end

% end

else
    errordlg('Datafull ins missing','Error')
end

catch
   errordlg('Error Plotting file','Error') 
end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Individual




end

clear datafulltemp Frmstemp datafull
set(handles.Info2,'String','Ready...')


% --- Executes on button press in Reset2.
function Reset2_Callback(hObject, eventdata, handles)
% hObject    handle to Reset2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
refresh_Callback(hObject, eventdata, handles)


%% Functions of user

function H_Reflex(hObject, eventdata, handles)
% hObject    handle to A_AnalysisMwave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Datafile
cancelRoutine=0;
set(handles.Info2,'String','Current task: M wave')
set(handles.A_AnalysisMenu,'Enable','off')

set(handles.Info,'String',Datafile)
load (Datafile)
set(handles.Info,'String',Datafile)

axes(handles.axes1),cla,ylabel(''),title('')
axes(handles.axes2),cla,ylabel(''),title('')
axes(handles.axes3),cla,ylabel(''),title('')
axes(handles.axes4),cla,ylabel(''),title('')
axes(handles.axes5),cla,ylabel(''),title('')
axes(handles.axes6),cla,ylabel(''),title('')

set(handles.axes1,'Visible','on')
set(handles.axes2,'Visible','on')
set(handles.axes3,'Visible','off')
set(handles.axes4,'Visible','off')
set(handles.axes5,'Visible','off')
set(handles.axes6,'Visible','on')

set(handles.input7,'String',num2str(100));

graphic=1;

%% Detect EMG channel
% emgCH=2; 

lch=length(DataInformation);
flag=false;
indEMG=[];
txtEMG={};
for i=1:lch
    flag=strcmp(DataInformation{i}(1:3),'EMG');
    if flag
        indEMG=[indEMG i];
        txtEMG=[txtEMG DataInformation{i}];
%     else
%         flag=true;
    end
end

if length(indEMG)>1
    val=ChannelSelection([{'Select'},txtEMG]);
% fig = uifigure('Name','Channel'); 
% fig.Position = [500,400,220 100];
% 
% dd = uidropdown(fig,...
%     'Position',[10 70 100 22],...
%     'Items',txtEMG);
% 
% waitfor(fig)
ind=strcmp(val,txtEMG);
emgCH=indEMG(ind);

%     'Value','Blue')

% if ~isempty(answer)
elseif isempty(indEMG)
    warndlg({['EMG channels are missing!: F',name{ifile}]}','Warning!')
end

%%

try
%%
correct=1;
k=1;j=1;
% dataf=EMGFilter(handles,datafull,Fs);

if exist('marks','var')
    
    
sec=3;  % number of seconds arround the peak
sec1=str2num(get(handles.input6,'String'))/1000;  % number of seconds arround the peak. 1000 factor to convert to seconds
sec2=str2num(get(handles.input7,'String'))/1000;  

% % Settings
% sample1=marks(end)-sec1*Fs; % first sample to extract the trial
% sample2=marks(end)+sec2*Fs; % last sample to extract the trial
% 
% figure, plot(datafull(sample1:sample2,emgCH))
% [x,y]=ginput(2);
% x=round(x);
% % Mwave=datafull(sample1+x(1):sample1+x(2),emgCH); % Extraction of the M wave

for i=1:1:length(marks)
    
 
% load (Datafile)

sample1=marks(i)-sec1*Fs; % first sample to extract the trial
sample2=marks(i)+sec2*Fs; % last sample to extract the trial

try
    EMG(:,i)=datafull(sample1:sample2,emgCH); % Extract the trial with +-sec seconds (20 e 60/100 ms)
    time(:,i)=datafull(sample1:sample2,1); % Extract the trial with +-sec seconds 
    if marks(i)-3*Fs>0        
        baseline=datafull(marks(i)-3*Fs:marks(i)-2*Fs,emgCH);
    elseif marks(i)-2*Fs>0
        baseline=datafull(1:marks(i)-2*Fs,emgCH);
    else
        baseline=datafull(1:marks(i)-0.01*Fs,emgCH);
    end
catch Err
   stop=1;
end


% if i==85
%    stop=1; 
% end

%% Peak to peak measure

%% M wave detection
% x1=round(sec1*Fs+0.005*Fs); % 5 ms after marks
% y1=round(sec1*Fs+0.025*Fs); % 25 ms after marks

th=max(abs(baseline))*3; % 3 times the maximum value of the baseline
% th=mean(baseline)+std(baseline)*3;

x=find(abs(EMG(:,i))>th); % To detect samples above 3 times the baseline
if ~isempty(x)
    
x1=round(x(1)+0.005*Fs); % 10 ms after first sample to avoid artefact / mudei para 5
y1=round(x(1)+0.020*Fs); % 20 ms after artefacts. M-wave should have finished at this time

Mwave=EMG(x1:y1,i); % Extraction of the M wave

%%
% xc=find(Mwave<0); % Next zero crossing
% if ~isempty(xc)
%     
%     xcd=diff(xc);  % To detect non-consecutive samples, correspondent to different negative lobes
%     x1c=find(xcd~=1);
%     if ~isempty(x1c)
%         indNeg=x1c(end);
% %         x1=x1+xc(indNeg-1);
%         x1=x1+xc(indNeg)-1;
%     end
% 
% end
% 
% Mwave=EMG(x1:y1,i);
% %%
% xc=find(Mwave<0); % Next zero crossing
% xc=find(Mwave<0); % Next zero crossing
% 
% dM=diff(Mwave);
% 
% EMGgradp=Mwave;
% ind=find(abs(Mwave)<max(abs(Mwave))*.25); % Points lower thatn 30% are avoided
% EMGgradp(ind)=0;
% d2=gradient(EMGgradp); % It is calculated the first derivative to obtain the inflection points

%%
[Mpeak,Mi]=max(Mwave); % Max of M wave
[mpeak,mi]=min(Mwave); % Min of M wave

% find(Mwave())
diff(Mpeak-Mwave);
diff(Mwave+mpeak);

Mpp(i)=Mpeak-mpeak; % M wave peak to peak

%% H reflex detection
x2=round(sec1*Fs+0.025*2000); % 5 ms after marks
[Hpeak,Hi]=max(EMG(x2:end,i)); % Max of H wave
[hpeak,hi]=min(EMG(x2:end,i)); % Min of H wave

Hpp(i)=Hpeak-hpeak; % H wave peak to peak

%% Graphic
if graphic==1
% 
axes(handles.axes1)
cla
hold on
plot(datafull(:,1),datafull(:,emgCH)), axis tight
s1=marks(i)-sec*Fs;
s2=marks(i)+sec*Fs;
if s2>size(datafull,1)
    s2=size(datafull,1);
end
if s1<=0
    s1=1;
end
shad=datafull(s1:s2,1);
bar(shad,ones(length(shad),1)*max(datafull(:,emgCH)),1,'k'),alpha(0.1)
bar(shad,ones(length(shad),1)*min(datafull(:,emgCH)),1,'k'),alpha(0.1)
try 
    plot(datafull(:,1),datafull(:,5)*MM,'c')
end
hold off
ylabel('EMG')
set(handles.axes1,'YTickLabel',[])
set(handles.axes1,'XTickLabel',[])
% 
% axes(handles.axes2)
% plot(datafull(:,1),datafull(:,4))
% axis tight
% set(handles.axes2,'YTickLabel',[])
% 
% 
axes(handles.axes6),cla
if get(handles.plotFigure,'Value')
    fmw=figure;
end
plot(time(x(1):end,i),EMG(x(1):end,i))
% axis tight
% axis([time(x(1),i) time(end,i) min(EMG(x(1):end,i)) max(EMG(x(1):end,i))])
axis([time(x(1),i) time(end,i) -5000 5000])

hold on
% plot( (marks(i+1)+p2) /Fs+datafull(1,1),mm,'sk','MarkerFaceColor',[.1 .49 .30],'MarkerSize',5)
% plot( [(marks(i)+p2) (marks(i)+p2)]/Fs+datafull(1,1),[MM mm],'-.k')
title(strcat('H Reflex. Trial: ',num2str(i)))
xlabel('Time [s]')
ylabel('Amplitude')
legend({'EMG'})

% 
% %%
% % shade1=time{j}(tm:tM);
% % bar(shade1,ones(length(shade1),1)*max(EMGplot),1,'k','EdgeColor','none'),
% % alpha(0.1)
% % bar(shade1,ones(length(shade1),1)*min(EMGplot),1,'k','EdgeColor','none'),
% % alpha(0.1)
% plot([time{j}(tm) time{j}(tm)],[MM mm],'--r')
% plot([time{j}(tM) time{j}(tM)],[MM mm],'--r')
% legend({'EMG','Estimulus','Peaks'})
% 
% try
% drawMWave
% catch
%    waitfor(warndlg('Please, correct the peaks!','Warning!'));
%    flagcorrect=1;
% end

% de=(sec1)*Fs+0.005*Fs; % delay to avoid the estimulus to detect the peak of M wave
% EMGgradp=EMG(de:end); % It is taken into account the signal 5 ms after estimulus
% 
% 
% str=('Select the border left!');
% set(handles.textaxes5,'Visible','on','String',str) 
% 

end

% shade
if graphic==1

shade1=time(x1:y1,i);
bar(shade1,ones(length(shade1),1)*max(EMG),1,'k','EdgeColor','none'),
alpha(0.1)
bar(shade1,ones(length(shade1),1)*min(EMG),1,'k','EdgeColor','none'),
alpha(0.1)
legend({'EMG'})

% plot([time(x1,i) time(x1,i)],[max(EMG(:,i)) min(EMG(:,i))],'.r')
% plot([time(y1,i) time(y1,i)],[max(EMG(:,i)) min(EMG(:,i))],'.r')
plot([time(x1+Mi-1,i) time(x1+Mi-1,i)],[max(EMG(:,i)) min(EMG(:,i))],'-m')
plot([time(x1+mi-1,i) time(x1+mi-1,i)],[max(EMG(:,i)) min(EMG(:,i))],'-m')

plot(time(x1+Mi-1,i),Mpeak,'xr')
plot(time(x1+mi-1,i),mpeak,'xr')


plot(time(x2+Hi-1,i),Hpeak,'xr')
plot(time(x2+hi-1,i),hpeak,'xr')
% plot([time(x2+Hi-1,i) time(x2+Hi-1,i)],[max(EMG(:,i)) min(EMG(:,i))],'-r')
% plot([time(x2+hi-1,i) time(x2+hi-1,i)],[max(EMG(:,i)) min(EMG(:,i))],'-r')
end

%%
% % set(handles.Panel_Info2,'Visible','on')
% % set(handles.I1,'String',{['Datafull size: ',num2str(size(datafull,1))]})
% % set(handles.I2,'String',{['Num peaks: ',num2str(length(marks))]})

% pause()
% EMG(:,i)=[];

else
    disp({['Mwave can not be detected. Trial:',num2str(i)]})
    
end
end

else
    errordlg('The peaks data was not found','Error')
end
stop=1;

catch Err
    stop=1;
end

% figure, plot(current,Hpp), 
% hold on, plot(current,Mpp)
% xlabel('Current [mA]')
figure, plot(Hpp), 
hold on, plot(Mpp)
ylabel('Amplitude (peak to peak) [uV]')
xlabel('Trial')
legend('H Reflex','M wave')

% save('Teste_Ale_20_11_19','EMG','time','Fs','datafull','marks','current','DataInformation','Hpp','Mpp')

% current=[];
% plus=zeros(26,1);
% plus=plus';
% Mpp=Mpp+plus;
% 
% figure, plot(current,Hpp), 
% hold on, plot(current,Mpp)
% ylabel('Amplitude (peak to peak) [uV]')
% xlabel('Current [mA]')
% legend('H Reflex','M wave')



% --------------------------------------------------------------------
function profile_Callback(hObject, eventdata, handles)
% hObject    handle to profile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in SetStimuli.
function SetStimuli_Callback(hObject, eventdata, handles)
% hObject    handle to SetStimuli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SetStimuli contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SetStimuli

if get(hObject,'Value')==1
    set(handles.input2,'String',num2str(2))
    set(handles.input3,'String',num2str(5))
elseif get(hObject,'Value')==2
    set(handles.input2,'String',num2str(3))
    set(handles.input3,'String',num2str(10))
end

% --- Executes during object creation, after setting all properties.
function SetStimuli_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SetStimuli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function setChannels_Callback(hObject, eventdata, handles)
% hObject    handle to setChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set(handles.PanelFigure,'Visible','off')
set(handles.PanelEdit,'Visible','on')

% prompt = {'Patients:','Number of tasks',...
%     'Control (CT) or amputed (AP) Patient: Format file "1PatientSsesion_Task"',...
%     'Sesions','Repetitions:','Channels:','Protocolo:','Select cues manually? 1:Yes 0:No'};
% dlg_title = 'Input for segment the data';
% num_lines = 1;
% def = {'1','7','CT','1','6','9','4','1'};
% answer = inputdlg(prompt,dlg_title,num_lines,def);
% % if ~isempty(answer)


% --- Executes on button press in PanelEditClose.
function PanelEditClose_Callback(hObject, eventdata, handles)
% hObject    handle to PanelEditClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.PanelEdit,'Visible','off')


% --- Executes on selection change in popch7.
function popch7_Callback(hObject, eventdata, handles)
% hObject    handle to popch7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popch7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popch7


% --- Executes during object creation, after setting all properties.
function popch7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popch7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popch6.
function popch6_Callback(hObject, eventdata, handles)
% hObject    handle to popch6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popch6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popch6


% --- Executes during object creation, after setting all properties.
function popch6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popch6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popch5.
function popch5_Callback(hObject, eventdata, handles)
% hObject    handle to popch5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popch5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popch5


% --- Executes during object creation, after setting all properties.
function popch5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popch5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popch4.
function popch4_Callback(hObject, eventdata, handles)
% hObject    handle to popch4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popch4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popch4


% --- Executes during object creation, after setting all properties.
function popch4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popch4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popch3.
function popch3_Callback(hObject, eventdata, handles)
% hObject    handle to popch3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popch3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popch3


% --- Executes during object creation, after setting all properties.
function popch3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popch3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popch2.
function popch2_Callback(hObject, eventdata, handles)
% hObject    handle to popch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popch2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popch2


% --- Executes during object creation, after setting all properties.
function popch2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popch1.
function popch1_Callback(hObject, eventdata, handles)
% hObject    handle to popch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popch1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popch1


% --- Executes during object creation, after setting all properties.
function popch1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Textn.
function popchPeak_Callback(hObject, eventdata, handles)
% hObject    handle to Textn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Textn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Textn


% --- Executes during object creation, after setting all properties.
function popchPeak_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popchPeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CH1_Callback(hObject, eventdata, handles)
% hObject    handle to CH1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CH1 as text
%        str2double(get(hObject,'String')) returns contents of CH1 as a double



function CH2_Callback(hObject, eventdata, handles)
% hObject    handle to CH2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CH2 as text
%        str2double(get(hObject,'String')) returns contents of CH2 as a double



function CH3_Callback(hObject, eventdata, handles)
% hObject    handle to CH3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CH3 as text
%        str2double(get(hObject,'String')) returns contents of CH3 as a double



function CH4_Callback(hObject, eventdata, handles)
% hObject    handle to CH4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CH4 as text
%        str2double(get(hObject,'String')) returns contents of CH4 as a double



function CH5_Callback(hObject, eventdata, handles)
% hObject    handle to CH5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CH5 as text
%        str2double(get(hObject,'String')) returns contents of CH5 as a double



function CH6_Callback(hObject, eventdata, handles)
% hObject    handle to CH6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CH6 as text
%        str2double(get(hObject,'String')) returns contents of CH6 as a double



function CH7_Callback(hObject, eventdata, handles)
% hObject    handle to CH7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CH7 as text
%        str2double(get(hObject,'String')) returns contents of CH7 as a double
    

% --- Executes on button press in Chk_AllChannels.
function Chk_AllChannels_Callback(hObject, eventdata, handles)
% hObject    handle to Chk_AllChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Chk_AllChannels


% --- Executes on button press in save_profile.
function save_profile_Callback(hObject, eventdata, handles)
% hObject    handle to save_profile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname

CH_Label1=get(handles.CH1,'String');
CH_Label2=get(handles.CH2,'String');
CH_Label3=get(handles.CH3,'String');
CH_Label4=get(handles.CH4,'String');
CH_Label5=get(handles.CH5,'String');
CH_Label6=get(handles.CH6,'String');
CH_Label7=get(handles.CH7,'String');
CH_Label8=get(handles.CH8,'String');
CH1=get(handles.popch1,'Value');
CH2=get(handles.popch2,'Value');
CH3=get(handles.popch3,'Value');
CH4=get(handles.popch4,'Value');
CH5=get(handles.popch5,'Value');
CH6=get(handles.popch6,'Value');
CH7=get(handles.popch7,'Value');
CH8=get(handles.popch8,'Value');


[filename, pathname2] = uiputfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select a file',...
    strcat(pathname));
    
if isequal(filename,0)
   disp('Selection canceled')
else
   try
   Datafile=fullfile(pathname2, filename);
   save (Datafile,'CH_Label1','CH_Label2','CH_Label3','CH_Label4','CH_Label5',...
       'CH_Label6','CH_Label7','CH_Label8','CH1','CH2','CH3','CH4','CH5','CH6','CH7','CH8')
   disp(['You Selected:', fullfile(pathname2, filename)])
   set(handles.Info,'String',fullfile(pathname2, filename))
   set(handles.Info2,'String','The file was successfully saved!')
   catch ME
       errordlg('Please, select a file','Error!')
   end
end

% --- Executes on button press in load_profile.
function load_profile_Callback(hObject, eventdata, handles)
% hObject    handle to load_profile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pathname

if ~ischar(pathname)
    pathname='';
end
[filename, pathname2] = uigetfile( ...
    {'*.mat','MAT Files (*.mat)';
    '*.*',  'All files (*.*)'}, ...
    'Select the Profile',pathname);

if isequal(filename,0)
   
   disp('Selection canceled')
else

disp(['You Selected:', fullfile(pathname2, filename)])
load(fullfile(pathname2, filename))

set(handles.CH1,'String',CH_Label1)
set(handles.CH2,'String',CH_Label2)
set(handles.CH3,'String',CH_Label3)
set(handles.CH4,'String',CH_Label4)
set(handles.CH5,'String',CH_Label5)
set(handles.CH6,'String',CH_Label6)
set(handles.CH7,'String',CH_Label7)
set(handles.CH8,'String',CH_Label8)
set(handles.popch1,'Value',CH1);
set(handles.popch2,'Value',CH2);
set(handles.popch3,'Value',CH3);
set(handles.popch4,'Value',CH4);
set(handles.popch5,'Value',CH5);
set(handles.popch6,'Value',CH6);
set(handles.popch7,'Value',CH7);
set(handles.popch8,'Value',CH8);

end


% --- Executes on selection change in popupmenu29.
function popupmenu29_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu29 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu29


% --- Executes during object creation, after setting all properties.
function popupmenu29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Plot_HiddenFigures_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_HiddenFigures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(handles.Plot_HiddenFigures,'Checked')
    case 'on'
        set(handles.Plot_HiddenFigures,'Checked','off')
    case 'off'
        set(handles.Plot_HiddenFigures,'Checked','on')
end


% --------------------------------------------------------------------
function Flag_correct_sat_Callback(hObject, eventdata, handles)
% hObject    handle to Flag_correct_sat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(handles.Flag_correct_sat,'Checked')
    case 'on'
        set(handles.Flag_correct_sat,'Checked','off')
    case 'off'
        set(handles.Flag_correct_sat,'Checked','on')
end


% --- Executes on selection change in selectionEMGchannel.
function selectionEMGchannel_Callback(hObject, eventdata, handles)
% hObject    handle to selectionEMGchannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectionEMGchannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectionEMGchannel


% --- Executes during object creation, after setting all properties.
function selectionEMGchannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectionEMGchannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function MultFiles_Callback(hObject, eventdata, handles)
% hObject    handle to MultFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(handles.MultFiles,'Checked')
    case 'on'
        set(handles.MultFiles,'Checked','off')
    case 'off'
        set(handles.MultFiles,'Checked','on')
end


% --------------------------------------------------------------------
function hide_Plots_Callback(hObject, eventdata, handles)
% hObject    handle to hide_Plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(handles.hide_Plots,'Checked')
    case 'on'
        set(handles.hide_Plots,'Checked','off')
    case 'off'
        set(handles.hide_Plots,'Checked','on')
end



function Edit_ClearOnset_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_ClearOnset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_ClearOnset as text
%        str2double(get(hObject,'String')) returns contents of Edit_ClearOnset as a double


% --- Executes during object creation, after setting all properties.
function Edit_ClearOnset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_ClearOnset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function thrms_Callback(hObject, eventdata, handles)
% hObject    handle to thrms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thrms as text
%        str2double(get(hObject,'String')) returns contents of thrms as a double


% --- Executes during object creation, after setting all properties.
function thrms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thrms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in thperc.
function thperc_Callback(hObject, eventdata, handles)
% hObject    handle to thperc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of thperc


% --- Executes on selection change in popch8.
function popch8_Callback(hObject, eventdata, handles)
% hObject    handle to popch8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popch8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popch8


% --- Executes during object creation, after setting all properties.
function popch8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popch8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CH8_Callback(hObject, eventdata, handles)
% hObject    handle to CH8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CH8 as text
%        str2double(get(hObject,'String')) returns contents of CH8 as a double


% --- Executes during object creation, after setting all properties.
function CH8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CH8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SelCH1.
function SelCH1_Callback(hObject, eventdata, handles)
% hObject    handle to SelCH1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SelCH1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelCH1
global Datafile indCH

load (Datafile)

indi=get(hObject,'Value')-1;
txt=get(hObject,'String');
txt=txt(indi+1);

axes(handles.axes25),cla

hold on

plot(datafull(:,1),datafull(:,indCH{indi}(1)),'r')
plot(datafull(:,1),datafull(:,indCH{indi}(2)),'g')
plot(datafull(:,1),datafull(:,indCH{indi}(3)),'b')
try plot(datafull(:,1),datafull(:,indCH{indi}(4)),'k'); end

ylabel(txt{1})

axis tight, 
hold off
if length(indCH{indi})==4
    legend(DataInformation{indCH{indi}(1)},DataInformation{indCH{indi}(2)},DataInformation{indCH{indi}(3)},DataInformation{indCH{indi}(4)})
else
    legend(DataInformation{indCH{indi}(1)},DataInformation{indCH{indi}(2)},DataInformation{indCH{indi}(3)})
end

axes(handles.axes29), cla
[eje_f,mag_ss]=espectro(datafull(:,indCH{indi}(1)),Fs,0);
plot(eje_f,mag_ss(1:length(eje_f)),'r')


% --- Executes during object creation, after setting all properties.
function SelCH1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelCH1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SelCH2.
function SelCH2_Callback(hObject, eventdata, handles)
% hObject    handle to SelCH2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SelCH2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelCH2
global Datafile indCH

load (Datafile)

indi=get(hObject,'Value')-1;
txt=get(hObject,'String');
txt=txt(indi+1);

axes(handles.axes26),cla

hold on

plot(datafull(:,1),datafull(:,indCH{indi}(1)),'r')
plot(datafull(:,1),datafull(:,indCH{indi}(2)),'g')
plot(datafull(:,1),datafull(:,indCH{indi}(3)),'b')
try plot(datafull(:,1),datafull(:,indCH{indi}(4)),'k'); end

ylabel(txt{1})

axis tight, 
hold off
if length(indCH{indi})==4
    legend(DataInformation{indCH{indi}(1)},DataInformation{indCH{indi}(2)},DataInformation{indCH{indi}(3)},DataInformation{indCH{indi}(4)})
else
    legend(DataInformation{indCH{indi}(1)},DataInformation{indCH{indi}(2)},DataInformation{indCH{indi}(3)})
end

axes(handles.axes30), cla
[eje_f,mag_ss]=espectro(datafull(:,indCH{indi}(1)),Fs,0);
plot(eje_f,mag_ss(1:length(eje_f)),'r')


% --- Executes during object creation, after setting all properties.
function SelCH2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelCH2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SelCH3.
function SelCH3_Callback(hObject, eventdata, handles)
% hObject    handle to SelCH3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SelCH3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelCH3
global Datafile indCH

load (Datafile)

indi=get(hObject,'Value')-1;
txt=get(hObject,'String');
txt=txt(indi+1);

axes(handles.axes27),cla

hold on

plot(datafull(:,1),datafull(:,indCH{indi}(1)),'r')
plot(datafull(:,1),datafull(:,indCH{indi}(2)),'g')
plot(datafull(:,1),datafull(:,indCH{indi}(3)),'b')
try plot(datafull(:,1),datafull(:,indCH{indi}(4)),'k'); end

ylabel(txt{1})

axis tight, 
hold off
if length(indCH{indi})==4
    legend(DataInformation{indCH{indi}(1)},DataInformation{indCH{indi}(2)},DataInformation{indCH{indi}(3)},DataInformation{indCH{indi}(4)})
else
    legend(DataInformation{indCH{indi}(1)},DataInformation{indCH{indi}(2)},DataInformation{indCH{indi}(3)})
end

axes(handles.axes31), cla
[eje_f,mag_ss]=espectro(datafull(:,indCH{indi}(1)),Fs,0);
plot(eje_f,mag_ss(1:length(eje_f)),'r')


% --- Executes during object creation, after setting all properties.
function SelCH3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelCH3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SelCH4.
function SelCH4_Callback(hObject, eventdata, handles)
% hObject    handle to SelCH4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SelCH4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelCH4
global Datafile indCH

load (Datafile)

indi=get(hObject,'Value')-1;
txt=get(hObject,'String');
txt=txt(indi+1);

axes(handles.axes28),cla

hold on

plot(datafull(:,1),datafull(:,indCH{indi}(1)),'r')
plot(datafull(:,1),datafull(:,indCH{indi}(2)),'g')
plot(datafull(:,1),datafull(:,indCH{indi}(3)),'b')
try plot(datafull(:,1),datafull(:,indCH{indi}(4)),'k'); end

ylabel(txt{1})

axis tight, 
hold off
if length(indCH{indi})==4
    legend(DataInformation{indCH{indi}(1)},DataInformation{indCH{indi}(2)},DataInformation{indCH{indi}(3)},DataInformation{indCH{indi}(4)})
else
    legend(DataInformation{indCH{indi}(1)},DataInformation{indCH{indi}(2)},DataInformation{indCH{indi}(3)})
end

axes(handles.axes32), cla
[eje_f,mag_ss]=espectro(datafull(:,indCH{indi}(1)),Fs,0);
plot(eje_f,mag_ss(1:length(eje_f)),'r')


% --- Executes during object creation, after setting all properties.
function SelCH4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelCH4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
