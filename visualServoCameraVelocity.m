% Visual Servoing - Camera Velocity
% Sample Quiz 3

% ------- EXPLAIN -------
% The camera velocity in a visual servoing task is determined by 
% minimizing the re-projection error between the current and desired 
% positions of the features in the image.
%
% In visual servoing, the error is computed for each feature as the 
% difference between the current feature positions and the desired 
% positions in the image plane. Then, using the control gain λλ, the 
% camera velocity is computed by multiplying the error by −λ−λ.


% ------- CODE -------
% Given data
lambda = 0.18;  % Control gain
Z = 1.2;  % Depth (in meters)

% Current feature positions (x, y) in image plane
current_points = [25 80; 965 25; 80 745; 965 745];

% Desired feature positions (x, y) in image plane
desired_points = [20 20; 1550 20; 20 750; 1550 800];

% Calculate re-projection error (e)
e = current_points - desired_points;

% Compute the camera velocity (dot_e = -lambda * e)
dot_e = -lambda * e;

% Display results
disp('Re-projection Error (e):');
disp(e);

disp('Camera Velocity (dot_e):');
disp(dot_e);
