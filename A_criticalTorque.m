function A_criticalTorque(hObject, eventdata, handles)
% hObject    handle to A_criticalTorque (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Datafile pathname filename DatafileCT

%% Initial Conditions
set(handles.A_AnalysisMenu,'Enable','off')
set(handles.Info2,'String','Current task: Critical torque')
switch get(handles.Plot_HiddenFigures,'Checked')
    case 'on'
        hidden=true;
    case 'off'
        hidden=false;
end

switch get(handles.MultFiles,'Checked')
    case 'on'
        FlagSerial=1;
    case 'off'
        FlagSerial=0;
end

switch get(handles.hide_Plots,'Checked')
    case 'on'
        flagPlot=false;
    case 'off'
        flagPlot=true;
end




%%
if FlagSerial==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Serial
if ~ischar(pathname)
    pathname='';
end

pathname = uigetdir(pathname);

if isequal(pathname,0)

   disp('Selection canceled')
   return
else

oldFolder = cd(pathname);
ldir=dir ('*Peaks*.mat');  % Leitura de arquivos com extensão mat

cd(oldFolder);

name={ldir.name};
name=name';
test='Multiple Analysis';
end

else
    name{1}=Datafile;
    test='Single Analysis';
end
% name([1:2])=[];

for ifile=1:length(name)

clear sig timek IntT IntTl IntTm peakT timepeakT sizeSig IntTSub6

if FlagSerial==1
    Datafile=fullfile(pathname, name{ifile});
end

load (Datafile)
% if exist('marks')
disp(['You Selected:', Datafile])
set(handles.Info,'String',Datafile)
inc=0;

if flagPlot
axes(handles.axes1),cla,ylabel('')
axes(handles.axes2),cla,ylabel('')
axes(handles.axes3),cla,ylabel('')
axes(handles.axes4),cla,ylabel('')
axes(handles.axes5),cla,ylabel('')
axes(handles.axes6),cla,ylabel('')

set(handles.axes1,'Visible','on'),cla
set(handles.axes2,'Visible','on'),cla
set(handles.axes3,'Visible','off'),cla
set(handles.axes4,'Visible','off'),cla
set(handles.axes5,'Visible','off'),cla
set(handles.axes6,'Visible','on'),cla
end
%% Detect Torque channel
if exist('DataInformation','Var')
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
else
    indTorque=4;
end

%%
torque=(datafull(:,indTorque));
time=(datafull(:,1));
% ListMarks=get(handles.listbox1,'String');
lsig=length(torque);

if flagPlot
    axes(handles.axes6),cla
    plot(time,torque), hold off
    axis tight
end

%% Removal Offset

% Offset=mean(torque(1:3*Fs));
% torque=torque - Offset;
% torque(find(torque<0))=0;

%%
th = max(torque)*0.1;
pulseSig=zeros(1,lsig);
pulseSig(find(torque>th))=1; % To find every samples higher than the threshold
T=1/Fs;

% figure, plot(torque)
% hold on
% plot(pulseSig*th)
plateauPlus=round(0.5*Fs);

k=1; torque_plot=[]; time_ne=[];
while 1
    pos=find(pulseSig); % To find the first non zero element, corresponding to the begin of the pulse
if ~isempty(pos)
    neg=find(~pulseSig(pos(1):end)); % To find the first zero element, corresponding to the end of the pulse
    neg=neg+pos(1)-1;

    % if ~isempty(time_ne)
    % inc=time_ne(end);
    % end
    if neg(1)-pos(1)>1*Fs
        
        if pos(1)>0.5*Fs % to avoid errors for narrow pulses 
            sig{k}=torque(pos(1)-plateauPlus:neg(1)+plateauPlus); % Torque for the k-th trial
            timek{k}=time(pos(1)-plateauPlus:neg(1)+plateauPlus); % Time for the k-th trial
            % torque_plot=[torque_plot; torque(pos(1)-plateauPlus:neg(1)+plateauPlus)];
            % time_ne=[time_ne; time(pos(1)-plateauPlus:neg(1)+plateauPlus)+inc];
        else
            sig{k}=torque(round(pos(1)*0.5):neg(1)+plateauPlus); % Torque for the k-th trial
            timek{k}=time(round(pos(1)*0.5):neg(1)+plateauPlus); % Time for the k-th trial
            % torque_plot=[torque_plot; torque(pos(1)*0.5:neg(1)+plateauPlus)];
            % time_ne=[time_ne; time(pos(1)*0.5:neg(1)+plateauPlus)+inc];
        end

        IntT(k)=trapz(T:T:length(sig{k})*T,sig{k}); % Area of k-th Torque
        IntTl(k)=length(sig{k}); % Size of k-th Torque
        IntTm(k)=mean(sig{k}); % Mean of k-th Torque
        [peakT(k),I]=max(sig{k}); % Maximum of k-th Torque
        timepeakT(k)=timek{k}(I);
        sizeSig(k)=length(sig{k}); % To identify the length of the pulse of torque. Lower pulses are related to involuntary contractions
        k=k+1;
    end 
        torque=torque(neg(1):end); % the next pulses to be analyzed. First trial is removed
        pulseSig=pulseSig(neg(1):end); 
        time=time(neg(1):end);             
    
else
    break
end

end

% ind=find(IntT<max(IntT)*0.2); % to identify the peaks with estimulus, which are not reagards to the trials
% % ind2=[ind ind-1]; % Para o quê????
% % ind2(find(~ind2))=[]; % to remove zero indices
% ind(find(~ind))=[]; % to remove zero indices
% IntT(ind2)=[];
% IntTm(ind2)=[];
% 
% % IntTm=IntT./IntTl;
% % Removing the peaks different than trials
% peakT(ind2)=[];
% sig(ind2)=[];
% timek(ind2)=[];
% timepeakT(ind2)=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % Last 6 voluntary contractions

ntrials=length(sig);
if length(IntT)>=6
    
    % Previous version modified 06/17/2020
    % plateauPlus=round(0.2*Fs);
    % ti=plateauPlus+0.5*Fs;
    
    plateauMean6=[];
    for jk=1:6        
        [ti, te]=Onset_Offset_Plateau(sig{ntrials-jk+1},5,[],Fs,Datafile); % Onset and Offset detection
        if (te-ti)/Fs>3 % to cut the plateau with more than 3 s of duration
            te=ti+3*Fs-1;
        end
        plateauMean6=[plateauMean6 mean(sig{ntrials-jk+1}(ti:te))];
        SizePlateau=te-ti;
%         hold on, plot(sig{ntrials-jk+1}(ti:te))
        % Previous version modified 06/17/2020
        % plateauMean6=[plateauMean6 mean(sig{ntrials-jk+1}(ti:end-ti))];
    end
    
    IntTsum6=sum(IntT(end-5:end));      % Sum of areas
    IntT6m=mean(IntTm(end-5:end));      % Mean of areas
    Peak_Mean6=mean(peakT(end-5:end));  % Mean of peaks
    TMean6=mean(plateauMean6);          % Mean Value of full plateau above threshold. Dephault=5Nm
    CritT=TMean6;                       % Critical Torque
    
    % Confidence interval Mean plateau
    SD=std(plateauMean6);                                 % Standard Deviation
    SEM = std(plateauMean6)/sqrt(length(plateauMean6));   % Standard Error
    ts = tinv([0.05  0.95],length(plateauMean6)-1);       % T-Score
    CI = mean(plateauMean6) + ts*SEM;                     % Confidence Interval
%     peakT2=peakT;
%     peakT2(find(peakT2<Peak_Mean6))=Peak_Mean6;
%     I_Wlinha=trapz(peakT2-Peak_Mean6);

    % Confidence interval Peak torque
    tp=peakT(end-5:end);
    SDp=std(tp);                                 % Standard Deviation
    SEMp = std(tp)/sqrt(length(tp));             % Standard Error
    tsp = tinv([0.05  0.95],length(tp)-1);       % T-Score (Student's t inverse cumulative distribution function)
    CIp = mean(tp) + tsp*SEMp;                   % Confidence Interval
    
    for jk=1:ntrials
        sig2=sig{jk}; % Torque subtracted by CT and offset
        sig2(find(sig2<CritT))=CritT; 
        sig2=sig2-CritT; 

        Int_AboveCT(jk)=trapz(T:T:length(sig2)*T,sig2); % Area of k-th Torque above CT
        if Int_AboveCT(jk)<0
           errordlg('Integral was negative!','Error')
           a=1; % error 
        end
    end
    I_Wlinha=sum(Int_AboveCT);
    Tmean=mean(peakT);
    
% wl=IntT(1:end-6)-IntTm;
% wlm=sum(wl);

% set(handles.t3,'String',strcat('Wl = ',num2str(wl)))

% set(handles.axes6,'Visible','on')
% axes(handles.axes6),cla

%% Graphics
if flagPlot
    
try
    axes(handles.axes1)
    cla
    hold on
    plot(datafull(:,1),datafull(:,indTorque)), axis tight
    % plot(peakT,'k')
    hold off
    ylabel('Torque [Nm]')
    axis([datafull(1,1) datafull(end,1) min(datafull(:,indTorque)) max(datafull(:,indTorque))])
end

try
    axes(handles.axes2)
    plot(datafull(:,1),datafull(:,5))
    % xlabel('Time [s]')
    axis([datafull(1,1) datafull(end,1) 0 max(datafull(:,5))])
end

torque=(datafull(:,indTorque));
time=(datafull(:,1));

if get(handles.plotFigure,'Value')
    figure
else
    axes(handles.axes6),cla
end

plot(time,torque), hold on
plot(ones(1,round(time(end)))*CritT,'--r')
plot(timepeakT,peakT,'k')
plot(round(time(end))-14:round(time(end)),ones(1,15)*CI(1),'-.k')
plot(round(time(end))-14:round(time(end)),ones(1,15)*CI(2),'-.k')

% plot(round(time(end))-14:round(time(end)),ones(1,15)*CI(1),'-.k')
% plot(ones(1,round(time(end)))*CI(2),'-.g')

% plot(wl(1:end-6),'r')
plot(timepeakT,peakT,'.k')

pulseSig=ones(1,lsig);

text(timepeakT(end)*.6,peakT(1)*.85,strcat('CT =',num2str(CritT),'Nm'))
text(timepeakT(end)*.6,peakT(1)*.8,strcat('Mean Peak (6)=',num2str(Peak_Mean6),'Nm'))
axis tight

hold off
title('Critical Torque')
xlabel('Time [s]')
ylabel('Torque [Nm]')
legend({'Torque [Nm]','Critical Torque','Peak of Torque','Confidence Interval'})

% % Portugues
% xlabel('Tempo [s]')
% legend({'Torque [Nm]','Torque Crítico','Picos de Torque','Intervalo de Confiança'})


% figure
% cla, hold on   
% % plot(peakT,'k')
% % % plot(wl(1:end-6),'r')
% % plot(ones(1,length(peakT))*Peak_Mean6,'--r')
% % plot(peakT,'.k')
% 
% plot(timepeakT,peakT,'k')
% % plot(wl(1:end-6),'r')
% plot(ones(1,round(time(end)))*Peak_Mean6,'--r')
% 
% plot(timepeakT,peakT,'.k')
% 
% % plot(IntTm,'b')
% axis tight
% title('Critical Torque')
% xlabel('Trials')
% % ylabel('Impulse of Torque')
% ylabel('Peak of Torque')
% % legend({'Impulse Torque','Critical Torque'})
% legend({'Peak of Torque','Critical Torque'})
% 
% % text(30,peakT(1)*.85,strcat('CT=',num2str(Peak_Mean6),'Nm'))
% % text(30,peakT(1)*.8,strcat('CT average=',num2str(Tmean),'Nm'))
% 
% text(timepeakT(end)*.6,peakT(1)*.85,strcat('CT =',num2str(CritT),'Nm'))
% text(timepeakT(end)*.6,peakT(1)*.8,strcat('Mean Peak (6)=',num2str(Peak_Mean6),'Nm'))
% 
% % figure
% % plot(IntTm)
% % hold on
% % % plot(wl(1:end-6),'r')
% % plot(ones(1,length(IntTm))*IntT6m,'--k')
% % plot(IntTm,'.k')
% % title('Critical Torque')
% % xlabel('')
% % ylabel('Impulse of Torque')
% % legend({'Impulse Torque','Critical Torque'})


end


else
   IntTsum6=0; 
   Tmean=0;
   Peak_Mean6=0;
   errordlg('Unable to calculate indices because there are less than 6 peaks!','Error!')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Saving Results

sizeData=size(datafull);

set(handles.Panel_Info2,'Visible','off')
set(handles.Panel_Info1,'Visible','on')
% set(handles.t1,'String',strcat('IM = ',num2str(IntTm)))
set(handles.t1,'String',strcat('CT = ',num2str(CritT),'[Nm]'))
set(handles.t2,'String',strcat('I_Wlinha = ',num2str(I_Wlinha),'[Nm]'))
set(handles.t3,'String',{['Num peaks: ',num2str(length(IntT))]})
set(handles.t4,'String',{['Data size: ',num2str(sizeData)]})
set(handles.t5,'String','')
set(handles.t6,'String','')

disp(strcat('CT = ',num2str(CritT),'Nm'))
disp(strcat('I_Wlinha = ',num2str(I_Wlinha),'Nms'))

DatafileCT=strcat(Datafile(1:end-9),'Results_CT');
ResultsInformation={'I_Wlinha','CritTorque','CI_L','CI_H','SEM','SD','CritTpeak6','CI_Lp','CI_Hp','SEMp','SDp','ntrials','SizePleateau'};
Results=[I_Wlinha,CritT,CI,SEM,SD,Peak_Mean6,CIp,SEMp,SDp,ntrials,SizePlateau];

if exist('Props.history','var')
    Props.history{end+1}={'Critical Torque',Datafile,datetime};
else
    Props.history{1}={'Critical Torque',Datafile,datetime};
end

try
    save(DatafileCT,'peakT','I_Wlinha','Peak_Mean6','Datafile','IntT','CritT',...
        'ntrials','ResultsInformation','Results','CI','SEM','SD','Props','CIp','SEMp','SDp','test')
%    'ResCTInformation','ResCT': Before variables.

    disp(['File saved:', DatafileCT])
    set(handles.Info2,'String','The file was successfully saved!')
    
catch ME       
   errordlg('Please, select a file','Error!')
end    

% else
%     errordlg('Peaks should be loaded before!','Error')
% end


end

clear IntT IntTl IntTm Int_AboveCT datafull ind ind2 marks neg peakT pulseSig sig sig2...
    sizeSig time timek timepeakT torque
set(handles.A_AnalysisMenu,'Enable','on')


