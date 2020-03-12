function[disparityLine] = disparityDP(e1, e2, maxDisp, occ)
 %%%%%%%%%%%%%%%%%%%%%%%%%%
% CSCI 5722 Computer Vision
% Name: Yinbo Chen
% Professor: Ioana Fleming
% Assignment: HW4 
% Purpose: Stereo Vision 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R = length(e1);
C = length(e2);
d = zeros(R, C); 
%To initialize the distance matrix
D = zeros(R+1, C+1); 
%defined a DP matrix 
dir = zeros(R+1, C+1);
% a matrix to save all directions

%computing the distance between each pixels
for i =1:R
    for j = 1:C
        d(i,j) = (e1(i)-e2(j))^2;
    end
end

%initialize first col and first row without compute the costs
for j = 1:C+1
    D(1,j) = (j-1)*occ;
end
for i =1:R+1
    D(i, 1) = (i-1) * occ;
end

for i = 2:R+1
    for j = 2:C+1
        %costs from 3 directions
        temp = [D(i-1, j-1)+d(i-1, j-1) D(i-1,j)+occ D(i, j-1)+occ];
        [min_cost, min_I] = min(temp);
        D(i,j) = min_cost; 
        %finding the min cost
        dir(i, j) = min_I; 
        %saving directions
        %1: northwest,2: north,3: west
       
    end
end

disparityLine =NaN(1, R);

rp = R+1;
cp = C+1;
disparity = 0;
count = C;
while (rp > 1) || (cp > 1)
    if dir(rp, cp)==1 
        %northwest,nice!
        rp=rp-1; 
        %go to northwest
        cp=cp-1;
        %updating current disparity and filling it
        
        disparityLine(count)= disparity;
        count=count-1; 
    elseif dir(rp, cp)==2
        %north
        rp=rp-1; 
        %go to north
        if disparity > maxDisp
            disparity = maxDisp-1;
        end
        disparity=disparity+1;
        
        count = count-1;
    elseif dir(rp,cp)==3
        %northwest
        cp=cp-1; 
        %go to west
        if disparity < 1 
            disparity = 2;
        end
        disparity=disparity-1;
    else
        break;   
    end
end

            
%  
%  figure;
%  imshow(disparity_Line,[0,64]);
%  title('DP')
%  colormap jet
%  colorbar

end