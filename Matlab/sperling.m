function [wz wr] = sperling(signal,fs)
%--------------------------------------------------------------------------
%This function calculates the sperling ride index value by the method
%
%SIGNAL is the acceleration data in m/s2, for which Wz ride index to be
%calculated.
%
%FS is sampling frequency.
%
%WZ is the ride index comfort value.
%WR is the ride quality factor.
%--------------------------------------------------------------------------
for ij=4:246
    f(ij)=ij*1000/8192;
    %**********************************************************************
    % Ride comfort weightening factor for 
    %                 horizontal direction 
    %                 of the acceleration
    %**********************************************************************
    Bw(ij)=0.737*((1.911*f(ij)^2+(0.25*f(ij)^2)^2)/ ...
    ((1-0.277*f(ij)^2)^2 + (1.563*f(ij)-0.0368*f(ij)^3)^2))^0.5;
    %**********************************************************************
    % Ride comfort weightening factor for 
    %                 vertical direction 
    %                 of the acceleration
    %**********************************************************************
    Bs(ij)=Bw(ij)/1.25;
    %**********************************************************************
    aa = f(ij);
    bb =(1 - 0.056*aa^2)^2;
    cc= ( (0.645*aa)^2 )* (3.55*aa^2);
    dd = (1- 0.252*aa^2)^2 ;
    ee = (1.547*aa - 0.00444*aa^3)^2 ;
    ff = 1 + 3.55*aa^2;
  
    %**********************************************************************
    % Vehicle ride quality
    %**********************************************************************
    B(ij) = 1.14*(( bb+ cc )/((dd +ee)*ff))^0.5;
end
hold on;
plot(f(4:end),Bw(4:end),'r');
plot(f(4:end),Bs(4:end),'g');
plot(f(4:end),B(4:end),'b');
set(gca,'fontsize',18)
xlabel('Честота([hz]');
ylabel('Коефициент на предаване');
hleg1 = legend('Влияние на трептения върху комфорта в хоризонтална посока','Влияние на трептения върху комфорта в вертикална посока','Влияние на трептения върху планост на хода');
set(gca,'fontsize',24)
title('Индекс на Шперлинг - тегловни предавателни характеристики');
% Freq = w/2*pi;
%semilogx(f,20*log10(Bs),'m');
%semilogx(f,20*log10(Bs),'m');
% plot(f(4:end),Bw(4:end));
% xlabel('frequency(hz)');


for a=1:3
    sum=0;sum2=0;
    [Pxx,w] = pwelch(signal(:,a),[],[],8192,fs);
    for ij=4:246
        if (a~=3)&&(a~=4)&&(a~=9)&&(a~=12)&&(a~=15)
            Pxx2(ij)=2*Pxx(ij+1)*(Bs(ij)*Bs(ij));
        else
            Pxx2(ij)=2*Pxx(ij+1)*(Bw(ij)*Bw(ij));
        end
    end
    for ij=4:246
        Pxx3(ij)=2*Pxx(ij+1)*(B(ij)*B(ij));
    end
    for ij=4:246
        sum = Pxx2(ij)+sum;
        sum2 =Pxx3(ij)+sum2;
    end
    % A factor of 10000 is applied for conversion from m/s^2 to cm/s^2
    % 1000/8192 is df or the discrete frequency step used in integration
    integral1 = sum*1000/8192*10000;
    integral2 = sum2*1000/8192*10000;
    wz(a) = integral1^(1/6.67);
    wr(a) = integral2^(1/6.67);
end

