function student_debt_wrapper()

% This file is associated with the book
% "Machine Learning Refined", Cambridge University Press, 2016.
% by Jeremy Watt, Reza Borhani, and Aggelos Katsaggelos.

% load in data
data = csvread('student_debt_data.csv');
x = data(:,1);
y = data(:,2);
x_tilde = [ones(length(x),1) x]';

% plot data 
figure(1)
scatter(x_tilde(2,:),y,40,'fill','MarkerFaceColor','k');
hold on

% solve Least Squares
w_tilde = pinv(x_tilde*x_tilde')*(x_tilde*y);
b = w_tilde(1)
w = w_tilde(2)
model =  [2004:1:2015]';
out = b + w*model;

% plot fit
plot(model,out,'m','LineWidth',1.5)
box on
set(gcf,'color','w');
set(gca,'FontSize',12);
axis([2004 2015 0.2 1.3])
ylabel('Student debt in trillions of dollars','Fontsize',14,'FontName','cmr10')
xlabel('Year','Fontsize',14,'FontName','cmr10')
end