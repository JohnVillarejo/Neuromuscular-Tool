function A_AnalysisT(hObject, eventdata, handles)

global Datafile checked pathname filename
set(handles.A_AnalysisMenu,'Enable','off')
    
% Panel info 1
set(handles.Panel_Info2,'Visible','off')
set(handles.t1,'String','')
set(handles.t2,'String','')
set(handles.t3,'String','')
set(handles.t4,'String','')
set(handles.t5,'String','')
set(handles.t6,'String','')
set(handles.t7,'String','')

% axes(handles.axes1),cla reset
% axes(handles.axes2),cla reset
% axes(handles.axes3),cla reset
% axes(handles.axes4),cla reset
% axes(handles.axes5),cla reset
% axes(handles.axes6),cla reset
% axes(handles.axes7),cla reset

set(handles.axes1,'Visible','on'),cla reset
set(handles.axes2,'Visible','on'),cla reset
set(handles.axes3,'Visible','off'),cla reset
set(handles.axes4,'Visible','off'),cla reset
set(handles.axes5,'Visible','off'),cla reset
set(handles.axes6,'Visible','on'),cla reset

%% Initialization
set(handles.A_peaks,'Enable','off')
si=get(handles.SetStimuli,'Value'); % Set stimuli
sst=get(handles.SetStimuli,'String');
ss=str2num(sst{si});

flagcancel=0;
flagcancel2=0;
load (Datafile)
set(handles.Info,'String',Datafile)

correct=1;
k=1;
jj=1;
[SizeData,Ncol]=size(datafull);
% ListMarks=get(handles.listbox1,'String');

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

if exist('marks','var')
    
for i=1:ss:length(marks)-1

    % sec1=2;  % number of seconds arround the peak
    % sec2=5;
    sec1=str2num(get(handles.input2,'String'));  % number of seconds arround the peak
    sec2=str2num(get(handles.input3,'String'));  
    sample1=marks(i)-sec1*Fs; % first sample to extract the trial
    if sample1<1
       sample1=1; 
       sec1=0;
    end
    sample2=marks(i)+sec2*Fs; % last sample to extract the trial
    if length(datafull(:,indTorque))<sample2
        sample2=length(datafull(:,indTorque));
    end
    torque{jj}=datafull(sample1:sample2,indTorque); % Extract the trial with +-sec seconds 
    EMG{jj}=datafull(sample1:sample2,indTorque);    % Extract the trial with +-sec seconds 
    time{jj}=datafull(sample1:sample2,1);
    % trigger=datafull(sample1:sample2,2);

