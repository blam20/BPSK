clc 
clear

N = 1024; % N sampling points
Random = rand(1,N); %%Random sequence

binary = round(Random); %% 0s and 1s

Fc = 2; %% Carrier frequency
Fs = 4; %% Sampling frequency
numCycles = 1; %% One bit is represented by one cycle of sine wave 
Tb = numCycles/Fc  %% Cycles represented for one bit
t = 0:1/Fs:(numCycles-1/Fs); %Period of one cycle

A = 1;

carrier = A*cos(2*pi*Fc*t); %%Carrier wave
bitStream = [];
carrierSignal = [];
i = 1;

%For every sample point, we have to make one bit as four sampling points
%So if the generated bit is one, then for one full cycle of the carrier wave
%we make the bitstream as one. Same goes for zero
while(i<=N)
    if(binary(i))
        bitStream = [bitStream ones(1,length(carrier))]; %%Creating a bit stream of 1
    else
        bitStream = [bitStream zeros(1, length(carrier))]; %%Creating bit stream of 0s 
    end
    carrierSignal = [carrierSignal carrier];
    i = i+1;
end

bits = 2*(bitStream-0.5); %% 1s and -1s
bpsk = carrierSignal.*bits;
plot(bits);
xlim([0 300]);
ylim([-1.1 1.1]);


figure;

plot(carrierSignal);
xlim([0 300]);
ylim([-1.1 1.1]);

figure;

plot(bpsk);
xlim([0 300]);
ylim([-1.1 1.1]);

%%
freqz(bpsk,1,2^10,'whole',1)
freqz(carrierSignal,1,2^10,'whole',1)
[CS frq]=freqz(carrierSignal,1,2^10,'whole',1);
plot(abs(CS))
[BPSK frq]=freqz(bpsk,1,2^10,'whole',1);
plot(abs(BPSK))
[BITS frq]=freqz(bits,1,2^10,'whole',1);
figure(10)
plot(abs(BITS))
plot(fftshift(abs(BITS)))
plot(-511:512,fftshift(abs(BITS)))
plot(-511:512,fftshift(abs(BPSK)))
plot((-511:512)/2^10,fftshift(abs(BPSK)))
plot((-511:512)/2^10,fftshift(abs(BITS)))


Eb = (A^2*Tb)/2; %%Bit energy
Eb_No_dB = 0:2:14; %%SNR
Eb_No = 10.^(Eb_No_dB/10);
nVar = Eb./Eb_No;
sound(bpsk)
