% Financial Statistics - Homework 1
% Group 2: Ferdinand Hacker, Adrian G. del Pozo, Enzo Franchini, 
%          Wander S. Rosario & Carlota Bernad

series = xlsread('Homework_1_info.xlsx');

series1 = series(:,1); % -> 5000 obs arranged in 5000x1 vector

series2 = series(:,2); % -> 3013 obs and rest are NaN

% We have NaN obs in series 2 -> thus we must remove it    
series2 = series2(~isnan(series2));

% Summary statistics and first inferences
mean1 = mean(series1);
std1  = std(series1);
mean2 = mean(series2);
std2  = std(series2);
fprintf('Series1: N=%d, Mean=%.5f, Std=%.5f\n', length(series1), mean1, std1);
fprintf('Series2: N=%d, Mean=%.5f, Std=%.5f\n', length(series2), mean2, std2)

% We see series 1 has basically zero mean and super small std while is the
% complete opposite with series 2.. first possible indicator for series 1
% likelihood to be stationary, unlike series 2

%% 1. Is the time series stationary? 
% For a time series to be stationary we need the 3 moments to be constant
% over time: mean, variance & autocorrelation//autocovariance

%Check for Augmented Dickey-Fuller test -> ADF for stationarity. 
% ADF test Null -> H0: non-stationary vs H1: Stationary. Thus if reject
% null -> stationary

figure(1)
plot(series1)
title('Series 1 plot')
[h1, pValue1, stat1] = adftest(series1);
fprintf('Series1 ADF test: p=%.4f, test statistic=%.2f\n', pValue1, stat1);
% Null rejected since p-value < 0.05 -> Thus, Series 1 is stationary

figure(2)
plot(series2)
title('Series 2 plot')
[h1, pValue1, stat1] = adftest(series2);
fprintf('Series2 ADF test: p=%.4f, test statistic=%.2f\n', pValue1, stat1);

% Null failed to be rejected since p-value > 0.05 -> hence, nonstationary
% (in levels at least)

%% 2. Is the series normally distributed?

% Do Jarque-Bera test -> tests if Skewness = 0 related to mean and
% Kurtosis = 3 -> jbtest -> H0: normality (s = 0 & k = 3) vs H1: non-normality

[h_jb1, p_jb1, jbstat1] = jbtest(series1);
fprintf('Series1 Jarque-Bera test: p=%.4g, JB-stat=%.1f\n', p_jb1, jbstat1);

% Jarque-Bera test turns out with a p-value < 1%, thus we reject the null
% and we cannot assume normality for this distribution -> Non-normal

[h_jb1, p_jb1, jbstat1] = jbtest(series2);
fprintf('Series2 Jarque-Bera test: p=%.4g, JB-stat=%.1f\n', p_jb1, jbstat1);

% Jarque-Bera test turns out with a p-value < 1%, thus we reject the null
% and we cannot assume normality for this distribution -> Non-normal

%% Comparison plots,  Series 1 vs Theoretically normal with table data
Ymean = mean(series1);
Ystd  = std(series1);
Yvar  = var(series1);
Yskew = skewness(series1,0);
Ykurt = kurtosis(series1,0);

% Kernel density
[F,Yi] = ksdensity(series1);   % Yi = support points, F = density values
x = linspace(min(series1), max(series1), 500);
xpdf = normpdf(x, Ymean, Ystd);

% Plot
figure;
plot(Yi, F, 'r', 'LineWidth', 2); hold on;
plot(x, xpdf, 'k', 'LineWidth', 1.5); hold off;
title('Density estimate of Series 1');
ylabel('Density');
legend('Smooth density estimate','Theoretical Normal','Location','best');
grid on;

statsTable = table(Ymean, Ystd, Yskew, Ykurt, ...
    'VariableNames', {'Mean','StdDev','Skewness','Kurtosis'});

% Display table
disp(statsTable);

