function filtered=iso2631(signal,type,fs)
%--------------------------------------------------------------------------
%This function calculate frequency weights according to ISO 2631-1
%and return the frequency weighted accelerations.
%SIGNAL is the acceleration vector(n*1 vector).
%TYPE 1 ......Wk
%TYPE 2.......Wd
%TYPE 3.......Wf
%TYPE 4.......Wc
%TYPE 5.......We
%TYPE 6.......Wj
%fs is sampling frequency.
%THE OUTPUT IS FILTERED VECTOR WHICH AGAIN IS A N*1 VECTOR WITH FREQUENCY
%WEIGHTINGS APPLIED TO IT AND IS IN TIME DOMAIN.
%the function first assigns the polynomial coeffecients for numerator and
%denominator for the band pass and weighting transfer functions. The analog
%s-domain tranfer function is then mapped to digital Z -domain transfer
%function using bilinear function and then the signal is passed through the
%digital filter.
% the various weighting filter parameters are f1,f2,f3,f4,f5,f6 and q4,q5
% and q6 .These are defined in theiso2631 standard.
%--------------------------------------------------------------------------
f1=0.4;
f2=100;
switch type
    case 1 %Wk
        f3=12.5;
        f4=12.5;
        q4=0.63;
        f5=2.37;
        q5=0.91;
        f6=3.35;
        q6=0.91;
        w5=2*pi*f5;
        w6=2*pi*f6;
        w3=2*pi*f3;
        w4=2*pi*f4;
    case 2 %Wd
        f3=2.0;
        f4=2.0;
        q4=0.63;
        w3=2*pi*f3;
        w4=2*pi*f4;
    case 3 %Wf
        f1=0.08;
        f2=0.63;
        f3=inf;
        f4=0.25;
        q4=0.86;
        f5=0.0625;
        q5=0.80;
        f6=0.1;
        q6=0.80;
        w5=2*pi*f5;
        w6=2*pi*f6;
        w3=2*pi*f3;
        w4=2*pi*f4;
    case 4
        f3=8.0;
        f4=8.0;
        q4=0.63;
        w3=2*pi*f3;
        w4=2*pi*f4;
    case 5
        f3 = 1.0;
        f4 = 1.0;
        q4 = 0.63;
        w3=2*pi*f3;
        w4=2*pi*f4;
    case 6
        f5 =3.75;
        q5 =0.91;
        f6= 5.32;
        q6 = 0.91;
        w5=2*pi*f5;
        w6=2*pi*f6;
    otherwise
        disp('Type should be 1 , 2 , 3 , 4 , 5 or 6 ');
end
w1=2*pi*f1;
w2=2*pi*f2;
a=1/(w2^2);
e=w1^2;
global w;
global hn;
switch type
    case {1}
%----------------------band pass filter----------------------------
%high pass filter
    numfh = [1 0 0];
    denfh = [1 sqrt(2)*w1 e];
    % low pass filter
    numfl= [0 0 1];
    denfl =[a sqrt(2)/w2 1];
    % band pass filter
    %numfh - числител на филтъра denf - знаменател
    % It is the product of low and high pass filter transfer functions
    numf = conv(numfh,numfl); %build the complete filter by convolution of the both filters
    denf = conv(denfh,denfl);
    [numdf dendf] = bilinear(numf,denf,fs); %convert the s-domain to discrete
    %filter the input vector 'signal' with the with the filter described by 
    %numerator coefficient vector numf and denominator coefficient vector dendf.
    filtered = filter(numdf,dendf,signal);
    plot(filtered);
    %frequency response vector h and the corresponding angular frequency 
    %vector w for the digital filter whose transfer function is determined 
    %by the (real or complex) numerator and denominator polynomials 
    %represented in the vectors numdf and dendf, respectively 50K points.
    [h w] = freqz(numdf,dendf,50000,fs);

    %------------------------------------------------------------------
    %------------------Weighting Filters-------------------------------
    % Acceleration-velocity transition
    numav = [1/w3 1];
    denav = [1/(w4^2) 1/(q4*w4) 1];
    %Upward step filter
    numus = [1/(w5^2) 1/(q5*w5) 1]*((w5/w6)^2);
    denus = [ 1/w6^2 1/(q6*w6) 1];
    % Actual weighting transfer function
    numw = conv(numav,numus);
    denw = conv(denav,denus);
    [numdw dendw] = bilinear(numw,denw,fs);
    filtered = filter(numdw,dendw,filtered);
    [h1 w] = freqz(numdw,dendw,50000,fs);
    
