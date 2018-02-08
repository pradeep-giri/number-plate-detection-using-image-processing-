im = imread('img/s1.jpg');
im = imresize(im, [480 NaN]);
imgray = rgb2gray(im);
imbin = im2bw(imgray);
im = edge(imgray, 'sobel');

im = imdilate(im, strel('diamond', 2));
im = imfill(im, 'holes');
im = imerode(im, strel('diamond', 10));

Iprops=regionprops(im,'BoundingBox','Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa= area;
boundingBox = Iprops.BoundingBox;
for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end 

im = imcrop(imbin, boundingBox);
im = imresize(im, [240 NaN]);
im = imopen(im, strel('rectangle', [4 4]));
im = bwareaopen(~im, 1000);
[h, w] = size(im);
imshow(im)
Iprops=regionprops(im,'BoundingBox','Area', 'Image');
count = numel(Iprops);

noPlate=[];

for i=1:count
   ow = length(Iprops(i).Image(1,:));
   oh = length(Iprops(i).Image(:,1));
   if ow<(h/2) & oh>(h/3)
       letter=readLetter(Iprops(i).Image); 
       figure; imshow(Iprops(i).Image);
       noPlate=[noPlate letter]; 
   end
end

