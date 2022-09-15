function Y = pointtransform(X, x1, y1, x2, y2)

% This block of code transforms the intensity values of X's elements
% according to the function given. In case x1 = x2 is true, a thresholding
% is applied.

if x1 == x2
% Thresholding depends on whether y2 or y1 is greater than the other.
% Values that meet the condition for X are going to be equal to 1 in Y
% array and the rest equal to 0.
    if y2 > y1
        Y = (X >= x1);
    else
        Y = (X <= x1);
    end
    
else

% Basically we find the values of X that belong to each range. Each
% array gets 1 at those cells and 0 to others. Also, array gets multiplied
% with the function's values at those ranges.
% Branch n.1
    Y1 = (0 <= X) & (X < x1);
    Y1 = (y1/x1) .* X .* Y1;
% Branch n.2    
    Y2 = (x1 <= X) & (X <= x2);
    Y2 = (( (y2-y1) / (x2-x1) ) .* X + y1 - x1*(y2-y1)/(x2-x1)) .* Y2;
% Branch n.3    
    Y3 = (x2 < X) & (X < 1);
    Y3 = (( (1-y2) / (1-x2) ) .* X + y2 - x2*(1 - y2)/(1 - x2) ) .* Y3;
% Summing all branches to create the final image.
    Y = Y1 + Y2 + Y3;
end

end

