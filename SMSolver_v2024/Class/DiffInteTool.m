classdef DiffInteTool < handle
    % solve difference and integrate numerically

    properties
        x;
        n;
        x_dif;
        n_dif;
        x_int;
        n_int;
        x_all;

    end

    methods
        function obj = DiffInteTool(x_orig)
            obj.x = x_orig;
            obj.n = length(x_orig);
        end


        function obj = get_dif(obj, n_order)
            % 注意： 这个是逆序！
            y = zeros(obj.n, n_order);
            obj.n_dif = n_order;
            k = obj.x;
            for i = 1:1:n_order
                k = self_dif(k);
                y(:,end-i+1) = k;
            end
            obj.x_dif = y;

        end

        function obj = get_int(obj, n_order)
            obj.n_int = n_order;
            y = zeros(obj.n, n_order);
            k = obj.x;
            for i = 1:1:n_order
                k = self_int(k);
                y(:,i) = k;
            end
            obj.x_int = y;

        end

        function obj = combine_all(obj)

            y = zeros(obj.n, obj.n_dif+1+obj.n_int);
            y(:,1:obj.n_dif) = obj.x_dif;
            y(:,obj.n_dif+1) = obj.x;
            y(:,obj.n_dif+2:end) = obj.x_int;
            obj.x_all = y;

        end

        function obj = normalize_all(obj)
            for i = 1:1:size(obj.x_all,2)
                obj.x_all(:,i) = obj.x_all(:,i) / max(abs(obj.x_all(:,i)));
            end

        end

    end
end