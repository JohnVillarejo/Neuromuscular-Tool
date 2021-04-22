% function baseline()

% Initialization
VAL=NaN; SuperTwich=NaN; PotTwich=NaN; Tb=NaN; Tmax=NaN; AL=NaN; delayEst=NaN;
tbase1=NaN; tbase2=NaN; 

%% Baseline for Superimposed twich
try
% tplateau: time of analysis for the peak in the superimpossed twich, from
% 200 to 50 ms before the peak
tplateau=200; 
tplateauShift=50;
Tb=mean(datafull(round(FinalMarks(k))-tplateau:round(FinalMarks(k))-tplateauShift,indTorque)); % baseline
hold on, % Segment to analyze the base of the peak
plot([round(FinalMarks(k))-tplateau round(FinalMarks(k))-tplateauShift]/Fs+datafull(1,1), [Tb Tb],'r')
plot([round(FinalMarks(k))-tplateau round(FinalMarks(k))-tplateau]/Fs+datafull(1,1), [Tb+1 Tb-1],'r')
plot([round(FinalMarks(k))-tplateauShift round(FinalMarks(k))-tplateauShift]/Fs+datafull(1,1), [Tb+1 Tb-1],'r')

SuperTwich = datafull(round(FinalMarks(k)),indTorque)-Tb;
PotTwich = datafull(round(FinalMarks(k+ss-1)),indTorque);

% % To select the baseline by the minimum value instead the mean value
% if SuperTwich<0
%     [Tb,b]=min(datafull(round(FinalMarks(k))-tplateau:round(FinalMarks(k))-tplateauShift,indTorque)); % baseline
%     if ~isempty(Tb)
%         Tb=Tb(end);
%     end
%     SuperTwich = datafull(round(FinalMarks(k)),indTorque)-Tb;
%     tTb=datafull(round(FinalMarks(k))-tplateau)+b/Fs;
%     plot([tTb-tplateauShift/Fs tTb+tplateauShift/Fs], [Tb Tb],'--k')
% end

sigPre=datafull(round(FinalMarks(k)-sec1*Fs):round(FinalMarks(k)),indTorque); % To calculate the maximum previus estimulus
sigPos=datafull(round(FinalMarks(k)+pt1*Fs):round(FinalMarks(k+1)),indTorque); % To calculate the maximum after estimulus

Tmax=max([sigPre; sigPos]);

if ss==2
    delayEst = (FinalMarks(k:k+1)-marks(i:i+1))/Fs;
elseif ss==4
    delayEst = (FinalMarks(k:k+3)-marks(i:i+3))/Fs;
end

for deli=1:ss
    if delayEst(deli)>0.3
        waitfor(warndlg('The peak of torque selected is too late from the electrical stimuli!','Warning!'))
    elseif delayEst(deli)<0.08
        waitfor(warndlg('The peak of torque selected is very early to the expected value!','Warning!'))
    end
end
        
if SuperTwich>0
    VAL = (1 - SuperTwich/PotTwich)*100;
    AL = 100 - SuperTwich*(Tb/Tmax)/PotTwich*100;
else
   err_dlg = errordlg('The baseline is higher than the peak. VAL can not be calculated','Error');
   movegui(err_dlg,'west')
   waitfor(err_dlg);  % code execution is stopped till err_dlg is dismissed.
end
% disp(['Voluntary activacion [%]:',num2str(VAL)])
catch ME
    errordlg('Error in the superimposed twich calculations!','Warning!')
%     rethrow(ME)
    disp(['Error: ',ME.message])
end

%% Baseline for Potentiated twich
try
% Extract 1 second before and 1 second after the second electrical estimulation
shadePT=0.5*Fs; % 500ms for the shade

if FinalMarks(k+ss-1)+shadePT < SizeData
    torquePT=datafull(FinalMarks(k+ss-1)-shadePT:FinalMarks(k+ss-1)+shadePT,indTorque); % Torque potentiated twich
else
    torquePT=datafull(FinalMarks(k+ss-1)-shadePT:end,indTorque); % Torque potentiated twich
end
[zeroel,samp,v]=find(torquePT==0);
flagOK=0;