%% Comparison plots,  Series 2 vs Theoretically normal with table data
Xmean = mean(series2);
Xstd  = std(series2);
Xvar  = var(series2);
Xskew = skewness(series2,0);
Xkurt = kurtosis(series2,0);

% Kernel density
[F,Yi] = ksdensity(series2);   % Yi = support points, F = density values
x = linspace(min(series2), max(series2), 500);
xpdf = normpdf(x, Xmean, Xstd);

% Plot
figure;
plot(Yi, F, 'r', 'LineWidth', 2); hold on;
plot(x, xpdf, 'k', 'LineWidth', 1.5); hold off;
title('Density estimate of Series 2');
ylabel('Density');
legend('Smooth density estimate','Theoretical Normal','Location','best');
grid on;

statsTable = table(Xmean, Xstd, Xskew, Xkurt, ...
    'VariableNames', {'Mean','StdDev','Skewness','Kurtosis'});

% Display table
disp(statsTable);

%% 3. Is the series WN, SWN and GWN? 

%% Autocorrelation check for Series1 using sample ACF and Ljung-Box test
figure;
subplot(1,2,1); autocorr(series1, 'NumLags',30); title('Series1 ACF');
subplot(1,2,2); parcorr(series1, 'NumLags', 30); title('Series1 PACF');

% Ljung-Box Q-test for no autocorrelation up to lag 10
[h_lb1, p_lb1, Qstat1] = lbqtest(series1, 'Lags', 20);
fprintf('Series1 Ljung-Box Q(20): p=%.3f, Q-stat=%.2f\n', p_lb1, Qstat1);

% Ljung-Box Q-test bears p-value = 0.06, hence we failt to reject the null, 
% which in this test, H0: No autocorrelation, thus THERE IS NO AUTOCORRELATION,
% implying it is a White Noise

% Furthermore, it is NOT a Gaussian WN, since we have already proven an
% strong non-normality from the series' distribution

% Finally, to check if it is a SWN (we check for squared ACF & PACF to see 
% if the "almost" uncorrelated is just linearly or not). We see it is NOT a
% SWN, because there are significant squared autocorrelations, and
% therefore there is a nonlinear relationship, which consequently implies
% that the distribution cannot be "independent" as per i.i.d states.

series1_sqr = series1.^2;
figure;
subplot(1,2,1); autocorr(series1_sqr, 'NumLags', 30); title('Series1_sqr ACF');
subplot(1,2,2); parcorr(series1_sqr, 'NumLags', 30); title('Series1_sqr PACF');
[h_lb1, p_lb1, Qstat1] = lbqtest(series1_sqr, 'Lags', 20);
fprintf('Series1_sqr Ljung-Box Q(20): p=%.7f, Q-stat=%.2f\n', p_lb1, Qstat1);


%% Autocorrelation check for Series2 using sample ACF and Ljung-Box test
figure;
subplot(1,2,1); autocorr(series2, 'NumLags', 30); title('Series2 ACF');
subplot(1,2,2); parcorr(series2, 'NumLags', 30); title('Series2 PACF');

% Ljung-Box Q-test for no autocorrelation up to lag 10
[h_lb1, p_lb1, Qstat1] = lbqtest(series2, 'Lags', 20);
fprintf('Series2 Ljung-Box Q(20): p=%.3f, Q-stat=%.2f\n', p_lb1, Qstat1);

% Ljung-Box Q-test bears p = 0.000, hence we reject the null, which in this
% test, H0: No autocorrelation, thus THERE IS AUTOCORRELATION, implying it
% is NOT a White Noise. Besides, the ACF & PACF clearly shown a strong
% and persistent autocorrelation.

% Furthermore, it is NOT a Gaussian WN, since we have already proven an
% strong non-normality from the series' distribution

% Finally, to check if it is a SWN: we know there is autocorrelation, hence 
% observations cannot be independent from each other, already violating the     
%  i.i.d assumption -> It is NOT a SWN, since there is a clear linear 
% relationship. 
series2_sqr = series2.^2;
figure;
subplot(1,2,1); autocorr(series2_sqr, 'NumLags', 30); title('Series2_sqr ACF');
subplot(1,2,2); parcorr(series2_sqr, 'NumLags', 30); title('Series2_sqr PACF');

