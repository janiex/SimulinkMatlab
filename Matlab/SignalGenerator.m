Nf = 1;                %number of periods for the smallest frequency
Fend = 10;              %highest frequency
f= 0.1;                 %signal imput frequency 
f_step = 0.1;           %increment step
Fs =100;                %sampling frequncy
Ts = 1/Fs;              %sampling period
t=0:Ts:Nf*(1/f);        %time of the signal
L = length(t);
numbers = length(t);
y = zeros(1,numbers);
for counter=f:f_step:Fend
    ytemp = sin(2*pi*counter*t);
    y = y + ytemp;
end
points = numbers -1;
figure(1);
plot(t,y);
ylabel ('Amplitude');
xlabel ('Time Index');
TITLE ('Sine wave');
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% Y = fft(y,NFFT)/L;
% f_fft = Fs/2*linspace(0,1,NFFT/2+1);
% Y_plot = 2*abs(Y(1:NFFT/2+1));
% % Plot single-sided amplitude spectrum.
% x_plot = f_fft(1:30000);
% 
% plot(x_plot,Y_plot(1:30000));
[pxx,F_plot] = pwelch(y,128,120,length(y),Fs,'onesided');
figure(2);
plot(F_plot,pxx);
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

save(['GeneratedSygnal.txt'],'y','-ascii');
