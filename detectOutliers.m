function[binaryImage] = detectOutliers(LR_image, RL_image, T_threshold)
 %%%%%%%%%%%%%%%%%%%%%%%%%%
% CSCI 5722 Computer Vision
% Name: Yinbo Chen
% Professor: Ioana Fleming
% Assignment: HW4 
% Purpose: Stereo Vision 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[R, C] = size(LR_image);
outlier_map = zeros(R, C);
    
for i = 1:R
    for j = 1:C
            
       dLR = LR_image(i, j);
            
       if j + dLR < 1 || j + dLR > C                
           outlier_map(i, j) = 1;
       else
           xdLR = round(j + dLR);
           dRL =  RL_image(i, xdLR);
                
            if abs(dLR - dRL) <= T_threshold
               outlier_map(i,j) = 0;
            else
               outlier_map(i,j) = 1;
            end
        end
% testing the method 1

%         if abs(LR_image(i,j) - RL_image(i,j+LR_image(i,j))) > T_threshold
%             outlier_map(i,j) = 1;
%         end
%  testing the method 2
            
     end
end
binaryImage = outlier_map;

end