%% Option 1
% if ~isempty(zeroel)
%     dif1=zeroel(2:end)-zeroel(1:end-1);
%     ind=find(dif1==max(dif1));
%     if zeroel(ind(1))>1 && zeroel(ind(1))<shadePT
%         if zeroel(ind(1)+1)>shadePT && zeroel(ind(1)+1)<2*shadePT
%             tbase1=FinalMarks(k+ss-1)-shadePT+zeroel(ind(1));
%             tbase2=FinalMarks(k+ss-1)-shadePT+zeroel(ind(1)+1);
%             flagOK=1;
%         end
%     end
% end

%% Option 2
if flagOK==0

dif=torquePT(2:end)-torquePT(1:end-1); % Difference to identify big changes
clear difP difN
difP=zeros(length(dif),1);
difN=zeros(length(dif),1);
% dif=abs(dif);
difP(find(dif>0))=dif(find(dif>0)); % Possitive samples of dif vector
difN(find(dif<0))=dif(find(dif<0)); % Negative samples of dif vector

indp=difP>(max(difP)-min(difP))*0.04; % indices highers than a threshold, 4%
indRF=indp(2:end)-indp(1:end-1);     % Extraction of rising flank
indpRF=find(indRF>0);                % 

indn=abs(difN)>abs(max(difN)-min(difN))*0.04; % indices lowers than a threshold, 4%
indFF=indn(2:end)-indn(1:end-1);       % Extraction of falling flank
indpFF=find(indFF<0);

if indpRF(1)<indpFF(1) % indpRF<indpFF this was updated to work in some cases
    tbase1=FinalMarks(k+ss-1)-shadePT+indpRF(1);
    tbase2=FinalMarks(k+ss-1)-shadePT+indpFF(end);
    flagOK=1;
    
%     t1=300;
%     d=datafull(tbase1-(t1-1):tbase1,indTorque)-datafull(tbase1-t1:tbase1-1,indTorque);
%     linea1=find(d>max(d)*0.1);
    
    b1=datafull(marks(k+ss-1):FinalMarks(k+ss-1)+5,indTorque);
    Mb1=max(b1);
    mb1=min(b1);
    Db1=Mb1-mb1;

    linea1=find((b1-mb1)>Db1*0.05);
    if ~isempty(linea1)
        tbase1=linea1(1)+marks(k+ss-1);
    end
    
%     b2=datafull(FinalMarks(k+ss-1)-5:FinalMarks(k+ss-1)+500,indTorque);
%     Mb2=max(b2);
%     mb2=min(b2);
%     Db2=Mb2-mb2;
% 
%     linea2=find((b1-mb1)>Db1*0.05);
%     if ~isempty(linea1)
%         tbase2=linea2(1)+FinalMarks(k+ss-1)-5;
%     end
%     
% %     t2=500;
% %     d=datafull(tbase2:tbase2+t2-1,indTorque)-datafull(tbase2+1:tbase2+t2,indTorque);
% %     linea1=find(d>max(d)*0.1);
% %     
% %     if ~isempty(linea1)
% %         corte2=linea1(end);
% %         tbase2=tbase2+corte2;
% %     end

end

end


% %% Option 3
% b1=datafull(marks(k+ss-1):FinalMarks(k+ss-1)+5,indTorque);
% Mb1=max(b1);
% mb1=min(b1);
% Db1=Mb1-mb1;
% 
% [a,b]=find((b1-mb1)>Db1*0.05);
% 
% tbase1=a(1)+marks(k+ss-1);


%% Graphic

if flagOK==1
    plot([datafull(tbase1,1) FinalMarks(k+ss-1)/Fs]+datafull(1,1),[datafull(tbase1,indTorque) datafull(FinalMarks(k+ss-1),indTorque)],'-.k')
    plot([FinalMarks(k+ss-1)/Fs datafull(tbase2,1)]+datafull(1,1),[datafull(FinalMarks(k+ss-1),indTorque) datafull(tbase2,indTorque)],'-.k')
end

catch ME
    waitfor(warndlg({'Unable to calculate baseline of the potentiated twich estimulus!','Please, edit the baseline manually, following the option "Edit Baseline" in the Main Menu'},'Warning!'))
%     rethrow(ME)
    disp(['Error: ',ME.message])
    disp(ME.stack(1))
end