%% To calculate the peaks in torque taken into account the delay between the estimulus and the torque response
    pt1=str2num(get(handles.input4,'String'))/1000;  % peak 1 radio
    pt2=str2num(get(handles.input5,'String'))/1000;  % peak 2 radio
    FillData=zeros(Fs,1); % Zeros to fill in cases with few data for the shadows
    
    %% Peak 1 Superimposed Twich. It happens around 185 ms after estimulation
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % REVISAR ESTES VALORES
% x=datafull(round(marks(i)+0.1*Fs:marks(i)+pt1*Fs),indTorque); % Eu tirei o valor
% adicionado de 0.1 para poder bater com os valores do pico de torque
x=datafull(round(marks(i):marks(i)+pt1*Fs),indTorque);
[r,peak{1}]=max(x);
% peak{1}=peak{1}+marks(i)+0.1*Fs-1; % to find the peak{ shifted by the cutted segment. Minus 1 to discount the sample in the cutted segment
peak{1}=peak{1}+marks(i)-2; % to find the peak shifted by the cutted segment. Minus 1 to discount the sample in the cutted segment

%% Peak 2 Potentiated Twich
shadePT=0.5*Fs; % 500ms for the shade
if marks(i+1)+pt2*Fs < SizeData
    x=datafull(round(marks(i+1):marks(i+1)+pt2*Fs),indTorque);
else
    x=[datafull(round(marks(i+1)):end,indTorque); FillData];    
end
[r,peak{2}]=max(x);
peak{2}=peak{2}+marks(i+1)-2; % to find the peak shifted by the cutted segment. Minus 1 to discount the sample in the cutted segment
if peak{2}+shadePT < SizeData
    torque2=datafull(peak{2}-shadePT:peak{2}+shadePT,indTorque);
else
    torque2=[datafull(peak{2}-shadePT:end,indTorque); FillData];
end

% peak2=p+marks(i+1)-1; % to find the peak shifted by the cutted segment. Minus 1 to discount the sample in the cutted segment
% Dibujar una barra transparente alrededor del pico
% correction of magnitud of torque
% torque= torque - min(torque);

if ss==4
    
%% Peak 3
    x=datafull(round(marks(i+2):marks(i+2)+pt2*Fs),indTorque);
    [r,peak{3}]=max(x);
    peak{3}=peak{3}+marks(i+2)-2; % to find the peak shifted by the cutted segment. Minus 1 to discount the sample in the cutted segment
    torque3=datafull(peak{3}-shadePT:peak{3}+shadePT,indTorque);
    
    if marks(i+3)+pt2*Fs < SizeData
        x=datafull(round(marks(i+3):marks(i+3)+pt2*Fs),indTorque);
    else
        x=[datafull(round(marks(i+3)):end,indTorque); FillData];
    end
    
%% Peak 4
    [r,peak{4}]=max(x);
    peak{4}=peak{4}+marks(i+3)-2; % to find the peak shifted by the cutted segment. Minus 1 to discount the sample in the cutted segment
    if peak{4}+shadePT < SizeData
        torque4=datafull(peak{4}-shadePT:peak{4}+shadePT,indTorque);
    else
        torque4=[datafull(peak{4}-shadePT:end,indTorque) ; FillData];
    end
end

%%
mm=min(torque{jj});
MM=max(torque{jj});

% factor correction
p1=360;
p2=400;

% figure, 
% subplot(411), 
%% Graphic

axes(handles.axes1)
cla
hold on
plot(datafull(:,1),datafull(:,indTorque)), axis tight
bar(time{jj},ones(length(time{jj}),1)*max(datafull(:,indTorque)),1,'k'),alpha(0.1)
try 
plot(datafull(:,1),datafull(:,5)*MM,'c')
end
hold off
ylabel('Torque [Nm]')
% axis([datafull(1,1) datafull(end,1) min(datafull(:,indTorque)) max(datafull(:,indTorque))])
legend({'Torque [Nm]','Data Analysis','Peaks'})

axes(handles.axes2)
try
plot(datafull(:,1),datafull(:,5))

% xlabel('Time [s]')
axis([datafull(1,1) datafull(end,1) 0 max(datafull(:,5))])
end

% subplot(212)
axes(handles.axes6)
cla, axis tight
if get(handles.plotFigure,'Value')
    figure
end
hold on
plot(time{jj},torque{jj})
% plot(t,trigger*max(torque))
plot([marks(i) marks(i)]/Fs+datafull(1,1),[MM mm],'-.m')
plot([peak{1} peak{1}+1]/Fs+datafull(1,1),[MM mm],'--r')
shade=datafull(round(marks(i):marks(i)+pt1*Fs),1);
bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

plot([marks(i+1) marks(i+1)]/Fs+datafull(1,1),[MM mm],'-.m')
plot( [peak{2} peak{2}+1]/Fs+datafull(1,1),[MM mm],'--r')
% plot(peak2/Fs+datafull(1,1),MM,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
% plot(peak{1}/Fs+datafull(1,1),MM,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
shade=datafull(round(marks(i+1):marks(i+1)+pt2*Fs),1);
bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

if ss==4
plot([marks(i+2) marks(i+2)]/Fs+datafull(1,1),[MM mm],'-.m')
plot([peak{3} peak{3}+1]/Fs+datafull(1,1),[MM mm],'--r')
shade=datafull(round(marks(i+2):marks(i+2)+pt2*Fs),1);
bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

plot([marks(i+3) marks(i+3)]/Fs+datafull(1,1),[MM mm],'-.m')
plot([peak{4} peak{4}+1]/Fs+datafull(1,1),[MM mm],'--r')
shade=datafull(round(marks(i+3):marks(i+3)+pt2*Fs),1);
bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

end
% plot( (marks(i)) /Fs,MM,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
% plot( (marks(i+1)) /Fs,mm,'sk','MarkerFaceColor',[.1 .49 .30],'MarkerSize',5)
% plot( [(marks(i)+p1) (marks(i)+p1+1)]/Fs,[MM mm] ,'k')
% plot( [(marks(i+2)+p2) (marks(i+2)+p2+1)]/Fs,[MM mm],'k')
title(strcat('Electrical stimulus in Torque. Trial: ',num2str(jj)))
xlabel('Time [s]')
ylabel('Torque [Nm]')
legend({'Torque [Nm]','Data Analysis','Peaks'})

% xlabel('Tempo [s]')
% ylabel('Torque [Nm]')
% title('')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FinalMarks(k)=peak{1};
FinalMarks(k+1)=peak{2};
if ss==4
    FinalMarks(k+2)=peak{3};
    FinalMarks(k+3)=peak{4};
end

%% Baseline
% try
baselineSIT % script
% catch ME
%     waitfor(warndlg('Unable to calculate baseline of the second estimulus!','Warning!'))
% %     rethrow(ME)
%     disp(['Error: ',ME.message])
% end

legend({'Torque','Estimulus','Peaks'})

%% Tese André
% samp_onset=2000; % samples before estimulus to detect the onset
% torqueOnset=datafull(round(FinalMarks(k))-samp_onset:round(FinalMarks(k)),indTorque);
% 
% [trms,Frms] = RMSvalue (torqueOnset,Fs,100,100);
% figure, plot(trms,Frms)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

repeat=1;
while repeat
if correct
str=('Press any key to continue!');
set(handles.textaxes5,'Visible','on','String',str) 
pause()
set(handles.textaxes5,'Visible','off')
flagOK=0;

% button = questdlg('Select Yes to correct the peaks?','Select to continue');
button = questdlg('Main Menu!','Question','OK','Edit peaks','Edit Baseline','OK');
% movegui(button,'west')
if isempty(button)
    flagcancel2=1;
    repeat=0;
    set(handles.Info2,'String','Current task: Cancelled')
else
    repeat1=1;

    if strcmp(button,'OK')
        repeat = 0;
        flagOK=1;
        
    elseif strcmp(button,'Edit peaks')
%         button = questdlg('Select the peak!','Question','Superimposed','Potentiated','Superimposed');
%         clear checked
        h=PeaksSelection;
%         waitfor(checked)
        
        while repeat1

%         xlabel('Press any key to continue!')
%     %     warndlg('Press any key to continue!','Heim!!') 
%         set(handles.A_AnalysisMenu,'Enable','off')
%         str=('Press any key to continue!');
%         set(handles.textaxes5,'Visible','on','String',str) 
%         pause
%         set(handles.textaxes5,'Visible','off') 
%     
%         set(handles.A_AnalysisMenu,'Enable','on')
%         [x,y] = ginput(1);
%         p1=round((x(1)-0.050-datafull(1,1))*Fs);
%         p2=round((x(1)+0.050-datafull(1,1))*Fs);
%         segm=datafull(p1:p2,indTorque);
%         [r,p]=max(segm);
%         FinalMarks(k)=p1+p-1; % revisar que atrasa 3 muestras aprox
%         if length(x)>1
%     %         FinalMarks(k+1)=x(2)*Fs;
%             p1=round((x(2)-0.050-datafull(1,1))*Fs);
%             p2=round((x(2)+0.050-datafull(1,1))*Fs);
%             segm=datafull(p1:p2,indTorque);
%             [r,p]=max(segm);
%             FinalMarks(k+1)=p1+p-1; %revisar que atrasa 3 muestras aprox
%         else
%             FinalMarks(k+1)=peak2;
%         end

%         xlabel('Press any key to continue!')
    %     warndlg('Press any key to continue!','Heim!!') 
%         set(handles.A_AnalysisMenu,'Enable','off')
%         pause
%         set(handles.textaxes5,'Visible','off') 
    
%         set(handles.A_AnalysisMenu,'Enable','on')
        if checked{1}
            str=('Zoom and select the superimposed peak. Press any key to continue!');
            set(handles.textaxes5,'Visible','on','String',str) 
            zoom on
            pause
            set(handles.textaxes5,'Visible','off') 
            [x,y] = ginput(1);
            p1=round((x(1)-0.050-datafull(1,1))*Fs); % To extract a segment 50ms around the selected point
            p2=round((x(1)+0.050-datafull(1,1))*Fs);
            segm=datafull(p1:p2,indTorque);
            [r,p]=max(segm);
            FinalMarks(k)=p1+p-1; % revisar que atrasa 3 muestras aprox
        else                
            FinalMarks(k)=peak{1}; % Debería ser k?
        end
        if checked{2}
    %         FinalMarks(k+1)=x(2)*Fs;            
            str=('Zoom and  select the potentiated peak. Press any key to continue!');
            set(handles.textaxes5,'Visible','on','String',str)
            zoom on
            pause
            set(handles.textaxes5,'Visible','off') 
            [x,y] = ginput(1);
            p1=round((x(1)-0.050-datafull(1,1))*Fs); % To extract a segment 50ms around the selected point
            p2=round((x(1)+0.050-datafull(1,1))*Fs);
            segm=datafull(p1:p2,indTorque);
            [r,p]=max(segm);
            FinalMarks(k+ss-1)=p1+p-1; %revisar que atrasa 3 muestras aprox
        else
            FinalMarks(k+ss-1)=peak{1+ss-1};
        end
        set(handles.textaxes5,'Visible','off') 
        
        %% Graphic
    %     figure, 
    %     subplot(212),        
        axes(handles.axes6)
        cla
        hold on
        plot(time{jj},torque{jj})        
                
        plot([marks(i) marks(i)]/Fs+datafull(1,1),[MM mm],'-.m')
        plot([FinalMarks(k) FinalMarks(k)]/Fs+datafull(1,1),[MM mm],'--k')
        shade=datafull(round(marks(i):marks(i)+pt1*Fs),1);
        bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)
        
        plot([marks(i+1) marks(i+1)]/Fs+datafull(1,1),[MM mm],'-.m')
        plot([FinalMarks(k+1) FinalMarks(k+1)]/Fs+datafull(1,1),[MM mm],'--k')
        shade=datafull(round(marks(i+1):marks(i+1)+pt1*Fs),1);
        bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

        if ss==4
        plot([marks(i+2) marks(i+2)]/Fs+datafull(1,1),[MM mm],'-.m')
        plot([FinalMarks(k+2) FinalMarks(k+2)]/Fs+datafull(1,1),[MM mm],'--k')
        shade=datafull(round(marks(i+2):marks(i+2)+pt1*Fs),1);
        bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

        plot([marks(i+3) marks(i+3)]/Fs+datafull(1,1),[MM mm],'-.m')
        plot([FinalMarks(k+3) FinalMarks(k+3)]/Fs+datafull(1,1),[MM mm],'--k')
        shade=datafull(round(marks(i+3):marks(i+3)+pt1*Fs),1);
        bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)
        end
        
        title(strcat('Electrical stimulus in Torque. Trial: ',num2str(jj)))
        xlabel('Time [s]')
        ylabel('Torque [Nm]')
        legend({'Torque','Estimulus','Peaks'})
            
        %%
        baselineSIT % script

        button2 = questdlg('Select an option!','Question','OK','Repeat','Cancel','OK');
%         movegui(button2,'west')

        if strcmp(button2,'OK')


            repeat1 = 0;
        elseif strcmp(button2,'Repeat')
            cla, axis tight
            hold on
            plot(time{jj},torque{jj})
            plot([marks(i) marks(i)]/Fs+datafull(1,1),[MM mm],'-.m')
%             plot(peak{1}/Fs+datafull(1,1),MM,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
            plot([peak{1} peak{1}+1]/Fs+datafull(1,1),[MM mm],'--r')
            shade=datafull(round(marks(i):marks(i)+pt1*Fs),1);
            bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)
            
            plot([marks(i+1) marks(i+1)]/Fs+datafull(1,1),[MM mm],'-.m')
%             plot(peak2/Fs+datafull(1,1),MM,'sk','MarkerFaceColor',[.49 1 .63],'MarkerSize',5)
            plot([peak{2} peak{2}+1]/Fs+datafull(1,1),[MM mm],'--r')
            shade=datafull(round(marks(i+1):marks(i+1)+pt1*Fs),1);
            bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

            if ss==4
            plot([marks(i+2) marks(i+2)]/Fs+datafull(1,1),[MM mm],'-.m')
            plot([peak{3} peak{3}+1]/Fs+datafull(1,1),[MM mm],'--r')
            shade=datafull(round(marks(i+2):marks(i+2)+pt1*Fs),1);
            bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

            plot([marks(i+3) marks(i+3)]/Fs+datafull(1,1),[MM mm],'-.m')
            plot([peak{4} peak{4}+1]/Fs+datafull(1,1),[MM mm],'--r')
            shade=datafull(round(marks(i+3):marks(i+3)+pt1*Fs),1);
            bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

            end
            title(strcat('Electrical stimulus in Torque. Trial: ',num2str(jj)))
            xlabel('Time [s]')
            ylabel('Torque [Nm]')
            legend({'Torque','Estimulus','Peaks'})

        elseif strcmp(button2,'Cancel')
            flagcancel=1;
            break

        end

        end

    elseif strcmp(button,'Edit Baseline')
        repeat2=1;
        while repeat2
    %     errordlg('Error in PT peak. Select manually','Error')
        str=('Zoom and select the baseline p1. Press any key to continue!');
        set(handles.textaxes5,'Visible','on','String',str)
        cla
        hold on
        plot(time{jj},torque{jj})        
                
        plot([marks(i) marks(i)]/Fs+datafull(1,1),[MM mm],'-.m')
        plot([FinalMarks(k) FinalMarks(k)]/Fs+datafull(1,1),[MM mm],'--k')
        shade=datafull(round(marks(i):marks(i)+pt1*Fs),1);
        bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)
        
        plot([marks(i+1) marks(i+1)]/Fs+datafull(1,1),[MM mm],'-.m')
        plot([FinalMarks(k+1) FinalMarks(k+1)]/Fs+datafull(1,1),[MM mm],'--k')
        shade=datafull(round(marks(i+1):marks(i+1)+pt1*Fs),1);
        bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

        if ss==4
        plot([marks(i+2) marks(i+2)]/Fs+datafull(1,1),[MM mm],'-.m')
        plot([FinalMarks(k+2) FinalMarks(k+2)]/Fs+datafull(1,1),[MM mm],'--k')
        shade=datafull(round(marks(i+2):marks(i+2)+pt1*Fs),1);
        bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

        plot([marks(i+3) marks(i+3)]/Fs+datafull(1,1),[MM mm],'-.m')
        plot([FinalMarks(k+3) FinalMarks(k+3)]/Fs+datafull(1,1),[MM mm],'--k')
        shade=datafull(round(marks(i+3):marks(i+3)+pt1*Fs),1);
        bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)
        end
        
        title(strcat('Electrical stimulus in Torque. Trial: ',num2str(jj)))
        xlabel('Time [s]')
        ylabel('Torque [Nm]')
        legend({'Torque','Estimulus','Peaks'})
        
        zoom on