%------------------------------------------------------------------
    hn = abs(h).*abs(h1);
    
    
    
    % Total weighting function
case {3}
%----------------------band pass filter----------------------------
%high pass filter
    numfh = [1 0 0];
    denfh = [1 sqrt(2)*w1 e];
    % low pass filter
    numfl= [1];
    denfl =[a sqrt(2)/w2 1];
    % band pass filter
    % It is the product of low and high pass filter transfer functions
    numf = conv(numfh,numfl);
    denf = conv(denfh,denfl);
    [numdf dendf] = bilinear(numf,denf,fs);
    filtered = filter(numdf,dendf,signal);
    [h w] = freqz(numdf,dendf,50000,fs);
    %------------------------------------------------------------------
    %------------------Weighting Filters-------------------------------
    % Acceleration-velocity transition
    numav = [1];
    denav = [1/(w4^2) 1/(q4*w4) 1];
    %Upward step filter
    numus = [1/(w5^2) 1/(q5*w5) 1]*((w5)^2);
    denus = [1/(w6^2) 1/(q6*w6) 1]*((w6)^2);
    % Actual wieghting transfer function
    numw = conv(numav,numus);
    denw = conv(denav,denus);
    [numdw dendw] = bilinear(numw,denw,fs);
    filtered = filter(numdw,dendw,filtered);
    [h1 w] = freqz(numdw,dendw,50000,fs);
    %------------------------------------------------------------------
    hn = abs(h).*abs(h1); 
    
case {2,4,5}
%----------------------band pass filter----------------------------
    %high pass filter
    numfh = [1 0 0];
    denfh = [1 sqrt(2)*w1 e];
    % low pass filter
    numfl= [1];
    denfl =[a sqrt(2)/w2 1];
    % band pass filter
    % It is the product of low and high pass filter transfer functions
    numf = conv(numfh,numfl);
    denf = conv(denfh,denfl);
    [numdf dendf] = bilinear(numf,denf,fs);
    filtered = filter(numdf,dendf,signal);
    [h w] = freqz(numdf,dendf,50000,fs);
%------------------------------------------------------------------  
%------------------Weighting Filters-------------------------------
    % Acceleration-velocity transition
    numav = [1/w3 1];
    denav = [1/(w4^2) 1/(q4*w4) 1];
    %Upward step filter
    numus = [1];
    denus = [1];
    % Actual wieghting transfer function
    numw = conv(numav,numus);
    denw = conv(denav,denus);
    [numdw dendw] = bilinear(numw,denw,fs);
    filtered = filter(numdw,dendw,filtered);
    [h1 w] = freqz(numdw,dendw,50000,fs);
    %------------------------------------------------------------------
    % Total weighting function
    hn = abs(h).*abs(h1);
case {6}
%----------------------band pass filter----------------------------
%high pass filter
    numfh = [1 0 0];
    denfh = [1 sqrt(2)*w1 e];
    % low pass filter
    numfl= [1];
    denfl =[a sqrt(2)/w2 1];
    % band pass filter
    % It is the product of low and high pass filter transfer functions
    numf = conv(numfh,numfl);
    denf = conv(denfh,denfl);
    [numdf dendf] = bilinear(numf,denf,fs);
    filtered = filter(numdf,dendf,signal);
    [h w] = freqz(numdf,dendf,50000,fs);
    %------------------------------------------------------------------
    %------------------Weighting Filters-------------------------------
    % Acceleration-velocity transition
    numav = [1];
    denav = [1];
    %Upward step filter
    numus = [1/(w5^2) 1/(q5*w5) 1]*((w5/w6)^2);
    denus = [ 1/w6^2 1/(q6*w6) 1];
    % Actual wieghting transfer function
    numw = conv(numav,numus);
    denw = conv(denav,denus);
    [numdw dendw] = bilinear(numw,denw,fs);
    filtered = filter(numdw,dendw,filtered);
    [h1 w] = freqz(numdw,dendw,50000,fs);
    %------------------------------------------------------------------
    % Total weighting function
    hn = abs(h).*abs(h1);
    
end
return
