function[points3D] = reconstructSceneCU(disparityMap, stereoParams)

[R,C] = size(disparityMap);

points3D = zeros(R,C);
% defined the points3D image, sizes as disparity Map

baseline = sqrt(sum(stereoParams.TranslationOfCamera2.^2));
% get baseline
focal_len_two = stereoParams.CameraParameters1.FocalLength;
focal_avg = (focal_len_two(1)+focal_len_two(2))/2;
% get focal length
for i = 1:R
        for j = 1:C
            value = ((focal_avg * baseline) / disparityMap(i,j));
%             value between 10^3 to 10^4
            points3D(i,j,1) = j;
% % %             x axi = j
            points3D(i,j,2)= i;
            points3D(i, j,3) = value;
% %             deth z
            
        end
end

% points3D = points3D;
% R by C by 3
end