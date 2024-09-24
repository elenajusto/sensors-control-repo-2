%% Sample Quiz 3 Q4 - Visual Servoing 

% Camera parameters
Z = 1.2;  % Depth
lambda = 0.18;  % Gain factor
f_x = 985;  % Focal length in x
f_y = 978;  % Focal length in y
c_x = 932;  % Principal point x
c_y = 542;  % Principal point y

% Current feature locations in pixels
current_features = [25, 80; 
                    965, 25; 
                    80, 745; 
                    965, 745];

% Desired feature locations in pixels
desired_features = [20, 20; 
                    1550, 20; 
                    20, 750; 
                    1550, 800];

% Normalize pixel coordinates relative to the principal point
current_features_normalized = [(current_features(:,1) - c_x) / f_x, ...
                               (current_features(:,2) - c_y) / f_y];
desired_features_normalized = [(desired_features(:,1) - c_x) / f_x, ...
                               (desired_features(:,2) - c_y) / f_y];

% Compute the error vector
error = reshape((current_features_normalized - desired_features_normalized)', [], 1);

% Initialize the interaction matrix Ls
L_s = [];

% Compute interaction matrix for each feature
for i = 1:4
    x = current_features_normalized(i, 1);
    y = current_features_normalized(i, 2);
    
    % Interaction matrix for the i-th feature
    L_i = [-1/Z, 0, x/Z, x*y, -(1 + x^2), y;
           0, -1/Z, y/Z, (1 + y^2), -x*y, -x];
       
    % Append to the overall interaction matrix
    L_s = [L_s; L_i];
end

% Compute the pseudo-inverse of the interaction matrix
L_s_pseudo = pinv(L_s);

% Compute the camera velocity
nu = -lambda * L_s_pseudo * error;

% Display the camera velocity
disp('Camera velocity (translation and rotation):');
disp(nu);
