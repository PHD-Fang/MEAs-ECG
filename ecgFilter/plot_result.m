function plot_result()

clear all
close all

load("RESULT_Function4order048low_4.mat");
fileds = fieldnames(RESULT);
for j = 1:12
    k = fileds(j);
    key = k{1};
    result = RESULT.(key);

    a = result.r(:,1) - result.r(:,2:end);
    for i = 1:5
        a(:,i) = a(:,i)./result.r(:,1);
    end

    a1(1184*(j-1)+1:1184*j,:) = a;         %R peak
    a2(47*(j-1)+1:47*j,:) = result.r_cor;  %R cor

    x(j) = result.meansnrtime;
    a3(j,:) =  mean(result.snrtime(:,2:end)-result.snrtime(:,1),1); %snr
    a4(j,:) = mean(result.cor,1);
end
figure()
h = boxplot(a1);
set(h,'LineWidth',2);
xticks([1 2 3 4 5]);
xticklabels({'design','butter','cheby01','cheby04','cheby08'})
set(gca,'FontSize',15,'Fontname', 'Times New Roman');
ylabel('R peak','FontSize',15,'FontName','Times New Roman')
set(gca,'fontweight','bold');
% saveas(gcf,'R peak change ratio.fig'); 

figure()
h = boxplot(a2);
set(h,'LineWidth',2);
xticks([1 2 3 4 5]);
xticklabels({'design','butter','cheby01','cheby04','cheby08'})
set(gca,'FontSize',15,'Fontname', 'Times New Roman');
ylabel('R corraletion','FontSize',15,'FontName','Times New Roman')
set(gca,'fontweight','bold');
% saveas(gcf,'R peak correlatio.fig'); 

figure()
plot(x,a3,'LineWidth',2);
xlabel('noise(dB)','FontSize',15,'FontName','Times New Roman')
ylabel('SNR improvement(dB)','FontSize',15,'FontName','Times New Roman')
legend('design','butter','cheby01','cheby04','cheby08')  
set(gca,'fontweight','bold');
% saveas(gcf,'SNR compare).fig'); 

figure()
plot(x,a4,'LineWidth',2);
xlabel('noise(dB)','FontSize',15,'FontName','Times New Roman')
ylabel('correlation','FontSize',15,'FontName','Times New Roman')
legend('design','butter','cheby01','cheby04','cheby08')  
set(gca,'fontweight','bold');
% saveas(gcf,'correlation compare.fig'); 

end