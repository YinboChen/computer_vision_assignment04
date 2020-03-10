function[disparityMap] = disparitySSD_smooth(frameLeftGray, frameRightGray, windowSize,threshold)
 %%%%%%%%%%%%%%%%%%%%%%%%%%
% CSCI 5722 Computer Vision
% Name: Yinbo Chen
% Professor: Ioana Fleming
% Assignment: HW4 
% Purpose: Stereo Vision 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
  clc;
  clear all;
 
     img_R = imread('frame_1L.png');
     img_L = imread('frame_1R.png');
% % testing
% 
%   img_L = frameLeftGray;
%   img_R = frameRightGray;
%   
%   img_L = imgaussfilt(frameRightGray);
%   img_R = imgaussfilt(frameLeftGray);
% 
   img_L = rgb2gray(img_L);
   img_R = rgb2gray(img_R);


% figure,imshow(img_L);
% figure,imshow(img_R);

[R, C] = size(img_L);
% img_L and R have ready rectified,so the sizes are same
 threshold = 1;
max_disparityRang = 64;
% set up the maximum and minimum disparity ranges
windowSize = 5;
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
          if windowSize == 1
              pix_value_L = sum(sum(new_imgL(i,j)));
          else
              pix_value_L = sum(sum(new_imgL(i-w+1:i+w,j-w+1:j+w)))/(windowSize_local^2);
              %    compute whole pixels' values in the window and find the mean value
          end

          min_diff = 1000;
          % set up the min diff
          bestX = 1;
          bestX_next = 1;
           if j+ max_disparityRang <= C_new-w
%                set the max disparity range when j+ max-range less than
%                max column of image 
                       
                for m = j : j+ max_disparityRang 
                        if min_diff < 1
%                     adding a flag to avoid continual computing and
%                     stopping for loop
                            if abs(bestX_next -(bestX-j)) <= threshold
                                disparity(i,j) = ( bestX_next );
                                bestX_next = bestX-j;
                            else
                                disparity(i,j) = ( bestX-j ); 
                                bestX_next = bestX-j;
                            end
                       break;
                       end
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
                         
                
               end
           elseif j+max_disparityRang > C_new-w 
%                     set the max disparity range when j+ range large than
%                     image's max column
               for n = C_new -w - max_disparityRang  : C_new -w 
                        if min_diff < 1
%                     adding a flag to avoid continual computing and
%                     stopping for loop
                            if abs(bestX_next - (bestX-j)) <= threshold
                                disparity(i,j) = ( bestX_next );
                                bestX_next = bestX-j;
                            else
                                disparity(i,j) = ( bestX - j ); 
                                bestX_next = bestX-j;
                            end
                       break;
                       end
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
                   
               end
           end       
    end  
    
     100*i/(R_new - w)
%      counting time remain
end
 tempdisp(1:R,1:C,:) = disparity(w+1:R_new-w,w+1:C_new -w,:);
 disparityMap = single(tempdisp);

%  disparityMap = single(medfilt2(disparity,[w,w]));

 figure;
 imshow(disparityMap,[0,64]);
 title('Disparity Map2')
 colormap jet
 colorbar

end