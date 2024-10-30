classdef MatStruProp < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        EIA;
        n_element;
        l_rate;
        i_mse;
    end

    methods

        function obj = MatStruProp(n, l_rate, EIA)
            % create and initialize EIA to 1

            obj.n_element = n;
            obj.l_rate = l_rate;
            obj.EIA = EIA;
        end


        function obj = update_EIA(obj, mat_exp, mat_fem, i_EIA, disprot)
            % input 2 matrix, calculate mse, find gradient, update EIA
            % i_EIA: 1 for E, 2 for I, 3 for A

            obj.i_mse = immse(mat_exp, mat_fem);
%             mat_exp = mat_exp / max(abs(mat_exp));
%             mat_fem = mat_fem / max(abs(mat_fem));
% hold on
% plot(mat_exp(:,1))
% plot(mat_fem(:,1))
% legend("experiment", "FEM", Location="southeast");
% xlabel('location(m)')
% ylabel('displacement (m)')
% title(strcat('Deformation in experiment and FEM'))
            for i = 4:1:obj.n_element-4
                i_ratio = abs((mat_fem(i, disprot) + mat_fem(i+1, disprot)) / (mat_exp(i, disprot) + mat_exp(i+1, disprot)));
                if i_ratio <= 1 && i_ratio >= 0
                    up_rate = 1 - (1-i_ratio) * obj.l_rate(i);
                elseif i_ratio > 1
                    up_rate = 1;
                    up_rate = 1 + (i_ratio-1) * obj.l_rate(i);
                end
                
                obj.EIA(i,i_EIA) = obj.EIA(i,i_EIA) * up_rate;
                if  obj.EIA(i,i_EIA) > 2.06e11
                     obj.EIA(i,i_EIA) = 2.06e11;
                end

            end


        end



 
    end
end