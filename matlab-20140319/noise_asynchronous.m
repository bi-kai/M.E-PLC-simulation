function [Npinp,F,Pxx,fr]=noise_asynchronous(custom,npc,ntv) %�빤Ƶ�첽������
%����Ĭ�ϲ�����ʽ��noise_asynchronous(0)

%���������
%custom=0,����ϵͳĬ�ϲ�����custom����ʱ�������û��Զ��������
%npc���û����õ�PC���ĸ�����npc��1��23֮�䣻
%ntv���û����õ�TV���ĸ�����ntv��1��23֮�䣻

%���������
%Npinp:խ������
%F:�����Ƶ��
%Pxx:����Ĺ�����
%fr:Ƶ���ϲ���Ƶ��
%clc;
%clf;

if custom==0
    Npc=1+round(10*rand);
    Ntv=1+round(10*rand);
else
    Npc=npc;
    Ntv=ntv;
end

Fpc=[30 120];
Fpc=Fpc*10^3;%PC��ʾ����ɨ��Ƶ��,ת����λHz
Ftv1=[15.75 15.625];
Ftv1=Ftv1*10^3;%TV��ɨ��Ƶ��,ת����λHz
Ftv2=[28 33 45 120];
Ftv2=Ftv2.*10^3;%��λkHz
Tw=[5 20];
Tw=Tw*10^-6;%������,ת����λs
Aback=[-65 -85];%����������db��
Apinp=(10.^(([Aback(1)+40 Aback(2)+10]+48.75)/20)).*10^-3;%��Ҫ�ٿ��ǣ�Npinp��������ֵ�����������е㲻��,��λΪV
Fsin=[0.5 30];%���������Ҳ���Ƶ�ʣ���λMHz��
Fsin=Fsin*10^6;%���������Ҳ�Ƶ�ʣ�ȡ����Ƶ�ʷ�Χ�ڵľ��ȷֲ�

ts=1/(6*10^7);%1.67*10^-8;
fs=6*10^7;
t=0:ts:0.02;
l=length(t);%���泤��0.02s,���������1/60M���������������Ⱦ��൱�ڶ��Ǽ������Ĳ�����
if ((Npc>=2)&&(Ntv>=2))
%����Noisepc��������ʾ������������
    a=Apinp(2)+rand(1,Npc)*(Apinp(1)-Apinp(2)); %��ֵ
    tw=Tw(1)+rand(1,Npc)*(Tw(2)-Tw(1)); %����
    fsin=Fsin(1)+(Fsin(2)-Fsin(1))*rand(1,Npc);
    PHY=2*pi*rand(1,Npc);
    
    f=Fpc(1)+rand(1,Npc)*(Fpc(2)-Fpc(1));
    T=1./f;
    x=find(T(:)<tw(:));
    T(x)=T(x)+abs(max(Tw)-1/max(Fpc));
    y=find(T(:)<tw(:));
    td=rand*(T(:)-tw(:));  %�������ʱ��

    tdc=fix(td/ts);
    for i=1:Npc
    %����һ��T(i)�ڵ����ݣ�Ȼ���ظ��Ϳ�����
    tcw=tw/5;%ʱ�䳣��
    N=a(i)*exp(-t/tcw(i)).*sin(2*pi*fsin(i)*t+PHY(i));%���еĵ�һ�����嶼��ͬһʱ����֣�û�м���һ������Ŀ�ʼʱ�䡣
    Noisepc(i,tdc(i):l)=N(1:length(tdc(i):l));
    k=find(abs(T(i)-t(:))<ts/2);
    lNpc(i)=k;
        for m=k+1:l
            Noisepc(i,m)=Noisepc(i,m-k);
        end
    end
   Npinppc=sum(Noisepc(:,:));
 


%����Noisetv��������ʾ������������
    a=Apinp(1)+rand(1,Ntv)*(Apinp(2)-Apinp(1)); %��ֵ
    tw=Tw(1)+rand(1,Ntv)*(Tw(2)-Tw(1)); %����
    fsin=Fsin(1)+(Fsin(2)-Fsin(1))*rand(1,Ntv);
    PHY=2*pi*rand(1,Ntv);
    f=Ftv2(1)+rand(1,Ntv)*(Ftv2(4)-Ftv2(1));
    f(1)=Ftv1(1+fix(rand*2));
    T=1./f;
    x=find(T(:)<tw(:));
    T(x)=T(x)+abs(max(Tw)-1/max(Ftv2));
    y=find(T(:)<tw(:));
    td=rand*(T(:)-tw(:));

    tdc=fix(td/ts);
    for i=1:Ntv
    %����һ��T(i)�ڵ����ݣ�Ȼ���ظ��Ϳ�����
    tcw=tw/5;
    N=a(i)*exp(-t/tcw(i)).*sin(2*pi*fsin(i)*t+PHY(i));%���еĵ�һ�����嶼��ͬһʱ����֣�û�м���һ������Ŀ�ʼʱ�䡣
    Noisetv(i,tdc(i):l)=N(1:length(tdc(i):l));
    k=find(abs(T(i)-t(:))<ts/2);
    lNtv(i)=k;
        for m=k+1:l
            Noisetv(i,m)=Noisetv(i,m-k);
        end
    end
    Npinptv=sum(Noisetv(:,:));
   
    Npinp=Npinppc+Npinptv;
else
    Npinp=zeros(1,l);
end

figure(1)
plot(t,Npinp)
%title('�첽�ڹ�Ƶ��������������');
xlabel('ʱ�� (s)');
ylabel('���� (V)');

%��Ƶ���ܶ�
[F,fr]=freqspec(Npinp,fs);
figure(2);
plot(fr,F);
%title('�첽�ڹ�Ƶ��������������Ƶ��');
xlabel('Ƶ�� (Hz)');
ylabel('���� ');

%�������ܶ� 
Pxx = 1/l * F.*conj(F);
figure(3);
plot(fr,Pxx);
%title('�첽�ڹ�Ƶ���������������������ܶ�');
xlabel('Ƶ�� (Hz)');
ylabel('���� (W)');
