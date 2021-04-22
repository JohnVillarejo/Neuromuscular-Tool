function A_AnalysisEMG(hObject, eventdata, handles)
% hObject    handle to A_AnalysisEMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Datafile

load (Datafile)
set(handles.Info,'String',Datafile)

axes(handles.axes1),cla
axes(handles.axes2),cla
axes(handles.axes3),cla
axes(handles.axes4),cla
axes(handles.axes5),cla
axes(handles.axes6),cla

set(handles.axes1,'Visible','on')
set(handles.axes2,'Visible','on')
set(handles.axes3,'Visible','off')
set(handles.axes4,'Visible','off')
set(handles.axes5,'Visible','off')
set(handles.axes6,'Visible','on')

correct=0;
k=1;j=1;

if exist('marks')

for i=1:2:length(marks)
sec=3;  % number of seconds arround the peak
EMG=datafull(marks(i)-sec*Fs:marks(i+1)+sec*Fs,3); % Extract the trial with +-sec seconds 
% correction of magnitud of torque

t=datafull(marks(i)-sec*Fs:marks(i+1)+sec*Fs,1);
mm=min(EMG);
MM=max(EMG);

axes(handles.axes1)
cla
hold on
plot(datafull(:,1),datafull(:,3)), axis tight
shad=datafull(marks(i+1)-sec*Fs:marks(i+1)+sec*Fs,1);
bar(shad,ones(length(shad),1)*max(datafull(:,3)),1,'k'),alpha(0.1)
bar(shad,ones(length(shad),1)*min(datafull(:,3)),1,'k'),alpha(0.1)
plot(datafull(:,1),datafull(:,2)*MM,'c')
hold off
ylabel('EMG [V]')

axes(handles.axes2)
plot(datafull(:,1),datafull(:,2))
axis tight
xlabel('Time [s]')

axes(handles.axes6),cla

plot(t,EMG)
hold on
plot( (marks(i)) /Fs,MM,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
plot( (marks(i+1)) /Fs,mm,'sk','MarkerFaceColor',[.1 .49 .30],'MarkerSize',5)
plot( [(marks(i)) (marks(i)+1)]/Fs,[MM mm],'k')
plot( [(marks(i+1)) (marks(i+1)+1)]/Fs,[MM mm],'k')
title(strcat('Electrical stimulus in EMG. Trial: ',num2str((i+3)/4)))
xlabel('Time [s]')
ylabel('Amplitude')

clear dataTemp

medmovil=str2num(get(handles.window,'String'));
shift=str2num(get(handles.shift,'String'));
ns=length(EMG);
j=1;
for im=medmovil:shift:size(EMG,1)
    dataRMS(j)=rms(EMG(im-medmovil+1:im,1));
    j=j+1;
end
trms=[floor(medmovil/2):shift:ns-floor(shift/2)]/Fs+marks(i)/Fs-sec;

plot(trms,dataRMS,'r')
pause()

ck=k+2;
j=j+1;
end % trial stimulus

else    
   errordlg('Peaks should be loaded before!','Error') 
end
