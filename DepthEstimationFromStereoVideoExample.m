%% Depth Estimation From Stereo Video
% This example shows how to detect people in video taken with a calibrated stereo 
% camera and determine their distances from the camera.
%% Load the Parameters of the Stereo Camera
% Load the |stereoParameters| object, which is the result of calibrating the 
% camera using either the |stereoCameraCalibrator| app or the |estimateCameraParameters| 
% function.
clc;
clear all;

% Load the stereoParameters object.
load('handshakeStereoParams.mat');

% Visualize camera extrinsics.
% showExtrinsics(stereoParams);
%% Create Video File Readers and the Video Player
% Create System Objects for reading and displaying the video.

videoFileLeft = 'handshake_left.avi';
videoFileRight = 'handshake_right.avi';

readerLeft = vision.VideoFileReader(videoFileLeft, 'VideoOutputDataType', 'uint8');
readerRight = vision.VideoFileReader(videoFileRight, 'VideoOutputDataType', 'uint8');
player = vision.DeployableVideoPlayer('Location', [20, 400]);
%% Read and Rectify Video Frames
% The frames from the left and the right cameras must be rectified in order 
% to compute disparity and reconstruct the 3-D scene. Rectified images have horizontal 
% epipolar lines, and are row-aligned. This simplifies the computation of disparity 
% by reducing the search space for matching points to one dimension. Rectified 
% images can also be combined into an anaglyph, which can be viewed using the 
% stereo red-cyan glasses to see the 3-D effect.

frameLeft = readerLeft.step();
frameRight = readerRight.step();

[frameLeftRect, frameRightRect] = ...
    rectifyStereoImages(frameLeft, frameRight, stereoParams);

% figure;
% imshow(stereoAnaglyph(frameLeftRect, frameRightRect));
% title('Rectified Video Frames');
%% Compute Disparity
% In rectified stereo images any pair of corresponding points are located on 
% the same pixel row. For each pixel in the left image compute the distance to 
% the corresponding pixel in the right image. This distance is called the disparity, 
% and it is proportional to the distance of the corresponding world point from 
% the camera.

frameLeftGray  = rgb2gray(frameLeftRect);
frameRightGray = rgb2gray(frameRightRect);

% part Q4.1 for SSD

% disparityMap = disparity(frameLeftGray, frameRightGray);
% disparityMap2 = disparitySSD(frameLeftGray,frameRightGray,1);
% disparityMap3 = disparitySSD(frameLeftGray,frameRightGray,5);
% disparityMap4 = disparitySSD(frameLeftGray,frameRightGray,11);

% figure;
% subplot(2,2,1),imshow(disparityMap,[0,64]),title('Build-in Disparity Map'),colormap jet,colorbar;
% subplot(2,2,2),imshow(disparityMap2,[0,64]),title('Disparity SSD window size 1'),colormap jet,colorbar;
% subplot(2,2,3),imshow(disparityMap3,[0,64]),title('Disparity SSD window size 5'),colormap jet,colorbar;
% subplot(2,2,4),imshow(disparityMap4,[0,64]),title('Disparity SSD window size 11'),colormap jet,colorbar;
% --------------------------------------------------------------------------------------------------------------------
% part Q4.2 for NCC

% disparityMap = disparity(frameLeftGray, frameRightGray);
% disparityMap2 = disparityNCC(frameLeftGray,frameRightGray,3);
% disparityMap3= disparityNCC(frameLeftGray,frameRightGray,5);
% disparityMap4 = disparityNCC(frameLeftGray,frameRightGray,7);
% 
% figure;
% subplot(2,2,1),imshow(disparityMap,[0,64]),title('Build-in Disparity Map'),colormap jet, colorbar;
% subplot(2,2,2),imshow(disparityMap2,[0,64]),title('Disparity NCC window size 3'),colormap jet,colorbar;
% subplot(2,2,3),imshow(disparityMap3,[0,64]),title('Disparity NCC window size 5'),colormap jet,colorbar;
% subplot(2,2,4),imshow(disparityMap4,[0,64]),title('Disparity NCC window size 7'),colormap jet,colorbar;

% --------------------------------------------------------------------------------------------------------------------

% part Q4.3 for Uniquencess constraint

% disparityMap = disparity(frameLeftGray, frameRightGray);
% disparityMap1 = disparitySSD(frameLeftGray,frameRightGray,5);
% disparityMap2 = disparitySSD_unique(frameLeftGray,frameRightGray,5);
% 
% figure;
% subplot(1,3,1),imshow(disparityMap,[0,64]),title('Build-in Disparity Map'),colormap jet, colorbar;
% subplot(1,3,2),imshow(disparityMap1,[0,64]),title('Disparity SSD window size 5'),colormap jet,colorbar;
% subplot(1,3,3),imshow(disparityMap2,[0,64]),title('Unique Constraint SSD window size 5'),colormap jet,colorbar;

% --------------------------------------------------------------------------------------------------------------------

% part Q4.4 for Disparity smoothness constraint

