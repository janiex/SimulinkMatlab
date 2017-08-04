clear all
clc
global w;
global hn;
NmbrOfElements = 6;
%TYPE 1 ......Wb
%TYPE 2.......Wc
%TYPE 3.......Wd
%TYPE 4.......We
%TYPE 5.......Wf
%TYPE 6.......Wg
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

%----- Plot Wb in BS6841 -------------------------------
FilteredSignal = bs6841(y,1,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'m');
hold on;
%----- Plot Wc in BS6841 -------------------------------
FilteredSignal = bs6841(y,2,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'c');
%----- Plot Wd in BS6841 -------------------------------
FilteredSignal = bs6841(y,3,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'r');
%----- Plot We in BS6841 -------------------------------
FilteredSignal = bs6841(y,4,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'g');
%----- Plot Wf in BS6841 -------------------------------
FilteredSignal = bs6841(y,5,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'b');
%----- Plot Wg in BS6841 -------------------------------
FilteredSignal = bs6841(y,6,Fs);
Freq = w/2*pi;
semilogx(Freq,20*log10(hn),'k');

hleg1 = legend('Wb','Wc','Wd','We','Wf','Wg');
title('BS 6841 weightening frequency transfer functions');
axis([0.01 1000 -30 10]);
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');

hold off;


