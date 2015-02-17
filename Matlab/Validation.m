clear all
clc
Amp = 0.5; % Amplitude of the test signal
xlsdata = xlsread('ISO2631.xlsx',1);
%[num, txt, raw] = xlsread('ISO2631.xlsx',1);
freq = xlsdata(:,1);
FinalFile = zeros(length(freq),19);
%*************************************************
% Col 1 is the frequncy of the signal used as an input
%*************************************************
FinalFile(:,1)=freq;
%*************************************************
% Start the calculation for Wk
%*************************************************
Wk = xlsdata(:,2); 
len = length(Wk);
for i=1:len
    f = freq(i); % Signal frequency
    T = 1/f;                      % Window period on which the RMS will be applied0
    Fs = f*100;                   % Sampling frequency
    t = 0:1/Fs:200*T;             % Form the time window
    sig = Amp*sin(2*pi*f*t);      % Form the signal
    temp = iso2631(sig,1,Fs);     % Filter the signal with iso2631 filter
    %*************************************************
    % Col 2 is the calculated by ISO2631 filter RMS
    %*************************************************
    FinalFile(i,2) = sqrt(mean(temp.^2)); %Implementation of the RMS function
    % And now make the manual calculation on the given frequncy
    %*************************************************
    % Col 3 is static calculated by table in ISO2631
    %*************************************************
    FinalFile(i,3) = ((Amp*Wk(i))/sqrt(2))/1000;
    %*************************************************
    % Col 4 is the calculated error for Wk (C3-C2)/C3
    %*************************************************
    if FinalFile(i,3) == 0
        FinalFile(i,4) = 0;
    else
        FinalFile(i,4) = (abs(FinalFile(i,3)-FinalFile(i,2)))/FinalFile(i,3);    
        FinalFile(i,4) = FinalFile(i,4) * 100;
    end;
end;    
%*************************************************
% Start the calculation for Wd
%*************************************************
Wd = xlsdata(:,3); 
len = length(Wd);
for i=1:len
    f = freq(i); % Signal frequency
    T = 1/f;                      % Window period on which the RMS will be applied0
    Fs = f*100;                   % Sampling frequency
    t = 0:1/Fs:200*T;             % Form the time window
    sig = Amp*sin(2*pi*f*t);      % Form the signal
    temp = iso2631(sig,2,Fs);     % Filter the signal with iso2631 filter
    %*************************************************
    % Col 5 is the calculated by ISO2631 filter RMS
    %*************************************************
    FinalFile(i,5) = sqrt(mean(temp.^2)); %Implementation of the RMS function
    % And now make the manual calculation on the given frequncy
    %*************************************************
    % Col 6 is static calculated by table in ISO2631
    %*************************************************
    FinalFile(i,6) = ((Amp*Wd(i))/sqrt(2))/1000;
    %*************************************************
    % Col 7 is the calculated error for Wk (C3-C2)/C3
    %*************************************************
    if FinalFile(i,6) == 0
        FinalFile(i,7) = 0;
    else
        FinalFile(i,7) = (abs(FinalFile(i,6)-FinalFile(i,5)))/FinalFile(i,6);    
        FinalFile(i,7) = FinalFile(i,7) * 100;
    end;
    
end;  
%*************************************************
% Start the calculation for Wf
%*************************************************
Wf = xlsdata(:,4); 
len = length(Wf);
for i=1:len
    f = freq(i); % Signal frequency
    T = 1/f;                      % Window period on which the RMS will be applied0
    Fs = f*100;                   % Sampling frequency
    t = 0:1/Fs:200*T;             % Form the time window
    sig = Amp*sin(2*pi*f*t);      % Form the signal
    temp = iso2631(sig,3,Fs);     % Filter the signal with iso2631 filter
    %*************************************************
    % Col 8 is the calculated by ISO2631 filter RMS
    %*************************************************
    FinalFile(i,8) = sqrt(mean(temp.^2)); %Implementation of the RMS function
    % And now make the manual calculation on the given frequncy
    %*************************************************
    % Col 9 is static calculated by table in ISO2631
    %*************************************************
    FinalFile(i,9) = ((Amp*Wf(i))/sqrt(2))/1000;
    %*************************************************
    % Col 7 is the calculated error for Wk (C3-C2)/C3
    %*************************************************
    if FinalFile(i,8) == 0
        FinalFile(i,10) = 0;
    else
        FinalFile(i,10) = (abs(FinalFile(i,9)-FinalFile(i,8)))/FinalFile(i,9);    
        FinalFile(i,10) = FinalFile(i,10) * 100;
    end;          
      
