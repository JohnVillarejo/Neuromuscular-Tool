function A_AnalysisMwave(hObject, eventdata, handles)
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

%% Initialization
set(handles.A_peaks,'Enable','off')
corr_sat=get(handles.Flag_correct_sat,'Checked');
si=get(handles.SetStimuli,'Value'); % Set stimuli
sst=get(handles.SetStimuli,'String');
ss=str2num(sst{si});
if ss==2
    stim=1; % stimuli i+1;
else
    stim=3; % stimuli i+3;
end
correct=1;
k=1;j=1;
% dataf=EMGFilter(handles,datafull,Fs);

% %% Detect EMG channel
% indEMG=length(DataInformation);
% flag=false;
% while ~flag
%     try
%         flag=strcmp(DataInformation{indEMG}(1:3),'EMG');  % GENERALIZAR PARA OUTROS CANAIS
%     catch
%         flag=false;
%     end
%     if ~flag
%         indEMG=indEMG-1;
% %     else
% %         flag=true;
%     end
% end
% emgCH=indEMG;

%% Detect EMG channels

if get(handles.selectionEMGchannel,'Value')==1
    
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

else
    indEMG=get(handles.selectionEMGchannel,'Value');
    structEMG=get(handles.selectionEMGchannel,'String');
    emgCH=find(strcmp(structEMG{indEMG},DataInformation));
end
%%
if exist('marks')

for i=1:ss:length(marks)-1

    sec=3;  % number of seconds arround the peak
    
    sec1=str2num(get(handles.input6,'String'))/1000;  % number of seconds arround the peak [ms]
    sec2=str2num(get(handles.input7,'String'))/1000;  
    sample1=marks(i+stim)-sec1*Fs; % first sample to extract the trial
    sample2=marks(i+stim)+sec2*Fs; % last sample to extract the trial
    try
        EMG=datafull(sample1:sample2,emgCH); % Extract the trial with +-sec seconds (20 e 60 ms)
        time{j}=datafull(sample1:sample2,1); % Extract the trial with +-sec seconds 
        
        if marks(i)-3*Fs>0 % Calculated before the muscle contraction
            baseline=datafull(marks(i)-3*Fs:marks(i)-2*Fs,emgCH); 
        elseif marks(i)-2*Fs>0
            baseline=datafull(1:marks(i)-2*Fs,emgCH);
        else
            baseline=datafull(1:marks(i)-0.01*Fs,emgCH);
        end
    catch Err
       stop=1; 
       errordlg('M wave trial can not be extracted!','Error') 
    end
    
    % figure, plot(EMG)
    % peak 1. It happens around 185 ms after estimulation
    pt1=str2num(get(handles.input8,'String'));  % peak 1 radio

    % x=datafull(round(marks(i+1)-pt1:marks(i+1)+pt1),3);
    % [r,p]=max(x);
    % marks(i+1)=p+marks(i+1)-pt1*Fs-2; % to find the peak shifted by the cutted segment. Minus 1 to discount the sample in the cutted segment

    % factor correction
    p1=0;
    p2=0; % electrical delay

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extract peaks
FinalMarks(k)=marks(i)+p1;
FinalMarks(k+1)=marks(i+1)+p2;  

if ss==4
    FinalMarks(k+2)=marks(i+2)+p2;
    FinalMarks(k+3)=marks(i+3)+p2; 
end

% samplespeak=str2num(get(handles.input9,'String'));  % number of samples before the peak
% c1=FinalMarks(k+1)-sample1-samplespeak;
% c2=FinalMarks(k+1)-sample1+samplespeak;
% if c1<1
%     c1=1;
% end
% 
% ondaM=EMG(c1:c2);
% [mm_M,tm1]=min(ondaM);
% [MM_M,tM1]=max(ondaM);
% tm=tm1(end)+c1-1;
% tM=tM1(1)+c1-1;

%% M wave detection
% x1=round(sec1*Fs+0.005*Fs); % 5 ms after marks
% y1=round(sec1*Fs+0.025*Fs); % 25 ms after marks

th=max(abs(baseline))*3; % 3 times the maximum value of the baseline
% th=mean(baseline)+std(baseline)*3;

