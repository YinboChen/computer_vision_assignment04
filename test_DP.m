% Depth Estimation From Stereo Video
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

frameLeftGray = im2double(frameLeftGray);
frameRightGray = im2double(frameRightGray);
left_I=frameLeftGray;
right_I=frameRightGray;
left_I=mean(left_I,3);
right_I=mean(right_I,3);
I_disp=zeros(size(left_I), 'single');
disp_range=55;
h_block_size=9;
blocksize=h_block_size*2+1;
row=size(left_I,1);
col=size(left_I,2);
min_diff= Inf;
disp_cost= min_diff*ones(col,2*disp_range+1,'single');
penalty=0.4;


for m =1:row
    disp_cost(:)= min_diff;
    row_min= max(1, m- h_block_size);
    row_max= min(row, m+ h_block_size);
    
    for n =1:col
          col_min= max(1,n-h_block_size);
          col_max= min(col,n+h_block_size);
          %% setting the pixel search limit
          pix_min= max(-disp_range, 1 - col_min);
          pix_max= min(disp_range, col - col_max);
         
          for i = pix_min : pix_max
              temp = left_I(row_min:row_max ,(col_min :col_max)+i)-right_I(row_min:row_max ,col_min:col_max);
              disp_cost(n,i+disp_range+1)=sum(sum(temp.*temp));
             
          end
    end
  Index= zeros(size(disp_cost), 'single');
  	c_p = disp_cost(end, :);
    for j = col-1:-1:1
           diff = (col - j + 1) *min_diff;
     [z,inx] = min([diff diff c_p(1:end-4)+3*penalty;
                      diff c_p(1:end-3)+2*penalty;
                      c_p(1:end-2)+penalty;
                      c_p(2:end-1);
                      c_p(3:end)+penalty;
                      c_p(4:end)+4*penalty diff;
                      c_p(5:end)+5*penalty diff diff],[],1);
                  c_p = [diff disp_cost(j,2:end-1)+z diff];
        Index(j, 2:end-1) = (2:size(disp_cost,2)-1) + (inx - 4);
    end
	
    [~,inx] = min(c_p);
    I_disp(m,1) = inx;
   
	for k = 1:(col-1)
		I_disp(m,k+1) = Index(k,max(1, min(size(Index,2), round(I_disp(m,k)) ) ) );
        
    end
    
end

I_disp = I_disp - disp_range- 1;

 figure;
 imshow(I_disp,[0,64]);
 title('DP')
 colormap jet
 colorbar
