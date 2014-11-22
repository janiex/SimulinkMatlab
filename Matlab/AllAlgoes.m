%------------------PROGRAM PURPOSE AND DEFINITION--------------------------
% The program RCS calculates ride comfort as per four different standards
% namely ISO2631 , BS6841 or THE BRITISH STANDARD, ENV12299 recommended
% by CEN and German standard known as sperling index.
%
% Tha data recorder gives bin files as output with some offset values. The
% offset values are repaired using a program given in appendix and outputs
% repaired bin files. These bin files are then converted to ascii files
% using PC-scan software.
% The input to the RCS program is an ascii file which contains acceleration
% data in 15 columns and n rows where n is a variable. The other input to
% the code is sample rate ie. the rate at which measured acceleration data
% has been sampled.
%
% The output to the program is both in graphical and tabular form. The
% output data is exported to text files and saved in a user defined
% directory while the graphical plots are also created whilst program's
% execution. The units of acceleration is always m/s^2 except for
% sperling index where it is cm/s^2. The units for power spectral density
% is power/Hz.
%
% The program incorporates proper exception handling and returns warning
% messages whereever applicable.
%
% The Flow structure of program's execution is as follows:
%
% Step 1 : The data is read from the ascii file into a double type N X 15
% matrix.
%
% Step 2 : A dialog box prompt asks for sampling rate from the user and
% returns the value fed into the data variable.
%
% Step 3: A graphical plot of all the acceleration channels is plotted
% wherein accleration(m/s^2) is plotted Vs time.Next the user is asked to
% choose the time domain over which the analysis is to be carried out.
% Step 4: The signal is trimmed over the time-domain choosen by the user.
%--------------------APPLICATION OF ISO 2631 STANDARD----------------------
% Step 6:Then frequency weightings are applied to the original signal as
% per ISO 2631 standard which is done by passing a single column vector
% at a time and the weighting type to ISO 2631 function.
%
% step7: The RMS value of each weighted column is obtained.The fourth power
% vibration dose values too are calculated.Then the crest factors are
% obtained for each column.
%
% step 8 : The root sum squares are obtained for the rms values at each
% location for all the three directions. Then an overall root sum square
% value is obtained for all the directions and all the points with
% appropriate multiplying factors.
% step 9: one second moving average is obtained for the weighted
% acceleration signal.
% step 10 : The original as well as weighted signals are tranformed from
% time domain to frequency domain and the results plotted.
%--------------------Application of British standard-----------------------
% step 11 : Step 6, 7 , 8 ,9 and 10 are repeated for BS 6841 standard. The
% frequency weightings are applied by calling the function bs6841.
%------------------Application of ENV12299 standard------------------------
% Step 9 :The signal for the entire time history is segmented into blocks
% of 5 seconds each.
% step 10: Each block is passed through weighting filters as defined in
% env12299. The rms value for each block is then calculated.
% step 11: The 95th and 50th percentile of the rms values calculated over
% the blocks is obtained and hence comfort factor is calculated for
% seating and standing positions.
%--------------Application of german standard or sperling index------------
% Step 12 : The sperling index comfort and quality factors are calculated
% by passing the acceleration signal to the function named sperling. It
% applies the frequency weighting and multiplies the frequency domain
% accleration data obtained from welch's method to the appropriate
% weighting factor and then calculates the index using linear discretized
%integration
%---------------------------Save the output--------------------------------
%Step 13: The various data variables are saved or exported to various text
%files with the name same as variable names.
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%------------------------DEFINITION OF VARIABLES---------------------------
% FS = Sample rate
% FileName = name of input file
% PathName = directory pathname of the input file
% signal = Measured acceleration data(n X 15)
%ISOFILTERED = weighted acceleration signal as per iso2631(n X 15)
%type = type of wieghting (1 X 15)
%k = multiplying factor(1 X 15)
%RMS = root mean square vector having rms of all 15 weighted
% columns( 1 X 15)
%VDV = fourth power vibration dose valu for weighted signal
% (1 X 15)
%SEATPAN_A = ROOT SUM SQUARE OF RMS VALUES IN X Y AND Z DIRECTION AT
% SEATPAN
%BACKREST_A = ROOT SUM SQUARE OF RMS VALUES IN X Y AND Z DIRECTION AT
% BACKREST
%LAPTOP_A = ROOT SUM SQUARE OF RMS VALUES IN X Y AND Z DIRECTION AT
% LAPTOP
%FLOOR_A = ROOT SUM SQUARE OF RMS VALUES IN X Y AND Z DIRECTION AT
% FLOOR
%TABLE_A = ROOT SUM SQUARE OF RMS VALUES IN X Y AND Z DIRECTION AT
% TABLE
%TOTAL_A = ROOT SUM SQUARE OF ALL THE RMS VALUES AT ALL DIRECTIONS
% AND ALL POINTS
%pxx = Frequency domain acceleration of the original signal
%pxx_iso = Frequency domain acceleration of the isofiltered signal
%MTVV = maximum value of the 1 second moving rms(1 X 15)
%ISO_RMS_MV = 1 second moving rms of the weighted acceleration(m X 15)
%BSFILTERED = weighted acceleration signal as per BS6841(n X 15)
%RMS_BS = RMS VECTOR FOR BSFILTERED DATA( 1 X 15)
%VDV_BS = FOURTH POWER VIBRATION DOSE VALUE FOR BSFILTERED DATA(1 X
%15)
%CRESTF = CREST FACTORS FOR ISOFILETERED DATA
%CRESTF_BS = CREST FACTORS FOR BS FILETERED DATA
%SEATPAN_A_BS = ROOT SUM SQUARE OF RMS_BS VALUES IN X Y AND Z DIRECTION AT
% SEATPAN
%BACKREST_A_BS = ROOT SUM SQUARE OF RMS_BS VALUES IN X Y AND Z DIRECTION
% AT BACKREST
%LAPTOP_A_BS = ROOT SUM SQUARE OF RMS VALUES IN X Y AND Z DIRECTION AT
% LAPTOP
%FLOOR_A_BS = ROOT SUM SQUARE OF RMS VALUES IN X Y AND Z DIRECTION AT
% FLOOR
%TABLE_A_BS = ROOT SUM SQUARE OF RMS VALUES IN X Y AND Z DIRECTION AT
% TABLE
%TOTAL_A_BS = ROOT SUM SQUARE OF ALL THE RMS VALUES AT ALL DIRECTIONS
% AND ALL POINTS
%pxx_bs = FREQUENCY DOMAIN ACCELERATION SIGNAL FOR BS FILTERED DATA
%F_BS = CORRESPONDING FREQUENCY VECTOR FOR PXX_BS
%signal_env= ORIGINAL ACCELERATION SIGNAL FOR ENV12299 EVALUATION(N X 6)
%env_filt = FILTERED ACCELERATION SIGANL AS PER ENV12299 STANDARD
%RMS_ENV = RMS VALUES OF THE 5 SECOND BLOCKS OF ENV FILTERED DATA
%azp95 = Z FLOOR 95TH PERCENTILE OF RMS DATA
%aya95 = Y SEAT 95TH PERCENTILE OF RMS DATA
%aza95 = Z SEAT 95TH PERCENTILE OF RMS DATA
%axd95 = X BACKREST 95TH PERCENTILE OF RMS DATA
%axp50 = X FLOOR 50TH PERCENTILE OF RMS DATA
%ayp50 = Y FLOOR 50TH PERCENTILE OF RMS DATA
%azp50 = Z FLOOR 50TH PERCENTILE OF RMS DATA
%ayp95 = Y FLOOR 95TH PERCENTILE OF RMS DATA
%WZ = sperling ride comfort index( 1 X 15)
%WR = sperling ride quality factor( 1 X 15)
% 1. Seat pan
% 2. Seat backrest
% 3. Laptop
% 4. Floor
% 5. Table
%-------------------------PROGRAM CODE STARTS------------------------------
%------------------------------READS FILES---------------------------------
clear all
clc
Dialog = 0;
NumberOfAxis = 3;
[FileName,PathName] = uigetfile('*.txt','Посочете файл със записи на ускоренията');
[fid,message1]=fopen([PathName FileName],'r');
disp(message1);
signal=fscanf(fid,'%f',[NumberOfAxis,inf]);
signal=signal';
warn1=fclose(fid);
if warn1 == -1
    disp('Файлът не може да бъде затворен коректно!!!');
    return;
