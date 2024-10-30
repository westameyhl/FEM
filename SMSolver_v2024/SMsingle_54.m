% function disp_7 = SMsingle_54(n, EIA_rate)
    % addpath(genpath('Class'));
    % addpath(genpath('classfunc'));
    
function disp_7 = SMsingle_54()
    clear;
    clc;
    addpath(genpath('Class'));
    addpath(genpath('classfunc'));

    n =15; 
    EIA_rate=ones(n,3);
    EIA_rate(4,1) = 0.5;
    EIA_rate(5,1) = 0.5;
    
    l = 5.4;

    EIA_0 = ones(n, 3);
    EIA_0(:,1) = 2.06*10^11;     % <-- bridge Youngs modulus (Pa)
    EIA_0(:,2) = 57.48*10^(-8);         % <-- bridge moment of inertia (m^4)
    EIA_0(:,3) = 65.42 * 0.0001;         % <-- bridge cross section area (m^2) 
    dense = 7850;    % <-- bridge density (kg/m^3) 

    % initial material EIA
    FieldEIA = EIA_0 .* EIA_rate;

    boundary_list = [1,0;2*n+1,0];
    
    velo = 0.008;
    dt = 2;
    timestep = 0:dt:l/velo+dt;
    f = 10*9.8;
    
    
    disp_field = zeros(length(timestep), n+1);
    x_output = zeros(length(timestep)-2, 2*n+2);
    f_output = zeros(length(timestep)-2, 2*n+2);
    for i = 1:1:length(timestep)-1
        f_loc = (timestep(i)+timestep(i+1))/2 * velo;
        Bridge1 = BridgeVib(l, n, FieldEIA, dense, f, f_loc);
        Bridge1.add_boundary(boundary_list);
        Bridge1.solveKXF();
        disp_field(i+1,:) = Bridge1.x_disprot(:,1)';
        x_output(i,:) =  -Bridge1.all_x(:,1)';
        f_output(i,:) = full(Bridge1.F_rec(:,1)');
    end
    
    plot(disp_field)



end

