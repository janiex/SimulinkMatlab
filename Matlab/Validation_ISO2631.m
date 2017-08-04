clear all
clc
Wk_input = 2;
Wd_input = 3;
Wf_input = 4;

Wc_input = 8;
We_input = 9;
Wj_input = 10;

f1_index = 1;

Wk_Index = f1_index + 1;
Wd_Index = Wk_Index + 3;
Wf_Index = Wd_Index + 3;
f2_index = Wf_Index + 3;
Wc_Index = f2_index + 1;
We_Index = Wc_Index + 3;
Wj_Index = We_Index + 3;
Coefficients = zeros(8,1);
% This is the indexes of the report written, at later phase.
Coefficients={Wk_Index, Wd_Index, Wf_Index,Wc_Index,We_Index,Wj_Index};
InputFilters = {Wk_input, Wd_input, Wf_input, Wc_input, We_input, Wj_input};
Amp = 1; % Amplitude of the test signal
xlsdata = xlsread('ISO2631_simplified.xlsx',1);
%[num, txt, raw] = xlsread('ISO2631.xlsx',1);

FinalFile = zeros(28,20);
% number of iterations
it = length(InputFilters);
%*************************************************
% Respective frequencies are written
%*************************************************

FinalFile(:,f1_index)=xlsdata(:,1);
FinalFile(:,f2_index)=xlsdata(:,7);
for count=1:it 
    if count > 3        
        %7 is the index of freq 2 in the input file
        frequency = xlsdata(:,7); 
        
    else
        %1 is the index of freq 1 in the input file
        frequency = xlsdata(:,1);
    end;
    %remove trailing NaN in the array
    frequency(isnan(frequency(:,1)),:) = [];
    % Take the appropriate lentght of the block
    len = length(frequency);
    table_filter_index = cell2mat(InputFilters(count));
    W_Filter = xlsdata(:,table_filter_index); 
    position = cell2mat(Coefficients(1,count));
    for i=1:len
        f = frequency(i);             % Signal frequency
        T = 1/f;                      % Window period on which the RMS will be applied0
        Fs = f*100;                   % Sampling frequency
        t = 0:1/Fs:200*T;             % Form the time window
        sig = Amp*sin(2*pi*f*t);      % Form the signal
        temp = ISO2631(sig,count,Fs);     % Filter the signal with iso2631 filter
     
        %*************************************************
        % First write calculated by ISO2631 filter RMS
        %*************************************************
        FinalFile(i,position) = sqrt(mean(temp.^2)); %Implementation of the RMS function
        % And now make the manual calculation on the given frequncy
        %*************************************************
        % now calculated by table in ISO2631
        %*************************************************
        FinalFile(i,(position+1)) = ((Amp*W_Filter(i))/sqrt(2))/1000;
        %*************************************************
        if FinalFile(i,(position+1)) == 0
            FinalFile(i,(position+2)) = 0;
        else
            FinalFile(i,(position+2)) = (abs(FinalFile(i,(position+1))-FinalFile(i,(position))))/FinalFile(i,(position+1));    
            FinalFile(i,(position+2)) = FinalFile(i,(position+2)) * 100;
        end;
    end;  
end;
Column_names_str = {'Freq [Hz]','Wk-Processed','Wk-Analitical','Wk-Error','Wd-Processed','Wd-Analitical','Wd-Error','Wf-Processed','Wf-Analitical','Wf-Error','Freq [Hz]','Wc-Processed','Wc-Analitical','Wc-Error','We-Processed','We-Analitical','We-Error','Wj-Processed','Wj-Analitical','Wj-Error'};
    %output_matrix = [Column_names_str; FinalFile];
    xlswrite('NewTestReport.xlsx',Column_names_str,'A1:T1'); 
    xlswrite('NewTestReport.xlsx',FinalFile,'A2:T45');
    Frequn = FinalFile(1:28,1);
    Frequn1 = FinalFile(1:22,11);
    Wk_Error = FinalFile(1:28,4);
    Wd_Error = FinalFile(1:28,7);
    Wf_Error = FinalFile(1:28,10);
    Wc_Error = FinalFile(1:22,14);
    We_Error = FinalFile(1:22,17);
    Wj_Error = FinalFile(1:22,20);
    
    figure
    %----------------------------------------
    %         +++ Wk Error +++
    %----------------------------------------
    % subplot(2,3,1)
    figure % opens new figure window
    plot(Frequn,Wk_Error)
    title('Error of Wk(Frequency)')
    xlabel('Frequency [Hz]') % x-axis label
    ylabel('Wk Error[%]') % y-axis label
    %----------------------------------------
    %         +++ Wd Error +++
    %----------------------------------------
    % subplot(2,3,2)
    figure % opens new figure window
    plot(Frequn,Wd_Error)
    title('Error of Wd(Frequency)')
    xlabel('Frequency [Hz]') % x-axis label
    ylabel('Wd Error[%]') % y-axis label
    %----------------------------------------
    %         +++ Wf Error +++
    %----------------------------------------
    % subplot(2,3,3)
    figure % opens new figure window
    plot(Frequn,Wf_Error)
    title('Error of Wf(Frequency)')
    xlabel('Frequency [Hz]') % x-axis label
    ylabel('Wf Error[%]') % y-axis label
    %----------------------------------------
    %         +++ Wc Error +++
    %----------------------------------------
    % subplot(2,3,4)
    figure % opens new figure window
    plot(Frequn1,Wc_Error)
    title('Error of Wc(Frequency)')
    xlabel('Frequency [Hz]') % x-axis label
    ylabel('Wc Error[%]') % y-axis label
    %----------------------------------------
    %         +++ We Error +++
    %----------------------------------------
    % subplot(2,3,5)
    figure % opens new figure window
    plot(Frequn1,We_Error)
    title('Error of We(Frequency)')
    xlabel('Frequency [Hz]') % x-axis label
    ylabel('We Error[%]') % y-axis label

    %----------------------------------------
    %         +++ Wj Error +++
    %----------------------------------------
    % subplot(2,3,6)
    figure % opens new figure window
    plot(Frequn1,Wj_Error)
    title('Error of Wj(Frequency)')
    xlabel('Frequency [Hz]') % x-axis label
    ylabel('Wj Error[%]') % y-axis label
