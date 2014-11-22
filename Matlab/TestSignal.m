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
WeightFactorsStr = {'Wk','Wd','Wf','Wc','We','Wj'}';
% colors: magenta,cyan,red, green, blue, black
LineColors       = {'m','c','r','g','b','x'}';
Fs = 1000;          % 1kHz sample rate
t = 0:1/Fs:1;      % 1 seconds @ 1kHz sample rate
fo = 1; f1 = 400;   % Start at 10Hz, go up to 400Hz
y = chirp(t,fo,10,f1)';
plot(t,y');
MyInput = y';
InputSignal = cat(2,t',y);
FilteredSignal = iso2631(y,1,Fs);
Kristian = FilteredSignal'; 
plot(FilteredSignal);
grid on;
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'m');hold on;
FilteredSignal = iso2631(y,2,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'c');
FilteredSignal = iso2631(y,3,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'r');
FilteredSignal = iso2631(y,4,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'g');
FilteredSignal = iso2631(y,5,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'b');
FilteredSignal = iso2631(y,6,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'k');
%-------------------- BS 6841-----------------------------

FilteredSignal = bs6841(y,1,Fs); % - TYPE 1 ......Wb
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),':k');

FilteredSignal = bs6841(y,6,Fs); % - TYPE 6 ......Wg
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'-.k');


hleg1 = legend('Wk','Wd','Wf','Wc','We','Wj','Wb','Wg');
title('Теглови Честотни Предавателни Функции за ISO2631 and BS6841');
axis([0.01 1000 -30 10]);
xlabel('Честота (Hz)');
ylabel('Усилване (dB)');
grid on;
hold off;


