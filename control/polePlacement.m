% Example from Brian Douglas Video
% What is Pole Placement (Full State Feedback)RANSAC
% State Space, Part 2 

% Define state matrices
A = [0 1; 2 -1];
B = [1; 0];
C = [1 0];
D = 0;

% Create state space object
stateObject = ss(A,B,C,D);

% Check open loop eigenvalues
openEigen = eig(A);
disp("Eigen Value Open Loop: ")
disp(openEigen);

disp("Real eigen:")
disp(real(openEigen));     

disp("Imaginary eigen:")
disp(imag(openEigen));    

% Desired closed loop eigenvalues
P = [-2 -1];

% Solve for K using pole placement
K = place(A, B, P);
disp("Solve for K for pole placement:")
disp(K);

% Create closed loop system based on poles
closed = A - B*K;

% Check for closed loop eigenvalues
closedEigen = eig(closed);

disp("Eigen Value Closed Loop: ")
disp(closedEigen)

disp("Real eigen:")
disp(real(closedEigen));     

disp("Imaginary eigen:")
disp(imag(closedEigen));    

% Create closed loop system
closedStateObject = ss(closed, B, C, D);

% Check step response of closed system
step(closedStateObject);

% Solve for Kr
Kdc = dcgain(closedStateObject);
Kr = 1/Kdc;

% Create scaled input closed loop system
closedStateObjectScaled = ss(closed, B*Kr, C, D);
step(closedStateObjectScaled)