x=find(abs(EMG)>th); % To detect samples above 3 times the baseline
if ~isempty(x)
    
    x1=round(x(1)+0.007*Fs); % 10 ms after first sample to avoid artefact / mudei para 5 / 7
    y1=round(x(1)+0.050*Fs); % 20 ms after artefacts. M-wave should have finished at this time
    
    if y1 < length(EMG)        
        Mwave=EMG(x1:y1); % Extraction of the M wave    
    else
        Mwave=EMG(x1:end); % Extraction of the M wave
    end
end

%% Correction Saturation 
if strcmp(corr_sat,'on')

FlagCorrect=true;
MM=max(EMG);
mm=min(EMG);

while FlagCorrect
key=0;
figure, plot(EMG)
hold on,
plot( [(FinalMarks(i+stim)+p2) (FinalMarks(i+stim)+p2)]/Fs+datafull(1,1),[MM mm],'-.k')
plot([FinalMarks(i+stim)+p2+0.008*Fs FinalMarks(i+stim)+p2+0.013*Fs]/Fs+datafull(1,1),[mm mm]*0.95,'r') % Expected values for M-wave

plot(EMG,'or')

title(strcat('M Wave. Trial: ',num2str(j)))
xlabel('Sample')
ylabel('Amplitude')

EMG2=EMG;
kk=1;
while key~=99
    [x(k),y,key]=ginput(1);
    disp(key)    
    if ~isempty(key) && key~=99
        x(k)=round(x(k));
        if EMG2(x(k))>0
%             EMG2(x)=5000+5000-EMG(x);
            EMG2(x(k))=5000;
        else
%             EMG2(x)=-5000-(5000+EMG(x));
            EMG2(x(k))=-5000;
        end
        cla,plot(EMG)
        hold on,
        plot(EMG2)
        plot( [(FinalMarks(i+stim)+p2) (FinalMarks(i+stim)+p2)]/Fs+datafull(1,1),[MM mm],'-.k')
        plot([FinalMarks(i+stim)+p2+0.008*Fs FinalMarks(i+stim)+p2+0.013*Fs]/Fs+datafull(1,1),[mm mm]*0.95,'r') % Expected values for M-wave

        plot(EMG,'or')
        title(strcat('M Wave. Trial: ',num2str(j)))
        xlabel('Sample')
        ylabel('Amplitude')
    end
    k=k+1;
end

buttonSat = questdlg('Accept corrections!','','OK','Repeat','Cancel','OK');
switch buttonSat
    case 'OK'
        EMG=EMG2;
        FlagCorrect=0;
    case 'Repeat'
        FlagCorrect=1;
    case 'Cancel'
        FlagCorrect=0;    
end

end

end
% Mwave2=Mwave;
% Dif=diff(Mwave2([x1(1)-1 x1]));
% for i=1:length(x1)
% %     Dif=diff(Mwave2([x1(i)-1 x1(i)]));
% Mwave2(x1(i))=Mwave2(x1(i)-1)-Dif(i);
% end
% 
% figure, plot(Mwave)
% hold on,plot(Mwave2)

%%
de=((sec1)+0.010)*Fs; % delay to avoid the estimulus to detect the peak of M wave (10 ms)
EMGgradp=EMG(de:end); % It is taken into account the signal 5 samples after estimulus
ind=find(abs(EMGgradp)<max(abs(EMGgradp))*.25); % Points lower thatn 30% are avoided
EMGgradp(ind)=0;
d2=gradient(EMGgradp); % It is calculated the first derivative to obtain the inflection points

% axes(handles.axes6),cla
% plot(time{j},EMG)
% shad=datafull(sample1+de:sample2,1);
% bar(shad,ones(length(shad),1)*max(EMG),1,'k')
% alpha(0.1)
% bar(shad,ones(length(shad),1)*min(EMG),1,'k')
% alpha(0.1)
% plot( [(marks(i+1)+p2) (marks(i+1)+p2)]/Fs+datafull(1,1),[300 -1000],'-.k')

