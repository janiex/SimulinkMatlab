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
% The new frequency in column 12
FinalFile(:,12)=freq1;

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
    % Col 12 is the calculated by ISO2631 filter RMS
    %*************************************************
    FinalFile(i,12) = sqrt(mean(temp.^2)); %Implementation of the RMS function
    % And now make the manual calculation on the given frequncy
    %*************************************************
    % Col 13 is static calculated by table in ISO2631
    %*************************************************
    FinalFile(i,13) = ((Amp*Wc(i))/sqrt(2))/1000;
    %*************************************************
    % Col 14 is the calculated error for Wc (C3-C2)/C3
    %*************************************************
    if FinalFile(i,13) == 0
        FinalFile(i,14) = 0;
    else
        FinalFile(i,14) = (abs(FinalFile(i,3)-FinalFile(i,12)))/FinalFile(i,13);    
        FinalFile(i,14) = FinalFile(i,13) * 100;
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
    % Col 15 is the calculated by ISO2631 filter RMS
    %*************************************************
    FinalFile(i,15) = sqrt(mean(temp.^2)); %Implementation of the RMS function
    % And now make the manual calculation on the given frequncy
    %*************************************************
    % Col 16 is static calculated by table in ISO2631
    %*************************************************
    FinalFile(i,16) = ((Amp*We(i))/sqrt(2))/1000;
    %*************************************************
    % Col 17 is the calculated error for We (C3-C2)/C3
    %*************************************************
    if FinalFile(i,16) == 0
        FinalFile(i,17) = 0;
    else
        FinalFile(i,17) = (abs(FinalFile(i,16)-FinalFile(i,16)))/FinalFile(i,16);    
        FinalFile(i,17) = FinalFile(i,17) * 100;
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
    % Col 18 is the calculated by ISO2631 filter RMS
    %*************************************************
    FinalFile(i,18) = sqrt(mean(temp.^2)); %Implementation of the RMS function
    % And now make the manual calculation on the given frequncy
    %*************************************************
    % Col 19 is static calculated by table in ISO2631
    %*************************************************
    FinalFile(i,19) = ((Amp*Wj(i))/sqrt(2))/1000;
    %*************************************************
    % Col 18 is the calculated error for Wj (C3-C2)/C3
    %*************************************************
    if FinalFile(i,19) == 0
        FinalFile(i,20) = 0;
    else
        FinalFile(i,20) = (abs(FinalFile(i,19)-FinalFile(i,18)))/FinalFile(i,19);    
        FinalFile(i,20) = FinalFile(i,20) * 100;
    end;
end;
Column_names_str = {'Freq [Hz]','Wk-Processed','Wk-Analitical','Wk-Error','Wd-Processed','Wd-Analitical','Wd-Error','Wf-Processed','Wf-Analitical','Wf-Error','Freq [Hz]','Wc-Processed','Wc-Analitical','Wc-Error','We-Processed','We-Analitical','We-Error','Wj-Processed','Wj-Analitical','Wj-Error'};
%output_matrix = [Column_names_str; FinalFile];
xlswrite('TestReport.xlsx',Column_names_str,'A1:T1'); 
xlswrite('TestReport.xlsx',FinalFile,'A2:T45'); 
%xlswrite('TestReport.xlsx',output_matrix);

