clear all
clc
global w;
global hn;
NmbrOfElements = 6;
%TYPE 1 ......Wk
%TYPE 2.......Wd
%TYPE 3.......Wf
%TYPE 4.......Wc
%TYPE 5.......We
%TYPE 6.......Wj

% colors: magenta,cyan,red, green, blue, black
LineColors       = {'m','c','r','g','b','x'}';
Fs = 1000;          % 1kHz sample rate
t = 0:1/Fs:1;      % 1 seconds @ 1kHz sample rate
fo = 1; f1 = 400;   % Start at 10Hz, go up to 400Hz
y = chirp(t,fo,10,f1)';
plot(t,y');
MyInput = y';
InputSignal = cat(2,t',y);
grid on;
%----- Plot Wk in ISO2631 -------------------------------
FilteredSignal = ISO2631(y,1,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'m');
hold on;
%----- Plot Wd in ISO2631 -------------------------------
FilteredSignal = ISO2631(y,2,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'c');
%----- Plot Wf in ISO2631 -------------------------------
FilteredSignal = ISO2631(y,3,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'r');
%----- Plot Wc in ISO2631 -------------------------------
FilteredSignal = ISO2631(y,4,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'g');
%----- Plot We in ISO2631 -------------------------------
FilteredSignal = ISO2631(y,5,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'b');
%----- Plot Wj in ISO2631 -------------------------------
FilteredSignal = ISO2631(y,6,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'k');
%------- Add the legend and labels to the plot ----------
hleg1 = legend('Wk','Wd','Wf','Wc','We','Wj');
title('ISO2631 weightening frequency transfer functions');
axis([0.01 1000 -30 10]);
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
grid on;
hold off;
%------- EOF ISO2631_TestSignal.m ------------------------

