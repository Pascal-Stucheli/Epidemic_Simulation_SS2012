%Analysis

clear all

% n = 1;
% degree_correlation = [0 0];
% for i = 1:999
%     try
%         bstr = int2str(i);
%         degree_corr_name='degree_corr000.txt';
%         degree_corr_name(15-length(bstr):14)=bstr;
%         degree_correlation(n,:) = dlmread(degree_corr_name);
%         n = n + 1;
%     end
% end
% t = 0:0.1:450;
% q = t.*0.0531+538.2358;
% figure 1
% hold on
% plot (degree_correlation(:,1),degree_correlation(:,2),'.')
% ylabel('Time until 30 percent infected')
% xlabel('Degree of seed neighbors')
% plot(t,q)
% hold off

%% 10% Infected Cities
% figure(2)
% hold on
% percentage = zeros(1,960);
% n = 1;
% for i = 1:999
%     try
%         bstr = int2str(i);
%         percentage_name='percent_10_total_000.txt';
%         percentage_name(21-length(bstr):20)=bstr;
%         percentage(n,:) = dlmread(percentage_name);
%         %         if mod(n,5) == 0
%         %         plot((1:960)/12,percentage(n,:),'LineWidth', 1)
%         %         end
%         n = n + 1;
%     end
% end
% 
% for i = 1:length(percentage(1,:))
%     percentage_mean(i) = mean(percentage(:,i));
%     percent_stdev(i) = std(percentage(:,i));
%     percent_intp(i)= percentage_mean(i)+percent_stdev(i)*1.65;
%     percent_intm(i) = percentage_mean(i)-percent_stdev(i)*1.65;
% 
% end
% 
% hold on
% for i = 1:126
%     for q = 1:10000
%         z(i,q+1) = find(percentage(i,:) >= q, 1, 'first' );
%     end
%     %    plot(z(i,:)/12)
% end
% 
% for i = 1:10000
%     zmean(i) = mean(z(:,i));
%     zstdev(i) = std(z(:,i));
%     zeip(i) = 1.6688*zstdev(i) + zmean(i);
%     zeim(i) = -1.6688*zstdev(i) + zmean(i);
% end
% % plot(zmean(:)/12,'r')
% % plot(zeip(:)/12,'r')
% % plot(zeim(:)/12,'r')
% 
% 
% 
% permeaninv = 0;
% for q = 1:960
%     try
%         permeaninv(q) = find(zmean(:) >= q, 1, 'first' );
%     catch
%         permeaninv(q) = 10000;
%     end
% end
% for q = 1:960
%     try
%         pereipinv(q) = find(zeip(:) >= q, 1, 'first' );
%     catch
%         pereipinv(q) = 10000;
%     end
% end
% 
% for q = 1:960
%     try
%         pereiminv(q) = find(zeim(:) >= q, 1, 'first' );
%     catch
%         pereiminv(q) = 10000;
%     end
% end
% 
% figure(2)
% box on
% xlim([25 80])
% ylim([0 10500])
% %ylim([0 11000])
% 
% ylabel('Cities with at least 10% infected','FontSize',14)
% xlabel('Time [d]','FontSize',14)
% 
% hold on
% plot((1:960)/12,permeaninv,'k','LineWidth',2)
% plot((1:960)/12,pereipinv,'--b','LineWidth',2)
% plot((1:960)/12,pereiminv,'--b','LineWidth',2)

%% Ratio

