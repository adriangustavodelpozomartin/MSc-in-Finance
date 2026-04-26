%------------------------------------------------------------------------
%   CASE 3: WORKING WITH MARKOWITZ
%
%   By David Moreno (2020)
%------------------------------------------------------------------------

% We import the data from .mat 
%clear all
%load dataCase3.mat
%--Definitions:
% rStocks: Matrix with returns from 10 stocks (size 72x10)
% rBond10y: Annualize yield of bonds 10 years maturity
% rBond5y: Annualize yield of bonds 10 years maturity
% rtbill: Annualize yield of Treasury Bills (6 months maturity)
% Tbills is goingo to be our Risk Free Asset, and Bonds are risky assests

%We transform the data in montly returns
rBond10y=rBond10y/(12*100);   
rBond5y=rBond5y/(12*100);
rtbill=rtbill/(12*100);
% rend= Matrix with every risky asset (stocks+bonds)
rend=[rStocks rBond10y rBond5y];


%-----    QUESTION 1    ---------------------
%We compute the monthly expected returns and volatilities.
mR=mean(rend);
stdR=std(rend);

%We anualized the data and transform to percentages (%)
mR_year=mR*12*100;
stdR_year=stdR*sqrt(12)*100;
%We do a table with the risk and return information
Table_Q1_month=[mR; stdR];
Table_Q1_year=[mR_year; stdR_year];

%We do a graph with risk and return information (we only do it for annual
%terms, as it is more common to publish only the annualized data)
figure(1)
subplot(2,1,1)
bar(mR_year)
title('Expected Returns for 10 American stocks and 2 Bonds')
axis tight    %This sets the axis limits to the range of the data.
subplot(2,1,2)
bar(stdR_year)
title('Volatility for 10 American stocks and 2 Bonds')
axis tight

%-----    QUESTION 2    ---------------------
%An Equaly-Weighted Portfolio
[fi,co]=size(rend);
w=ones(1,co)*(1/co)
RpEW=mR*w';
S=cov(rend);
VarRpEW=w*S*w';
StdRpEW=sqrt(VarRpEW);
%We annualize the data 
StdRpEW_year=StdRpEW*sqrt(12)*100;
RpEW_year=RpEW*12*100;
%-----    QUESTION 3    ---------------------
%Using the portopt function
%If we use it without output arguments, we get the graph directly 
figure(2)
portopt(mR,S,20)


%-----    QUESTION 4    ---------------------
%Using the portopt function
%If we use  output arguments, we get the portfolio Expected Returns and
%Volatility. From those values we can compute the Sharpe Ratio and chose
%the portfolio with the highest Sharpe Ratio.
% we use EF to indicate Efficient Frontier (e.g. Volat_EF, volatility of
% portfolios along the Efficient Froniter).
[Volat_EF,R_EF,W_EF]=portopt(mR,S,500);
%Sharpe Ratio
%In order to compute the Sharpe Ratio, we need the Rf (Risk Free Rate), and
%it will be the Treasury Bills. But we do not have to do an average of
%historical Tbills. It does not not make any sense. In the case of tbills
%we know exactly the return it will pay us. Therefore, we must only take
%the last one (in this case dec-2005). 
Rf=rtbill(72);
Sharpe_EF=(R_EF-Rf)./Volat_EF;
%We use sort for ranking the Sharpe ratios and find the highest one (the
%last one)
[value,ind]=sort(Sharpe_EF);
%The tangent portfolio is the portfolio in the last place (ind(500))
%But we also use the max command. You can use any of these commands. 
[T2,ind2]=max(Sharpe_EF)

disp(['The Tangent Portfolio is the number ' num2str(ind2) ' in the EF'])
disp(['This portfolio has a Sharpe Ratio equals to ' num2str(T2)])
disp(' Here we have the annualize returns and risk for the Tangent Portfolio:')
Rp_Tangent=R_EF(ind2)*12*100
Volat_Tangent=Volat_EF(ind2)*sqrt(12)*100
W_Tangent=W_EF(ind2,:)


