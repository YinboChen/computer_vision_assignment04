 function[disparityMap] = disparitySSD(frameLeftGray, frameRightGray, windowSize)
 %%%%%%%%%%%%%%%%%%%%%%%%%%
% CSCI 5722 Computer Vision
% Name: Yinbo Chen
% Professor: Ioana Fleming
% Assignment: HW4 
% Purpose: Stereo Vision 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clc;
% clear all;
%    img_R = imread('frame_1L.png');
%    img_L = imread('frame_1R.png');
% % testing
% 
%   img_L = frameLeftGray;
%   img_R = frameRightGray;
%   
  img_L = frameRightGray;
  img_R = frameLeftGray;

%   img_L = rgb2gray(img_L);
%   img_R = rgb2gray(img_R);


% figure,imshow(img_L);
% figure,imshow(img_R);

[R, C] = size(img_L);
% img_L and R have ready rectified,so the sizes are same
 
max_disparityRang = 64;
% set up the maximum and minimum disparity ranges
%  windowSize =5;
windowSize_local = windowSize;
w = round((windowSize_local -1)/2);
% windowSize = 2w+1, kernal size

new_imgL = padarray(img_L,[w w],0,'both');
new_imgR = padarray(img_R,[w w],0,'both');
% padding the original image with value 0
[R_new, C_new] = size(new_imgL);

disparity = zeros(R_new, C_new);


% gaussian
for i = w+1: R_new - w  
%     set up the boundary of Row

    for j = w+1:C_new - w
%         set up the boundary of column
          if windowSize == 1
              pix_value_L = sum(sum(new_imgL(i,j)));
          else
              pix_value_L = sum(sum(new_imgL(i-w+1:i+w,j-w+1:j+w)))/(windowSize_local^2);
          end
%    compute whole pixels' values in the window and find the mean value
          min_diff = 1000;          
% set up the min diff
          bestX = 1;
           if j+ max_disparityRang <= C_new-w
%                set the max disparity range when j+ max-range less than
%                max column of image
                for m = j : j+ max_disparityRang  
                    if windowSize == 1
                        pix_value = sum(sum(new_imgR(i,m)));
                    else
                        pix_value = sum(sum(new_imgR(i-w+1:i+w,m-w+1:m+w)))/(windowSize_local^2);
                    end
                   diff = sum((pix_value - pix_value_L)^2);
%                    find the min different value as well as the best x value
                         if diff< min_diff
                             min_diff = diff;
                             bestX = m;                                              
                         end  
                    
%                 disparity(i,j) = (new_imgR(i,bestX) - new_imgL(i,j));
%                 different of intensity
                disparity(i,j) = (bestX - j);
                
               end
           elseif j+max_disparityRang > C_new-w 
%                     set the max disparity range when j+ range large than
%                     image's max column
               for n = j : C_new -w 
                   if windowSize == 1
                        pix_value = sum(sum(new_imgR(i,n)));
                   else
                      
                       pix_value = sum(sum(new_imgR(i-w+1:i+w,n-w+1:n+w)))/(windowSize_local^2);
                   end
                   diff = sum((pix_value - pix_value_L)^2);
                         if diff< min_diff
                             min_diff = diff;
                             bestX = n;                         
                         end  
%                     disparity(i,j) = (new_imgR(i,bestX)- new_imgL(i,j));
                    disparity(i,j) = (bestX-j);
               end
           end       
    end    
     100*i/(R_new - w)
%      counting time remain
end
 tempdisp(1:R,1:C,:) = disparity(w+1:R_new-w,w+1:C_new -w,:);
 disparityMap = single(tempdisp);
%  figure;
%  imshow(disparityMap,[0,64]);
%  title('Disparity Map2')
%  colormap jet
%  colorbar

end