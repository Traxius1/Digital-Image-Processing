function rotImg = myImgRotation(img , angle)

% Load image, resize it if image is too big, 256 intensity levels in [0, 1].
X = imread(img);

if size(X, 1) > 600 & size(X, 2) > 600
    X = imresize(X, 0.2);
end

X = double(X) / 255;

% Calcualte the hypotenuse of the image.
max_rho = ceil( sqrt( (size(X, 1) - 1) ^ 2 + (size(X, 2) - 1) ^ 2 ) );

% Check which dimension is bigger, because the rotation of the image need
% will be rotated and no pixel should be lost.
biggest_dim = max( size(X,1), size(X,2) );

% Calculate the addition of zero pixels that should be padded to every side
% of the image.
addition = ceil(max_rho - biggest_dim);

% Zero padding to X image.
X = padarray(X, [addition addition]);

% Find the index of the middle element.
midx = floor( (size(X, 1)) / 2 );
midy = floor( (size(X, 2)) / 2 );

% Affline array used to rotate the image. sin's sign input is reversed to
% in order to rotate image counter-clockwise.
T = [cos(angle)   sin(angle);
     -sin(angle) cos(angle)];
 
% This is the inverse of the affline array.
T_inv = inv(T);

% Initializing the array that's going to be returned from this function.
rotImg = zeros(size(X));

% The coordinates of the calculated mapped elements in the input image are
% going to be stored in this array.
coords = zeros( numel(rotImg), 2 );

% A counter to used to scan arrays.
counter = 1;

% Scanning every pixel of the image.
for i = 1 : size(rotImg, 1)
    
    for j = 1 : size(rotImg, 2)
        
        % Transforming coordinates to the original image, using inverse
        % mapping technique.
        % 'coords' array has the index of every element of the input image
        % (padded). The index from the rotated matrix that was used has
        % been changed according to the point of reference, which is the
        % middle of the input image.
        coords(counter, :) = floor([i - midx, j - midy] * T_inv);
        
        % Restoring the point of reference to the original of the input
        % array.
        coords(counter, 1) = coords(counter, 1) + midx;
        coords(counter, 2) = coords(counter, 2) + midy;
        
        % If the index is inside 'X_sorted' boundries, do the mapping and
        % keep these coordinates in 'coords_used'.
        if coords(counter, 1) >= 1 && coords(counter, 1) <= size(rotImg, 1) && coords(counter, 2) >= 1 && coords(counter, 2) <= size(rotImg, 2)
            
            rotImg(i, j, :) = X(coords(counter, 1), coords(counter, 2), :);
            
        end
        
        % Go on to the next element.
        counter = counter + 1;
        
    end
end

% Set counter to 1.
counter = 1;

% Initializing 'rowToDelete' array.
rowToDelete = zeros(size(rotImg, 1), 1);

% If there is a whole row that is black, find it and store it.
for i = 1 : size(rotImg, 1)
    
   if rotImg(i, :) == 0  
       rowToDelete(counter) = i;
       counter = counter + 1;
   end
   
end

% Get rid of extra cells and delete the rows found to be black.
rowToDelete(rowToDelete == 0) = [];
rotImg(rowToDelete, :, :) = [];

% Reset counter to 1.
counter = 1;

% Initializing 'colToDelete' array.
colToDelete = zeros(size(rotImg, 2), 1);

% If there is a whole column that is black, find it and store it.
for i = 1 : size(rotImg, 2)
    
   if rotImg(:, i) == 0  
       colToDelete(counter) = i;
       counter = counter + 1;
   end
   
end

% Get rid of extra cells and delete the columns found to be black.
colToDelete(colToDelete == 0) = [];
rotImg(:, colToDelete, :) = [];

% Calculating the intensity value (bilinear interpolation).
for i = 1 : size(rotImg, 1)      

    for j = 1: size(rotImg, 2)
        
    % If column 1 is examined (column 1 of the image), there are 3 cases. Either one out of
    % two corners is checked or a random cell of the line.
    if j == 1

        if i == 1
        p = ( rotImg(i, j + 1, :) + rotImg( i + 1, j, :) ) / 4;

        elseif i == size(rotImg, 1)
        p = ( rotImg(i, j + 1, :) + rotImg( i - 1, j, :) ) / 4;

        else
        p = ( rotImg(i, j + 1, :)  + rotImg(i - 1, j, :) + rotImg(i + 1, j, :) ) / 4;

        end

    % If last column is examined, there are 3 cases. Either one out of
    % two corners is checked or a random cell of the line.
    elseif j == size(rotImg, 2)

        if i == 1
        p = ( rotImg( i, j - 1, :) + rotImg( i + 1, j, :) ) / 4;

        elseif i == size(rotImg, 1)
        p = ( rotImg( i, j - 1, :) + rotImg( i - 1, j, :) ) / 4;

        else
        p = ( rotImg( i, j - 1, :) + rotImg( i - 1, j, :) + rotImg( i + 1, j, :) ) / 4; 

        end
        
    % If there is no condition met yet, check if first or last row is
    % examined.
    elseif i == 1
    p = ( rotImg( i, j - 1, :) + rotImg( i, j + 1, :) + rotImg( i + 1, j, :) ) / 4;

    elseif i == size(rotImg, 1)
    p = ( rotImg( i, j - 1, :) + rotImg( i, j + 1, :) + rotImg( i - 1, j, :) ) / 4;

    % After all these statements, the examined cell is not located
    % on array's limits.
    else
    p = ( rotImg( i, j - 1, :) + rotImg( i, j + 1, :) + rotImg(i - 1, j, :) + rotImg( i + 1, j, :)) / 4;

    end

    rotImg( i, j, :) = p;
    
    end       
end

end

