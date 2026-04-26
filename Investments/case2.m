%% EXERCISE 1
data=xlsread("Dataset_hw_2.xlsx")

monthly_avg=mean(data)*100
monthly_std=std(data)*100

yearly_avg=monthly_avg*12
yearly_std=monthly_std*sqrt(12)
monthly_std(1,13)=0;
yearly_std(1,13)=0;

name=["s1","s2" "s3","s4","s5","s6","s7","s8","s9","s10","b1","b2","b3"]

subplot(2,2,1)
bar(name,monthly_avg)
title('Monthly Expected Returns')
subplot(2,2,2)
bar(name,yearly_avg)
title('Yearly Expected Returns')
subplot(2,2,3)
bar(name,monthly_std)
title('Monthly Volatilities')
subplot(2,2,4)
bar(name,yearly_std)
title('Yearly Volatilities')

%% EXERCISE 2
help cov

mat=cov(data(:,1:12))

%the equally weighted case
weight=ones(1,12)./12

monthly_return=mean(data(:,1:12))
ret=weight*monthly_return'
monthly_volatility=std(data(:,1:12))

variance=weight*(mat*weight')
volatility=sqrt(variance)


ret_yearly       = ret * 12;
volatility_yearly = volatility * sqrt(12);

ret
volatility
ret_yearly
volatility_yearly

%% Exercise 3

help portopt

NumPorts=20000

[PortRisk,PortReturn,PortWts]=portopt(monthly_return,mat,NumPorts)

plot(PortRisk*100,PortReturn*100)
title('Portfolio Effective Frontier')
xlabel('Risk')
ylabel('E[Rp]')

%% EXERCISE 4
rf=data(end,13)
PortRisk(1)
PortReturn(1)

s_ratio=(PortReturn-rf)./PortRisk
max(s_ratio)


s_ratio=-inf
for i=1:20000
    if s_ratio<(PortReturn(i)-rf)/PortRisk(i)
       s_ratio=(PortReturn(i)-rf)/PortRisk(i)
       loc=i
    end
end



figure              


plot(PortRisk*100, PortReturn*100);
hold on


slope = (PortReturn(loc) - rf) / PortRisk(loc);


x_max = max(PortRisk);           

% CAL
x_line = [0, x_max] * 100;
y_line = (rf + slope * [0, x_max]) * 100;

plot(x_line, y_line, 'b', 'LineWidth', 2);


plot(PortRisk(loc)*100, PortReturn(loc)*100, 'ko', 'MarkerFaceColor', 'k');

xlabel('Risk (monthly volatility, %)');
ylabel('Expected return (monthly, %)');
title('Efficient frontier and Capital Allocation Line');

% Tangent Portfolio features
mu_T_monthly    = PortReturn(loc);   
sigma_T_monthly = PortRisk(loc);     


mu_T_annual    = mu_T_monthly * 12;
sigma_T_annual = sigma_T_monthly * sqrt(12);


sharpe_T = (mu_T_monthly - rf) / sigma_T_monthly;


w_T = PortWts(loc,:);   

mu_T_monthly
sigma_T_monthly
mu_T_annual
sigma_T_annual
sharpe_T