% figure(3)
% 
% %semilogy(1,1)
% hold on
% n = 1;
% ratio = zeros(1,960);
% 
% for i = 1:999
%     try
%         bstr = int2str(i);
%         ratio_name='ratio_2nd_000.txt';
%         ratio_name(14-length(bstr):13)=bstr;
%         ratio(n,:) = dlmread(ratio_name);
%         if mod(n,1) == 0
%         plot((1:length(ratio(1,:)))/12,ratio(n,:)*92854020)
%         end
%         global_outbreak(n)=min(find(ratio(n,:) >= 1000/92854020));
%         n = n + 1;
%     end
% end
% mi=mean(global_outbreak(:))/12
% st=std(global_outbreak(:))/12;
% exp_range_fact = st*2*tcdf(0.975,147)
% %xlim([0 80])
% plot(mi+exp_range_fact,1:1000,'or')
% plot(mi-exp_range_fact,1:1000,'or')
% ylim([0 1000])
% 
% for i = 1:147
%     g = 1;
%     for q = 0:0.001:1
%         try
%             inv{i}(1,g) = find(ratio(i,:) >= q, 1, 'first' );
%             inv{i}(2,g) = q;
%             g = g+1;
%         catch
%             g = g+1;
%             %             inv{i}(1,g) = NaN;
%             %             inv{i}(2,g) = q;
%         end
%     end
% end
% t(1001,2) = 0;
% for g = 1:147
%     for i = 1:length(inv{g}(1,:))
%         %try
%         t(i,1) = t(i,1) + inv{g}(1,i);
%         t(i,2) = t(i,2) + 1;
%         %end
%     end
% end
% 
% for i = 1:length(t(:,1))
%     mea(i) = t(i,1)/t(i,2);
%     
%     if  t(i,2) > 0
%         sum(i) = 0;
%     for g = 1:147
%         try
%             sum(i) = sum(i) + (inv{g}(1,i)-mea(i))^2;
%         end
%     end
%         expfact(i) = sqrt(1/(t(i,2)-1)*sum(i))*2*tcdf(0.975,t(i,2));
%     else 
%         expfact(i) = 0;
%     end
%         expmin(i) = mea(i) - expfact(i);
%         expmax(i) = mea(i) + expfact(i);
%     
% end
% 
% for i = 1:147
%     %plot(inv{i}(1,:))
% end
% plot(mea(:)/12,(1:length(mea(:)))/1000,'k','LineWidth',2)
% plot(expmin(:)/12,(1:length(expmin(:)))/1000,'--b','LineWidth',2)
% plot(expmax(:)/12,(1:length(expmax(:)))/1000,'--b','LineWidth',2)
% set(gca,'FontSize',14)
%  xlim([25 80])
%  ylim([0 1.1])
%  box on
%   ylabel('Ratio of global infected over total population')
%  xlabel('Time [d]')
% hold off
% %% Combined Graph
% figure(5)
% hold on
% box on
% set(gca,'FontSize',14)
% line((1:960)/12,permeaninv,'Color','k','LineWidth',2)
% ax1 = gca;
% set(ax1,'XColor','k','YColor','k')
% ylim([0 10000])
% xlim([25 80])
% ylabel('Number of cities with at least 10% infected')
% x2 = axes('Position',get(ax1,'Position'),...
%            'YAxisLocation','right',...
%            'Color','none',...
%            'XColor','k','YColor','b');
%        
% set(gca,'FontSize',14)
% line(mea(:)/12,(1:length(mea(:)))/1000,'Color','b','LineWidth',2)
% ylim([0 1])
% xlim([25 80])
% ylabel('Ratio of global infected over total population')
% xlabel('Time [d]')
% hold off

%% degree correlation

n = 1;
degre2_correlation = [0 0];
for i = 1:999
    try
        bstr = int2str(i);
        degre2_corr_name='degre7_corr000.txt';
        degre2_corr_name(15-length(bstr):14)=bstr;
        degre2_correlation(n,:) = dlmread(degre2_corr_name);
        n = n + 1;
    end
end

figure(4)
set(gca,'FontSize',14)
x = degre2_correlation(:,1);
y = degre2_correlation(:,2);

plot(x,y,'sb','MarkerSize',2,'MarkerFaceColor','b')
hold on

deg = min(x):0.1:max(x);
q = 789.7*deg.^(-0.1128);
plot(deg,q,'k', 'LineWidth',2)
xlim([min(x)*0.9,max(x)*1.1])
 ylabel('Time until at least 20 cities are infected [d]')
xlabel('Degree of seed and 1st generation surrounding nodes [degree]')


box on
hold off

%% distance correlation

% n = 1;
% degre5_correlation = [0 0];
% for i = 1:999
%     try
%         bstr = int2str(i);
%         degre5_corr_name='degre5_corr000.txt';
%         degre5_corr_name(15-length(bstr):14)=bstr;
%         degre5_correlation(n,:) = dlmread(degre5_corr_name);
%         n = n + 1;
%     end
% end
% degre5_correlation(:,2) = degre5_correlation(:,2)/24;
% figure(4)
% set(gca,'FontSize',14)
% box on
% %grid on
% hold on
% %mean calculation
% for i = 1:8
%     finder = find(degre5_correlation==i);
%     for q = 1:length(finder)
%        if finder(q) > length(degre5_correlation)
%            finder(q) = finder(q) - length(degre5_correlation);
%        end
%     end
%     g{i} = degre5_correlation(finder(:),2);
% end
% for i = 1:8
%    m(i) = mean(g{i});
%    st(i) = std(g{i});
%    %plot(i,m(i),'*r')
% end
% %plot((degre5_correlation(:,1)),(degre5_correlation(:,2)),'.b')
% 
% d = min(degre5_correlation(:,1)):0.1:max(degre5_correlation(:,1));
% [a,b,c] = regression((degre5_correlation(:,1).'),(degre5_correlation(:,2)).')
% 
% %% time delay = distance*6.577  (6.131, 7.023) + 8.802  (6.434, 11.17)
% 
% q = ((d).*(b)+c);
% plot(d,q,'k','LineWidth',2)
% errorbar(1:8,m,st,'.b')
%  xlim([min(degre5_correlation(:,1))-0.5 max(degre5_correlation(:,1))+0.5])
%  ylabel('Time until one infected is found in random city [d]')
% xlabel('distance between seed and random city [edges]')

