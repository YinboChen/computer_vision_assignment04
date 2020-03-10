frame = imread('frame_1LR.png');
frameLeftGray = rgb2gray(imread('frame_1L.png'));
frameRightGray = rgb2gray(imread('frame_1R.png'));

disparity_SSD = disparitySSD(frameLeftGray,frameRightGray,3);
disparity_NNC = disparityNCC(frameLeftGray,frameRightGray,3);
disparity_SSD_uiq = disparitySSD_unique(frameLeftGray,frameRightGray,3);
disparity_SSD_smooth = disparitySSD_smooth(frameLeftGray,frameRightGray,3,1);

% Q4.7 1.compare disparity maps
figure;
subplot(2,3,1);
imshow(disparity_SSD, [0,64]);
title('Disparity Map SSD window size 3');
colormap jet
colorbar

subplot(2,3,2);
imshow(disparity_NNC, [0,64]);
title('Disparity Map NCC window size 3');
colormap jet
colorbar

subplot(2,3,3);
imshow(disparity_SSD_uiq, [0,64]);
title('Disparity Map SSD Uniqueness window size 3');
colormap jet
colorbar

subplot(2,3,4);
imshow(disparity_SSD_smooth, [0,64]);
title('Disparity Map SSD smooth window size 3');
colormap jet
colorbar

subplot(2,3,5);
imshow(double(frame), [0,64]);
title('Ground truth');
colormap jet
colorbar