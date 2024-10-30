function y = my_smf(x, params, n)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    a = params(1);
    b = params(2);
    y = zeros(size(x));
    for i = 1:1:length(y)
        if x(i) <= a
            y(i) = 0;
        elseif (x(i) >= a) && (x(i) <= 0.5*(a+b))
            y(i) = 2^(n-1) * (x(i)-a)^n / (b-a)^n;
        elseif (x(i) >= 0.5*(a+b)) && (x(i) <= b)
            y(i) = 1 - 2^(n-1) * (x(i)-b)^n / (b-a)^n;
        else
            y(i) = 1;
        end
    end
end