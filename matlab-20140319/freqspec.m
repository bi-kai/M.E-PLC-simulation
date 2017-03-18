function [Yf,f]=freqspec(yt,Fs)
%This function calculates the frequency spectrum of yt
%Fs������Ƶ�ʣ���λʱ�䣨1s���ڲ�������

% Ns=512;
% F=abs(fft(x,Ns));
% fr=(1/y)*(0:Ns/2-1)/Ns;

L = length(yt);

% ��Hanning��
w = hann(L);
yt = yt(:).*w(:);

NFFT = 2^nextpow2(L);
Yf = fft(yt,NFFT)/L;

Yf = 2*abs(Yf(1:NFFT/2+1));
f = Fs/2 * linspace(0,1,NFFT/2+1);
end