elseif warn1 == 0
        disp('OK! Файлът е прочетен и затворен успешно');
end;
%---------------------------FILE READING DONE------------------------------
%----------------------INPUT SAMPLING RATE FROM USER-----------------------
if Dialog == 1
    prompt={'Въведете честотата на дискретизация в Hz'};
    FS = inputdlg(prompt);
    close all;
    FS = cell2mat(FS);
    FS = str2double(FS);
else
    FS = 100;
end;

%-----------------------------INPUT DONE----------------------------------
nos=length(signal);
time = nos/FS;
t = 0:1/FS:time;
t = t(1:end-1);
t=t';
if Dialog == 1
    button = questdlg('Искате ли да видите трептенията?');
    if strcmp(button,'Yes')
        h = figure(1);
        subplot(3,1,1);
        plot(t,signal(:,1));
        xlabel('Време в секунди');
        ylabel('Трептение в m/s^2');
        title('Трептение в направление Х');
        subplot(3,1,2);
        plot(t,signal(:,2));
        xlabel('Време в секунди');
        ylabel('Трептение в m/s^2');
        title('Трептение в направление Y');
        subplot(3,1,3);
        plot(t,signal(:,3));
        xlabel('Време в секунди');
        ylabel('Трептение в m/s^2');
        title('Трептение в направление Z');
        uiwait(h);

        clear t;
        prompt={'Въведете начално време за анализ'};
        st = inputdlg(prompt);
        close all;
        st = cell2mat(st);
        st = str2double(st);
        prompt={'Въведете крайно време за анализ'};
        et = inputdlg(prompt);
        close all;
        et = cell2mat(et);
        et = str2double(et);
        
    end
