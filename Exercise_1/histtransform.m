function X = histtransform(X, h, v)

% values array sorts all the pixels in ascending order and positions array
% contains the original position of each pixel in the image. Only positions
% array is used.
[values, positions] = sort(X(:));

% j variable is used to scan h and v vectors. counter variable counts the
% number of pixels with intensity of v(j)
j = 1;
counter = 0;

% All the pixel of the input image, starting from which has the lowest
% value, is assigned to an intensity value of v. If the percentage of
% pixels with intensity v(j) is greater or equal than h(j), the next
% intensity value ( v(j+1) ) is selected for the next pixel.
for i = 1 : numel(X)

    condition = counter / numel(X);
    
    X(positions(i)) = v(j);
    counter = counter + 1;
    
    if(condition >= h(j))
        j = j + 1;
        counter = 0;
    end    
    
end

Y = X;

end

