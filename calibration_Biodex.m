function T_cal=calibration_Biodex(datafull,Tbiodex)

c=1; % is the delay from the two capture between both equipments
figure
hold on 
plot(datafull(1:end,1)-datafull(1,1),datafull(1:end,2))
% plot(Tbiodex(:,1)/1000+c,Tbiodex(:,2),'r')
legend({'EMG System'}) % legend({'EMG System','Biodex'})
ylabel('Torque [Nm]')
xlabel('Time [s]')
% plot(datafull(1:end,2))
% plot(Tbiodex(:,2),'r')
zoom on
title('Zoom and press any key to continue')
pause()
title('Select the point to 0 [Nm] in EMG System')

[x,y]=ginput(1);
x=round(x*1000); % used it when select the point with time either samples
T_EMG=datafull(x:end,2);
tempo_emg=datafull(x:end,1);
torque=Tbiodex(:,2);
tempo_bio=Tbiodex(:,1)/1000;

b=y; % by inspection in the Torque from datafull (EMG System)
Me=max(T_EMG);
Mt=max(torque);
me=b;
% me=min(T_EMG);
mt=min(torque);

A2=(Mt-mt)/(Me-me);
B2=mt-me*A2;

T_cal = datafull(:,2)*A2+B2;
datafull(:,4)=T_cal;

figure
hold on 
plot(datafull(:,1)-datafull(1,1),T_cal)
plot(tempo_bio+x/1000,torque,'r')
legend({'EMG System','Biodex'})
ylabel('Torque [Nm]')
xlabel('Time [s]')

ind=find(T_cal<0); % all values below zero are equal to zero
T_cal(ind)=0;

ind=find(T_cal>10);
Tie=datafull(ind(1),1); % time starting the first plateau in EMG System

ind=find(torque>10);
Tib=tempo_bio(ind(1)); % time starting the first plateau in biodex

if Tie>Tib
    
figure
hold on 
plot(datafull(:,1)-datafull(1,1),T_cal)
plot(tempo_bio+Tie-datafull(1,1),torque,'r')

else
        
figure
hold on 
plot(datafull(:,1)-datafull(1,1)+Tib,T_cal)
plot(tempo_bio,torque,'r')

end
axis tight
legend({'EMG System','Biodex'})
ylabel('Torque [Nm]')
xlabel('Time [s]')
