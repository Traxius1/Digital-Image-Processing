function [H, L, res] = myHoughTransform(img_binary , Drho , Dtheta , n)

% Pythagorean theorem to find the hypotenuse created from the dimensions
% of the image.
max_rho = ceil( sqrt( (size(img_binary,1) - 1) ^ 2 + (size(img_binary,2) - 1) ^ 2 ) );

% Creating Rho, Theta intervals, based on Drho and Dtheta given.
Rho = 0 : Drho : 2*max_rho;
Theta = 0 : Dtheta : pi - Dtheta;

% Transform is applied to the points of the image that have an edge value,
% so find them.
[y, x] = find(img_binary);

% Initialising the Hough array.
% X axis --> theta, Y axis --> rho.
H = zeros( length(Rho), length(Theta) );

% Scan the points with edge values and calculate rho.
rho_calc = ceil(x .* cos(Theta) +  y .* sin(Theta));

% For all Rho calculated
for i = 1 : length(Rho)
    
    % Find the index of this element.
    % Remember, the number of column corresponds to the theta used to
    % calculate this rho value. That means for instance, col(5) corresponds
    % to Theta(5).
    [row, col] = find( rho_calc == Rho(i) );

    % Add 1 to the according cell.
    for j = 1 : numel(col)
        H( i, col(j) ) =  H( i, col(j) ) + 1;
    end

end

% Initialising L array.
L = zeros(n, 2);

% Sorting H array. 'sorted_H' has the values of H sorted to descending order, 
% and position array has the corresponding positions of those.
[sorted_H, position] = sort(H(:), 'descend');

% Check the localilty of the dominant lines.

% Getting rid of elements with value of zero (used to make code faster because
% elements with value of zero can't be dominant).
sorted_H( sorted_H == 0 ) = [];

% Get the index of every value in 'sorted_H' in Hough's table.
[index_row_H, index_col_H] = ind2sub( size(H), position(1 : length(sorted_H)) );

% Initialising the vector whose values will be the dominant lines.
dominant = zeros(n,1);

% Acceptable range of distance.
allow = 50;

% The cell with the greatest value is for sure the most dominant line, so
% there is no need to check any distance. Also include its index in L
% array.
dominant(1) = sorted_H(1);
L(1,:) = [Rho(index_row_H(1)) Theta(index_col_H(1))];

% Storing in this array the index of the values selected as dominant.
L_ind = zeros(n,2);
L_ind(1,:) = [index_row_H(1) index_col_H(1)];

% Initializing the vector which saves the distance values of the dominant
% lines and the examined line.
distance = zeros(n-1,1);

% A counter to scan the dominant lines. It starts from the second greatest
% cell of 'sorted_H'.
counter = 2;
    
% Loop for every element of 'sorted_H', while we got less than n dominant
% lines. Because 'dominant' is initialised with zero values, we want to
% avoid them.
while ( counter <= length(sorted_H) )  && ( nnz(dominant) < n )
       
    % Calculate the distance between every dominant element and the examined
    % element.
    for j = 1 : nnz(dominant)
        distance(j) = round( sqrt( (L_ind(j,1) - index_row_H(counter))^2 + (L_ind(j,2) - index_col_H(counter))^2 ) ); 
    end  

    % Check if every distance calculated is greater than the acceptable
    % value. 'distance' is initialized with zeros, so we choose only the
    % non zero elements.
    if distance(distance ~= 0) >= allow
        
        % Creating the L array, which means storing the index of the
        % dominant line found.
        L(nnz(dominant) + 1, :) = [ Rho(index_row_H(counter)) Theta(index_col_H(counter)) ];
        L_ind(nnz(dominant) + 1, :) = [ index_row_H(counter) index_col_H(counter) ];
        dominant( nnz(dominant) + 1) = sorted_H(counter);
            
    end

    % Go on with the next element.
    counter = counter + 1;

end

% Calculating 'res' number.

% Use a function handle to calculate the y value of every element that
% composes the dominant lines found. That means a y value is calculated for
% every row.
dominant_lines = @(x_value) round( (L(:,1) - x_value .* cos(L(:,2))) ./ sin((L(:,2))) );
y_value = dominant_lines( 1:size(img_binary,1) );

% If y_value is equal to NaN or Inf, that means sin = 0 --> Theta = pi/2.
% So, this line has points equal to the number of rows. For 'res', the
% index of the points is out of concern and for that reason, ones replace the
% cells that 'y_value' got NaN or Inf.
y_value( isnan(y_value) ) = 1;
y_value( isinf(y_value) ) = 1;

% Keep only the points that are inside original picture's intervals.
y_value(y_value < 1 | y_value > size(img_binary,2)) = [];

% 'res' is equal to the number of elements of the original picture minus the number
% of elements that y_value returned.
res = numel(img_binary) - numel(y_value);