end
st = 0;
et = 500;
startno = st*FS+1;
endno = et*FS+1;
signal = signal( startno:endno , :);
str = {'ISO 2631','BS 6841','Sperling Index'};
[selection,v] = listdlg('PromptString','Изберете метод за анализ:',...
'SelectionMode','single',...
'ListString',str,'ListSize',[200 100]);

switch selection
case 1
    %--------------------------------------------------------------------------
    %-------------------------ISO 2631 STARTS----------------------------------
    %type = [2 2 1 2 2 4 1 1 1 1 1 1 1 1 1];
    type = [1 1 1]; % for the floor - 10,11,12
    nos=length(signal);
    time = (nos-1)/FS;
    h = waitbar(0,'Please wait...','name','APPLYING ISO WEIGHTING FILTERS');
    for ij=1:NumberOfAxis
        %SIGNAL IS FILTERED OVER HERE
        ISOFILTERED(:,ij) = iso2631(signal(:,ij),type(ij),FS);
        sum=0;sum2=0;
        for ijk=1:nos
            sum=sum+ISOFILTERED(ijk,ij)*ISOFILTERED(ijk,ij);
        end
        for ijk=1:nos
            sum2 = sum2+ISOFILTERED(ijk,ij)*ISOFILTERED(ijk,ij) ...
            *ISOFILTERED(ijk,ij)*ISOFILTERED(ijk,ij);
        end
        %CALULATION OF RMS AND VDV
        rms(ij) = sqrt(sum/nos);
        VDV(ij) = (sum2/FS).^(1/4);
        %CALCULATION OF CREST FACTOR
        [CRESTF(ij) pos(ij)] = max(abs(ISOFILTERED(:,ij))./rms(ij));
        waitbar(ij/NumberOfAxis)
    end
    close(h);
    % OUTPUT THE CACULATED RMS VALUES
    string ={'RMS VALUES FOR EACH DIRECTION AND LOCATIONS ARE ',' ',' ',...
    num2str(rms')};
    h = msgbox(string,'rms values for all 15 columns','none');
    uiwait(h);
    %-----------------------EVALUATION PERTAINING COMFORT----------------------
    %----------------------------FOR SEATED PERSONS----------------------------
    %k=[1 1 1 0.4 0.5 0.8 0.25 0.25 0.4 0.25 0.25 0.4 0.25 0.25 0.4];
    k=[0.25 0.25 0.4 ]; % for the floor - 10,11,12 elements
    RMS = rms.*k;
    FLOOR_A = norm(RMS(1:3));
%     BACKREST_A = norm(RMS(4:6));
%     LAPTOP_A = norm(RMS(7:9));
%     FLOOR_A = norm(RMS(10:12));
%     TABLE_A = norm(RMS(13:15));
    TOTAL_A = norm(RMS);
    string = {['FLOOR ROOT SUM SQUARE IS ' num2str(FLOOR_A)],' ',...
    ['TOTAL ROOT SUM SQUARE IS ' num2str(TOTAL_A)],' '};
    h= msgbox(string,'ROOT SUM SQUARE VALUES FOR ISO 2631','warn');
    uiwait(h);
    %--------------------CALCULATION OF MOVING AVERAGES------------------------
    ISO_RMS_MV = move_rms(ISOFILTERED,1,FS);
    for ij=1:NumberOfAxis
        MTVV(ij)=max(ISO_RMS_MV(:,ij));
    end
    MTVV_RATIO = MTVV./rms;
    VDV_RATIO = VDV./(rms*(time^0.25));
    FLOOR_A_MV=sqrt((k(1)*ISO_RMS_MV(:,1)).^2+(k(2)*ISO_RMS_MV(:,2)).^2 ...
    + (k(3)*ISO_RMS_MV(:,3)).^2);
    
    TOTAL_A_MV=sqrt(FLOOR_A_MV.^2);
    %--------------------------------------------------------------------------
    h = waitbar(0,'Please wait...','name','Time to Frequency domain');
    for ij=1:NumberOfAxis
        [pxx(:,ij),F] = pwelch(signal(:,ij),[],[],4096,FS);
        [pxx_iso(:,ij),F_ISO] = pwelch(ISOFILTERED(:,ij),[],[],4096,FS);
        waitbar(ij/NumberOfAxis)
    end
    close(h);
    %--------------------------EVALUATION PERTAINING HEALTH--------------------
    k = [ 1.4 1.4 1 0.8];
    RMS_H = 0;%[rms(1:3) rms(6)].*k;
    squaresum = 0; %norm(RMS_H);
    %---------------------------Graph plottings--------------------------------
    %PLOT OF FREQUENCY DOMAIN DATA
    button = questdlg('DO YOU WANT TO SEE Original-PSD PLOTS ?');
    if strcmp(button,'Yes')
        tit = { 'X-AXIS FLOOR PSD',...
        'Y-AXIS FLOOR PSD','Z-AXIS FLOOR PSD'};
        for i = 1:NumberOfAxis
            h= figure(i)
            plot (F,pxx(:,i));
            xlabel('frequency in hz');
            ylabel('power spectral density');
            t = char(tit(i));
            title(t);
            uiwait(h)
        end
    end
    button = questdlg('DO YOU WANT TO SEE ISO-PSD PLOTS ?');
    if strcmp(button,'Yes')
        tit = {'X-AXIS FLOOR ISO-PSD',...
        'Y-AXIS FLOOR ISO-PSD','Z-AXIS FLOOR ISO-PSD'};
        for i = 1:NumberOfAxis
            h= figure(i);
            plot (F_ISO,pxx_iso(:,i));
            xlabel('frequency in hz');
            ylabel('power spectral density');
            t = char(tit(i));
            title(t);
            uiwait(h)
        end
    end
%end
%-----------------------------ISO 2631 ENDS--------------------------------
%-----------------------------BS 6841 starts-------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
case 2
    %type=[3 3 1 3 3 2 1 1 1 1 1 1 1 1 1];
    type=[1 1 1]; % for the floor - 10,11,12 elements
    nos=length(signal);
    h = waitbar(0,'Please wait...','name','APPLYING BS WEIGHTING FILTERS');
    for ij=1:NumberOfAxis
        BSFILTERED(:,ij)=bs6841(signal(:,ij),type(ij),FS);
        sum=0;sum2=0;
        for ijk=1:nos
            sum=sum+BSFILTERED(ijk,ij)*BSFILTERED(ijk,ij);
        end
        for ijk=1:nos
            sum2 = sum2+BSFILTERED(ijk,ij)*BSFILTERED(ijk,ij)* ...
            BSFILTERED(ijk,ij)*BSFILTERED(ijk,ij);
        end
        % calulation of rms and fourth power vibration dose values
        RMS_BS(ij)=sqrt(sum/nos);
        VDV_BS(ij) = (sum2/FS).^(1/4);
        %calculation of crest factors
        [CRESTF_BS(ij) pos(ij)] = max(BSFILTERED(:,ij)/RMS_BS(ij));
        waitbar(ij/NumberOfAxis);
    end
    close(h);
    %-----------------------comfort evaluation---------------------------------
    %k=[1 1 1 0.4 0.5 0.8 0.25 0.25 0.4 0.25 0.25 0.4 0.25 0.25 0.4];
    k=[0.25 0.25 0.4 ]; % for the floor - 10,11,12 elements
    RMS = RMS_BS.*k;
    FLOOR_A_BS = norm(RMS(1:3));
%     BACKREST_A_BS = norm(RMS(4:6));
%     LAPTOP_A_BS = norm(RMS(7:9));
%     FLOOR_A_BS = norm(RMS(10:12));
%     TABLE_A_BS = norm(RMS(13:15));
    TOTAL_A_BS = norm(RMS);
    string = {['FLOOR ROOT SUM SQUARE IS ' num2str(FLOOR_A_BS)],' ',...
    ['TOTAL ROOT SUM SQUARE IS ' num2str(TOTAL_A_BS)],' '};
    h= msgbox(string,'ROOT SUM SQUARE VALUES FOR BS 6841','warn');
    uiwait(h);
    %---------------------power spectral density calulation--------------------
    h = waitbar(0,'Please wait...','name','Time to Frequency domain for BS');
    for ij=1:NumberOfAxis
        [pxx_bs(:,ij),F_BS] = pwelch(BSFILTERED(:,ij),[],[],4096,FS);
        waitbar(ij/NumberOfAxis)
    end
    close(h);
    %--------------------------------------------------------------------------
    %---------------------------graph plottings--------------------------------
    button = questdlg('DO YOU WANT TO SEE BS-PSD PLOTS ?');
    if strcmp(button,'Yes')
        tit = { 'X-AXIS FLOOR BS-PSD',...
        'Y-AXIS FLOOR BS-PSD','Z-AXIS FLOOR BS-PSD'};
        for i = 1:NumberOfAxis
            h= figure(i);
            plot (F_BS,pxx_bs(:,i));
            xlabel('frequency in hz');
            ylabel('power spectral density');
            t = char(tit(i));
            title(t);
            uiwait(h);
        end
    end
%--------------------------END OF BS STANDARD------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
case 3
    %----------------------CALCULATION OF SPERLING INDEX-----------------------
    [WZ WR] = sperling(signal,FS);
    string ={'SPERLING INDEX FOR EACH DIRECTION AND LOCATIONS ARE ',' ',' ',...
    num2str(WZ')};
    h = msgbox(string,'Sperling indices for all 15 columns','none');
    uiwait(h);
    otherwise
        disp('select atleast one standard');
    end
    %---------------SAVE THE RESULTS AS TEXT FILES IN ASCII FORMAT-------------
    % GET THE USER DEFINED DIRECTORY
    dir_results=[FileName(1:length(FileName)-4) ' results']
    directory_name = uigetdir(pwd,'save result dir as:');
    if(directory_name~=0)
        mkdir(directory_name,dir_results);
        directory_name=[directory_name '\' dir_results];
        mkdir(directory_name,'ISO Results');
        mkdir(directory_name,'BS Results');
        mkdir(directory_name,'ENV Results');
        mkdir(directory_name,'PSD Results');
        mkdir(directory_name,'WZ Results');
        switch selection
        case 1
            save([directory_name '\ISO Results\ISOFILTERED.txt'],'ISOFILTERED', ...
            '-ascii');
            save([directory_name '\ISO Results\RMS.txt'],'rms','-ascii');
            
            save([directory_name ...
            '\ISO Results\1s averaged floor acceleration.txt'],...
            'FLOOR_A_MV','-ascii');
            
            save([directory_name ...
            '\ISO Results\1s averaged total acceleration.txt'],...
            'TOTAL_A_MV','-ascii');
            save([directory_name '\ISO Results\crest factor.txt'],...
            'CRESTF','-ascii');
            save([directory_name '\ISO Results\MTVV.txt'],'MTVV','-ascii');
            save([directory_name '\ISO Results\VDV.txt'],'VDV','-ascii');
            
            save([directory_name '\ISO Results\floor acceleration.txt'],...
            'FLOOR_A','-ascii');
            
            save([directory_name '\ISO Results\total acceleration.txt'],...
            'TOTAL_A','-ascii');
            save([directory_name ...
            '\ISO Results\1s averaged rms ISO accelerations(all in one).txt'],...
            'ISO_RMS_MV','-ascii');
            save([directory_name '\ISO Results\mtvv ratio.txt'],...
            'MTVV_RATIO','-ascii');
            save([directory_name '\ISO Results\vdv ratio.txt'],...
            'VDV_RATIO','-ascii');
            save([directory_name '\ISO Results\isofiltered psd.txt'],...
            'pxx_iso','-ascii');
            save([directory_name '\PSD Results\signal psd.txt'],'pxx','-ascii');
        case 2
        save([directory_name '\BS Results\BSFILTERED.txt'],...
        'BSFILTERED','-ascii');
        save([directory_name '\BS Results\signal psd.txt'],'pxx_bs','-ascii');
        save([directory_name '\BS Results\RMS.txt'],'RMS_BS','-ascii');
        case 3
        save([directory_name '\WZ Results\Wz.txt'],'WZ','-ascii');
        end
end