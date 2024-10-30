function [w, b] = gererate_wb(x, y, m)
    % m th order poly

    w = zeros(m+1);
    b = zeros(m+1, 1);
    for i = 1:1:m+1
        % get w
        for j = 1:1:m+1
            if ~(i == 1 && j == 1) 
                w(i,j) = sum(x.^(i+j-2));
            else
                w(i,j) = length(x);
            end
        end
        % get b
        if i ~= 1
            b(i) = sum(y.*(x.^(i-1)));
        else
            b(i) = sum(y);
        end 
    end

end