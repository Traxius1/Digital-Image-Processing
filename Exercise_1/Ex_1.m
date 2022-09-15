clear
clc
clf

% Load image, and convert it to gray-scale
x = imread('lena.bmp');
x = rgb2gray(x);
x = double(x) / 255;

%Show the histogram of intensity values
[hn, hx] = hist(x(:), 0:1/255:1);

% Image's histogram
figure(1)
bar(hx, hn)

%  --- 1.a ---
Y = pointtransform(x, 0.1961, 0.0392, 0.8039, 0.9608);
figure('Name','Point transform with (x1,y1, x2, y2) = (0.1961, 0.0392, 0.8039, 0.9608)');
imshow(Y)

% --- 1.b ---
Y = pointtransform(x, 0.5, 0, 0.5, 1);
figure('Name','Threshold of 0.5');
imshow(Y)

% --- 2.1 ---

% Case 1
L = 10;
v = linspace(0, 1, L);
h = ones([1, L]) / L;

Y = histtransform(x, h, v);
figure('Name','2.1: Case 1, Image');
imshow(Y)
[hn, hy] = hist(Y(:), 0:1/255:1);
figure('Name','2.1: Case 1, Histogram');
bar(hy, hn)

% Case 2
L = 20;
v = linspace(0, 1, L);
h = ones([1, L]) / L;

Y = histtransform(x, h, v);
figure('Name','2.1: Case 2, Image');
imshow(Y)
[hn, hy] = hist(Y(:), 0:1/255:1);
figure('Name','2.1: Case 2, Histogram');
bar(hy, hn)

% Case 3
L = 10;
v = linspace(0, 1, L);
h = normpdf(v, 0.5) / sum(normpdf(v, 0.5));

Y = histtransform(x, h, v);
figure('Name','2.1: Case 3, Image');
imshow(Y)
[hn, hy] = hist(Y(:), 0:1/255:1);
figure('Name','2.1: Case 3, Histogram');
bar(hy, hn)

% --- 2.2 ---

% Uniform Distribution [0,1]
% f = @(x) unifpdf(x, 0, 1);

% Uniform Distribution [0,2]
% f = @(x) unifpdf(x, 0, 2);

% Normal Distribution, mean = 0.5, variance = 0.1
% f = @(v) normpdf(v, 0.5, 0.1);

% --- 2.3 ---

% Using [0, 1] interval, consisted from 257 points. The reason why 257 is
% chosen is because intensity level will be equal to "d's points - 1",
% which means 256. 256 is the intensity levels used in the original image.
d = linspace(0, 1, 257);

% Computing the intensity levels for the histogram's equalization.
for i = 1 : length(d) - 1
    v(i) = (d(i) + d(i+1)) / 2;
end

% Histogram equalization to Uniform Distribution [0,1].
f = @(x) unifpdf(x, 0, 1);
histogramOfX = pdf2hist(d,f);
Y = histtransform(x, histogramOfX, v);
[hn, hy] = hist(Y(:), 0:1/255:1);

figure('Name','Image: Uniform Distribution [0,1]');
imshow(Y)

figure('Name','Histogram: Uniform Distribution [0,1]');
bar(hy,hn)

% Histogram equalization to Uniform Distribution [0,2].

% In order to simulate this distribution, d is expanded to meet
% distribution's intervals but we keep step equal to 257 so we have again
% the same number of intensity levels.
d = linspace(0, 2, 257);

for i = 1 : length(d) - 1
    v(i) = (d(i) + d(i+1)) / 2;
end

f = @(x) unifpdf(x, 0, 2);
histogramOfX = pdf2hist(d,f);
Y = histtransform(x, histogramOfX, v);

% For this case, histogram is printed from 0 to 2, with step of 2/255, so
% we have 256 bins in the histogram.
[hn, hy] = hist(Y(:), 0:2/255:2);

figure('Name','Image: Uniform Distribution [0,2]');
imshow(Y)

figure('Name','Histogram: Uniform Distribution [0,2]');
bar(hy,hn)

% Histogram equalization to Normal Distribution, mean = 0.5, variance = 0.1

% Keep the same d with case Uniform distribution [0 1].
d = linspace(0, 1, 257);

for i = 1 : length(d) - 1
    v(i) = (d(i) + d(i+1)) / 2;
end

f = @(x) normpdf(x, 0.5, 0.1);
histogramOfX = pdf2hist(d,f);
Y = histtransform(x, histogramOfX, v);
[hn, hy] = hist(Y(:), 0:1/255:1);

figure('Name','Image: Normal Distribution, mean = 0.5, variance = 0.1');
imshow(Y)

figure('Name','Histogram: Normal Distribution, mean = 0.5, variance = 0.1');
bar(hy,hn)
