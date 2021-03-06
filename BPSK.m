clc 
clear all
close all

Nbits = 5000; % N bits

spb = 10; %samples per symbol
Random = upsample(sign(randn(1,Nbits)),spb); %Random sequence (in phase)
Random = [Random zeros(1,spb/2)]; %Adding zeros to indicate offset in phase component
RandomQ = upsample(sign(randn(1,Nbits)),spb); %Random sequence (quadrature)
RandomQ = [zeros(1,spb/2) RandomQ]; %Adding zeros to indicate offset in quadrature component
IQ = Random + j*RandomQ; %In phase, quadrature

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

ps_size = 16;
ps = boxcar(ps_size);
ps = blackman(ps_size);
title('Pulse Shaping')
filtered_IQ = filter(ps,1,IQ); %Pulse shaping 

I_bits = Random; %% Polar data of 1s and -1s
Q_bits = RandomQ; 



figure(1)
plot(real(filtered_IQ),'b-');
hold on
plot(imag(filtered_IQ),'r-');
hold off
title('Pulse Shaping of Random Sequence')
xlim([0 100]);


oqpsk = carrier.*filtered_IQ; %offset bpsk
real_oqpsk = real(oqpsk);

figure(2)
plot(I_bits,'bx-'); %Plotting both IQ bits
hold on
plot(Q_bits,'rx-');
hold off
title('Bipolar bitstream')
xlim([0 50]);
ylim([-1.1 1.1]);


figure(3)
plot(real(oqpsk),'bx-'); %Real part of obpsk
hold on
plot(imag(oqpsk),'rx-'); %Imaginary part of obpsk
hold off
title('OQPSK Modulated Signal')
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
freqz(real(oqpsk),1,2^10,'whole',Fs); 
title('OQPSK Spectrum')
ylim([-50 80]);


figure(6)
freqz(filtered_IQ,1,2^10,'whole',Fs);
title('Baseband Spectrum')
ylim([-80 80]);


%Demodulation
demod_carrier = A*exp(-j*2*pi*(Fc/Fs)*n); %same as carrier

demod_sig = real(oqpsk).*demod_carrier;


figure(8)
freqz(demod_sig,1,2^10,'whole',Fs);
title('Demodulated Signal')

figure(9)
demod_pass = lowpass(demod_sig,40,Fs);
freqz(demod_pass,1,2^10,'whole',Fs);
title('Demodulated Filtered Signal')

figure(10)
real_filtered_demod = real(demod_pass);
imag_filtered_demod = imag(demod_pass);
demod_ps_real = filter(ps,1,real_filtered_demod);
demod_ps_imag = filter(ps,1,imag_filtered_demod);


figure(11)
hold on
plot(demod_ps_real);
plot(real(filtered_IQ),'r-');
%xlim([0 100]);
title('Superimposed Real Parts of the Pulse Shaped and Demodulated Pulse Shaped Signal')
hold off

figure(12)
hold on
plot(demod_ps_imag);
plot(imag(filtered_IQ),'r-');
title('Superimposed Imaginary Parts of the Pulse Shaped and Demodulated Pulse Shaped Signal')
%xlim([0 100]);
hold off

%sample the demodsignal at every 20th sample
len_demod_sig  = length(demod_ps_real);
i = 8;
data = zeros(1,len_demod_sig); %our final data stream (1 of 2)
while i<len_demod_sig
    if demod_ps_real(i) < 0
    data(i) = 0;
    end
    if demod_ps_real(i) >= 0
    data(i) = 1;
    end
    i = i +20;
end


% turns polar NRZ random bits at the start to 0 and 1
x  = length(Random);
i = 1;
while i<x
    if Random(i) == -1
    Random(i) = 0;
    end
    i = i +1;
end


i = 16;

%samples random at every 20th sample
while i<x
    if Random(i) == -1
    Random(i) = 0;
    end
    i = i +20;
end

%compares real data to random 
error = biterr(Random,data)

