function [ Q ] = TRASIM( original, retargeted, sal_orginal, sal_retargeted, model )
%default = 24;
BLK_SIZE = 24;  
% grid saliency
[ BSO, BSOM, BSR ] = black_saliency( sal_orginal, sal_retargeted, BLK_SIZE ) ;  
% SIFT-flow matching
[ XX_forward, YY_forward] = my_siftflow(retargeted, original);
[ XX_backward, YY_backward] = my_siftflow(original, retargeted);
% feature
[FGD, FIL, GSD] = forward_feature( BLK_SIZE, original,  XX_forward, YY_forward, XX_backward, BSO, BSOM);
[BGD, BIL] = backward_feature( BLK_SIZE, original, retargeted, sal_orginal,  sal_retargeted, XX_backward, YY_backward, BSR);

feature = [FGD; FIL;0.5*GSD;BGD; BIL];
[Q, ~, ~] = svmpredict( 1, feature', model);

end