%         pause()
%         str=('Press any key to continue!');
        set(handles.textaxes5,'Visible','on','String',str) 
        pause
        set(handles.textaxes5,'Visible','off') 

        [x,y]=ginput(1);    
        tbase1=(x-datafull(1,1))*Fs;
        plot([datafull(round(tbase1),1) FinalMarks(k+ss-1)/Fs+datafull(1,1)],[datafull(round(tbase1),indTorque) datafull(FinalMarks(k+ss-1),indTorque)],'-k','LineWidth',1.5)

        str=('Select the baseline p2');
        set(handles.textaxes5,'Visible','on','String',str) 
    %     pause()
        [x,y]=ginput(1);
    %     pause()
        tbase2=(x-datafull(1,1))*Fs;
        set(handles.textaxes5,'Visible','off') 
        plot([FinalMarks(k+ss-1)/Fs+datafull(1,1) datafull(round(tbase2),1)],[datafull(FinalMarks(k+ss-1),indTorque) datafull(round(tbase2),indTorque)],'-k','LineWidth',1.5)

        button3 = questdlg('Select an option!','Question','OK','Repeat','Cancel','OK');
%         movegui(button3,'west')

        if strcmp(button3,'OK')
            repeat2 = 0;
        elseif strcmp(button3,'Repeat')

        axes(handles.axes6)
        cla
        hold on
        plot(time{jj},torque{jj})        
                
        plot([marks(i) marks(i)]/Fs+datafull(1,1),[MM mm],'-.m')
        plot([FinalMarks(k) FinalMarks(k)]/Fs+datafull(1,1),[MM mm],'--k')
        shade=datafull(round(marks(i):marks(i)+pt1*Fs),1);
        bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)
        
        plot([marks(i+1) marks(i+1)]/Fs+datafull(1,1),[MM mm],'-.m')
        plot([FinalMarks(k+1) FinalMarks(k+1)]/Fs+datafull(1,1),[MM mm],'--k')
        shade=datafull(round(marks(i+1):marks(i+1)+pt1*Fs),1);
        bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

        if ss==4
        plot([marks(i+2) marks(i+2)]/Fs+datafull(1,1),[MM mm],'-.m')
        plot([FinalMarks(k+2) FinalMarks(k+2)]/Fs+datafull(1,1),[MM mm],'--k')
        shade=datafull(round(marks(i+2):marks(i+2)+pt1*Fs),1);
        bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

        plot([marks(i+3) marks(i+3)]/Fs+datafull(1,1),[MM mm],'-.m')
        plot([FinalMarks(k+3) FinalMarks(k+3)]/Fs+datafull(1,1),[MM mm],'--k')
        shade=datafull(round(marks(i+3):marks(i+3)+pt1*Fs),1);
        bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)
        end
        
        title(strcat('Electrical stimulus in Torque. Trial: ',num2str(jj)))
        xlabel('Time [s]')
        ylabel('Torque [Nm]')
        legend({'Torque','Estimulus','Peaks'})

        elseif strcmp(button3,'Cancel')
            flagcancel=1;
            break    
        end
        end

    end
