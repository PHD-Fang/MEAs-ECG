function showHfilt(sol,Problem,name)

[b,a] = sol2coef(sol,Problem.isVariableLength);

desiredFilter_h = Problem.desiredFilter_h;
[h,w] = freqz(b,a,Problem.fs);
figure()
subplot(2,1,1);
plot(w/pi,abs(h),'r','LineWidth',1);hold on


[h,w] = freqz(Problem.b,Problem.a,Problem.fs);
plot(w/pi,abs(h),'LineWidth',1);hold on
[h,w] = freqz(Problem.cb1,Problem.ca1,Problem.fs);
plot(w/pi,abs(h),'LineWidth',1);hold on
[h,w] = freqz(Problem.cb2,Problem.ca2,Problem.fs);
plot(w/pi,abs(h),'LineWidth',1);hold on
[h,w] = freqz(Problem.cb3,Problem.ca3,Problem.fs);
plot(w/pi,abs(h),'LineWidth',1);hold on

plot(w/pi,desiredFilter_h,'LineWidth',2);
legend('design','butter','cheby1','ellip','cheby2','idea');
title(name);
set(gca,'FontSize',24,'Fontname','Times New Roman');

subplot(2,2,3);
Z_f = roots(b);
P_f = roots(a);
zplane(Z_f,P_f);hold on %%% Displays the poles and zeros of discrete-time systems.
legend('Zero','Pole');
xlabel('Real Part');
ylabel('Imaginary Part');
title('Pole-Zero Plot design');
set(gca,'FontSize',24,'Fontname','Times New Roman');
% 
subplot(2,2,4);
Z_f = roots(Problem.cb2);
P_f = roots(Problem.ca2);
zplane(Z_f,P_f,'r'); %%% Displays the poles and zeros of discrete-time systems.
% legend('Zero','Pole');
% xlabel('Real Part');
% ylabel('Imaginary Part');
% title('Pole-Zero cheby1');

% subplot(2,2,4);
% Z_f = roots(Problem.b);
% P_f = roots(Problem.a);
% zplane(Z_f,P_f,'b'); %%% Displays the poles and zeros of discrete-time systems.
legend('Zero','Pole');
xlabel('Real Part');
ylabel('Imaginary Part');
title('Pole-Zero butter');
set(gca,'FontSize',24,'Fontname','Times New Roman');
end