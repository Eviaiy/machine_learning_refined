function breast_cancer_wrapper()

% This file is associated with the book
% "Machine Learning Refined", Cambridge University Press, 2016.
% by Jeremy Watt, Reza Borhani, and Aggelos Katsaggelos.

% load data
[X,y] = load_data();

% run iterative grad
run_grads(X,y);

%%%%%%%%%%%%%%% subfunctions %%%%%%%%%%%
%%% compare grad descents %%% 
function run_grads(X_orig,y)
    % learn filters
    max_its = 10;
    X = [ ones(size(X,1),1), X];
    X = X';
    w0 = randn(size(X,1),1)/10;
    
    [mis,obj,w] = softmax_newtons_method(X,y,w0,max_its);
    plot_it(mis,obj,'g',1)
   

    [mis,obj,w] = squared_hinge_newtons_method(X,y,w0,max_its);
    plot_it(mis,obj,'m',1) 
    
    legend('softmax','squared margin')
   
end

function [mis,obj,w] = softmax_newtons_method(X,y,w,max_its)
    % precomputations
    H = bsxfun(@times,X',y);
    mis = [];
    obj = [];
    
    % caclulate number of misclassifications at current iteration
    s = X'*w;
    t = sum(max(0,sign(-y.*s)));
    mis = [mis; t];

    % calculate objective value at current iteration
    s = y.*s;
    s = sum(log(1 + exp(-s))); 
    obj = [obj; s];  
        
    k = 1;
    %%% main %%%
    while k < max_its
        
        % prep gradient for logistic objective
        r = sigmoid(-H*w);
        g = r.*(1 - r);
        grad = -H'*r;
        hess = bsxfun(@times,g,X')'*X';

        % take Newton step
        temp = hess*w - grad;
        w = pinv(hess)*temp;
        k = k + 1;
        
        % caclulate number of misclassifications at current iteration
        s = X'*w;
        t = sum(max(0,sign(-y.*s)));
        mis = [mis; t];

        % calculate objective value at current iteration
        s = y.*s;
        s = sum(log(1 + exp(-s))); 
        obj = [obj; s];  

    end
    
    function t = sigmoid(z)
        t = 1./(1 + my_exp(-z));
    end
    
    function s = my_exp(input)
        a = find(input > 100);
        b = find(input < -100);
        input(a) = 0;
        input(b) = 0;
        s = exp(input);
        s(b) = 1;
    end
end

%%% gradient descent function for squared hinge loss %%%
function [mis,obj,w] = squared_hinge_newtons_method(X,y,w,max_its)
    % Initializations 
    l = ones(size(X,2),1);

    % precomputations
    H = bsxfun(@times,X',y);
    mis = [];
    obj = [];
    
    % caclulate number of misclassifications at current iteration
    s = X'*w;
    t = sum(max(0,sign(-y.*s)));
    mis = [mis; t];

    % calculate objective value at current iteration
    s = y.*s;
    s = sum(max(0,1 - s).^2); 
    obj = [obj; s];  
    k = 1;
    
    while k < max_its
        
        % form gradient
        temp = l-H*w;
        grad = -2*H'*max(l-H*w,0);
        
        % form Hessian
        s = find(temp > 0);
        X_temp = X(:,s);
        hess = 2*(X_temp*X_temp');
        
        % take Newton step
        temp = hess*w - grad;
        w = pinv(hess)*temp;
                
        % caclulate number of misclassifications at current iteration
        s = X'*w;
        t = sum(max(0,sign(-y.*s)));
        mis = [mis; t];

        % calculate objective value at current iteration
        s = y.*s;
        s = sum(max(0,1 - s).^2); 
        obj = [obj; s];  
        k = k + 1;
    end
end



end

%%% plots descent levels %%%
function plot_it(mis,obj,color,width)
    % plot all
    subplot(1,2,1)
    start = 2;
    hold on
    plot(start:length(mis),mis(start:end),'Color',color,'LineWidth',width);
    title('# of misclassifications')
    box off
    
    subplot(1,2,2)
    hold on
    plot(start:length(obj),obj(start:end),'Color',color,'LineWidth',width);
    title('objective value')
    set(gcf,'color','w');
    box off
    
    % last adjustments to plot    
    subplot(1,2,1)
    axis tight
    set(gca,'FontSize',14)
    xlabel('iteration','FontSize',18)
    ylabel('number of misclassifications','FontSize',18)
    
    subplot(1,2,2)
    axis tight
    set(gca,'FontSize',14)
    xlabel('iteration','FontSize',18)
    ylabel('objective value','FontSize',18)
end

%%% load data %%%
function [X, y] = load_data()    
      
    %%% real face dataset %%%
    data = csvread('breast_cancer_dataset.csv');
    X = data(:,1:end-1);
    X(:,6) = [];        % remove feature with incomplete data
    y = data(:,end);
 
end


