clear
clc
clf

% Load image, convert it to gray-scale, resize it if image is too big, 256 intensity levels in [0, 1].
X = imread('im1.jpg');

if size(X, 3) == 3
    X = rgb2gray(X);
end

if size(X, 1) > 600 && size(X, 2) > 600
    X = imresize(X, 0.2);
end

X = double(X) / 255;

corners = myDetectHarrisFeatures(X);

figure(1)
imshow(X);

% Plot squares with center the corners detected.
for i = 1 : size(corners, 1)
    hold on
    square = [corners(i, 2) - 5, corners(i, 1) - 5, 5, 5];
    rectangle('Position', square , 'EdgeColor', 'r');
end


