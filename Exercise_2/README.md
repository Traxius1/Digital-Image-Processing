# Exercise 2

In this exercise there are some implementations of ready-to-use functions of Matlab, written from scratch. These functions are:
1. Hough Transform.
2. Harris Corner Detection.
3. Rotation of an image with respect to its center (counterclockwise).

## myHoughTransform:

Applies Hough Transform.

Arguments: 
1. img_binary, a binary image containing 1s where there is edge and 0s elsewhere.
2. Drho, a step used for rho parameter
3. Dtheta, a step used for theta parameter
4. n, the number of lines to be returned, based on their score in H array.

Returns:
1. H, a parameter space matrix whose rows and columns correspond to rho and theta values respectively.
2. L, an array which contains the rho-theta pairs of the n lines.
3. res, the number of pixels that don't belond to Hough lines.

## myDetectHarrisFeatures:

Applies Harris Corner Detection

Arguments: 
1. I, a grayscale image.

Returns:
1. corners, the pixels that a corner was detected.

## myImgRotation:

Rotates an image counterclockwise with respect to its center.

Arguments: 
1. img, an image to be rotated.
2. angle, the angle of rotation (rads).

Returns:
1. corners, the rotated image padded with black pixels.

## Deliverables

Deliverable files preprocess images and plot the results of each algorithm.