end;
%*****************************************************************
% Read the new frequencies
%*****************************************************************
freq1 = xlsdata(:,7);
%*************************************************
% Start the calculation for Wc
%*************************************************
Wc = xlsdata(:,8); 
Wc(isnan(Wc(:,1)),:) = [];
len = length(Wc);
for i=1:len
    f = freq1(i); % Signal frequency
    T = 1/f;                      % Window period on which the RMS will be applied0
    Fs = f*100;                   % Sampling frequency
    t = 0:1/Fs:200*T;             % Form the time window
    sig = Amp*sin(2*pi*f*t);      % Form the signal
    temp = iso2631(sig,4,Fs);     % Filter the signal with iso2631 filter
    %*************************************************
    % Col 11 is the calculated by ISO2631 filter RMS
    %*************************************************
    FinalFile(i,11) = sqrt(mean(temp.^2)); %Implementation of the RMS function
    % And now make the manual calculation on the given frequncy
    %*************************************************
    % Col 12 is static calculated by table in ISO2631
    %*************************************************
    FinalFile(i,12) = ((Amp*Wc(i))/sqrt(2))/1000;
    %*************************************************
    % Col 13 is the calculated error for Wc (C3-C2)/C3
    %*************************************************
    if FinalFile(i,12) == 0
        FinalFile(i,13) = 0;
    else
        FinalFile(i,13) = (abs(FinalFile(i,12)-FinalFile(i,11)))/FinalFile(i,12);    
        FinalFile(i,13) = FinalFile(i,13) * 100;
    end;
end;
%*************************************************
% Start the calculation for We
%*************************************************
We = xlsdata(:,9); 
We(isnan(We(:,1)),:) = [];
len = length(We);
for i=1:len
    f = freq1(i); % Signal frequency
    T = 1/f;                      % Window period on which the RMS will be applied0
    Fs = f*100;                   % Sampling frequency
    t = 0:1/Fs:200*T;             % Form the time window
    sig = Amp*sin(2*pi*f*t);      % Form the signal
    temp = iso2631(sig,5,Fs);     % Filter the signal with iso2631 filter
    %*************************************************
    % Col 14 is the calculated by ISO2631 filter RMS
    %*************************************************
    FinalFile(i,14) = sqrt(mean(temp.^2)); %Implementation of the RMS function
    % And now make the manual calculation on the given frequncy
    %*************************************************
    % Col 15 is static calculated by table in ISO2631
    %*************************************************
    FinalFile(i,15) = ((Amp*We(i))/sqrt(2))/1000;
    %*************************************************
    % Col 16 is the calculated error for We (C3-C2)/C3
    %*************************************************
    if FinalFile(i,15) == 0
        FinalFile(i,16) = 0;
    else
        FinalFile(i,16) = (abs(FinalFile(i,15)-FinalFile(i,14)))/FinalFile(i,15);    
        FinalFile(i,16) = FinalFile(i,16) * 100;
    end;
end;
%*************************************************
% Start the calculation for Wj
%*************************************************
Wj = xlsdata(:,10); 
Wj(isnan(Wj(:,1)),:) = [];
len = length(Wj);
for i=1:len
    f = freq1(i); % Signal frequency
    T = 1/f;                      % Window period on which the RMS will be applied0
    Fs = f*100;                   % Sampling frequency
    t = 0:1/Fs:200*T;             % Form the time window
    sig = Amp*sin(2*pi*f*t);      % Form the signal
    temp = iso2631(sig,6,Fs);     % Filter the signal with iso2631 filter
    %*************************************************
    % Col 17 is the calculated by ISO2631 filter RMS
    %*************************************************
    FinalFile(i,17) = sqrt(mean(temp.^2)); %Implementation of the RMS function
    % And now make the manual calculation on the given frequncy
    %*************************************************
    % Col 18 is static calculated by table in ISO2631
    %*************************************************
    FinalFile(i,18) = ((Amp*Wj(i))/sqrt(2))/1000;
    %*************************************************
    % Col 18 is the calculated error for Wj (C3-C2)/C3
    %*************************************************
    if FinalFile(i,18) == 0
        FinalFile(i,19) = 0;
    else
        FinalFile(i,19) = (abs(FinalFile(i,18)-FinalFile(i,17)))/FinalFile(i,18);    
        FinalFile(i,19) = FinalFile(i,19) * 100;
    end;
end;

xlswrite('TestReport.xlsx',FinalFile); 

                    

