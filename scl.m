function [ output_scl ] = scl( im , h, w)

output_scl = imresize(im, [h, w]);

end

