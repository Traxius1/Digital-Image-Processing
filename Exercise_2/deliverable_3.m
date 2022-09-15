clear
clc
clf

% Rotate 54 deegres.
rotImg = myImgRotation('im2.jpg' , (54 * pi) / 180);
figure(1)
imshow(rotImg)

% Rotate 213 deegres.
rotImg = myImgRotation('im2.jpg' , (213 * pi) / 180);
figure(2)
imshow(rotImg)
