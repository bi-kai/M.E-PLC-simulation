function [Nran,F,Pxx,fr]=noise_rand(custom,nums)%�����������
%����Ĭ�ϲ�����ʽ��noise_rand(0)

%���������
%custom=0����ʾʹ��Ĭ�ϲ���������ʹ�������nums
%nums�����������������������Ϊ0

%���������
%t:���ʱ��
%Nran:�첽�������
%F:�����Ƶ��
%Pxx:����Ĺ�����
%fr:Ƶ���ϲ���Ƶ��
%clf;
%clc;

if custom==0
   l1=1+round(15*rand);%l1-�ϳɵ��ź����������ĸ���
else
    l1=nums;
end 

amp=ranimpulseamp(l1);%������ֵ����λV
tw=ranimpulsetw(l1);%������λus
td=ranimpulsetd(l1);%����������λms
tw=tw*10^-6;%ת��Ϊ��
td=td*10^-3;%ת��Ϊ��
td=td/35;%ѹ��ʱ��Χ
Fsin=[0.5 3];%���������Ҳ���Ƶ�ʣ���λMHz��
Fsin=Fsin*10^6; %�����ڵ����Ҳ�Ƶ�ʣ���ʱȡ500kHz����3MHz��Χ�ڣ���ʵ>3MHz��Χ�Ļ��С�%���������Ҳ�Ƶ�ʣ�ȡ����Ƶ�ʷ�Χ�ڵľ��ȷֲ�

tcw=tw/5;%tcw-ָ��˥����ʱ�䳣��
fsin=Fsin(1)+(Fsin(2)-Fsin(1))*rand(1,l1);

ts=1/(6*10^7);%10^-6;
fs=6*10^7;
t=0:ts:0.02;
l=length(t);%l=500001
st=0;
ranimpulse=zeros(1,l);

for i=1:l1
    N1=zeros(1,l);
    tem=st;
    st=st+tw(i)+td(i);
    t1=0:ts:st;
    N=amp(i)*exp(-(t1)/tcw(i)).*sin(2*pi*fsin(i)*t1+2*pi*rand);
    temc=floor(tem/ts)+1;
    stc=floor(st/ts);
    N1(temc:stc)=N(1:length(temc:stc));
    if(length(ranimpulse)>length(N1))
       N1((length(N1)+1):length(ranimpulse))=zeros(1,(length(ranimpulse)-length(N1)));
    end   
    if(length(ranimpulse)<length(N1))
       N1=N1(1:l);
    end 
    ranimpulse=ranimpulse+N1;
end
Nran=ranimpulse;

figure(1);
%title('�����������');
plot(t,Nran);
xlabel('ʱ�� (s)');
ylabel('���� (V)');

% plot(t,ranimpulse)
%��Ƶ���ܶ�
[F,fr]=freqspec(Nran,fs);
figure(2)
plot(fr,F);
xlabel('Ƶ�� (Hz)');
ylabel('����');


%�������ܶ�
Pxx = 1/l * F.*conj(F);
figure(3)
plot(fr,Pxx);
xlabel('Ƶ�� (Hz)');
ylabel('���� (W)');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [amp]=ranimpulseamp(l2) 
%����100������Ҫ����������amp,��λV

% clear;
% clc;
xamp=[0 0.2 1.06 2
     1 0.1 0.01 0];
l1=length(xamp);l=l1-1;
b=zeros(1,l2);
for i=1:l
    as(i)=fix(l2*(xamp(2,i))-fix(l2*xamp(2,i+1))); %�Ƹ�����ֲ������ݸ���
    b(i,1:as(i))=xamp(1,i)+(xamp(1,i+1)-xamp(1,i))*rand(1,as(i)); %������������Ӧ���е�����
end

d=b(find(b))';
for i=1:l
    ca(i)=length(find(b>xamp(1,i)&b<xamp(1,i+1)|b==xamp(1,i+1)));
end

hold on
cac=zeros(1,l1);
for i=1:l
    cac(i)=sum(ca(i:l))/l2;
end

amp=d(randperm(l2));


function td=ranimpulsetd(l2)%l2-�������ݵĸ���
%����100������Ҫ���������tIAT,������д��td��ΪtIAT
% clear all;
% clc;
xd=[0	0.4	     1.2	2.4	    4	    6	    8.4	     11.2	 14.4	18	    22	    26.4	31.2	36.4	42	    48	    54.4	61.2	 68.4	 76	     84
    1	0.9574	0.90015	0.84546	0.7868	0.72798	0.67383	0.62746	0.59014	0.56163	0.54069	0.52563	0.51479	0.50674	0.50041	0.49506	0.49024	0.4857	0.48129	0.47697	0.47272  ];

xd=[xd,[100;0]];
l1=length(xd);%%l1-xd�ĳ���,l1=22
l=l1-1;%l=21;

b=zeros(1,l2);
for i=1:l
    as(i)=fix(l2*(xd(2,i))-fix(l2*xd(2,i+1))); %�Ƹ�����ֲ������ݸ���
    b(i,1:as(i))=xd(1,i)+(xd(1,i+1)-xd(1,i))*rand(1,as(i)); %������������Ӧ���е�����
end

d=b(find(b))';%find���Ϊһ�У�����ת��
% for i=1:l
%     ca(i)=length(find(b>xd(1,i)&b<xd(1,i+1)|b==xd(1,i+1)));
% end
%
% cac=zeros(1,l1);
% for i=1:l
%     cac(i)=sum(ca(i:l))/l2;
% end
% figure(4);
% plot(xd(1,:),cac,'p');

td=d(randperm(l2));%randperm��������˳��
kk=3;


function tw=ranimpulsetw(l2)
%����100������Ҫ���������tw
% clear all;
% clc;
xw=[0	5	15	30	50	75	105	140	180	225	275	330	390	455	525 680 950
1	0.94819	0.85289	0.72853	0.59218	0.4597	0.34287	0.24801	0.17634	0.12541	0.090933	0.068334	0.053697	0.044067	0.037395  0.028175 0.018305
];

%����˵��:
%l1-xw�ĳ���
%l2-�������ݵĸ���
xw=[xw,[1000;0]];
l1=length(xw);l=l1-1;%l2=100;

b=zeros(1,l2);
for i=1:l
    as(i)=fix(l2*(xw(2,i))-fix(l2*xw(2,i+1))); %�Ƹ�����ֲ������ݸ���
    b(i,1:as(i))=xw(1,i)+(xw(1,i+1)-xw(1,i))*rand(1,as(i)); %������������Ӧ���е�����
end

d=b(find(b))';
for i=1:l
    ca(i)=length(find(b>xw(1,i)&b<xw(1,i+1)|b==xw(1,i+1)));
end

hold on
cac=zeros(1,l1);
for i=1:l
    cac(i)=sum(ca(i:l))/l2;
end

tw=d(randperm(l2));