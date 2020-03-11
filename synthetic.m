clc;
clear all;

frame = single(imread('frame_1RL.png'));
frameLeftGray = rgb2gray(imread('frame_1L.png'));
frameRightGray = rgb2gray(imread('frame_1R.png'));

disparity_SSD = disparitySSD(frameLeftGray,frameRightGray,5);
disparity_NNC = single(disparityNCC(frameLeftGray,frameRightGray,5));
disparity_SSD_uiq = disparitySSD_unique(frameLeftGray,frameRightGray,5);
disparity_SSD_smooth = disparitySSD_smooth2(frameLeftGray,frameRightGray,3,20);

% Q4.7 1.compare disparity maps
figure;
subplot(2,3,1);
imshow(disparity_SSD, [0,64]);
title('Disparity Map SSD window size 5');
colormap jet
colorbar

subplot(2,3,2);
imshow(disparity_NNC, [0,64]);
title('Disparity Map NCC window size 5');
colormap jet
colorbar

subplot(2,3,3);
imshow(disparity_SSD_uiq, [0,64]);
title('Disparity Map SSD Uniqueness window size 5');
colormap jet
colorbar

subplot(2,3,4);
imshow(disparity_SSD_smooth, [0,64]);
title('Disparity Map SSD smooth window size 5');
colormap jet
colorbar

subplot(2,3,5);
imshow(double(frame), [0,64]);
title('Ground truth');
colormap jet
colorbar

% Q4.7 2. Calculate a map of errors and display it
%2.Calculate a map of errors and display it
% SSDError = sqrt((disparity_SSD - frame).^2);
% NCCError = sqrt((disparity_NNC - frame).^2);
% uniqueError = sqrt((disparity_SSD_uiq - frame).^2);
% smoothError = sqrt((disparity_SSD_smooth - frame).^2);

% figure;
% subplot(2,2,1);
% imshow(SSDError);
% title('SSD Error');
% 
% subplot(2,2,2);
% imshow(NCCError);
% title('NCC Error');
% 
% subplot(2,2,3);
% imshow(uniqueError);
% title('Uniqueness Error');
% 
% subplot(2,2,4);
% imshow(smoothError);
% title('Smooth Error');

% Q4.7 3. Calculate a histogram of disparity differences and display it

% figure;
% subplot(2,2,1);
% histogram(SSDError(:))
% title('SSD Error');
% 
% subplot(2,2,2);
% histogram(NCCError(:))
% title('NCC Error');
% 
% subplot(2,2,3);
% histogram(uniqueError(:))
% title('Uniqueness Error');
% 
% subplot(2,2,4);
% histogram(smoothError(:))
% title('smooth Error');