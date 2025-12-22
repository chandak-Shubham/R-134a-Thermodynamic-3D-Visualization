clear all; clc;
r = Solution('liquidvapor.yaml', 'HFC-134a'); % Creates Cantera Solution object r for R-134a
Critical_Temp = critTemperature(r); % Set T_critical as critical temperature
Critical_Pressure = critPressure(r); % set P_critical as critical pressure
Critical_Volume = 1 / critDensity(r); % Set V_critical as critical volume
Triple_point_R134a = 169.85; % in Kelvin 
% 2. Define Temperature and Specific Volume Ranges
minT = 170; % in Kelvin, slightly above T_triple_ref as below it R-134a solidifies & Cantera's liquid–vapor model can't handle the solid phase
maxT = 455; % extend beyond critical point (which is 374.2100)
T_total_count = 600;
T_array = linspace(minT, maxT, T_total_count); % Creates an array between 170 and 455 with 600 evenly spaces units.
minV = 1E-4; % m^3/kg, Subcooled liquid, above solid phase
maxV = 1E+2; % m^3/kg, Superheated vapor
V_count = 600;
V_array = logspace(log10(minV), log10(maxV), V_count); % logspace is used because specific volume spans several orders of magnitude, so a log scale is better for visualization
P_Matrix = zeros(V_count, T_total_count); % Compute Pressure Matrix P(V,T), which stores values of Pressure for different V and T
for i = 1:T_total_count % Syantax (for loop) --> for variablename =start:end
    T1 = T_array(i);
    for j = 1:V_count % inner loop, calculates values of V for corresponding T
        V1 = V_array(j);
        try % try-catch is used to handle errors in cantera
            setState_TV(r, [T1; V1]);
            P_Matrix(j, i) = pressure(r);
        catch
            P_Matrix(j, i) = NaN;
        end
    end
end
plot_Pressure = P_Matrix;
plot_Pressure(isnan(plot_Pressure)) = 10; % The code wasn't working as some values in P_Pa were 0 and log(0) is undefined, therefore we assigned a minimum value of 10Pa as floor
plot_Pressure = max(plot_Pressure, 10); % ensure >= 10 Pa
logP = log10(plot_Pressure);
[V_grid, T_grid] = meshgrid(V_array, T_array); % meshgrid creates matrices for plotting 3D surfaces. V_grid(i,j) and T_grid(i,j) will therefore correspond to the coordinates of pressure value P_Pa(i,j)
Z_grid = logP.'; % The apostrophe means taking transpose in matlab and this is done so because acc. to matlab convention rows are y and columns are x
C_data = logP.'; % Final 3D plot has axes X,Y,Z as specific volume, Temperature, log10Pressure
figure() % Creates a new figure
finalplot = surf(V_grid, T_grid, Z_grid, C_data, ... % Surf function creates the 3D plot taking 4 inputs including color
    'FaceAlpha', 0.88, 'EdgeColor', 'none'); % FaceAlpha 0.88 makes it 88% opaque. No edgecolor.
colormap(jet); % Inbuilt colormap of Matlab where low values are Blue, high values are red
cb = colorbar; % colorbar adds a vertical bar showing what color corresponds to what value
cb.Label.String = 'Pressure (Pa)'; % labels the colorbar as Pressure as the varying values define Pressure Values
set(gca, 'XScale', 'log'); % gca is a Matlab command (get current axes) that gives us a handle to the current axes in the plot
xlabel('Specific Volume v [m^3/kg]');
ylabel('Temperature T [K]');
zlabel('Pressure P [Pa]');
title('P–v–T Surface for R-134a (Surface colored by Pressure)');
grid on;
set(gca, 'Box', 'on'); % makes a box around the plot
set(gcf, 'Renderer', 'opengl'); % forces MATLAB to use the OpenGL renderer, which handles transparency and lighting best for 3D plots, gcf stands for get current figure camlight left; lighting gouraud; % Gouraud shading, used to enable us to see the dome properly
zlog_min = 1;
zlog_max = ceil(max(Z_grid(:))); % based on actual data
z_ticks_log = zlog_min:1:zlog_max;
set(gca, 'ZTick', z_ticks_log);
set(gca, 'ZTickLabel', arrayfun(@(L) zlabels(10^L), z_ticks_log,'UniformOutput', false));
cb.Ticks = z_ticks_log;
cb.TickLabels = arrayfun(@(L) zlabels(10^L), z_ticks_log, 'UniformOutput',false);
% CSV with columns: T [K], v [m^3/kg], P [Pa]
[T_mat, V_mat] = meshgrid(T_array, V_array);
P_mat = P_Matrix;
% Convert to column vectors (each row is one (T,v,P) point)
T_col = reshape(T_mat, [], 1);
V_col = reshape(V_mat, [], 1);
P_col = reshape(P_mat, [], 1);
% Create a table for better structure
final_table = table(T_col, V_col, P_col, 'VariableNames', {'Temperature_K', 'SpecificVolume_m3_per_kg', 'Pressure_Pa'});
% Save to CSV file
csv_filename = 'PVT_R134a.csv';
writetable(final_table, csv_filename);
function s = zlabels(Ppa) % This function helps in writing the z-axis(Pressure) values
    if Ppa < 1000
        s = sprintf('%.0f Pa', Ppa);
    elseif Ppa < 1000000
        s = sprintf('%.0f kPa', Ppa/1000);
    else
        s = sprintf('%.2f MPa', Ppa/1000000);
    end
end
