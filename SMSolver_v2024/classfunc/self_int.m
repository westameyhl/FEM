function b = self_int(a)
    b = zeros(length(a),1);
    for i = 1:1:length(a)-1
        b(i+1) = b(i) + 0.5 * (a(i+1)+a(i));
    end
end 