end

end

if ~flagcancel2 && ~flagOK
button3 = questdlg('Select an option!','Question','Continue','Main menu','Cancel','Continue');
% movegui(button3,'west')

if strcmp(button3,'Continue')
    repeat = 0;
elseif strcmp(button3,'Main menu')
    axes(handles.axes6)
    cla
    hold on
    plot(time{jj},torque{jj})        

    plot([marks(i) marks(i)]/Fs+datafull(1,1),[MM mm],'-.m')
    plot([FinalMarks(k) FinalMarks(k)]/Fs+datafull(1,1),[MM mm],'--k')
    shade=datafull(round(marks(i):marks(i)+pt1*Fs),1);
    bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

    plot([marks(i+1) marks(i+1)]/Fs+datafull(1,1),[MM mm],'-.m')
    plot([FinalMarks(k+1) FinalMarks(k+1)]/Fs+datafull(1,1),[MM mm],'--k')
    shade=datafull(round(marks(i+1):marks(i+1)+pt1*Fs),1);
    bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

    if ss==4
    plot([marks(i+2) marks(i+2)]/Fs+datafull(1,1),[MM mm],'-.m')
    plot([FinalMarks(k+2) FinalMarks(k+2)]/Fs+datafull(1,1),[MM mm],'--k')
    shade=datafull(round(marks(i+2):marks(i+2)+pt1*Fs),1);
    bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)

    plot([marks(i+3) marks(i+3)]/Fs+datafull(1,1),[MM mm],'-.m')
    plot([FinalMarks(k+3) FinalMarks(k+3)]/Fs+datafull(1,1),[MM mm],'--k')
    shade=datafull(round(marks(i+3):marks(i+3)+pt1*Fs),1);
    bar(shade,ones(length(shade),1)*max(torque{jj}),1,'k'),alpha(0.1)
    end

    title(strcat('Electrical stimulus in Torque. Trial: ',num2str(jj)))
    xlabel('Time [s]')
    ylabel('Torque [Nm]')
    legend({'Torque','Estimulus','Peaks'})
        
    baselineSIT % script
