function [gss,F,Pxx,fr]=noise_colored(usedefault,Wps)%��˹��ɫ������
%����Ĭ�ϲ�����ʽ��noise_colored(0)

%���������
%usedefault=0��ʾʹ��Ĭ�ϲ�����usedefault=1��ʾʹ���Զ������Wps����ʾ�˲�����ͨ����ֹƵ�ʺ������ֹƵ�ʵ��м�ֵ;
%Wpsȡֵ��Χ��0.2~2.8

%���������
%F:�����Ƶ�ף�
%Pxx:����Ĺ����ף�
%fr:Ƶ���ϲ���Ƶ�ʣ�
%Ns:Ƶ�ʳ�����
%clc;
%clf;

fs=6*10^7;%�������źţ�0~30Mhz���ʲ�������60MHz
t_s=1/(6*10^7);%1.67*10^-8;
t_sim=0:t_s:0.02;
L=length(t_sim);%���泤��0.001s,���������1/60M���������������Ⱦ��൱�ڶ��Ǽ������Ĳ�����

A=[-65 -85];%���ȷ�Χ-65db~-85db
A=(10.^((A+48.75)/20))*10^-3;
%batterworth�˲���������������fs=1000Hz��L����������ͬ���ǽ������Ĳ������������������W���źŴ���500hz����ͨ�˲���ͨƵ��������3dB�Ĳ���,���0��170���ȣ�����60 dB��˥�������,�綨���210���ȵ��ο�˹��Ƶ��(1000����)
if usedefault==0
Wp=0.5*L/3;
Ws=1*L/3;
else
Wp=(Wps-0.2+0.000001)*L/3;%0.000001�Ǳ�֤����Wps=0.2ʱ��Wp>0
Ws=(Wps+0.2-0.000001)*L/3;%0.000001�Ǳ�֤����Wps=0.2.8ʱ��Ws<3
end    
W=L;
%%%%%%%%%%%%%%%%%%%%%%% S ��˹������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xi=A(2)+wgn(1,L,0)*(A(1)-A(2));%randn(L,1);  %������ֵΪ0������Ϊ1�ĸ�˹����������

%y_mean=mean(xi);%��ֵ
%y_var=var(xi);%����
%y_square=y_var+y_mean.*y_mean;%����ֵ
%[y_self_correlation,lag]=xcorr(xi,'unbiased');%����غ���
%[f_g,y_probability_density] = ksdensity(xi);%�����ܶ�
%[y_frequency_spectrum,f1_gss] = Spectrum_Calc(xi,fs);
%y_power_spectrum = 1/L * y_frequency_spectrum.*conj(y_frequency_spectrum);

%figure(1);
%subplot(2,4,1);plot(t,xi);
%title('��˹������');%axis([0 L -5 5]);
%subplot(2,4,2);plot(t,y_mean);
%title('��˹��������ֵ');%axis([0 L -2 2]);
%subplot(2,4,3);plot(t,y_var);
%title('��˹����������');%axis([0 L -2 2]);
%subplot(2,4,4);plot(t,y_square);
%title('��˹����������ֵ');%axis([0 L -2 2]);
%subplot(2,4,5);plot(lag,y_self_correlation);
%title('��˹����������غ���');%axis([-L L -1 1]);
%subplot(2,4,6);plot(y_probability_density,f_g);
%title('�����ܶ�');
%subplot(2,4,7);plot(f1,y_frequency_spectrum);
%title('��˹������Ƶ��');
%subplot(2,4,8);plot(f1,y_power_spectrum);
%title('��˹�������������ܶ�');
%%%%%%%%%%%%%%%%%%%%%%% E ��˹������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%% S ��ͨ�˲���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[n,Wn] = buttord(Wp/W,Ws/W,3,60);
[b,a] = butter(n,Wn);
[h1,f1]=freqz(b,a,512,fs);
%figure(4);
%plot(f1,abs(h1)); xlabel('f/Hz');ylabel('|H(jf)|');
%grid on;
%title('��ͨ�˲�����Ƶ��Ӧ');
%%%%%%%%%%%%%%%%%%%%%%% E ��ͨ�˲���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% S ��˹��ɫ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gss=filter(b,a,xi);%�˲�������˹ɫ����
%gss1=mean(gss);%��ֵ
%gss2=var(gss);%����
%gss3=gss2+gss1.*gss1;%����ֵ
%[gss4,lag]=xcorr(gss,'unbiased');%����غ���
%[f_g,gss5]=ksdensity(gss);%�����ܶ�
%[y2,f2] = Spectrum_Calc(gss,fs);%Ƶ��
%p2 = 1/L * y2.*conj(y2);%������


figure(1);
plot(t_sim,gss);
%title('��˹��ɫ��������');
xlabel('ʱ�� (s)');
ylabel('���� (V)');

%��Ƶ���ܶ�
[F,fr]=freqspec(gss,fs);
for j=1:4
   F(j)=F(j+5); 
end
figure(2);
plot(fr,F);
%title('��˹��ɫ��������Ƶ��');ylim([0 10^-6]);
xlabel('Ƶ�� (Hz)');
ylabel('���� (V/Hz)')

%�������ܶ� 
Pxx = 1/L * F.*conj(F);
figure(3);
plot(fr,Pxx);
%title('��˹��ɫ���������������ܶ�');ylim([0 10^-18]);
xlabel('Ƶ�� (Hz)');
ylabel('���� (W)')


%{
figure(21);
%subplot(2,4,1);plot(t,gss);
%title('��˹ɫ����');%axis([0 L -5 5]);
%subplot(2,4,2);plot(t,gss1);
%title('��˹ɫ������ֵ');%axis([0 L -1 1]);
%subplot(2,4,3);plot(t,gss2);
%title('��˹ɫ��������');%axis([0 L -0.5 1.5]);
%subplot(2,4,4);plot(t,gss3);
%title('��˹ɫ��������ֵ');%axis([0 L -0.5 1.5]);
%subplot(2,4,5);plot(lag,gss4);
%title('��˹ɫ��������غ���');%axis([-L L -0.5 1]);
%subplot(2,4,6);plot(gss5,f_g);
%title('��˹ɫ���������ܶ�');
% subplot(2,1,1);
% plot(f1_gss,y_frequency_spectrum);
% title('��˹������Ƶ��');xlabel('f/Hz');ylabel('W/Hz');ylim([0 10^-6]);
% subplot(2,1,2);
plot(f2,y2);
title('��˹��ɫ����Ƶ��');xlabel('f/Hz');ylabel('W/Hz');ylim([0 10^-6]);

figure(31);
plot(f2,p2);
title('��˹��ɫ�����������ܶ�');xlabel('f/Hz');ylabel('W');ylim([0 10^-18]);

figure(4);
subplot(2,1,1);
plot(t_sim,xi,'b');xlabel('s');ylabel('V');
subplot(2,1,2);
plot(t_sim,gss,'r');xlabel('s');ylabel('V');
title('��˹������������ɫ����ʱ���ζԱ�');
%}
%%%%%%%%%%%%%%%%%%%%%%% E ��˹��ɫ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end