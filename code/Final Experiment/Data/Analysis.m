%Analysis

n = 1;
degree_correlation = [0 0];
for i = 1:999
    try
        bstr = int2str(i);
        degree_corr_name='degree_corr000.txt';
        degree_corr_name(15-length(bstr):14)=bstr;
        degree_correlation(n,:) = dlmread(degree_corr_name);
        n = n + 1;
    end
end
t = 0:0.1:450;
q = t.*0.0531+538.2358;
hold on
plot (degree_correlation(:,1),degree_correlation(:,2),'.')
ylabel('Time until 30 percent infected')
xlabel('Degree of seed neighbors')
plot(t,q)
hold off
