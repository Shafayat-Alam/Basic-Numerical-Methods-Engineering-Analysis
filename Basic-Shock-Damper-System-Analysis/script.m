%% Shock Damper System Analysis
% Three-mass spring-damper system simulation

clear all
close all
clc

% Load input data (contains images for mechanism visualization)
load("input.mat")

%% System Parameters
% Masses (kg)
m1 = 108.9;
m2 = 45.0;
m3 = 54.4;

% Spring constants (N/m)
k1 = 1.9;
k2 = 3.4;
k3 = 1.8;

% Damping coefficients (N·s/m)
c1 = 6.5;
c3 = 4.2;

%% Time Parameters
t0 = 0;
dt = 0.1;
T = 300;
t = t0:dt:T;
N = length(t);

%% External Forces
% F1: Sinusoidal forcing + Gaussian pulse
F1 = 2 .* sin(2 * pi * t / 20) + 8 * exp(-(t - 50).^2 / 15);
F2 = zeros(size(t));  % No external force on mass 2
F3 = zeros(size(t));  % No external force on mass 3

%% Initial Conditions
x1_0 = 0.0;
x2_0 = 0.0;
x3_0 = 0.0;
v1_0 = 0.0;
v2_0 = 0.0;
v3_0 = 0.0;

%% Initialize Arrays
x1 = zeros(size(t));
x2 = zeros(size(t));
x3 = zeros(size(t));
v1 = zeros(size(t));
v2 = zeros(size(t));
v3 = zeros(size(t));

% Assign initial conditions
x1(1) = x1_0;
x2(1) = x2_0;
x3(1) = x3_0;
v1(1) = v1_0;
v2(1) = v2_0;
v3(1) = v3_0;

%% Euler Integration
% Time-stepping loop using forward Euler method
for i = 2:N
    % Force equations based on system dynamics
    f1 = -k1 * x1(i-1) - c1 * v1(i-1) + F1(i-1);
    f2 = k1 * (x1(i-1) - x2(i-1));
    f3 = k1 * (x2(i-1) - x3(i-1)) - k3 * x3(i-1) - c3 * v3(i-1);
    
    % Update velocities using Newton's second law: F = ma
    v1(i) = v1(i-1) + (f1 / m1) * dt;
    v2(i) = v2(i-1) + (f2 / m2) * dt;
    v3(i) = v3(i-1) + (f3 / m3) * dt;
    
    % Update displacements using kinematic equation
    x1(i) = x1(i-1) + v1(i) * dt;
    x2(i) = x2(i-1) + v2(i) * dt;
    x3(i) = x3(i-1) + v3(i) * dt;
end

%% Plot Displacement vs. Time
figure('Position', [100, 100, 800, 600]);
plot(t, x1, 'r', 'LineWidth', 1.5); hold on;
plot(t, x2, 'g', 'LineWidth', 1.5);
plot(t, x3, 'b', 'LineWidth', 1.5);
xlabel('Time (s)', 'FontSize', 12);
ylabel('Displacement (m)', 'FontSize', 12);
title('Displacement vs. Time', 'FontSize', 14, 'FontWeight', 'bold');
legend('Mass 1', 'Mass 2', 'Mass 3', 'Location', 'best');
grid on;
saveas(gcf, 'Displacement_vs_Time.png');

%% Plot Velocity vs. Time 
figure('Position', [100, 100, 800, 600]);
plot(t, v1, 'r', 'LineWidth', 1.5); hold on;
plot(t, v2, 'g', 'LineWidth', 1.5);
plot(t, v3, 'b', 'LineWidth', 1.5);
xlabel('Time (s)', 'FontSize', 12);
ylabel('Velocity (m/s)', 'FontSize', 12);
title('Velocity vs. Time', 'FontSize', 14, 'FontWeight', 'bold');
legend('Mass 1', 'Mass 2', 'Mass 3', 'Location', 'best');
grid on;
saveas(gcf, 'Velocity_vs_Time.png');

%% Mass 1 Position at t = 5s 
index_t5 = find(t == 5);
x1a = x1(index_t5);

%% Mass 1 Velocity at t = 5s 
v1a = v1(index_t5);

%% Minimum Separation Distance L 
% Calculate relative displacements between adjacent masses
dist_1_2 = x2 - x1;  % Distance from mass 1 to mass 2
dist_2_3 = x3 - x2;  % Distance from mass 2 to mass 3

% Find minimum relative displacement for each pair
min_dist_1_2 = min(dist_1_2);
min_dist_2_3 = min(dist_2_3);

% The smallest separation L must prevent contact
% L must be greater than the maximum negative displacement
L = max(abs([min_dist_1_2, min_dist_2_3]));

%% Maximum Velocity Magnitude 
% Find maximum absolute velocity across all three masses
vmax = max(max(abs([v1; v2; v3])));

%% Minimum Distance Between Mass 1 and Mass 2 
distance_x2_and_x1 = x2 - x1;
dmin = min(distance_x2_and_x1);

%% Average Velocity of Mass 1 (First 10 seconds) 
indices = find(t <= 10);
v1mean = mean(v1(indices));

%% Display Results
fprintf('\n========================================\n');

fprintf('x1a (Mass 1 position at t=5s): %.6f m\n', x1a);
fprintf('v1a (Mass 1 velocity at t=5s): %.6f m/s\n', v1a);
fprintf('L (Minimum separation distance): %.6f m\n', L);
fprintf('vmax (Maximum velocity magnitude): %.6f m/s\n', vmax);
fprintf('dmin (Min distance between M1 and M2): %.6f m\n', dmin);
fprintf('v1mean (Avg velocity M1, t=0-10s): %.6f m/s\n', v1mean);

%% Relative Displacements
figure('Position', [100, 100, 800, 600]);
plot(t, dist_1_2, 'b', 'LineWidth', 1.5); hold on;
plot(t, dist_2_3, 'r', 'LineWidth', 1.5);
yline(0, 'k--', 'LineWidth', 1);
yline(L, 'g--', 'Safe Separation L', 'LineWidth', 2);
yline(-L, 'g--', 'LineWidth', 2);
xlabel('Time (s)', 'FontSize', 12);
ylabel('Relative Displacement (m)', 'FontSize', 12);
title('Relative Displacements Between Masses', 'FontSize', 14, 'FontWeight', 'bold');
legend('Mass 2 - Mass 1', 'Mass 3 - Mass 2', 'Zero Line', 'Location', 'best');
grid on;
saveas(gcf, 'Relative_Displacements.png');
