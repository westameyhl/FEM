classdef BridgeVib < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        node_list;
        element_list;
        n_node;
        n_element;
        M;
        K;
        C;
        N;
        F;
        F_rec;
        K_rec;
        alpha;
        beta;
        nDOF;
        boundary;
        x;
        all_x;
        x_disprot;

    end

    methods
        function obj = BridgeVib(L, n, EIA, dense, f, f_loc)


%             L = 5.4;
            obj.n_element = n;

            obj.alpha = 0;
            obj.beta = 0;

            obj.n_node = obj.n_element + 1;
            e_length = L / obj.n_element;


            obj.node_list = cell(obj.n_node,2);
            for i = 1:1:obj.n_node
                obj.node_list{i,1} = i;
                obj.node_list{i,2} = Node((i-1)*e_length,0,0,0,0,0);
            end
            obj.element_list = cell(obj.n_node-1, 1);
            for i = 1:1:obj.n_element
                obj.element_list{i,1} = i;
                if and((i-1)*e_length <= f_loc, i*e_length > f_loc)
                    obj.element_list{i,2} = OneDimElement(obj.node_list{i,2},obj.node_list{i+1,2},EIA(i,1),EIA(i,2),EIA(i,3),dense, f,f_loc-(i-1)*e_length);
                    obj.element_list{i,2}.element_number = i;
                else
                    obj.element_list{i,2} = OneDimElement(obj.node_list{i,2},obj.node_list{i+1,2},EIA(i,1),EIA(i,2),EIA(i,3),dense, 0,0);
                    obj.element_list{i,2}.element_number = i;
                end

                obj.element_list{i,2}.expand_k(obj.n_element);
            end


            obj.nDOF = 2 * obj.n_node;
            obj.K = sparse(zeros(obj.nDOF));
            obj.F = sparse(zeros(obj.nDOF, 1));
            obj.M = sparse(zeros(obj.nDOF));

            obj.get_KF();
            obj.get_M();

        end

        function obj = get_KF(obj)
            id_dof = 1;
            for i = 1:1:obj.n_element
                eDOF = obj.element_list{i,2}.eDOF;
                obj.K(id_dof:id_dof+eDOF-1, id_dof:id_dof+eDOF-1) = obj.K(id_dof:id_dof+eDOF-1, id_dof:id_dof+eDOF-1) + obj.element_list{i,2}.k_mat;
                obj.F(id_dof:id_dof+eDOF-1) = obj.F(id_dof:id_dof+eDOF-1) + obj.element_list{i,2}.f_mat;
                id_dof = id_dof + 2;
            end
            obj.F_rec = full(obj.F);
            obj.K_rec = full(obj.K);

        end


        function obj = get_M(obj)

            id_dof = 1;
            for i = 1:1:obj.n_element
                eDOF = obj.element_list{i,2}.eDOF;
                obj.M(id_dof:id_dof+eDOF-1, id_dof:id_dof+eDOF-1) = obj.M(id_dof:id_dof+eDOF-1, id_dof:id_dof+eDOF-1) + obj.element_list{i,2}.m_mat;
                id_dof = id_dof + 2;
            end

        end


        function obj = add_boundary(obj, boundary)

            obj.boundary = boundary;
            k_u = obj.K;
            f_u = obj.F;
            m_u = obj.M;

            for i = size(boundary,1):-1:1
                if boundary(i,1) == 1
                    k_u = k_u(2:end,2:end);
                    m_u = m_u(2:end,2:end);
                    f_u = f_u(2:end);
                elseif boundary(i,1) == length(f_u)
                    k_u = k_u(1:end-1,1:end-1);
                    m_u = m_u(1:end-1,1:end-1);
                    f_u = f_u(1:end-1);
                else
                    i_b = boundary(i,1);
                    k_u = [k_u(1:i_b-1,1:i_b-1), k_u(1:i_b-1,i_b+1:end); k_u(i_b+1:end,1:i_b-1), k_u(i_b+1:end,i_b+1:end)];
                    m_u = [m_u(1:i_b-1,1:i_b-1), m_u(1:i_b-1,i_b+1:end); m_u(i_b+1:end,1:i_b-1), m_u(i_b+1:end,i_b+1:end)];
                    f_u = [f_u(1:i_b-1); f_u(i_b+1:end)];
                end
            end

            obj.K = k_u;
            obj.M = m_u;
            obj.F = f_u;
            obj.C = obj.alpha * obj.M + obj.beta * obj.K;
%             obj.nDOF = obj.nDOF - 1;
        end

        function obj = solveKXF(obj)

            obj.x = - obj.K \ obj.F;
            
            a_x = zeros(obj.nDOF, 2);
            for j = 1:1:size(obj.boundary,1)
                a_x(obj.boundary(j,1),1) = obj.boundary(j,2);
                a_x(obj.boundary(j,1),2) = 1;
            end

            i_cur = 1;
            for i = 1:1:obj.nDOF
                if a_x(i,2) == 0
                    a_x(i,1) = obj.x(i_cur);
                    a_x(i,2) = 1;
                    i_cur = i_cur + 1;
                end
            end
            obj.all_x = a_x;

            x_dr = zeros(obj.n_node,2);
            for i = 1:1:obj.n_node
                x_dr(i,1) = a_x(i*2-1);
                x_dr(i,2) = a_x(i*2);
            end
            obj.x_disprot = x_dr;

            % for i = 1:1:obj.n_element
            %     obj.element_list{i,2}.f_expand = obj.element_list{i,2}.k_expand * obj.all_x(:,1);
            % end

        end

    end
end