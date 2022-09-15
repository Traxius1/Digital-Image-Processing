function h = pdf2hist(d, f) 

% Computing the intervals that we are going to interval. Every line is an
% interval. We also initialize them with zeros.
new_d = zeros(length(d)-1, 2);

for i = 1 : length(d) - 1
    new_d(i,:) = [d(i), d(i+1)];
end
    
% Integrating on the intervals created.    
for i = 1 : size(new_d, 1)
    p(i) = integral(f, new_d(i,1), new_d(i,2));
end

% Normalizing integration's results, which means Sum(h) = 1.
h = p ./ sum(p(:));

end

