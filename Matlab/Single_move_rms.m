function [ output ] = Single_move_rms( signal,tau,fs )
% This function calculates running rms for the filtered signal 
% signal - data for which moving rms to be calculated
% tau - time of averaging
% rms - return value o time averaged acceleration

nos = length(signal);
datalen = fix(nos/(fs*tau));
    for i=0:datalen
        seg_start= i*fs*tau+1;
        seg_end = seg_start+tau*fs-1;
        if seg_end>nos
            seg_end=nos;
        end
        sum=0;
        for ij=seg_start:seg_end
            sum=sum+signal(ij)*signal(ij);
        end
        output=sqrt(sum/(tau*fs));
    end
end




