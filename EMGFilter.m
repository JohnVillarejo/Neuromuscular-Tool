function dataf=EMGFilter(data,Fs,flag)
%     'D:\Work1\EMG Analysis\Fadiga\Interfaz V2\Dados John\EMG Delsys Pós\Alta densidade\Sujeitos\RMS\EJD_Lorena_Plot_and_Store_Rep_1.38._filtered_RMS_MVC.mat'

Nchannel=size(data,2);

try 
clear dataf 
for ch=1:Nchannel
% %     espectro(data(:,ch),Fs,1);
    n=2;
    cut=25;
    [z,p,k] = butter(n,cut/(Fs/2),'high');
    [b,a] = zp2tf(z,p,k);
    dataf(:,ch) = filtfilt(b,a,data(:,ch));
%     espectro(dataf(:,ch),Fs,1);

    n=10;
    cut=300;
    [z,p,k] = butter(n,cut/(Fs/2));
    [b,a] = zp2tf(z,p,k);
    dataf(:,ch) = filtfilt(b,a,dataf(:,ch));
%     espectro(dataf(:,ch),Fs,flag);

    n=1;
    cut=[59 61];
    [z,p,k] = butter(n,cut/(Fs/2),'stop');
    [b,a] = zp2tf(z,p,k);
    dataf(:,ch) = filtfilt(b,a,dataf(:,ch));
    espectro(dataf(:,ch),Fs,flag);
end


    
for ch=1:Nchannel
    dataf(:,ch)=dataf(:,ch)-mean(dataf(:,ch));
end

clear data
 

catch
    disp(['Error in filtering. Subject '])%,num2str(sub),', Rep: ',TT])
end