elseif strcmp(button3,'Cancel')
    flagcancel2=1;
    set(handles.Info2,'String','Current task: Cancelled')
    break
end

end
end
% 
%     
% else
%     FinalMarks(k)=peak{1};
%     FinalMarks(k+1)=peak2;    


% SuperTwich = datafull(FinalMarks(k),indTorque);
% PotTwich = datafull(FinalMarks(k+1),indTorque);

   

% figure, hold on
% plot(dif,'r')
% plot(indRF)
% plot(indFF,'k')
% 
% figure, hold on
% plot(dif,'r')
% plot(indp)
% plot(indn,'k')
%% Calculations
% Initialization
P100=NaN; P10=NaN; r=NaN; RTD=NaN; HRT=NaN; tcontr=NaN; RTD30=NaN; RTD50=NaN; RTD100=NaN; RTD200=NaN; PTvol=NaN; Tpeak2=NaN; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flagcancel2~=1 % to avoid an error when cancel is selected

tcontr=(FinalMarks(k+ss-1)-tbase1)/Fs; % time of contraction
Tpeak2=datafull(FinalMarks(k+ss-1),indTorque); % Peak of torque potentiated doublet
RTD=Tpeak2/(tcontr); % Rate of development torque
if FinalMarks(k+ss-1)+1*Fs < SizeData
    temp=datafull(FinalMarks(k+ss-1):FinalMarks(k+ss-1)+1*Fs,indTorque); % One second from the peak
