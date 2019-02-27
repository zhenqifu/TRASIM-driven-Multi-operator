function [ output_cr ] = cr( im , h, w, step, sal)

for i = 1:step+1
    e = w -(step+1)+i;
    s = sal(:,i:e);
    score(i) = sum(sum(s));
end

[~,I] = sort(score);
start_point = I(step+1);
%end_point = w -(step+1)+start_point;

output_cr = imcrop(im, [start_point 1 w-step-1  h]); 
end