sipos=find(d2>0); % Points where sign changes are detected, related to the inflection points
sineg=find(d2<0);
sPos=zeros(length(EMGgradp),1);
sPos(sipos)=1;
sNeg=zeros(length(EMGgradp),1);
sNeg(sineg)=1;
% figure;plot(EMG(de:end))
% hold on
% stairs(sPos*max(EMGplot),'r')
% stairs(sNeg*min(EMGplot),'k')
dneg=sPos(2:end)+sNeg(1:end-1); % to detect points where sign changes
dpos=sPos(1:end-1)+sNeg(2:end);
dpos=find(dpos==2);
dneg=find(dneg==2);
try
if dpos(end)<dneg(end)
    EMGplot=EMG;
    
%     samPeak=sipos(end)+de;
    samPeak=dpos(end)+de;
    [MM_M,tM1]=max(EMG(samPeak-5:samPeak+5));
    tM1=tM1+samPeak-5-1;
    samPeak=dneg(end)+de;
    [mm_M,tm1]=min(EMG(samPeak-5:samPeak+5));
    tm1=tm1+samPeak-5-1;
else
    % inverting the signal to plot positive follows by negative peaks
    EMGplot=EMG*(-1);
    
    samPeak=dneg(end)+de;
    [mm_M,tm1]=min(EMG(samPeak-5:samPeak+5));
    tm1=tm1+samPeak-5-1;
    samPeak=dpos(end)+de;
    [MM_M,tM1]=max(EMG(samPeak-5:samPeak+5));
    tM1=tM1+samPeak-5-1;
end
catch
    EMGplot=EMG;
    tm1=length(EMG);
    tM1=length(EMG);
end
mm=min(EMGplot);
MM=max(EMGplot);
tm=tm1;
tM=tM1;

%% Graphic

axes(handles.axes1)
cla
hold on
plot(datafull(:,1),datafull(:,emgCH)), axis tight
s1=FinalMarks(i+stim)-sec1*Fs;
s2=FinalMarks(i+stim)+sec2*Fs;
if s2>size(datafull,1)
    s2=size(datafull,1);
end
shad=datafull(s1:s2,1);
bar(shad,ones(length(shad),1)*max(datafull(:,emgCH)),1,'k'),alpha(0.1)
bar(shad,ones(length(shad),1)*min(datafull(:,emgCH)),1,'k'),alpha(0.1)
try 
    plot(datafull(:,1),datafull(:,5)*MM,'c')
end
hold off
ylabel('EMG VL')
set(handles.axes1,'YTickLabel',[])
set(handles.axes1,'XTickLabel',[])

axes(handles.axes2)
plot(datafull(:,1),datafull(:,4))
axis tight
set(handles.axes2,'YTickLabel',[])


axes(handles.axes6),cla
if get(handles.plotFigure,'Value')
    fmw=figure;
end
plot(time{j},EMGplot)
axis tight
hold on
% plot( (marks(i+1)+p2) /Fs+datafull(1,1),mm,'sk','MarkerFaceColor',[.1 .49 .30],'MarkerSize',5)
plot( [(FinalMarks(i+stim)+p2) (FinalMarks(i+stim)+p2)]/Fs+datafull(1,1),[MM mm],'-.k')
plot([FinalMarks(i+stim)+p2+0.008*Fs FinalMarks(i+stim)+p2+0.013*Fs]/Fs+datafull(1,1),[mm mm]*0.95,'r') % Expected values for M-wave
title(strcat('M Wave. Trial: ',num2str(j)))
xlabel('Time [s]')
ylabel('Amplitude')

%%
% shade1=time{j}(tm:tM);
% bar(shade1,ones(length(shade1),1)*max(EMGplot),1,'k','EdgeColor','none'),
% alpha(0.1)
% bar(shade1,ones(length(shade1),1)*min(EMGplot),1,'k','EdgeColor','none'),
% alpha(0.1)
plot([time{j}(tm) time{j}(tm)],[MM mm],'--r')
plot([time{j}(tM) time{j}(tM)],[MM mm],'--r')
legend({'EMG','Estimulus','Peaks'})


%%
try
    drawMWave
catch
    waitfor(warndlg('Please, correct the peaks!','Warning!'));
    flagcorrect=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.A_AnalysisMenu,'Enable','off')
if correct
    
