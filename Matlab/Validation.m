% f = 0.4;           % Frequency of the Signal
% Fs = f*100;        % 1kHz sample rate
% T = 1/f;
% t = 0:1/Fs:T;      % 1 second signal window
% Amp = 0.5;         % Amplitude of the test signal
% sig = Amp*sin(2*pi*f*t);
% plot(t,sig);
% temp = iso2631(sig',4,Fs);
% Result = sqrt(mean(temp.^2)); %Implementation of the RMS function

f = 0.4;                      % Signal frequency
Amp = 0.5;                    % Amplitude of the test signal
T = 1/f;                      % Window period on which the RMS will be applied0
Fs = f*100;                    % Sampling frequency
t = 0:1/Fs:200*T;                 % Form the time window
sig = Amp*sin(2*pi*f*t);      % Form the signal
plot(t,sig);
temp = iso2631(sig,1,Fs);     % Filter the signal
%Result = Single_move_rms(temp,T,Fs); % Implementation of the RMS function
Result = sqrt(mean(temp.^2)); %Implementation of the RMS function

