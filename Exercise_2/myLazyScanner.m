clear
clc
clf

X = imread('im1.jpg');

% Load image, convert it to gray-scale, resize it if image is too big, 256 intensity levels in [0, 1].
if size(X, 3) == 3
    X = rgb2gray(X);
end

if size(X, 1) > 600 && size(X, 2) > 600
    X = imresize(X, 0.2);
end

X = double(X) / 255;

% Applying a gaussian filter with sigma equal to 5 for better results of
% edge detecting.
HoughX = X;
HoughX = imgaussfilt(HoughX, 5);

% Edge detection, using Canny method.
x_edges = edge(HoughX, 'Canny');

% Setting variables for Hough transform.
n = 10;
Dtheta = pi / 180;
Drho = 1;

% Getting L array
[H, L, res] = myHoughTransform(x_edges , Drho , Dtheta , n);

% Getting the index of the corners.
HarrisX = X;
corners = myDetectHarrisFeatures(HarrisX);

% In this array, corners that are on Hough lines are stored.
cornersOfImage = zeros;

counter = 1;

% In this loop, every element in 'corners' is checked whether it is on one 
% of the Hough lines stored in 'L'. Corners meet this condition are stored
% in 'cornersOfImage'.
for i = 1 : n
    
    for j = 1 : size(corners, 1)
        
        % Calculate the y value for each corner.
        photos = @(x)( L(i, 1) - x * cos(L(i, 2))) ./ sin((L(i, 2)));

        y_value = photos( corners(j, 1) );

        % In case the examined line is a x = const, the check is about the
        % x value of the corner that must be equal to the 'rho' value of
        % the line examined.
        if sin( L(i, 2) ) == 0
            
            x_value = L(i, 1);
            
            if x_value == corners(j, 1)
                cornersOfImage(counter, 1) = corners(j, 1);
                cornersOfImage(counter, 2) = corners(j, 2);
                counter = counter + 1;  
            end
    
        else
            
            % If y value is between a range with radius of 10, it is
            % accepted.
            if y_value - 10 < corners(j, 2) && y_value + 10 > corners(j, 2)
                
                cornersOfImage(counter, 1) = corners(j, 1);
                cornersOfImage(counter, 2) = corners(j, 2);
                counter = counter + 1;
                
            end
            
        end
    
    end
    
    
end

% Reset counter to 1.
counter = 1;

% In this array, the coords of the intersections of Hough lines are stored.
Intersections = zeros;

% Reset photos function handler's type.
photos = @(x)( L(:, 1) - x .* cos(L(:, 2))) ./ sin((L(:, 2)));

% Calculate every y value of the dominant lines. 'Nlines' stands from normal
% lines, which means the Hough lines that aren't 'x = const'. Also, number
% of columns is equal to the number of row in the image. So, that means
% that if Nlines(1, 5) = 50, 50 was calculated from x = 5.
Nlines =  round( photos( 1 : size(HarrisX, 1) ) );

% Find lines which are parallel to y axis.
parallels = find( (L(:, 2) ) == 0);

% Delete parallel to y axis lines.
Nlines(parallels, :) = [];

% In this vector, store which of the dominant lines are parallel to y axis.
Plines = round( L(parallels, 1) );

% Starting from the first line of 'Nlines' check whether is has any
% intersection with any other line and store them in 'Intersections' array.
for i = 1 : size(Nlines, 1) - 1
    
   % For every next element.
   for j = i + 1 :  size(Nlines, 1)
   
       ComPoint = intersect( Nlines(i), Nlines(j) );
   
       % If there is an intersection.
       if ~isempty(ComPoint)

            % Find the x value of the intersection.
            x_value = find( Nlines(i) == ComPoint &  Nlines(j) == ComPoint);

            Intersections(counter, 1) = x_value;
            Intersections(counter, 2) = ComPoint;

            counter = counter + 1;
       end
     
   end 
   
end

% This loop is used to find the intersections of every line in 'Nlines'
% with the parallel to y axis lines.
for i = 1 : size(Nlines, 1)
    
    ComPoint = intersect( Nlines(i), 1 : size(HarrisX, 2));
    
    % If there is an intersection.
    if ~isempty(ComPoint)
        
        % For every parallel line.
        for j = 1 : numel(Plines)
            
            % Remember, 'Plines' has stored the rounded 'rho' values of the
            % dominant lines parallel to y axis.
            Intersections(counter, 1) = Plines(j);
            Intersections(counter, 2) = Nlines( i, Plines(j) );
            
            counter = counter + 1;
        end
        
    end
    
end    

% Plot the original image
figure(1)
imshow(X);

% Plot squares with center the corners detected.
for i = 1 : size(cornersOfImage, 1)
    hold on
    square = [cornersOfImage(i, 2) - 5, cornersOfImage(i, 1) - 5, 5, 5];
    rectangle('Position', square , 'EdgeColor', 'r');
end

hold on

% Also plot the Hough line's intersections.
plot(Intersections(:, 1), Intersections(:, 2), 'g*')
 
    
