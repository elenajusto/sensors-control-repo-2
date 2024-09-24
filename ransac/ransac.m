% RANSAC (Random Sample Consensus) Algorithm
% Quiz 2 - Question 2
%
% RANSAC is used on images that have been processed with SURF or SIFT or another
% algorithm to estimate the geometric transformation between images by
% identifying and rejecting outliers. 
% 
% Allows stuff like image alignment, panoramic
% stitching, etc, and can be a step in reconstructing a coherent 3D model of an
% object or scene based on multiple images
%
% -------- How does RANSAC work? --------
%
% Random Sampling: Randomly select a subset of the input data points to fit the model 
% (called a minimal sample set, or MSS). This is done because the majority of the 
% data might contain outliers that would negatively affect a standard fitting approach.
% 
% Model Fitting: Use the selected subset to estimate the parameters of the model.
% 
% Consensus Evaluation: Determine how many data points from the entire dataset 
% agree with this model, i.e., how many points are within a certain tolerance 
% from the model (these are the inliers).
% 
% Iteration: Repeat the above steps for a fixed number of iterations or until 
% a certain number of inliers is found.
%
% Final Model: Once the best consensus set is identified (i.e., the set of 
% inliers that most agree with the model), re-fit the model using only these inliers.
%
%
% -------- DUMB TERMS --------
% so it takes two images andd tells us which points on those images are the 
% same point? like if i too ka picture of kfc bucket from two angles, it can tell me 
% where a point in the bucket IRL is on the two images i took?


% -------- EXAMPLE RANSAC CODE --------

% Read the images
image1 = imread("kfc1.jpg");
image2 = imread("kfc2.jpg");

% Convert images to grayscale
grayImage1 = rgb2gray(image1);
grayImage2 = rgb2gray(image2);

% Detect feature points in both images
points1 = detectSURFFeatures(grayImage1);
points2 = detectSURFFeatures(grayImage2);

% Extract feature descriptors around the detected points
[features1, valid_points1] = extractFeatures(grayImage1, points1);
[features2, valid_points2] = extractFeatures(grayImage2, points2);

% Match the features between the two images
indexPairs = matchFeatures(features1, features2);

% Retrieve the locations of the matched points
matchedPoints1 = valid_points1(indexPairs(:, 1), :);
matchedPoints2 = valid_points2(indexPairs(:, 2), :);

% Show all matched features
figure;

showMatchedFeatures(image1, image2, matchedPoints1, matchedPoints2, 'montage');
title('All Matched Features');

% Estimate the geometric transformation using RANSAC
[tform, inlierIdx] = estimateGeometricTransform2D(matchedPoints1, matchedPoints2, 'projective', 'MaxDistance', 4);

% Retrieve inlier points
inlierPoints1 = matchedPoints1(inlierIdx, :);
inlierPoints2 = matchedPoints2(inlierIdx, :);

% Show the inlier matched features after RANSAC
figure;
showMatchedFeatures(image1, image2, inlierPoints1, inlierPoints2, 'montage');
title('Inlier Matched Features after RANSAC');

% Calculate the transformed points from the first image using the transformation
outputView = imref2d(size(image2));
transformedImage1 = imwarp(image1, tform, 'OutputView', outputView);

% Show the original second image and the transformed first image for comparison
figure;
imshowpair(transformedImage1, image2, 'montage');
title('Transformed Image 1 and Original Image 2');