if ~flagcorrect
button = questdlg('Select an option!','','Continue','Correct peaks','Cancel','Continue');
else
    button='Correct peaks';
end
repeat=1;

if strcmp(button,'Correct peaks')
    while repeat
        
    EMGplot=EMG;
    mm=min(EMGplot);
    MM=max(EMGplot);
%     figure, 
    hold off
    plot(time{j},EMGplot),hold on
%     Linha eliminada temporalmente
%     plot( [(marks(i+1)+p2) (marks(i+1)+p2)]/Fs+datafull(1,1),[MM mm],'-.k')
    axis tight
    hold on
%     xlabel('Press any key to continue!')
    str=('Press any key to continue!');
    set(handles.textaxes5,'Visible','on','String',str) 
%     warndlg('Press any key to continue!','Heim!!') 
%     pause
%     xlabel('Select the maximum peak!')
    str=('Select the maximum peak!');
    set(handles.textaxes5,'Visible','on','String',str) 
    [x1,y,key] = ginput(1);
    if ~isempty(key) && key~=99
        x1=round((x1-time{j}(1))*Fs)+1;
        [MM_M,tM1]=max(EMGplot(x1-5:x1+5));
        tM=tM1+x1-5-1;    
        plot([time{j}(tM) time{j}(tM)],[MM mm],'--r')
    else            
        disp(key)
        repeat=0;
    end
%     pause
%     xlabel('Select the minimum peak!')
    str=('Select the minimum peak!');
    set(handles.textaxes5,'Visible','on','String',str) 
    [x2,y,key] = ginput(1);    
    if ~isempty(key) && key~=99
        x2=round((x2-time{j}(1))*Fs)+1;
        [mm_M,tm1]=min(EMGplot(x2-5:x2+5)); % error if peak is near to the end
        tm=tm1+x2-5-1;
        plot([time{j}(tm) time{j}(tm)],[MM mm],'--r')
    else
        disp(key)
        repeat=0;
    end
    legend({'EMG','Peaks'})
    xlabel('Time [s]')
    set(handles.A_AnalysisMenu,'Enable','on')
    set(handles.textaxes5,'Visible','off') 

    FinalMarks(k+ss-1)=round((x1(1)-datafull(1,1))*Fs);
    FinalMarks(k)=marks(i)+p1;

    xlabel('Time [s]')
    ylabel('EMG [Nm]')
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

if tm<tM
%         shade1=time{j}(tm:tM);
    EMGplot=EMG*(-1);
    mm=min(EMGplot);
    MM=max(EMGplot);
else
%         shade1=time{j}(tM:tm);

%         f=errordlg('The peak is wrong!','Error');
%         waitfor(f)
end
%     bar(shade1,ones(length(shade1),1)*max(EMGplot),1,'k','EdgeColor','none'),
%     alpha(0.1)
%     bar(shade1,ones(length(shade1),1)*min(EMGplot),1,'k','EdgeColor','none'),
%     alpha(0.1)

try
drawMWave
catch
   waitfor(warndlg('Please, correct the Zero-Crossing!','Warning!'));
   flagcorrect=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %     xlabel('Press any key to continue!')
%     str=('Press any key to continue!');
%     set(handles.textaxes5,'Visible','on','String',str) 
%     %     warndlg('Press any key to continue!','Heim!!') 
%     pause
%     set(handles.textaxes5,'Visible','off') 
%     xlabel('Time [s]')
if ~flagcorrect
    button1=questdlg('The peaks are ok?','Heim!!','Yes','No','Zero-Crossing','Yes');
else
    button1='Zero-Crossing';
end
%     waitfor(button1)
    if strcmp(button1,'Yes')
        repeat = 0;
    elseif strcmp(button1,'Zero-Crossing')
        hold off
        plot(time{j},EMGplot)
        plot( [(FinalMarks(i+stim)+p2) (FinalMarks(i+stim)+p2)]/Fs+datafull(1,1),[MM mm],'-.k')
        plot([FinalMarks(i+stim)+p2+0.008*Fs FinalMarks(i+stim)+p2+0.013*Fs]/Fs+datafull(1,1),[mm mm]*0.95,'r') % Expected values for M-wave
        axis tight
        hold on