% disparityMap = fliplr(disparitySSD(fliplr(frameRightGray),fliplr(frameLeftGray),3));
% disparityMap1 = disparitySSD(frameLeftGray,frameRightGray,3);
% disparityMap_SSD_smooth = disparitySSD_smooth(frameLeftGray,frameRightGray,3,1);
% disparityMap_SSD_smooth2=fliplr(disparitySSD_smooth(fliplr(frameRightGray),fliplr(frameLeftGray),3,1));
% figure;
% subplot(2,2,1),imshow(disparityMap1,[0,64]),title('Left-Right Disparity SSD window size 3'),colormap jet,colorbar;
% subplot(2,2,2),imshow(disparityMap,[0,64]),title('Right-Left Disparity SSD window size 3'),colormap jet, colorbar;
% subplot(2,2,3),imshow(disparityMap_SSD_smooth,[0,64]),title('Disparity Left-Right smoothness Constraint SSD window size 3'),colormap jet,colorbar;
% subplot(2,2,4),imshow(disparityMap_SSD_smooth2,[0,64]),title('Disparity Right-Left smoothness Constraint SSD window size 3'),colormap jet,colorbar;

% --------------------------------------------------------------------------------------------------------------------

% part Q4.5 Generate outliers map

%  disparityMap_SSD_LR = disparitySSD(frameLeftGray,frameRightGray,5);
%  disparityMap_SSD_RL = fliplr(disparitySSD(fliplr(frameRightGray),fliplr(frameLeftGray),5));
%  binary_image_SSD = detectOutliers(disparityMap_SSD_LR,disparityMap_SSD_RL,1);
%  
%  disparityMap_NCC_LR = disparityNCC(frameLeftGray,frameRightGray,5);
%  disparityMap_NCC_RL = fliplr(disparityNCC(fliplr(frameRightGray),fliplr(frameLeftGray),5));
%  binary_image_NCC = detectOutliers(disparityMap_NCC_LR,disparityMap_NCC_RL,1);
 
%  figure;
%   subplot(2,3,1),imshow(disparityMap_SSD_LR,[0,64]),title('Left-Right Disparity SSD window size 5'),colormap jet,colorbar;
%   subplot(2,3,2),imshow(disparityMap_SSD_RL,[0,64]),title('Right-Left Disparity SSD window size 5'),colormap jet, colorbar;
%   subplot(2,3,3),imshow(binary_image_SSD),title('Outlier map for SSD window size 5 with threshold 1');
%   subplot(2,3,4),imshow(disparityMap_NCC_LR,[0,64]),title('Left-Right Disparity NCC window size 5'),colormap jet,colorbar;
%   subplot(2,3,5),imshow(disparityMap_NCC_RL,[0,64]),title('Right-Left Disparity NCC window size 5'),colormap jet, colorbar;

%  figure;
%  subplot(1,2,1),imshow(binary_image_SSD),title('Outlier map for SSD window size 5 with threshold 1');
%  subplot(1,2,2),imshow(binary_image_NCC),title('Outlier map for NCC window size 5 with threshold 1');
% 
% --------------------------------------------------------------------------------------------------------------------


% part 2  Dynamic Programming(contain partA and B)

 frameLeftGray = im2double(frameLeftGray);
 frameRightGray = im2double(frameRightGray);
%  loading the images conv to double range 0-1



[R, C] = size(frameLeftGray);

for i = 1: R
    
    line_R = frameRightGray(i,:);
    line_L = frameLeftGray(i,:);
    %run DP main function return a disparity map
    D = disparityDP(line_R, line_L, 64, 0.01);
    disparityMapDP(i,:) = D; 
    
    100*i/(R)
%     counting time left
end
save('disparityMapDP.mat','disparityMapDP')
disp('Save disparityMapDP to file disparityMapDP.mat!!!');
figure;
imshow(disparityMapDP, [0, 64]);
title('DP Disparity Map');
colormap jet
colorbar

%% Reconstruct the 3-D Scene
% Reconstruct the 3-D world coordinates of points corresponding to each pixel 
% from the disparity map.

% part Q4.6 Compute depth from disparity
disparityMap = disparitySSD(frameLeftGray,frameRightGray,1);
points3D = reconstructSceneCU(disparityMap, stereoParams);

% Convert to meters and create a pointCloud object
 points3D = points3D ./ 1000;

ptCloud = pointCloud(points3D, 'Color', frameLeftRect);

% Create a streaming point cloud viewer
player3D = pcplayer([-3, 3], [-3, 3], [0, 8], 'VerticalAxis', 'y', ...
    'VerticalAxisDir', 'down');

% Visualize the point cloud
view(player3D, ptCloud);

%% Summary
% This example showed how to localize pedestrians in 3-D using a calibrated 
% stereo camera.
%% References
% [1] G. Bradski and A. Kaehler, "Learning OpenCV : Computer Vision with the 
% OpenCV Library," O'Reilly, Sebastopol, CA, 2008.
% 
% [2] Dalal, N. and Triggs, B., Histograms of Oriented Gradients for Human 
% Detection. CVPR 2005.
% 
% _Copyright 2013-2014 The MathWorks, Inc._