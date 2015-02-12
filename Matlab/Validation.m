% f = 0.4;           % Frequency of the Signal
% Fs = f*100;        % 1kHz sample rate
% T = 1/f;
% t = 0:1/Fs:T;      % 1 second signal window
% Amp = 0.5;         % Amplitude of the test signal
% sig = Amp*sin(2*pi*f*t);
% plot(t,sig);
% temp = iso2631(sig',4,Fs);
% Result = sqrt(mean(temp.^2)); %Implementation of the RMS function
Amp = 0.5; % Amplitude of the test signal
xlsdata = xlsread('ISO2631.xlsx',1);
freq = xlsdata(:,1);
Wk = xlsdata(:,2); 
len = length(Wk);
FinalFile = zeros(len,3);
for i=1:len
    f = freq(i); % Signal frequency
    T = 1/f;                      % Window period on which the RMS will be applied0
    Fs = f*100;                    % Sampling frequency
    t = 0:1/Fs:200*T;                 % Form the time window
    sig = Amp*sin(2*pi*f*t);      % Form the signal
    temp = iso2631(sig,1,Fs);     % Filter the signal with iso2631 filter
    FinalFile((i+1),1) = sqrt(mean(temp.^2)); %Implementation of the RMS function
    % And now make the manual calculation on the given frequncy
    FinalFile((i+1),2) = ((Amp*Wk(i))/sqrt(2))/1000;
    if FinalFile((i+1),2) == 0
        FinalFile((i+1),3) = 0;
    else
        FinalFile((i+1),3) = (abs(FinalFile(i,2)-FinalFile(i,1)))/FinalFile(i,2);    
        FinalFile((i+1),3) = FinalFile(i,3) * 100;
    end;
    Result = xlswrite('TestReport',FinalFile); 
    [data,colNames] = xlsread('TestReport.xlsx');
    colNames = {'Manual Calculated','Processed by ISO2631','% Error'};
    output = [colNames;num2cell(data)];
    xlswrite('TestReport',output);  
end     

                    