%% 4. Is the series martingale difference? 

% Martingale Difference says: Given/known past obs, the expected value for
% tommorrow has to be zero. In other words, "fair game", -> I cannot know
% tommorrow. E[Y(t)\Y(t-1),...,Y(t-n)] = 0. It is a MD, since we know there
% is zero mean and it is uncorrelated for series 1. On the other hand,
% series 2 is not a MD.

[h,p,ci,stats] = ttest(series1, 0);
disp(p);disp(ci)
[h,p,ci,stats] = ttest(series2, 0);
disp(p);disp(ci)
% Furthermore, series 1 includes 0 in its 95% CI and p-value = 0.87, hence
% we fail to reject. Mean is zero, it is MD

%% 5. The dynamic dependence of the series can be represented by a linear model? 

y = series1(:);                 

% Specify AR(4) with intercept
Mdl = arima('ARLags',1:4,'Constant',NaN,'Variance',NaN);

% Estimate
[EstMdl, EstCov, logL, info] = estimate(Mdl, y, 'Display','off');

% Collect estimates
arCoeffs = cell2mat(EstMdl.AR); % 1x4
params   = [EstMdl.Constant; arCoeffs(:); EstMdl.Variance];
se       = sqrt(diag(EstCov));
tstat    = params ./ se;
pval     = 2*normcdf(-abs(tstat));   % large-sample p-values

% Pretty table
names = {'Constant','AR(1)','AR(2)','AR(3)','AR(4)','Variance'}';
T = table(names, params, se, tstat, pval, ...
    'VariableNames', {'Parameter','Estimate','SE','tStat','pValue'});
disp(T)

res = infer(EstMdl,y);
yhat = y - res;

% R-squared
SSR = sum(res.^2);                 % residual sum of squares
SST = sum( (y - mean(y)).^2 );     % total sum of squares
R2  = 1 - SSR/SST;

fprintf('AR(4) R^2 = %.4f\n', R2);

% First off, the dynamics of the series cannot be represented by a linear
% model as we have seen how the squared ACF and PACF are significant. 
% Furthermore, if we regress an AR(4) model, we see how the 
% R_squared = 0.3% -> SUPER SUPER BAD linear explanatory power

% The pick of an AR(4) is because the 4th lag is a cutoff when checking the
% ACF & PACF
 
%% 6. Are there potential non-linear dependences? 

% For series 1, again we plot the ACF & PACF of the squared where we see
% that there is indeed NON-LINEAR DEPENDENCIES in the series
series1_sqr = series1.^2;
figure;
subplot(1,2,1); autocorr(series1_sqr, 'NumLags', 30); title('Series1_sqr ACF');
subplot(1,2,2); parcorr(series1_sqr, 'NumLags', 30); title('Series1_sqr PACF');

%Series 2
series2_sqr = series2.^2;
figure;
subplot(1,2,1); autocorr(series2_sqr, 'NumLags', 30); title('Series2_sqr ACF');
subplot(1,2,2); parcorr(series2_sqr, 'NumLags', 30); title('Series2_sqr PACF');

%% 7. For the non-stationary time series, justify the proper transformation to stationarity, and respond the same previous questions for the transformed stationary data. 
figure;
series2_logdiff = diff(log(series2));
plot(series2_logdiff)
title('Series 2 plot (after logdifferencing)')
%7.1 -> Stationary?
[h2d, pValue2d] = adftest(series2_logdiff);
fprintf('Log_Diff Series2 ADF p=%.3g (after logdifferencing)\n', pValue2d);

% Dickey-Fuller test for the series 2 after differencing bears a 
% p-value = 0.001, thus we reject the null of Non-stationary, implying we
% have now a stationary series

%7.2 -> Normal?

% Jarque-Bera test shows even though the series has been transformed to
% stationary, it is still non-normal, since p-value = 0.001