else
    temp=datafull(FinalMarks(k+ss-1):end,indTorque); % One second from the peak
end
HRT=find(temp>Tpeak2/2)/Fs;
HRT=HRT(end); % Half relaxation time
% HRT=(tbase2-FinalMarks(k+ss-1))/Fs/2; % Half relaxation time

%% Peaks Potentiated Twich
% 4 stimuli profile
if ss==4
    P10=max(torque3);
    P100=max(torque2);
    r=P10/P100;
end
%% RTD potentiated twitch
[a,b]=find(torque{jj}>7);
a=a(1);
tonset=time{jj}(a,1);
RTD30=(torque{jj}(a+0.03*Fs)-7)/0.03; % 30 ms 
RTD50=(torque{jj}(a+0.05*Fs)-7)/0.05; % 50 ms
RTD100=(torque{jj}(a+0.1*Fs)-7)/0.1; % 100 ms
RTD200=(torque{jj}(a+0.2*Fs)-7)/0.2; % 200 ms

indPTvol=marks(i)-time{jj}(1)*Fs;
PTvol=max(torque{jj}(1:indPTvol));

% Panel info 1
set(handles.t1,'String',['Time of Contraction: ',num2str(tcontr*1000),' [ms]'])
set(handles.t2,'String',['Peak of Torque: ',num2str(Tpeak2),' [Nm]'])
set(handles.t3,'String',['RTD: ',num2str(RTD),' [Nm/s]'])
set(handles.t4,'String',['HRT: ',num2str(HRT*1000),' [ms]'])
set(handles.t5,'String',['VAL: ',num2str(VAL),' [%]'])
set(handles.t6,'String',['Pico Torque Vol: ',num2str(PTvol),'[Nm]'])
set(handles.t7,'String',['Delay Est/Peak [ms]: ',num2str(delayEst),'[Nm]'])


