function [Npisp,F,Pxx,fr]=noise_synchronous(custom,N)%�빤Ƶͬ��������
%����Ĭ�ϲ�����ʽ��noise_synchronous(0)

%���������
%custom=0ʱ������ϵͳĬ�ϲ�����custom����ʱ�������û��Զ������
%N���û��Զ����SCR������

%���������
%Npisp:խ��������
%F:�����Ƶ�ף�
%Pxx:����Ĺ����ף�
%fr:Ƶ���ϲ���Ƶ�ʣ�

%clf;
%clc;
if custom==0
    n=1+round(9*rand);
else
    n=1+round((N-1)*rand);%N;
end
Ton=[1.9 11.2];%SCR��ͨʱ�䷶Χus
Toff=[15 150];%SCR�ض�ʱ�䷶Χus
Ton=Ton*10^-6;
Toff=Toff*10^-6;
Tp=50;%��Ƶ���ڶ�Ӧ��Ƶ��50Hz
Ap=-45;%�������dbֵ
a=(10^((Ap+48.75)/20))*10^-3;%������Ȼ�׼ֵ,��λV

Fsin=[0.5:3];
Fsin=Fsin*10^6; %�����ڵ����Ҳ�Ƶ�ʣ���ʱȡ500kHz����3MHz��Χ��%���������Ҳ�Ƶ�ʣ�ȡ����Ƶ�ʷ�Χ�ڵľ��ȷֲ�

A(:,1)=a*rand(n,1);%Aton��SCR��ͨʱ����ķ���
A(:,2)=a*rand(n,1);%Atoff��SCR�ض�ʱ����ķ���
tw(:,1)=Ton(1)+(Ton(2)-Ton(1))*rand(n,1);%ton��SCR��ͨʱ����Ŀ�� 
tw(:,2)=Toff(1)+(Toff(2)-Toff(1))*rand(n,1);%toff��SCR�ض�ʱ����Ŀ��
tcw=tw/5;%ʱ�䳣��
td(:,1)=rand(n,1).*(1/Tp-tw(:,1)-tw(:,2));%SCR��֮ͨǰ����������������ʱ�䣩
td(:,2)=rand(n,1).*(1/Tp-tw(:,2)-tw(:,1)-td(:,1));%SCR��ͨ����SCR��ֹ֮ǰ����������������ʱ�䣩
fsin=Fsin(1)+(Fsin(2)-Fsin(1))*rand(n,2);
PHY=2*pi*rand(n,2);
    
ts=1/(6*10^7);
fs=6*10^7;
t=0:ts:0.02;
l=length(t);%���泤��0.02s,���������1/60M���������������Ⱦ��൱�ڶ��Ǽ������Ĳ�����

Npisp=zeros(1,l);

tdc=fix(td/ts);
twc=fix(tw/ts);
N1=zeros(1,l);
    
x=find(twc);
for i=1:length(x)
t1=0:ts:twc(x(i))*ts;
N=A(x(i))*exp(-(t1)/tcw(x(i))).*sin(2*pi*fsin(x(i))*t1+PHY(x(i)));
lN=length(N);
N1(tdc(x(i)):tdc(x(i))+lN-2)=N(1:lN-1);
Npisp=Npisp+N1;
N1=zeros(1,l);
end
        
figure(1);
plot(t,Npisp);
%title('ͬ���ڹ�Ƶ��������������');
xlabel('ʱ�� (s)');
ylabel('���� (V)');

%��Ƶ���ܶ�
[F,fr]=freqspec(Npisp,fs);
figure(2);
plot(fr,F);
%title('ͬ���ڹ�Ƶ��������������Ƶ��');
xlabel('Ƶ�� (Hz)');
ylabel('���� ');
    
%�������ܶ�
Pxx = 1/l * F.*conj(F);
figure(3);
plot(fr,Pxx);
%title('ͬ���ڹ�Ƶ���������������������ܶ�');
xlabel('Ƶ�� (Hz)');
ylabel('���� (W)');
end    