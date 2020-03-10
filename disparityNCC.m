function [disparityMap] = disparityNCC(frameLeftGray, frameRightGray, windowSize)
%%%%%%%%%%%%%%%%%%%%%%%%%%
% CSCI 5722 Computer Vision
% Name: Yinbo Chen
% Professor: Ioana Fleming
% Assignment: HW4 
% Purpose: Stereo Vision 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%      img_L = double(rgb2gray(imread('frame_1L.png')));
%      img_R = double(rgb2gray(imread('frame_1R.png')));
% % testing
% 
   img_L = double(frameLeftGray);
   img_R = double(frameRightGray);
% for attaching to main script

% figure,imshow(img_L);
% figure,imshow(img_R);

[R, C] = size(img_L);
% img_L and R have ready rectified,so the sizes are same
 
max_disparityRang = 64;
% set up the maximum and minimum disparity ranges

% windowSize_local = windowSize;
windowSize_local = windowSize;
w = round((windowSize_local -1)/2);
% windowSize = 2w+1, kernal size

new_imgL = padarray(img_L,[w w],0,'both');
new_imgR = padarray(img_R,[w w],0,'both');
% padding the original image with value 0
[R_new, C_new] = size(new_imgL);

disparity = zeros(R_new, C_new);

for i = w+1: R_new - w  
%     set up the boundary of Row

    for j = w+1:C_new - w     
%         set up the boundary of column                    
              windowpixels_R = new_imgR(i-w+1:i+w,j-w+1:j+w);
%                    define pixel in Right image(number 1)
             if j+ max_disparityRang <= C_new-w
                    bestX = 0;
                    ncc_Max = 0;
%                    set threshold
                for k = 0: max_disparityRang
%                    define the range of compared windows from (0 : 64 by default)          
                     windowpixels_L = new_imgL(i-w+1:i+w,j-w+1+k:j+w+k);
%                      L =size(windowpixels_L)
%                      R =size(windowpixels_R)
%                      testing the size of two matrices
                     temple1 = sum(windowpixels_L.* windowpixels_R, 'all');
                     temple2 = sum(windowpixels_R.* windowpixels_R, 'all');
                     temple3 = sum(windowpixels_L.* windowpixels_L, 'all');
%                    applying a NNC algorithm
                     ncc = temple1/sqrt(temple2*temple3);
                     if ncc > ncc_Max
                        ncc_Max = ncc;
                        bestX = k;
                     end
                         
                     disparity(i,j) = bestX;
                end
             elseif j+ max_disparityRang > C_new-w
                 
                 for k = 0 - max_disparityRang + (C_new - w -j): C_new - w -j
%                    define the range of compared windows from (-X : C_new - w -j ),the sum equ to max_disparityRang          
                     windowpixels_L = new_imgL(i-w+1:i+w,j-w+1+k:j+w+k);
                     temple1 = sum(windowpixels_L.* windowpixels_R, 'all');
                     temple2 = sum(windowpixels_R.* windowpixels_R, 'all');
                     temple3 = sum(windowpixels_L.* windowpixels_L, 'all');
%                    applying a NNC algorithm
                     ncc = temple1/sqrt(temple2*temple3);
                     if ncc > ncc_Max
                        ncc_Max = ncc;
                        bestX = abs(k);
                     end
                         
                     disparity(i,j) = bestX;
                end
                 
             end
                Time = 100*i/(R_new - w)
  
    end
end
 tempdisp(1:R,1:C,:) = disparity(w+1:R_new-w,w+1:C_new -w,:);
 disparityMap = uint8(tempdisp);
%  figure;
%  imshow(disparityMap,[0,64]);
%  title('Disparity Map NCC')
%  colormap jet
%  colorbar
end