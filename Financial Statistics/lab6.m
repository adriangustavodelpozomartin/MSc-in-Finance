[data,txt,all]=xlsread('Lab6Data.xlsx','BrentDated');
brent_spot =data;
plot(brent_spot)
title('Brent Dated spot prices')

% ACF for the Brent Dated spot prices and for the first regular difference 

H=30; % number of autocorrelations to compute
subplot(2,1,1)
autocorr(brent_spot,NumLags = H)
title('ACF for spot prices') 
dif_brent_spot=diff(brent_spot,1); subplot(2,1,2) 
autocorr(dif_brent_spot, NumLags = H) 
title('ACF for dif spot prices')

r=diff(log(brent_spot),1);
%series of returns equivalent to price2ret
% Some descriptive analysis of returns plot(r, 'k')
tit = title('Daily Brent Dated returns') 
set(tit,'FontSize',16);
set(gca, 'Fontsize', 16) 
xlabel('time')

% As we knew, the series of returns looks already stationary. Is it already WN? Mean=mean(r)
Standard_deviation = std(r) 
Skewnes = skewness(r) 
Kurtosis = kurtosis(r)
% Jarque-Vera Normality test 
[hypor, pr, t_obs] = jbtest(r);

subplot(3,1,1) 
autocorr(r, NumLags = 40)
tit=title('ACF of r_t'); 
set(tit,'FontSize',16); 
set(gca, 'Fontsize', 16)
subplot(3,1,2) 
parcorr(r, NumLags = 40)
tit=title('PACF of r_t'); 
set(tit,'FontSize',16); 
set(gca, 'Fontsize', 16)
subplot(3,1,3) 
autocorr(r.^2, NumLags = 40)
tit=title('ACF of r^2_t') ; 
set(tit,'FontSize',16); 
set(gca, 'Fontsize', 16);

alpha=0.05;
lags=1:10; 
[Hypo_r,pv_r,stat_r]=lbqtest(r,Lags = lags,Alpha = alpha);

Spec1=arima(0,0,1);
% Spec1.Variance=garch(0,0);
Fit=estimate(Spec1,r);
[a_hat,v_estimated]=infer(Fit,r); % we estimate the residuals for the linear model
% v_estimated: conditional variance estimation
% How can we choose among the possible statistically significant alternative models at hand? % Diagnosis for the linear residuals coming from the fitted ARMA model
% Plot the series of linear residuals
plot(a_hat)
title('Residuals for the linear model')
Mean=mean(a_hat) 
Standar_deviation=std(a_hat) 
Skewness=skewness(a_hat) 
Kurtosis=kurtosis(a_hat)
H=30; 
subplot(2,1,1)
autocorr(a_hat,NumLags = H)
tit=title('ACF of linear residuals') 
set(tit,'FontSize',16);
set(gca, 'Fontsize', 16)
subplot(2,1,2) 
parcorr(a_hat,Numlags = H)
tit=title('PACF of linear residuals') 
set(tit,'FontSize',16);
set(gca, 'Fontsize', 16)



