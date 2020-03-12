function[d_color] = display_dmap(d)
 %%%%%%%%%%%%%%%%%%%%%%%%%%
% CSCI 5722 Computer Vision
% Name: Yinbo Chen
% Professor: Ioana Fleming
% Assignment: HW4 
% Purpose: Stereo Vision 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('disparityMapDP.mat');
d = disparityMapDP;
% check =d(1:size(d,1),1:200)
% for testing

[R, C] = size(d);

d_color = d;

% map disparity into the range [0 1]
min_d = min(d_color, [], 'all');
max_d = max(d_color, [], 'all');

% subracting the min and dividing the difference between max and min
d_color = d_color-min_d;
dif_d = max_d - min_d;
d_color = (d_color./dif_d);

%make gray scale
d_color(:,:,2) = d_color(:,:,1);
d_color(:,:,3) = d_color(:,:,1);

%colorize occluded pixels to be red
for i =1:R
    for j = 1:C
        if isnan(d(i,j))
            d_color(i ,j ,1) = 1;
            d_color(i ,j ,2) = 0;
            d_color(i ,j ,3) = 0;
        end
    end
end

figure;
imshow(d_color);
title('Occlusions in disparity map');

end