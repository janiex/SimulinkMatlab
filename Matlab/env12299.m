function filtered=env12299(signal,type,fs)
%--------------------------------------------------------------------------
%This function calculate frequency weights according to ENV12299 STANDARD
%And return the frequency weighted accelerations.
%
%SIGNAL is the acceleration readings (n*1 vector).
%TYPE 1 ......Wab
%TYPE 2.......Wac
%TYPE 3.......Wad
%fs is sampling frequency
%filtered is filtered signal.
%the function first assigns the polynomial coeffecients for numerator and
%denominator for the band pass and weighting transfer functions. The analog
%s-domain tranfer function is then mapped to digital Z -domain transfer
%function using bilinear function and then the signal is passed through the
%digital filter.
% the various weighting filter parameters are f1,f2,f3,f4,f5,f6 and q1,q2,
% q3and q4 .These are defined in the env12299 standard.
%--------------------------------------------------------------------------
f1=0.4;
f2=100;
q1=0.71;
switch type
    case 1
        f3=16;
        f4=16;
        f5=2.5;
        f6=4;
        q2=0.63;
        q3=0.8;
        q4=0.8;
        k=0.4;
        m=2*pi*f6/q4;
        n=(2*pi*f6)^2;
        a= (2*pi*f5)^2;
        b = 2*pi*f5/q3;
    case 2
        f3=8.0;
        f4=8.0;
        q2=0.63;
        k=1;
    case 3
        f3=2.0;
        f4=2.0;
        q2=0.63;
        k = 1;
    otherwise
        disp('Type should be 1 , 2 , 3 or 4');
end
c = 2*pi*f1/q1;
d = 2*pi*f2/q1;
e = 2*pi*f3;
g = (2*pi*f4)^2;
h = 2*pi*f4/q2;
i = (2*pi*f1)^2;
j = (2*pi*f2)^2;
switch type
case {1}
%---------------transfer function of band pass filter--------------
numfl = [j 0 0];
denfl = [1 c i];
numfh =[1];
denfh =[1 d j];
numf = conv(numfl,numfh);
denf = conv(denfl,denfh);
[numdf dendf] = bilinear(numf,denf,fs);
filtered = filter(numdf,dendf,signal);
[p w] = freqz(numdf,dendf,50000,fs);
%------------------weighting transfer function---------------------
kk = 2*pi*k*f4*f4*f6*f6/(f3*f5*f5);
numt = [1 e];
dent= [1 h g];
nums = [1 b a]*kk;
dens = [1 m n];
numw = conv(numt,nums);
denw = conv(dent,dens);
[numdw dendw] = bilinear(numw,denw,fs);
filtered = filter(numdw,dendw,filtered);
[p1 w] = freqz(numdw,dendw,50000,fs);
global hn;
hn = abs(p).*abs(p1);
case {2,3}
%---------------transfer function of band pass filter--------------
numfl = [j 0 0];
denfl = [1 c i];
numfh =[1];
denfh =[1 d j];
numf = conv(numfl,numfh);
denf = conv(denfl,denfh);
[numdf dendf] = bilinear(numf,denf,fs);
filtered = filter(numdf,dendf,signal);
[p w] = freqz(numdf,dendf,50000,fs);
%------------------weighting transfer function---------------------
kk = 2*pi*k*f4*f4/f3;
numw = [1 e]*kk;
denw = [1 h g];
[numdw dendw] = bilinear(numw,denw,fs);
filtered = filter(numdw,dendw,filtered);
[p1 w] = freqz(numdw,dendw,50000,fs);
%-----------------total transfer function--------------------------
global hn;
hn = abs(p).*abs(p1);
end
return

