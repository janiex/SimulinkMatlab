function filtered=bs6841(signal,type,fs)
%--------------------------------------------------------------------------
%This function calculate frequency weights according to BS-6481
%and return the frequency weighted accelerations.
%
%SIGNAL is the acceleration readings (n*1 vector).
%TYPE 1 ......Wb
%TYPE 2.......Wc
%TYPE 3.......Wd
%TYPE 4.......We
%TYPE 5.......Wf
%TYPE 6.......Wg
%
%fs is sampling frequency.
%filtered is filtered signal.
%the function first assigns the polynomial coeffecients for numerator and
%denominator for the band pass and weighting transfer functions. The analog
%s-domain tranfer function is then mapped to digital Z -domain transfer
%function using bilinear function and then the signal is passed through the
%digital filter.
% the various weighting filter parameters are f1,f2,f3,f4,f5,f6 and q1,q2,
% q3and q4 .These are defined in the bs6841 standard.
%--------------------------------------------------------------------------
f1=0.4;
f2=100;
switch type
    case 1
        f3=16;
        f4=16;
        f5=2.5;
        f6=4;
        q1=0.71;
        q2=0.55;
        q3=0.9;
        q4=0.95;
        k=0.4;
        m=2*pi*f6/q4;
        n=(2*pi*f6)^2;
        a= (2*pi*f5)^2;
        b = 2*pi*f5/q3;
    case 2
        f3=8.0;
        f4=8.0;
        q1=0.71;
        q2=0.63;
        k=1;
    case 3
        f3=2.0;
        f4=2.0;
        q1=0.71;
        q2=0.63;
        k = 1;
    case 4
        f3 = 1.0;
        f4 = 1.0;
        q1=0.71;
        q2 = 0.63;
        k= 1.0;
    case 5
        f1=0.08;
        f2=0.63;
        f3=inf;
        f4=0.25;
        f5=0.0625;
        f6=0.1;
        q1=0.71;
        q2=0.86;
        q3=0.86;
        q4=0.8;
        k=0.4;
        m=2*pi*f6/q4;
        n=(2*pi*f6)^2;
        a= (2*pi*f5)^2;
        b= 2*pi*f5/q3;
    case 6
        f1 = 0.8;
        f2 = 100;
        f3 = 1.5;
        f4 = 5.3;
        q1 = 0.71;
        q2 = 0.68; %it was 0.86
        k = 0.42;
    otherwise
        disp('Type should be 1 , 2 , 3 , 4 , 5 or 6');
end        
c = 2*pi*f1/q1;
d = 2*pi*f2/q1;
e= 2*pi*f3;
g = (2*pi*f4)^2;
h = 2*pi*f4/q2;
i = (2*pi*f1)^2;
j = (2*pi*f2)^2;
global hn w;
switch type
    case {1}
        kk = (2*pi*k*f4*f4*f6*f6)/(f3*f5*f5);
        numbt = [j 0 0];
        denbt = [1 d+c j+c*d+i c*j+i*d i*j];
        [numbd denbd] = bilinear(numbt,denbt,fs);
        filtered = filter(numbd,denbd,signal);
        [p w] = freqz(numbd,denbd,50000,fs);
        numwt=[1 e+b a+e*b a*e]*kk;
        denwt=[1 m+h n+h*m+g h*n+g*m g*n];
        [numwd,denwd] = bilinear(numwt,denwt,fs);
        filtered = filter(numwd,denwd,filtered);
        [p1 w] = freqz(numwd,denwd,50000,fs);
        hn=abs(p).*abs(p1);
    case {5}
        kk = (4*pi*pi*k*f4*f4*f6*f6)/(f5*f5);
        numbt = [j 0 0];
        denbt = [1 d+c j+c*d+i c*j+i*d i*j];
        [numbd denbd] = bilinear(numbt,denbt,fs);
        filtered = filter(numbd,denbd,signal);
        [p w] = freqz(numbd,denbd,50000,fs);
        numwt=[1 b a]*kk;
        denwt=[1 m+h n+h*m+g h*n+g*m g*n];
        [numwd,denwd] = bilinear(numwt,denwt,fs);
        filtered = filter(numwd,denwd,filtered);
        [p1 w] = freqz(numwd,denwd,50000,fs);
        hn=abs(p).*abs(p1);
    case {2,3,4,6}
        kk = 2*pi*k*f4*f4/f3;
        numbt = [j 0 0];
        denbt = [1 d+c j+c*d+i c*j+i*d i*j];
        [numbd denbd] = bilinear(numbt,denbt,fs);
        filtered = filter(numbd,denbd,signal);
        [p w] = freqz(numbd,denbd,50000,fs);
        numwt =[1 e]*kk;
        denwt =[1 h g];
        [numwd,denwd] = bilinear(numwt,denwt,fs);
        filtered = filter(numwd,denwd,filtered);
        [p1 w] = freqz(numwd,denwd,50000,fs);
        hn=abs(p).*abs(p1);
end



