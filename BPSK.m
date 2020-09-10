clc 
clear all
close all

Nbits = 5000; % N bits

spb = 5 %samples per symbol
Random = upsample(sign(randn(1,Nbits)),spb); %Random sequence


Fc = 40; % Carrier frequency
Fs = 200; % Sampling frequency
%numCycles = 137.5 ;
%Tb = numCycles/Fc;  % Bit duration
%t = 0:1/Fs:(numCycles-1/Fs); %Period of one cycle
%t = t(1:2500);
n = 0:Nbits*spb-1;
t = n/Fs;

A = 1;

%carrier = A*cos(2*pi*(Fc/Fs)*n); %Carrier wave
carrier = A*exp(j*2*pi*(Fc/Fs)*n); %Carrier wave
real_carrier = real(carrier);

X = 13
ps = boxcar(X);
ps = blackman(X);
figure(7)
plot(ps)
title('Pulse Shaping')
y = filter(ps,1,Random); %Pulse shaping 
bits = Random; %% Polar data of 1s and -1s


figure(1)
plot(y)
title('Pulse Shaping of Random Sequence')
xlim([0 100]);

bpsk = real_carrier.*y;
figure(2)
plot(bits,'x-');
title('Bipolar bitstream')
xlim([0 50]);
ylim([-1.1 1.1]);


figure(3)
plot(bpsk,'rx-')
title('BPSK Modulated Signal')
xlim([0 50]);
ylim([-1.1 1.1]);


figure(4)
plot(carrier)
title('Carrier')
xlim([0 50]);
ylim([-1.1 1.1]);


figure(5)
freqz(bpsk,1,2^10,'whole',Fs); 
title('BPSK Spectrum')
ylim([-50 80]);

figure(6)
freqz(y,1,2^10,'whole',Fs);
title('Baseband Signal Spectrum')
ylim([-80 80]);

base_real = real(y);
figure(7)
plot(base_real);







