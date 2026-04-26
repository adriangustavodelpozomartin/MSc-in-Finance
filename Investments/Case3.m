clear all

%%% question 1 to 3

data=rStocks
rBond10y_monthly=rBond10y/1200
rBond5y_monthly=rBond5y/1200
data=[rStocks rBond10y_monthly rBond5y_monthly]


monthly_avg=mean(data)
monthly_std=std(data)


yearly_avg=monthly_avg*12
yearly_std=monthly_std*sqrt(12)

weight=ones(1,12)./12

monthly_return=mean(data(:,1:12))
ret=weight*monthly_return'
monthly_volatility=std(data(:,1:12))
mat=cov(data)

variance=weight*(mat*weight')
volatility=sqrt(variance)


ret_yearly       = ret * 12;
volatility_yearly = volatility * sqrt(12);

ret
volatility
ret_yearly
volatility_yearly



NumPorts=20

[PortRisk,PortReturn,PortWts]=portopt(monthly_return,mat,NumPorts)

figure
plot(PortRisk*100,PortReturn*100)
title('Portfolio Effective Frontier')
xlabel('Risk')
ylabel('E[Rp]')



%%%%%%%%%Part 4
NumPorts=500

[PortRisk,PortReturn,PortWts]=portopt(monthly_return,mat,NumPorts)

figure
plot(PortRisk*100*sqrt(12),PortReturn*100*12)
title('Portfolio Effective Frontier')
xlabel('Risk')
ylabel('E[Rp]')
w_t=PortWts(loc,:)

rf=rtbill(72)/1200


s_ratio=(PortReturn-rf)./PortRisk
max(s_ratio)


s_ratio=-inf
for i=1:500
    if s_ratio<(PortReturn(i)-rf)/PortRisk(i)
       s_ratio=(PortReturn(i)-rf)/PortRisk(i)
       loc=i
    end
end



figure              


plot(PortRisk*100*sqrt(12), PortReturn*100*12);
hold on


slope = (PortReturn(loc)*12 - rf*12) / (PortRisk(loc)*sqrt(12));


x_max = max(PortRisk)*sqrt(12);           

% CAL
x_line = [0, x_max] * 100;
y_line = (rf*12 + slope * [0, x_max]) * 100;

plot(x_line, y_line, 'b', 'LineWidth', 2);



plot(PortRisk(loc)*100*sqrt(12), PortReturn(loc)*100*12, 'ko', 'MarkerFaceColor', 'k');

xlabel('Risk (annually volatility, %)');
ylabel('Expected return (annual, %)');
title('Efficient frontier and Capital Allocation Line');



%%%%%%%%%exercise 5
rStocks_04=rStocks(1:60,:)

monthly_avg=mean(rStocks_04)
monthly_std=std(rStocks_04)

yearly_avg=monthly_avg*12
yearly_std=monthly_std*sqrt(12)

mat=cov(rStocks_04)


figure
NumPorts=500
[PortRisk,PortReturn,PortWts]=portopt(monthly_avg,mat,NumPorts)
plot(PortRisk*100,PortReturn*100)
title('Portfolio Effective Frontier')
xlabel('Risk')
ylabel('E[Rp]')

%%% plotting into yearly terms
figure
plot(PortRisk*100*sqrt(12),PortReturn*100*12)
title('Portfolio Effective Frontier')
xlabel('Risk')
ylabel('E[Rp]')

rf=rtbill(60)/1200
s_ratio=(PortReturn-rf)./PortRisk
max(s_ratio)

%%%looping the location where gives the max sharpe ratio
s_ratio=-inf
for i=1:500
    if s_ratio<(PortReturn(i)-rf)/PortRisk(i)
       s_ratio=(PortReturn(i)-rf)/PortRisk(i)
       loc=i
    end
end

%%%plotting together in yearly terms
figure
plot(PortRisk*100*sqrt(12), PortReturn*100*12);
hold on

slope = (PortReturn(loc) - rf) / PortRisk(loc);
x_max = max(PortRisk)*sqrt(12);

% CAL
x_line = [0, x_max] * 100;
y_line = (rf*12 + sqrt(12)*slope * [0, x_max]) * 100;

plot(x_line, y_line, 'b', 'LineWidth', 2);
title('Portfolio Effective Frontier')
xlabel('Risk')
ylabel('E[Rp]')

weight=PortWts()
WT_OPT=PortWts(loc,:)


data2=rStocks(61:72,:)
monthly_average2=mean(data2)
monthly_std2=std(data2)
yearly_average2=monthly_average2*12
yearly_std2=monthly_std2*sqrt(12)
monthly_cov=cov(data2)



NumPorts=500

[PortRisk,PortReturn,PortWts]=portopt(monthly_average2,monthly_cov,NumPorts)

figure
plot(PortRisk*100,PortReturn*100)
title('Portfolio Effective Frontier')
xlabel('Risk')
ylabel('E[Rp]')

rf2=rtbill(end,:)/1200

s_ratio=(PortReturn-rf2)./PortRisk
max(s_ratio)

s_ratio=-inf
for i=1:500
    if s_ratio<(PortReturn(i)-rf2)/PortRisk(i)
       s_ratio=(PortReturn(i)-rf2)/PortRisk(i)
       loc=i
    end
end

weight=ones(1,10)./10

ret=weight*monthly_average2'
monthly_volatility=std(data2(:,:))

variance=weight*(monthly_cov*weight')
volatility=sqrt(variance)
w_T=WT_OPT

ret04=monthly_average2*w_T'*12
var04=w_T*(monthly_cov*w_T')
vol04=sqrt(var04)*sqrt(12)

%%%now to plot them together


figure              


plot(PortRisk*100*sqrt(12), PortReturn*100*12);
hold on


slope = (PortReturn(loc) - rf2)*sqrt(12) / PortRisk(loc);
%%%yearle slope 2
slope2 = (ret04 - rf2*12)/(vol04)


x_max = max(PortRisk)*sqrt(12);           

% CAL
x_line = [0, x_max] * 100;
y_line = (rf2*12 + slope * [0, x_max]) * 100;

plot(x_line, y_line, 'b', 'LineWidth', 2);
plot(x_line, y_line, 'b', 'LineWidth', 2);


plot(PortRisk(loc)*100*sqrt(12), PortReturn(loc)*100*12, 'ko', 'MarkerFaceColor', 'k');
plot(volatility*100*sqrt(12), ret*100*12, 'ko', 'MarkerFaceColor', 'b');
plot(vol04*100, ret04*100, 'ko', 'MarkerFaceColor', 'r');

% CAL
x_line2 = [0, x_max] * 100;
y_line2 = (rf2*12 + slope2 * [0, x_max]) * 100;

plot(x_line2, y_line2, 'r', 'LineWidth', 2);

xlabel('Risk (annually volatility, %)');
ylabel('Expected return (annually, %)');
title('Efficient frontier and Capital Allocation Line');




%%% exercise 6
help portfolio

a=ones(1,12)*0.3    %fijo que el upperbound para cada weight sea 0,3
b=zeros(1,12)       % fijo que el lowerbound sea 0, que no se puede short selling

data
Portfolio()
monthly_return=mean(data(:,1:12))
mat=cov(data)

%create the object with the expected return vector, the cov matrix, and the
%bounds
p = Portfolio('assetmean',monthly_return, 'assetcovar', mat, ...
'lowerbound', b,'upperbound',a)

% Optional: turn on budget constraint, es para marcar que la suma de los
% pesos de 1
p = p.setBudget(1, 1);

% Display Portfolio object
disp(p)

%ask for the extremes of the efficient fronteir, first row the min var
%portfolio weights, the second row is the max return portfolio weights
w_minvar_maxreturn = p.estimateFrontierLimits

%ask the weights of the portfolio with the max sharp rate
w_sharpe = p.estimateMaxSharpeRatio;
w_sharpe


exp_return= monthly_return*w_sharpe*12
w_sharpe=w_sharpe'
variance=w_sharpe*(mat*w_sharpe')
volatility=sqrt(variance)*sqrt(12)


%%% assign value to the component of portfolio
%p.AssetMean=()


%%% portfolio with the same constrain in case 2 (to check if the result is correct)
p = Portfolio('assetmean',monthly_avg , 'assetcovar', mat, ...
'lowerbound', b)
