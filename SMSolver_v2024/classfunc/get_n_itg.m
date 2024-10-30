function [n_itg, itg_true] = get_n_itg(itg_list)

    n_itg = 0;
    itg_true = [0,0];
    if isnumeric(itg_list)
        j = 1;

        for i = 1:1:size(itg_list, 1)
            if itg_list(i,1) ~= 0
                itg_true(j,:) = itg_list(i,:);
                j = j + 1;
            end
        end
        if itg_true(1,1) ~= 0
            n_itg = size(itg_true, 1);
        end
    end

end

