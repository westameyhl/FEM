classdef DeformFEM < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        mat_route;
        work_route;
        L;
        deform_data;
        n_data;
        nrow;
        ncol;
        dx;   % distance of observing points
        is_modified;
    end


    methods
        function obj = DeformFEM(mat_route, work_route)
            % initialize
            % load '.mat' file
            obj.mat_route = mat_route;
            obj.work_route = work_route;
            deform_data = load(mat_route);
            obj.deform_data = deform_data.ALLDataFEM;
            obj.n_data = size(obj.deform_data, 1);
            obj.L = 5.4;
            obj.nrow = size(obj.deform_data{1,3}, 1);
            obj.ncol = size(obj.deform_data{1,3}, 2);
            obj.dx = obj.L / obj.ncol;
            if size(obj.deform_data, 2) > 5
                obj.is_modified = 1;
            else
                obj.is_modified = 0;
            end

        end


        function obj = modify_data(obj)

            for i = 1:1:size(obj.deform_data, 1)
                % 5 for disp
                obj.deform_data{i,5} = zeros(obj.nrow, obj.ncol);
                loc = cell2mat(obj.deform_data{i,3}(1,2:end));
                obj.deform_data{i,5}(1, 2:end) = loc;
                obj.deform_data{i,5}(2:end, 1) = cell2mat(obj.deform_data{i,3}(2:end, 1));
                % 6 for tan rot
                obj.deform_data{i,6} = obj.deform_data{i,5};
                loc = 0.5 * ([0,loc] + [loc, obj.L]);
                obj.deform_data{i,6}(1, 2:end+1) = loc;
                % 7 for rad rot
                obj.deform_data{i,7} = obj.deform_data{i,6};
            
                for j = 2:1:size(obj.deform_data{i,3},1)
                    dp = -cell2mat(obj.deform_data{i,3}(j,2:end))/1000;
                    dpy = ([dp,0] - [0,dp])/obj.dx;
                    dpy2 = atan(([dp,0] - [0,dp])/obj.dx);
            
                    obj.deform_data{i,5}(j, 2:end) = dp;
                    obj.deform_data{i,6}(j, 2:end) = dpy;
                    obj.deform_data{i,7}(j, 2:end) = dpy2;
                end
            end
            ALLDataFEM = obj.deform_data;
            save(obj.mat_route,'ALLDataFEM');
        end


        function plot_static(obj, fig_route)

            %  plot together
            fig_route = strcat(obj.work_route, fig_route);
            x_disp = [0,obj.deform_data{1,5}(1,2:end),obj.L];
            x_rot = obj.deform_data{1,6}(1,2:end);

            for i = 1:1:obj.n_data
                y_disp = [0, obj.deform_data{i,5}(2,2:end), 0];
                y_rot = obj.deform_data{i,6}(2,2:end);
                i_fig = figure(i);
                hold on
                plot(x_disp, 0.4*y_disp);
                plot(x_rot, 0.4*y_rot)
                legend("shape", "tilt", Location="northwest");
                xlabel('location(m)')
                ylabel('value (m, rad)')
                ylim([-0.025 0.015])
                title(strcat(obj.deform_data{i,1}{1,1}, '(FEM)'))
                fig_name = strcat(fig_route, 'fem_', obj.deform_data{i,1}{1,1}, '_.jpg');
                saveas(i_fig, fig_name);
                close(i_fig);
            end

        end


    end


end