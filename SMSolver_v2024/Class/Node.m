classdef Node < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        x;
        y;
        z;
        rxx;
        ryy;
        rzz;

        x_d;
        y_d;
        z_d;
        rxx_d;
        ryy_d;
        rzz_d;

        b_x=0;
        b_y=0;
        b_z=0;
        b_rxx=0;
        b_ryy=0;
        b_rzz=0;
    end

    methods
        function obj = Node(x,y,z,rxx,ryy,rzz)
            obj.x=x;
            obj.y=y;
            obj.z=z;
            obj.rxx=rxx;
            obj.ryy=ryy;
            obj.rzz=rzz;
        end

    end
end