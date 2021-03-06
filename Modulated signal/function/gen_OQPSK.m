function [OQPSK_signal,s_complex,s]=gen_OQPSK(A,fc,fs,Rs,N)
%OQPSK
if nargin==0
    A=1;                                            %amplitude
    Rs=10e2;                                        %bit ratio
    N=1000;                                         %Number of bits to process
    fc=10e3;                                        %carrier frequency
    fs=10e4;                                        %sample frequency
end

Ts=1/Rs;
T=1/fs;
t=(0:(round(N*Ts/T)-1))*T;
r=round(Ts/T);

a=rand(1,N)>0.5;                               %bit symbol

%% serial-to-paralle
Idata=a(1:2:end);
Idata=repmat(Idata,2,1);
Idata=Idata(:)';

Qdata=a(2:2:end);
Qdata=repmat(Qdata,2,1);
Qdata=Qdata(:)';

%% Qdata delay one bit
Qdata=[0,Qdata(1:end-1)];

%% Gray coded
% 00->0->5pi/4
% 01->1->7pi/4
% 10->2->3pi/4
% 11->3-> pi/4
two_bits_decimal = [2,1]*[Qdata;Idata];
phase_code=pi*[5/4,7/4,3/4,1/4];
phi=phase_code(two_bits_decimal+1);

phi_sample=repmat(phi,r,1);
phi_sample=phi_sample(:)';

%% constellation
j=sqrt(-1);
s=cos(phi)+sin(phi)*j;

%% carrier wave
xc=cos(2*pi*fc*t);
xs=sin(2*pi*fc*t);

%% OQPSK

OQPSK_signal=A*(cos(phi_sample).*xc-sin(phi_sample).*xs);

s_complex=cos(phi_sample)+sin(phi_sample)*j;
s_complex=A*s_complex;
end