%-----    QUESTION 5   (out-of-sample) ---------------------
% In order to observe differences between the insample and out-of-sample we
% must use ONLY stocks returns. 
% We select the first 10 columns
INdata=1:60;
OUTdata=61:72;
rend_IN=rend(INdata,:);
rend_OUT=rend(OUTdata,:);
% We must compute the securities mean return and covariance from 2000 to
% 2004 (it is observations 1 to 60).
mR_IN=mean(rend_IN);
S_IN=cov(rend_IN);
[Volat_EFin,R_EFin,W_EFin]=portopt(mR_IN,S_IN,500);
%The Risk-free here is not the Rf in 2005 but in 2004
Rf_IN=rtbill(60);
Sharpe_EFin=(R_EFin-Rf_IN)./Volat_EFin;
%we  use the max command to find the highest Sharpe Ratio
[T3,ind3]=max(Sharpe_EFin);
%Therefore, we choose the weights of the tangent portfolio
%ind3 = index (position) of the tangent portfolio in the efficient frontier
WT_in=W_EFin(ind3,:);
%---out-of sample evaluation----
%We use the tangent portfolio weights with the data of the next year (OUT)
% Rp_OUT are the monthly returns of this portfoio in 2005 (we have 12
% observations because there are 12 months in 2005)
Rp_OUT=(WT_in*rend_OUT')';
%In order to evaluate the performance of this portfolio we could compute
%its risk and return in 2005
mRp_OUT=mean(Rp_OUT);
stdRp_OUT=std(Rp_OUT);
%We can plot together the efficient frontier in 2005, the returns of an
%Equally-Weighted Portfolio in 2005, and the results of our portfolio
%(Tangent Portfolio) using only data from 2000-2005. 
mR_2005=mean(rend_OUT);
S_2005=cov(rend_OUT);
[Volat_EF2005,R_EF2005,W_EF2005]=portopt(mR_2005,S_2005,500);
%We can get the equally-weighted returns also with the transpose of the
%returns and the mean. 
EW_Rp=mean(rend_OUT')';
mEW_Rp=mean(EW_Rp);
stdEW_Rp=std(EW_Rp);
% --Making a figure with all these results
%-- We must do a figure in ANNUAL TERMS AND %, so we anualized the data 
figure
plot(Volat_EF2005*sqrt(12)*100, R_EF2005*12*100,'-+b')  %We do the efficient frontier in blue
hold on
plot(stdEW_Rp*sqrt(12)*100, mEW_Rp*12*100, 'sr')  %Plot the EW portfolio with a square and red
plot(stdRp_OUT*sqrt(12)*100, mRp_OUT*12*100, 'go') %Plot the results of the tangent portfolio (green)
xlabel('volatility annual')
ylabel('returns annual')
legend('Efficient Frontier with 2005 data', 'EW portfolio', 'Tangent portfolio using data from 2000-04')


%-----    QUESTION 6   (Using Portfolio command) ---------------------
p = Portfolio('assetmean',mR,'assetcovar',S);
ub = [ones(12,1)*(0.30)]; 
p = setDefaultConstraints(p);
p.UpperBound=ub;
NumPorts=100;
W2 = estimateFrontier(p, NumPorts); 
[pRisk2,pReturn2] = estimatePortMoments(p, W2);
plotFrontier(p)
Sharpe_EF_Q6=(pReturn2-Rf)./pRisk2;
[T3,ind3]=max(Sharpe_EF_Q6)
Rp_Tangent_Q6=pReturn2(ind3)*12*100
Volat_Tangent_Q6=pRisk2(ind3)*sqrt(12)*100
W_Tangent_Q6=W2(:,ind3)

disp('----------- We have finished this exercise¡¡¡   -------')