ResTInformation{1}='VAL';
ResTInformation{2}='AL';
ResTInformation{3}='P100';
ResTInformation{4}='P10';
ResTInformation{5}='r=P10/P100';
ResTInformation{6}='Torque PotTwich'; 
ResTInformation{7}='RTD';
ResTInformation{8}='HRT';
ResTInformation{9}='Time of contraction'; 
ResTInformation{10}='Torque SuperTwich'; %Informação
ResTInformation{11}='Torque baseline'; %Informação
ResTInformation{12}='Torque max. (Pre/Pos)'; %Informação
ResTInformation{13}='RTD30-Voluntary';
ResTInformation{14}='RTD50-Voluntary';
ResTInformation{15}='RTD100-Voluntary';
ResTInformation{16}='RTD200-Voluntary';
ResTInformation{17}='Torque of Voluntary peak ';
ResTInformation{18}='Torque of peak 2';
ResTInformation{19}='Delay Estimulus/SuperTwich [ms]'; % Can be have more than one value

try
    ResT(jj,:)=[VAL AL P100 P10 r PotTwich RTD HRT tcontr SuperTwich Tb Tmax RTD30 RTD50 RTD100 RTD200 PTvol Tpeak2 delayEst tbase1 tbase2];
catch ME
   disp('Error in Torque when concatenate the results') 
   rethrow(ME)
