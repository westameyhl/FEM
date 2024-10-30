classdef OneDimElement < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        element_number;
        start_node;
        end_node;
        k_mat;
        f_mat;
        m_mat;
        E;
        I;
        A;
        F = 0;
        ele_length;
        dense;
        eDOF;
        k_expand;
        f_expand;

    end

    methods
        function obj = OneDimElement(start_node, end_node, E, I, A, dense,ft,f_loc)

            obj.start_node = start_node;
            obj.end_node = end_node;
            obj.E = E;
            obj.A = A;
            obj.I = I;
            obj.ele_length = abs(start_node.x - end_node.x);
            obj.k_mat = 2*obj.E*obj.I/obj.ele_length^3*[   6,      3*obj.ele_length,   -6,     3*obj.ele_length;
                            3*obj.ele_length,   2*obj.ele_length^2, -3*obj.ele_length,  obj.ele_length^2;
                            -6,     -3*obj.ele_length,  6,      -3*obj.ele_length;
                            3*obj.ele_length,   obj.ele_length^2,   -3*obj.ele_length,  2*obj.ele_length^2];    % beam element K

            obj.dense = dense;
            obj.m_mat = dense*obj.A*obj.ele_length/420*[   156,    22*obj.ele_length,  54,     -13*obj.ele_length;
                                22*obj.ele_length,  4*obj.ele_length^2, 13*obj.ele_length,  -3*obj.ele_length^2;
                                54,     13*obj.ele_length,  156,    -22*obj.ele_length;
                                -13*obj.ele_length, -3*obj.ele_length^2,-22*obj.ele_length, 4*obj.ele_length^2];    % beam element M
            
            if ft == -1
                obj.F = obj.dense * obj.A * 9.8;
                obj.f_mat = obj.F * obj.ele_length * [1/2; 1/12; 1/2; -1/12];
            else
                obj.F = ft;
                l1 = 1 - 3*f_loc^2 / obj.ele_length^2 + 2*f_loc^3 / obj.ele_length^3;
                l2 = f_loc - 2*f_loc^2 / obj.ele_length + f_loc^3 / obj.ele_length^2;
                r1 = 3*f_loc^2 / obj.ele_length^2 - 2*f_loc^3 / obj.ele_length^3;
                r2 = - f_loc^2 / obj.ele_length + f_loc^3 / obj.ele_length^2;
                obj.f_mat = obj.F * [l1; l2; r1; r2];
                % obj.f_mat = obj.f_mat + obj.dense * obj.A * 9.8 * obj.ele_length * [1/2; 1/12; 1/2; -1/12];
            end

            obj.eDOF = 4;

        end


        function obj = expand_k(obj, n_ele)
            i_len = obj.eDOF/2;
            obj.k_expand = zeros((n_ele+1)*i_len);
            i_st = obj.element_number*i_len -1;
            obj.k_expand(i_st:i_st+obj.eDOF-1,i_st:i_st+obj.eDOF-1) = obj.k_mat;

        end

    end
end