[h_jb2d, p_jb2d, jbstat2d] = jbtest(series2_logdiff);
fprintf('Series2_logdiff Jarque-Bera: p=%.4g, JB-stat=%.1f\n', p_jb2d, jbstat2d);

%% Comparison between Series 2 (differentiated) vs Theoretical Normal

Ymean = mean(series2_logdiff);
Ystd  = std(series2_logdiff);
Yvar  = var(series2_logdiff);
Yskew = skewness(series2_logdiff,0);
Ykurt = kurtosis(series2_logdiff,0);

% Kernel density
[F,Yi] = ksdensity(series2_logdiff);   % Yi = support points, F = density values
x = linspace(min(series2_logdiff), max(series2_logdiff), 500);
xpdf = normpdf(x, Ymean, Ystd);

% Plot
figure;
plot(Yi, F, 'r', 'LineWidth', 2); hold on;
plot(x, xpdf, 'k', 'LineWidth', 1.5); hold off;
title('Density estimate of Series 2 (after logdifferencing)');
ylabel('Density');
legend('Smooth density estimate','Theoretical Normal','Location','best');
grid on;

statsTable = table(Ymean, Ystd, Yskew, Ykurt, ...
    'VariableNames', {'Mean','StdDev','Skewness','Kurtosis'});

% Display table
disp(statsTable);

%% 7.3 -> WN, SWN or GWN?

figure;
subplot(1,2,1); autocorr(series2_logdiff,'NumLags', 30); title('Series2 LogDiff ACF');
subplot(1,2,2); parcorr(series2_logdiff, 'NumLags', 30); title('Series2 LogDiff PACF');
[h_lb2d, p_lb2d] = lbqtest(series2_logdiff, 'Lags', 20);
fprintf('Series2_Logdiff Ljung-Box Q(20): p=%.3g\n', p_lb2d);

% There is No autocorrelation as depicted in the plots. Plus, Ljung-Box test is a   
% p-value = 0.09, greater than 5% significance level, hence we fail to
% reject the null for NO autocorrelation. 

% We have zero mean (constant), and a constant variance and an uncorrelated
% process, hence we have a WN. But it is not GWN since we already know from
% Jarque-Bera test the distribution is non-normal. Besides, kurtosis = 14.

% Finally, to check whether it is a SWN, we look at the squared
% autocorrelations, and we see there is autocorrelation, both, graphically
% and through the Jarque-Bera test, where we reject the null of NO
% AUTOCORRELATION with a p-value = 0

% 7.4 Is it a Martingale Difference?

%It is not a MD since the mean is statistically different from zero, we do
%a t-test to check whther H0: mean = 0 and we reject the null with a
%p-value = 0.0315
[h,p,ci,stats] = ttest(series2_logdiff, 0);
disp(p);disp(ci)

%% 7.5 Linear model dynamics? + 7.6 Nonlinear model?

% Check if there is other possible non-linear relationship

series2_logdiff_sqr = series2_logdiff.^2;
figure;
subplot(1,2,1); autocorr(series2_logdiff_sqr,'NumLags', 30); title('Series2 Logsqr Diff ACF');
subplot(1,2,2); parcorr(series2_logdiff_sqr, 'NumLags', 30); title('Series2 Logsqr Diff PACF');

[h_lb2d, p_lb2d] = lbqtest(series2_logdiff, 'Lags', 20);
fprintf('Series2_Logdiff Ljung-Box Q(20): p=%.3g\n', p_lb2d);

[h_lb2d, p_lb2d] = lbqtest(series2_logdiff_sqr, 'Lags', 20);
fprintf('Series2_Logdiffsqr Ljung-Box Q(20): p=%.3g\n', p_lb2d);

% There is in fact a NON-LINEAR significant relationship, (squared autocorrelations are 
% strongly significant). Hence, despite there been autocorrelation, the
% series would be better explained under a non-linear model, as per proven
% in the plots for the squared ACF & PACF 
