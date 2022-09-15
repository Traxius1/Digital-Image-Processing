function corners = myDetectHarrisFeatures(I)

% Create a Gaussian filter with kernel size of 15 and sigma = 1;
w = fspecial('gaussian', 15, 1);

% 'dx' annd 'dy' are used for derivatives.
% dx's rows are the same (-1:1) and dy's columns are the same (-1:1).
[dx, dy] = meshgrid(-1:1, -1:1);

% Compute x and y derivatives of the image.
Ix = conv2(I, dx, 'same');
Iy = conv2(I, dy, 'same');

% Calculate Ix2, Iy2, Ixy arrays.
Ix2 = Ix .^ 2;
Iy2 = Iy .^ 2;
Ixy = Ix .* Iy;

% Calculate the subarrays that compose 'M' array.
Mx2 = conv2(Ix2, w, 'same');
My2 = conv2(Iy2, w, 'same');
Mxy = conv2(Ixy, w, 'same');

% Set sensitivity parameter k (0 < k < 0.25).
k = 0.05;

% Initializing R vector with zeros.
R = zeros(numel(I), 1);

% Calculating R parameter for every element of the image.
for i = 1 : numel(I)
    
    % Compose M array.
    M = [Mx2(i) Mxy(i); Mxy(i) My2(i)];  

    % Calculate R values for every element of the array.
    R(i) = det( M ) - k * (trace( M ))^2;

end

% Threshold value to detect if this element is a corner or an edge.
threshold = 0.001;

% Sort 'R' vector's values to descending order and store their position in
% 'positions' vector.
[R, positions] = sort(R, 'descend');

% Setting threshold depending on the highest R value calculated.
threshold = threshold * R(1);

% Keep only the values that are greater than threshold value.
positions = positions( R > threshold );
R = R( R > threshold );

% Get the index of every element in 'R' in the input image.
[index_row_R, index_col_R] = ind2sub( size(I), positions );

% Elements that going to be deleted.
counter = 1;

% Initializing 'toBeDeleted' vector.
toBeDeleted = zeros;

% Corners returned shouldn't have any other corners next to them.
% So, check if every corner has distance with every other greater than
% 1, which means distance greater than 1 cell.
for i = 1 : numel(index_row_R)
    
    % 'R' array is sorted, so the very first element of 'index_row_R' and
    % 'index_col_R' are those with the greatest R value. So, always will be
    % R(i) >  R(j). That's why j starts from i and not previous values of
    % i.
    for j = i + 1 : numel(index_col_R)
        
        distance = round( sqrt( (index_row_R(i) - index_row_R(j))^2 + (index_col_R(i) - index_col_R(j))^2 ) );
        
        if distance == 1

            % Store the number of element that is going to be deleted.
            toBeDeleted(counter) = j;           
            counter = counter + 1;
            
        end
    
    end
end

% Keep only the unique elements. The composition of the previous code
% allows to store multiple equal values. Get rid of them and keep every
% number just 1 time.
toBeDeleted = unique(toBeDeleted);

% Delete these elements.
index_row_R(toBeDeleted) = [];
index_col_R(toBeDeleted) = [];

% Return the pixel that a corner is detected.
corners = [index_row_R(:) index_col_R(:)];

end