%         plot( [(marks(i+1)+p2) (marks(i+1)+p2)]/Fs+datafull(1,1),[MM mm],'-.k')
        plot([time{j}(tm) time{j}(tm)],[MM mm],'--r')
        plot([time{j}(tM) time{j}(tM)],[MM mm],'--r')
        title(strcat('M Wave. Trial: ',num2str(j)))
        xlabel('Time [s]')
        ylabel('Amplitude')
        
        str=('Select the zero crossing at left!');
        set(handles.textaxes5,'Visible','on','String',str) 
        [x1,y,key] = ginput(1);
%         if ~isempty(key) && key~=99
        t1basep=round((x1-time{j}(1))*Fs);
        posPeak=[0; EMG(t1basep:t2basep); 0]; % Is limited with zero to complet the wave to zero
        time1=time{j}(t1basep-1:t2basep+1);
        xverts =[time1(1:end-1)'; time1(1:end-1)'; time1(2:end)'; time1(2:end)'];
        if tM>tm
        yverts = [zeros(1,length(time1)-1); (-1)*posPeak(1:end-1)'; (-1)*posPeak(2:end)'; zeros(1,length(time1)-1)];
        else
        yverts = [zeros(1,length(time1)-1); posPeak(1:end-1)'; posPeak(2:end)'; zeros(1,length(time1)-1)];
        end
        p = patch(xverts,yverts,'b','EdgeColor','none');
        alpha(0.1)
        
        
        str=('Select the zero crossing at left!');
        set(handles.textaxes5,'Visible','on','String',str) 
        [x1,y] = ginput(1);
        t2basen=round((x1-time{j}(1))*Fs);
        negPeak=[0; EMG(t1basen:t2basen); 0]; % Is limited with zero to complet the wave to zero
        time2=time{j}(t1basen-1:t2basen+1);
        xverts =[time2(1:end-1)'; time2(1:end-1)'; time2(2:end)'; time2(2:end)'];
        if tM>tm
        yverts = [zeros(1,length(time2)-1); (-1)*negPeak(1:end-1)'; (-1)*negPeak(2:end)'; zeros(1,length(time2)-1)];
        else
        yverts = [zeros(1,length(time2)-1); negPeak(1:end-1)'; negPeak(2:end)'; zeros(1,length(time2)-1)];
        end
        p = patch(xverts,yverts,'b','EdgeColor','none');
        alpha(0.1)
        
        legend({'EMG','Estimulus','Peaks'})
        title(strcat('M Wave. Trial: ',num2str(j)))
        xlabel('Time [s]')
        ylabel('Amplitude')
                
        set(handles.textaxes5,'Visible','off')     
        
        button1=questdlg('Continue?','!','Yes','No','Yes');
        if strcmp(button1,'Yes')
        repeat = 0;
        end
    end

    end
    
elseif strcmp(button,'Continue')
    axes(handles.axes6),cla
    if get(handles.plotFigure,'Value')
        fmw=figure;
    end
    plot(time{j},EMGplot)
    axis tight
    hold on
    % plot( (marks(i+1)+p2) /Fs+datafull(1,1),mm,'sk','MarkerFaceColor',[.1 .49 .30],'MarkerSize',5)
    plot( [(FinalMarks(i+stim)+p2) (FinalMarks(i+stim)+p2)]/Fs+datafull(1,1),[MM mm],'-.k')
    plot([FinalMarks(i+stim)+p2+0.008*Fs FinalMarks(i+stim)+p2+0.013*Fs]/Fs+datafull(1,1),[mm mm]*0.95,'r') % Expected values for M-wave
    title(strcat('M Wave. Trial: ',num2str(j)))
    xlabel('Time [s]')
    ylabel('Amplitude')

    drawMWave
%     FinalMarks(k)=marks(i)+p1;
%     FinalMarks(k+1)=marks(i+1)+p2;

elseif strcmp(button,'Cancel')
    cancelRoutine=1;
    break
end

end
set(handles.A_AnalysisMenu,'Enable','on')

