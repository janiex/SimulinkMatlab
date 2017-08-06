clear all;
clc
print_multiple = 2;
Wb_input = 2;
Wc_input = 3;
Wd_input = 4;

We_input = 5;
Wf_input = 6;
Wg_input = 7;

f1_index = 1;

Wb_Index = f1_index + 1;
Wc_Index = Wb_Index + 3;
Wd_Index = Wc_Index + 3;
We_Index = Wd_Index + 3;
Wf_Index = We_Index + 3;
Wg_Index = Wf_Index + 3;
Coefficients = zeros(6,1);
% This is the indexes of the report written, at later phase.
Coefficients={Wb_Index, Wc_Index, Wd_Index,We_Index,Wf_Index,Wg_Index};
InputFilters = {Wb_input, Wc_input, Wd_input, We_input, Wf_input,Wg_input};
Amp = 1; % Amplitude of the test signal
xlsdata = xlsread('BS6841_simplified',1);
FinalFile = zeros(60,19);
% number of iterations
it = length(InputFilters);
%*************************************************
% Respective frequencies are written
%*************************************************

FinalFile(:,f1_index)=xlsdata(:,1);
Calculated = zeros(18,6);
Tabled1 = zeros(18,6);
Tabled2 = zeros(18,6);

for count=1:it 
    frequency = xlsdata(:,1);
    %remove trailing NaN in the array
    frequency(isnan(frequency(:,1)),:) = [];
    % Take the appropriate lentght of the block
    len = length(frequency);
    %len = len/2;
    table_filter_index = cell2mat(InputFilters(count));
    W_Filter = xlsdata(:,table_filter_index); 
    position = cell2mat(Coefficients(1,count));
    table_counter = 1;
    for i=1:2:len
    
        f = frequency(i);             % Signal frequency
        T = 1/f;                      % Window period on which the RMS will be applied0
        Fs = f*100;                   % Sampling frequency
        t = 0:1/Fs:200*T;             % Form the time window
        sig = Amp*sin(2*pi*f*t);      % Form the signal
        temp = bs6841(sig,count,Fs);     % Filter the signal with iso2631 filter
        
        %*************************************************
        % First write calculated by ISO2631 filter RMS
        %*************************************************
        FinalFile(i,position) = sqrt(mean(temp.^2)); %Implementation of the RMS function
        FinalFile(i+1,position) = FinalFile(i,position);
        Calculated(table_counter,count) = FinalFile(i,position);
        % And now make the manual calculation on the given frequncy
        %*************************************************
        % now calculated by table in ISO2631
        %*************************************************
        FinalFile(i,(position+1)) = ((Amp*W_Filter(i))/sqrt(2));        
        Tabled1(table_counter,count) = FinalFile(i,(position+1));
        
        FinalFile(i+1,(position+1)) = ((Amp*W_Filter(i+1))/sqrt(2));        
        Tabled2(table_counter,count) = FinalFile(i+1,(position+1));
        table_counter = table_counter + 1;
        
        %*************************************************
        if FinalFile(i,(position+1)) == 0
            FinalFile(i,(position+2)) = 0;    
        else
            FinalFile(i,(position+2)) = (abs(FinalFile(i,position)-FinalFile(i,(position+1)))/FinalFile(i,(position+1)))
            FinalFile(i,(position+2)) = FinalFile(i,(position+2)) * 100; %100%
        end;
        if FinalFile(i+1,(position+1)) == 0
            FinalFile(i+1,(position+2)) = 0;
        else
            FinalFile(i+1,(position+2)) = (abs(FinalFile(i,position)- FinalFile(i+1,(position+1)))/FinalFile(i+1,(position+1)));
            FinalFile(i+1,(position+2)) = FinalFile(i+1,(position+2)) * 100;%100%
        end;
    end;  
end;
Column_names_str = {'Freq [Hz]','Wb-Processed','Wb-Analitical','Wb-Error','Wc-Processed','Wc-Analitical','Wc-Error','Wd-Processed','Wd-Analitical','Wd-Error','We-Processed','We-Analitical','We-Error','Wf-Processed','Wf-Analitical','Wf-Error','Wg-Processed','Wg-Analitical','Wg-Error'};
    %output_matrix = [Column_names_str; FinalFile];
    xlswrite('NewTestReport_BS_6841.xlsx',Column_names_str,'A1:T1'); 
    xlswrite('NewTestReport_BS_6841.xlsx',FinalFile,'A2:T45');
    Frequn = FinalFile(1:60,1);  
    Wb_Error = FinalFile(1:60,4);
    Wc_Error = FinalFile(1:60,7);
    Wd_Error = FinalFile(1:60,10);
    We_Error = FinalFile(1:60,13);
    Wf_Error = FinalFile(1:60,16);
    Wg_Error = FinalFile(1:60,19);
    %----------------------------------------
    %         +++ Wb Error +++
    %----------------------------------------

    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn,Wb_Error)
    title('Грешка за Wb(честота)')
    xlabel('Честота [Hz]') % x-axis label
    ylabel('Модул абсолютна грешка[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('Wb Таблична стойност от стандарта')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с Wb ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('Wb изчислена от филтера')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с Wb') % y-axis label
    end;
    %----------------------------------------
    %         +++ Wc Error +++
    %----------------------------------------

    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn,Wc_Error)
    title('Грешка за Wc(честота)')
    xlabel('Честота [Hz]') % x-axis label
    ylabel('Модул абсолютна грешка[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('Wc Таблична стойност от стандарта')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с Wc ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('Wc изчислена от филтера')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с Wc') % y-axis label
    end;
    %----------------------------------------
    %         +++ Wd Error +++
    %----------------------------------------

    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn,Wd_Error)
    title('Грешка за Wd(честота)')
    xlabel('Честота [Hz]') % x-axis label
    ylabel('Модул абсолютна грешка[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('Wd Таблична стойност от стандарта')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с Wd ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('Wd изчислена от филтера')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с Wd') % y-axis label
    end; 
    %----------------------------------------
    %         +++ We Error +++
    %----------------------------------------

    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn,We_Error)
    title('Грешка за We(честота)')
    xlabel('Честота [Hz]') % x-axis label
    ylabel('Модул абсолютна грешка[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('We Таблична стойност от стандарта')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с We ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('We изчислена от филтера')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с We') % y-axis label
    end; 
    %----------------------------------------
    %         +++ Wf Error +++
    %----------------------------------------

    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn,Wf_Error)
    title('Грешка за Wf(честота)')
    xlabel('Честота [Hz]') % x-axis label
    ylabel('Модул абсолютна грешка[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('Wf Таблична стойност от стандарта')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с Wf ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('Wf изчислена от филтера')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с Wf') % y-axis label
    end; 
   %----------------------------------------
    %         +++ We Error +++
    %----------------------------------------
    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn,We_Error)
    title('Грешка за We(честота)')
    xlabel('Честота [Hz]') % x-axis label
    ylabel('Модул абсолютна грешка[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('We Таблична стойност от стандарта')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с We ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('We изчислена от филтера')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с We') % y-axis label
    end;
    %----------------------------------------
    %         +++ Wg Error +++
    %----------------------------------------

    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn,Wg_Error)
    title('Грешка за Wg(честота)')
    xlabel('Честота [Hz]') % x-axis label
    ylabel('Модул абсолютна грешка[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('Wg Таблична стойност от стандарта')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с Wg ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('Wg изчислена от филтера')
        xlabel('Честота [Hz]') % x-axis label
        ylabel('Филтрирана с Wg') % y-axis label
    end; 
