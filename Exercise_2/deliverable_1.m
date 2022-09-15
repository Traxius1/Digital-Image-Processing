clear
clc
clf

% Load image, convert it to gray-scale, resize it if image is too big, 256 intensity levels in [0, 1].
X = imread('im2.jpg');

if size(X, 3) == 3
    X = rgb2gray(X);
end

if size(X, 1) > 600 && size(X, 2) > 600
    X = imresize(X, 0.2);
end

X = double(X) / 255;

% In order to make edge detection more successful, pass image from a
% Gaussian filter.
X = imgaussfilt(X, 5);

% Edge detection, using Canny method.
x_edges = edge(X,'Canny');

% Setting the input values.
Drho = 1;
Dtheta = pi/180;
n = 10;

% Setting 'Rho' and 'Theta' because they are needed for the Hough peaks
% plot.
max_rho = ceil( sqrt( (size(X,1) - 1) ^ 2 + (size(X,2) - 1) ^ 2 ) );
Rho = 0 : Drho : 2*max_rho;
Theta = 0 : Dtheta : pi - Dtheta;

[H, L, res] = myHoughTransform(x_edges , Drho , Dtheta , n);

% Plotting 'H' array with it's n dominant peaks.
figure(1)
imshow(H, [], 'XData', Theta, 'YData', Rho, 'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
plot(L(:,2), L(:,1) ,'s','color','green');

% Showing the n dominant lines in the original image.
% Setting the start and finish point of each line.
x1 = 1; x2 = size(X, 1);

% Calculating the corresponding y value
y1 = (L(:,1) - x1 * cos(L(:,2))) ./ sin((L(:,2)));
y2 = (L(:,1) - x2 * cos(L(:,2))) ./ sin((L(:,2)));

% Initializing the vector that's gonna show if there are parallel lines.
parallels = zeros(n, 1);
   
% In case there are any parallel lines, find them and plot them properly.
for i = 1 : n

        if isinf( y1(i) ) && isinf( y2(i) )
            parallels( nnz(parallels) + 1) = i;
        end 
        
end

% 'parallels' is initialized with zeros, so elements that are still zero
% are deleted. Also lines found parallel are also deleted from 'y1' and
% 'y2', so they can be plotted properly.
parallels( parallels == 0 ) = [];
y1(parallels) = []; y2(parallels) = []; 

% Plot every Hough lines, except those of the form "x = const".
figure(2)
imshow(X, [])
hold on;
p1 = plot([x1, x2], [y1, y2], 'LineWidth', 2);

% Plot the parallel lines.
for i = 1 : numel(parallels)
    
    hold on
    plot ( L( parallels(i), 1) .* ones(1, size(X, 2)), 1:size(X, 2), 'LineWidth',2)
    
end