% hold off
% if get(handles.plotFigure,'Value')
%     fmw=figure;
% end
% plot(time{j},EMGplot)
% axis tight
% hold on
% % plot( (marks(i+1)+p2) /Fs+datafull(1,1),mm,'sk','MarkerFaceColor',[.1 .49 .30],'MarkerSize',5)
% plot( [(marks(i+1)+p2) (marks(i+1)+p2)]/Fs+datafull(1,1),[MM mm],'-.k')
% plot([time{j}(tm) time{j}(tm)],[MM mm],'--r')
% plot([time{j}(tM) time{j}(tM)],[MM mm],'--r')
% legend({'EMG','Estimulus','Peaks'})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% % positive peak (for wave positive reflected)
% t1basep=find(EMG(1:tM)<0); % to detect the first sample in the minimum peak
% if ~isempty(t1basep)
%     t1basep=t1basep(end)+1;
% else
%     errordlg('Unable to define the negative peak','Error!')
% end
% t2basep=find(EMG(tM:end)<0)+tM-1;
% if ~isempty(t2basep)
%     t2basep=t2basep(1)-1;
% else
%     t2basep=length(EMG)-1;
%     warndlg('Unable to define the negative peak','Error!')
% end
% 
% posPeak=[0; EMG(t1basep:t2basep); 0]; % Is limited with zero to complet the wave to zero
% 
% % negative peak (for wave negative reflected)
% t1basen=find(EMG(1:tm)>0);
% t1basen=t1basen(end)+1;
% t2basen=find(EMG(tm:end)>0)+tm-1;
% t2basen=t2basen(1)-1;
% 
% negPeak=[0; EMG(t1basen:t2basen); 0]; % Is limited with zero to complet the wave to zero
% 
% % shade
% if get(handles.plotFigure,'Value')
%     figure(fmw)
% else
%     axes(handles.axes6), 
%     hold on
% end
% time1=time{j}(t1basep-1:t2basep+1);
% xverts =[time1(1:end-1)'; time1(1:end-1)'; time1(2:end)'; time1(2:end)'];
% if tM>tm
% yverts = [zeros(1,length(time1)-1); (-1)*posPeak(1:end-1)'; (-1)*posPeak(2:end)'; zeros(1,length(time1)-1)];
% else
% yverts = [zeros(1,length(time1)-1); posPeak(1:end-1)'; posPeak(2:end)'; zeros(1,length(time1)-1)];
% end
% p = patch(xverts,yverts,'b','EdgeColor','none');
% alpha(0.1)
% time2=time{j}(t1basen-1:t2basen+1);
% xverts =[time2(1:end-1)'; time2(1:end-1)'; time2(2:end)'; time2(2:end)'];
% if tM>tm
% yverts = [zeros(1,length(time2)-1); (-1)*negPeak(1:end-1)'; (-1)*negPeak(2:end)'; zeros(1,length(time2)-1)];
% else
% yverts = [zeros(1,length(time2)-1); negPeak(1:end-1)'; negPeak(2:end)'; zeros(1,length(time2)-1)];
% end
% p = patch(xverts,yverts,'b','EdgeColor','none');
% alpha(0.1)
% legend({'EMG','Estimulus','Peaks'})
% title(strcat('M Wave. Trial: ',num2str(j)))
% xlabel('Time [s]')
% ylabel('Amplitude')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
App(j)=MM_M-mm_M;
App_p(j)=MM_M;
App_n(j)=mm_M;
tpp(j)=abs(tM-tm)/Fs;
% Ipp(j) = trapz(time{j}(tm:tM),ondaM(tm1(end):tM1(1))); % wrong

if tM>tm
Ipp(j) = trapz(time{j}(t1basen-1:t2basep+1),abs([0; EMG(t1basen:t2basep); 0]));
else
Ipp(j) = trapz(time{j}(t1basep-1:t2basen+1),abs([0; EMG(t1basep:t2basen); 0]));
end

Ipp_p(j) = trapz(time{j}(t1basep-1:t2basep+1),abs(posPeak));
Ipp_n(j) = trapz(time{j}(t1basen-1:t2basen+1),abs(negPeak));
tmwaveP(j) = (t2basep+1-(t1basep-1))/1000;
tmwaven(j) = (t2basen+1-(t1basen-1))/1000;
catch
    stop=1; 
    if exist('Ipp')
        Ipp(j)=NaN;
    end
    Ipp_p(j) = NaN;
    Ipp_n(j) = NaN;
    tmwaveP(j) = NaN;
    tmwaven(j) = NaN;
