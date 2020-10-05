clc 
clear all
close all

Nbits = 5000; % N bits

spb = 10 %samples per symbol
Random = upsample(sign(randn(1,Nbits)),spb); %Random sequence (imaginary)
Random = [Random zeros(1,spb/2)];
RandomQ = upsample(sign(randn(1,Nbits)),spb); %Random sequence
RandomQ = [zeros(1,spb/2) RandomQ];
IQ = Random + j*RandomQ;

Fc = 40; % Carrier frequency
Fs = 200; % Sampling frequency
%numCycles = 137.5 ;
%Tb = numCycles/Fc;  % Bit duration
%t = 0:1/Fs:(numCycles-1/Fs); %Period of one cycle
%t = t(1:2500);
n = 0:Nbits*spb-1+spb/2;
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
y = filter(ps,1,IQ); %Pulse shaping 

I_bits = Random; %% Polar data of 1s and -1s
Q_bits = RandomQ;



figure(1)
plot(real(y),'b-');
hold on
plot(imag(y),'r-');
hold off
title('Pulse Shaping of Random Sequence')
xlim([0 100]);


obpsk = carrier.*y; %offset bpsk
figure(2)
plot(I_bits,'bx-');
hold on
plot(Q_bits,'rx-');
hold off
title('Bipolar bitstream')
xlim([0 50]);
ylim([-1.1 1.1]);


figure(3)
plot(real(obpsk),'bx-');
hold on
plot(imag(obpsk),'rx-');
hold off
title('OBPSK Modulated Signal')
xlim([0 50]);
ylim([-1.1 1.1]);

%{
figure(4)
plot(carrier)
title('Carrier')
xlim([0 50]);
ylim([-1.1 1.1]);
%}

figure(5)
freqz(obpsk,1,2^10,'whole',Fs); 
title('BPSK Spectrum')
ylim([-50 80]);


figure(6)
freqz(y,1,2^10,'whole',Fs);
title('Baseband Signal Spectrum')
ylim([-80 80]);
return

base_real = real(y);
figure(7)
plot(base_real);


%Demod
demod_carrier = Aexp(j2pi(Fc/Fs)n); %same as carrier

demod_sig = real(obpsk.demod_carrier);


figure(8)
plot(demod_sig)

demod_ps = filter(ps,1,demod_sig);

figure(9)
plot(demod_ps)

demod_pass = lowpass(demod_ps,.5,Fs);

figure(10)
plot(demod_pass)



