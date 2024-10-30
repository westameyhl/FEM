function b = self_dif(a)
    b = zeros(length(a),1);
    for i = 1:1:length(a)-1
        b(i) = a(i+1) - a(i);
    end
    b(end) = b(end-1);
end 