end
disp('____________________')
disp(['Trial: ',num2str((i+3)/4)])
disp(['Amplitude pp = ',num2str(App(j))])
disp(['Time pp = ',num2str(tpp(j))])
disp(['Integral fullwave = ',num2str(Ipp(j))])
disp(['Integral Positive Peak= ',num2str(Ipp_p(j))])
disp(['Integral Negative Peak = ',num2str(Ipp_n(j))])
disp('_________________________________________________')
set(handles.t1,'String',['Amplitude pp = ',num2str(App(j))])
set(handles.t2,'String',['Time pp = ',num2str(tpp(j))])
set(handles.t3,'String',['Integral fullwave = ',num2str(Ipp(j))])
set(handles.t4,'String',['Integral Positive Peak= ',num2str(Ipp_p(j))])
set(handles.t5,'String',['Integral Negative Peak = ',num2str(Ipp_n(j))])

ResM(j,:)=[App(j) App_p(j) App_n(j) tpp(j) tmwaveP(j) tmwaven(j) Ipp(j) Ipp_p(j) Ipp_n(j)];

ResMInformation{1}='Amplitude peak to peak';
ResMInformation{2}='Amplitude positive wave';
ResMInformation{3}='Amplitude negative wave';
ResMInformation{4}='Time pp';
ResMInformation{5}='Time Positive';
ResMInformation{6}='Time Negative';
ResMInformation{7}='Integral fullwave';
ResMInformation{8}='Integral Positive Peak';
ResMInformation{9}='Integral Negative Peak';


% figure
% % plot(toM,ondaM)
% plot(t,ondaM)
% hold on
% plot( [(FinalMarks(k+1)) (FinalMarks(k+1)+1)]/Fs,[MM mm],'c')
% title(strcat('M wave. Trial: ',num2str((i+3)/4)))
% xlabel('Time [s]')
% ylabel('Amplitude')

EMGsave{j}=EMG;
if ss==2
    k=k+2;
else
    k=k+4;
end
j=j+1;

save('MWave_WorkTemporal','EMGsave','time','FinalMarks','ResM','ResMInformation')

pause(0.5)
end % trial stimulus

if ~cancelRoutine
  
if length(Ipp)>=6
    IppM=mean(Ipp);
    IppM6=mean(Ipp(end-5:end));
    disp('____________________')
    disp('====================')
    disp('Summary')
    disp(['Average Integral pp = ',num2str(IppM)])
    disp(['Average Integral pp (last six) = ',num2str(IppM6)])
else
    disp('Unable to calculate six last indices because there are not enough peaks!')
end

set(handles.t1,'String',['Amplitude pp av.= ',num2str(ResM(end,1))])
set(handles.t2,'String',['Time pp av.= ',num2str(ResM(end,4))])
set(handles.t3,'String',['Integral fullwave av.= ',num2str(ResM(end,7))])
set(handles.t4,'String',['Integral Positive Peak av.= ',num2str(ResM(end,8))])
set(handles.t5,'String',['Integral Negative Peak av.= ',num2str(ResM(end,9))])

figure
hold on
plot(ResM(:,7))
plot(ResM(:,8),'r')
plot(ResM(:,9),'k')
xlabel('Trials')
legend({'Integral Fullwave','Integral Positive','Integral negative'})

ResM=[ResM; mean(ResM,1)];

DatafileM=strcat(Datafile(1:end-9),'Results_M');

try
    
save(DatafileM,'EMGsave','time','FinalMarks','ResM','ResMInformation')
disp(['You Selected:', DatafileM])
set(handles.Info2,'String','The file was successfully saved!')
catch ME
       
   errordlg('Please, select a file','Error!')
end    

else
    set(handles.A_AnalysisMenu,'Enable','on')
end

else    
   errordlg('Peaks should be loaded before!','Error') 
end
clear datafull EMG time EMGgradp EMG plot
set(handles.A_AnalysisMenu,'Enable','on')
set(handles.A_AnalysisMenu,'Value',1)

