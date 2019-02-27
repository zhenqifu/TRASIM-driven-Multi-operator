%% mutil-operator
addpath(genpath('.\TRASIM\'));
addpath(genpath('.\HS\'));
load TRASIM_SVR_model
original = imread('original.bmp');
step = 15;
retargeting_ratio = 0.75;
[m,n,~] = size(original);
mm =m;  
nn = round(n*retargeting_ratio); % 75%
step_num = floor((n - nn)/step);
last_step = n - nn -step*(step_num);
cd('./HS')  
dos('run_original');
cd('../')
sal_orginal = imread('./HS/src1/original_res.png');
output_best = original; % initialization
sal_retargeted3 = sal_orginal; % initialization

for i = 1:(step_num+1)
    
    [m ,n,~] = size(output_best);
    h = m;
    if i~=step_num+1
        w = n - step;
    else
        w = n - last_step;
        step = last_step;
    end
    im = output_best;
    % SCL
    output_scl = scl( im , h, w);
    imwrite(output_scl,'./HS/src2/scl.bmp')
    % SC
    output_sc = seamcarving( im, step);
    imwrite(output_sc,'./HS/src2/sc.bmp')
    % CR
    sal = sal_retargeted3;
    output_cr = cr( im , m, n, step, sal);
    imwrite(output_cr,'./HS/src2/cr.bmp')
    
    cd('./HS')  
    dos('run_retargeted');
    cd('../')
    
    sal_retargeted1 = imread('./HS/src2/scl_res.png');
    sal_retargeted2 = imread('./HS/src2/sc_res.png');
    sal_retargeted3 = imread('./HS/src2/cr_res.png');
    % TRASIM
    score_1 = TRASIM(original, output_scl, sal_orginal, sal_retargeted1, model);
    score_2 = TRASIM(original, output_sc,  sal_orginal, sal_retargeted2, model);
    score_3 = TRASIM(original, output_cr, sal_orginal, sal_retargeted3, model);
    
    [Y,I] = sort([score_1, score_2, score_3]);
    if (I(3)==1)
        output_best = im2uint8(output_scl);
        disp(['########## Step = ' num2str(i)]);
        disp(['########## the best output is SCL']);
    elseif (I(3)==2)
        output_best = im2uint8(output_sc);
        disp(['########## Step = ' num2str(i)]);
        disp(['########## the best output is SC']);
    else
        output_best = im2uint8(output_cr);
        disp(['########## Step = ' num2str(i)]);
        disp(['########## the best output is CR']);
    end
        
end

result = output_best;
imwrite(result,'our.bmp');
