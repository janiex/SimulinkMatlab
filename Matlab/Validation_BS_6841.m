clear all;
clc
print_multiple = 2;
% plot based on one of the two frequences
single_plot = 1;
Wb_input = 2;
Wc_input = 4;
Wd_input = 6;
We_input = 8;

f1_index = 1;

Wb_Index = f1_index + 1;
Wc_Index = Wb_Index + 4;
Wd_Index = Wc_Index + 4;
We_Index = Wd_Index + 4;
Coefficients = zeros(4,1);
% This are the indexes of the report written, at later phase.
Coefficients={Wb_Index, Wc_Index, Wd_Index,We_Index};
% This are the indexes of the input file of weightening coefficients.
InputFilters = {Wb_input, Wc_input, Wd_input, We_input};
% *************************************************************************
% Amplitude of the test signal
% *************************************************************************
Amp = 0.5; 
% *************************************************************************
xlsdata = xlsread('BS6841_MinMax',1);
FinalFile = zeros(30,13);
% number of iterations
it = length(InputFilters);
%*************************************************
% Respective frequencies are written
%*************************************************

FinalFile(:,f1_index)=xlsdata(:,1);

for count=1:it 
    frequency = xlsdata(:,1);
    %remove trailing NaN in the array
    frequency(isnan(frequency(:,1)),:) = [];
    % Take the appropriate lentght of the block
    len = length(frequency);
    %len = len/2;
    table_filter_index = cell2mat(InputFilters(count));
    W_Filter1 = xlsdata(:,table_filter_index); 
    W_Filter2 = xlsdata(:,table_filter_index+1); 
    position = cell2mat(Coefficients(1,count));    
    for i=1:len
        f = frequency(i);             % Signal frequency
        T = 1/f;                      % Window period on which the RMS will be applied0
        Fs = f*100;                   % Sampling frequency
        t = 0:1/Fs:200*T;             % Form the time window
        sig = Amp*sin(2*pi*f*t);      % Form the signal
        temp = bs6841(sig,count,Fs);  % Filter the signal with bs6841 filter
        
        %*************************************************
        % First write calculated by ISO2631 filter RMS
        %*************************************************
        CalculatedValue = sqrt(mean(temp.^2)); %Implementation of the RMS function
        %FinalFile(i+1,position) = FinalFile(i,position);
   
        % And now make the manual calculation on the given frequncy
        %*************************************************
        % now calculated by table in BS6841
        %*************************************************
        tempValue1 = ((Amp*W_Filter1(i))/sqrt(2));                        
        tempValue2  = ((Amp*W_Filter2(i))/sqrt(2));       
        if tempValue1 >= tempValue2
            if((tempValue2 < CalculatedValue) && (tempValue1 >= CalculatedValue)) || ((tempValue2 <= CalculatedValue) && (tempValue1 > CalculatedValue))
                % calculated fits to the range of the table
                FinalFile(i,position+3) = 0;
            else
                % calculated DOES NOT fit to the range of the table
                FinalFile(i,position+3) = ((tempValue2+tempValue1)/2);
                if FinalFile(i,position+3) == 0
                    FinalFile(i,position+3) = 0;
                else
                    FinalFile(i,position+3) = ((abs(FinalFile(i,position+3) - CalculatedValue))*100)/FinalFile(i,position+3);
                end;
            end;
        else
            if((tempValue1 < CalculatedValue) && (tempValue2 >= CalculatedValue)) || ((tempValue1 <= CalculatedValue) && (tempValue2 > CalculatedValue))
                % calculated fits to the range of the table
                FinalFile(i,position+3) = 0;
            else
                % calculated DOES NOT fit to the range of the table
                FinalFile(i,position+3) = ((tempValue2+tempValue1)/2);
                if FinalFile(i,position+3) == 0
                    FinalFile(i,position+3) = 0;
                else
                    FinalFile(i,position+3) = ((abs(FinalFile(i,position+3) - CalculatedValue))*100)/FinalFile(i,position+3);
                end;
            end;
        end;
          %write the calculated value by the filter
          FinalFile(i,position) = CalculatedValue;
          %write the first table value
          FinalFile(i,position+1) = tempValue1;
          %write the second table value
          FinalFile(i,position+2) = tempValue2;
        

    end;  
end;
Column_names_str = {'Freq [Hz]','Wb-Processed','Wb-Analitical 1','Wb-Analitical 2','Wb-Error','Wc-Processed','Wc-Analitical 1','Wc-Analitical 2','Wc-Error','Wd-Processed','Wd-Analitical 1','Wd-Analitical 2','Wd-Error','We-Processed','We-Analitical 1','We-Analitical 2','We-Error'};
    %output_matrix = [Column_names_str; FinalFile];
    xlswrite('TestReport_BS_6841.xlsx',Column_names_str,'A1:Q1'); 
    xlswrite('TestReport_BS_6841.xlsx',FinalFile,'A2:Q31');