end

% set(handles.RTDt,'String',num2str(T3))
% set(handles.HRTt,'String',num2str(T4*1000))
% set(handles.VALt,'String',num2str(T5))
    
disp(strcat('Electrical stimulus in Torque. Trial: ',num2str(jj)))
disp(['50% Time of relaxation:',num2str(tcontr*.5*1000),' [ms]'])
disp(['Peak of Torque:',num2str(Tpeak2),' [Nm]'])
disp(['RTD [Nm/s]:',num2str(RTD)])
disp(['HRT [ms]:',num2str(HRT*1000)])
disp(['VAL [%]:',num2str(VAL)])
disp('_________________________________________________')
% set(handles.A_AnalysisMenu,'Enable','off')
% str=('Press any key to continue!');
% set(handles.textaxes5,'Visible','on','String',str) 
% pause
set(handles.textaxes5,'Visible','off') 
% set(handles.A_AnalysisMenu,'Enable','on')

% t(1)+4567/2000
% t(1)+5104/2000
% t(1)+4717/2000
% t(1)+12550/2000
%     
if ss==2
    k=k+2;
else
    k=k+4;
end
jj=jj+1;

else
    flagcancel=1;
    break
end
end % trial stimulus

if flagcancel==0
    if exist('ResT','var')
ResT=[ResT; mean(ResT,1)];
disp('_________________________________________________')
disp(strcat('Mean values'))
disp(['50% Time of relaxation av.:',num2str(ResT(end,2)),' [ms]'])
disp(['Peak of Torque av.:',num2str(ResT(end,3)),' [Nm]'])
disp(['RTD av.[Nm/s]:',num2str(ResT(end,4))])
disp(['HRT av.[ms]:',num2str(ResT(end,5))])
disp(['VAL av.[%]:',num2str(ResT(end,1))])
disp('_________________________________________________')

set(handles.t1,'String',['50% Time of relaxation av.:',num2str(ResT(end,2)),' [ms]'])
set(handles.t2,'String',['Peak of Torque av.:',num2str(ResT(end,3)),' [Nm]'])
set(handles.t3,'String',['RTD av.[Nm/s]:',num2str(ResT(end,4))])
set(handles.t4,'String',['HRT av.[ms]:',num2str(ResT(end,5))])
set(handles.t5,'String',['VAL av.[%]:',num2str(ResT(end,1))])

DatafileCT=strcat(Datafile(1:end-9),'Results_torque');

params.sec1=sec1;
params.sec2=sec2;
params.pt1=pt1;
params.pt2=pt2;
params.tplateau=tplateau; 
params.tplateauShift=tplateauShift;

try
save(DatafileCT,'torque','time','FinalMarks','ResT','params','ResTInformation')
disp(['You Selected:', DatafileCT])
set(handles.Info2,'String','The file was successfully saved!')

% catch ME
%    disp()
%    warndlg(ME.identifier,'Warning')
% 
%    save(DatafileCT,'torque','time','FinalMarks','Res')
%    disp(['You Selected:', DatafileCT])
%    set(handles.Info2,'String','The file was successfully saved!')
% 
%    try
%    save(Datafile,'datafull','DataInformation','Fs')
   catch ME       
       errordlg('Error saving the file','Error!')
       rethrow(ME)
   end    
% end

    else
        errordlg('The file can not be saved. Results are empty','Error!')
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    errordlg('The peaks data was not found','Error')
end

set(handles.A_peaks,'Enable','on')
set(handles.A_AnalysisMenu,'Enable','on')
set(handles.A_AnalysisMenu,'Value',1)

