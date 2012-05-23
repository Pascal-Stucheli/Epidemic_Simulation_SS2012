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

% figure(2)
% hold on
% percentage = zeros(1,960);
% n = 1;
% for i = 1:999
%     try
%         bstr = int2str(i);
%         percentage_name='percentage000.txt';
%         percentage_name(14-length(bstr):13)=bstr;
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
%     zeip(i) = 1.65*zstdev(i) + zmean(i);
%     zeim(i) = -1.65*zstdev(i) + zmean(i);
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
% xlim([25 55])
% ylim([0 11000])
% 
% ylabel('Cities with at least 20% infected','FontSize',14)
% xlabel('Time [d]','FontSize',14)
% set(gca,'FontSize',14)
% hold on
% plot((1:960)/12,permeaninv,'k','LineWidth',2)
% plot((1:960)/12,pereipinv,'b','LineWidth',2)
% plot((1:960)/12,pereiminv,'b','LineWidth',2)
% 
% figure(3)
% hold on
% n = 1;
% ratio = zeros(1,960);
% for i = 1:999
%     try
%         bstr = int2str(i);
%         ratio_name='ratio000.txt';
%         ratio_name(9-length(bstr):8)=bstr;
%         ratio(n,:) = dlmread(ratio_name);
%         plot((1:960)/12,ratio(n,:))
%         n = n + 1;
%     end
% end

% n = 1;
% degre2_correlation = [0 0];
% for i = 1:999
%     try
%         bstr = int2str(i);
%         degre2_corr_name='degre2_corr000.txt';
%         degre2_corr_name(15-length(bstr):14)=bstr;
%         degre2_correlation(n,:) = dlmread(degre2_corr_name);
%         n = n + 1;
%     end
% end
% figure(4)
% hold on
% plot(degre2_correlation(:,2),(degre2_correlation(:,1)),'.b')
% t = 350:0.1:650;
% q = 10.^(t.*(-0.0026)+2.7849);
% plot(t,q)

n = 1;
degre3_correlation = [0 0];
for i = 1:999
    try
        bstr = int2str(i);
        degre3_corr_name='degre4_corr000.txt';
        degre3_corr_name(15-length(bstr):14)=bstr;
        degre3_correlation(n,:) = dlmread(degre3_corr_name);
        n = n + 1;
    end
end
figure(4)
hold on
plot((degre3_correlation(:,1)),(degre3_correlation(:,2)),'.b')

d = 1:0.1:8;
q = 10.^(d.*(-0.0230)+2.693);
%plot(d,q)
