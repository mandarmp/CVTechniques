%$ Image segmentation Experimentation
%   Other m-files required: none %   MAT-files required: none % 
%   Image segmentation toolbox needed.
%   Author: Mandar Patil
%   email: mxp172@student.bham.ac.uk
%   Date: 12/03/2022; 
% 
%   Last revision: 14/03/2022, Mandar Patil, Object colour count.

clc
clear all
close all
warning off

dbstop if error
x_org=imread('Images/image2.png');
subplot(2,3,1)
imshow(x_org);
title('Original Image');

xblur1 = imgaussfilt(x_org,2);
subplot(2,3,2)
imshow(xblur1)
xGray = rgb2gray(xblur1);
subplot(2,3,3)
imshow(xGray)
xBW = imbinarize(xGray);
xBW = imfill(xBW,'holes');
subplot(2,3,4)
imshow(xBW)
[B,L,N,A] = bwboundaries(xGray);
subplot(2,3,5)
imshow(x_org); hold on;
colors=['b' 'g' 'r' 'c' 'm' 'y'];

%%
%ref: https://uk.mathworks.com/help/images/ref/bwboundaries.html 
for k=1:length(B),
  boundary = B{k};
  cidx = mod(k,length(colors))+1;
  plot(boundary(:,2), boundary(:,1),...
       colors(cidx),'LineWidth',2);
  %randomize text position for better visibility
  rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
  col = boundary(rndRow,2); row = boundary(rndRow,1);
  h = text(col+1, row-1, num2str(L(row,col)));
  set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
end


%%
g = regionprops(xBW,xGray, 'Area','BoundingBox','WeightedCentroid','PixelValues');

M = containers.Map();

subplot(2,3,5);hold on;
red = 0;
green =0;
for iter_variable = 1: N
    g(iter_variable)
    area_values = [g.Area];
    pixel_values{iter_variable} = g.PixelValues;
    centroid_value = cast([g.WeightedCentroid],"uint32");
    XCO = centroid_value(2*(iter_variable)-1);
    YCO = centroid_value(2*(iter_variable));
    cval = x_org(YCO,XCO,:);
    plot(XCO,YCO,'b*')
    RGB{iter_variable} = [diag(cval(:,:,1)), diag(cval(:,:,2)), diag(cval(:,:,3))];
    RGB{iter_variable} = double(RGB{iter_variable})./ double(255);
    [~, index] = max(RGB{1,iter_variable});
    if index == 1
        red = red +1;
    else index == 2
        green = green +1;
    end
    M(num2str(iter_variable))=ans;

end

if(red>green)
    countstr = "green is the odd colour"
else
    countstr = "red is the odd colour"
end
ax = subplot(2,3, 6);
text(0.2,0.2,countstr);
set ( ax, 'visible', 'off')
