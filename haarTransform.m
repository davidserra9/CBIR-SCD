function haarTransform()
%%% HAAR TRANSFORM TO THE HSV HISTOGRAMÇ
% Author: David Serrano
% github: davidserra9

% load the histograms of the Database
load hist_hsv.mat hist_hsv

% definition of the output coeficients of each iteration
% use the same bins as the histogram

coef11 = zeros(16,4,4,2000);
coef12 = zeros(16,4,4,2000);
coef13 = zeros(16,4,4,2000);

coef21 = zeros(16,4,4,2000);
coef22 = zeros(16,4,4,2000);
coef23 = zeros(16,4,4,2000);

% you can use as many iterations of the transform as possible
% the result will be worse but will use less memory

for p = 1:2000
% iteration 1 of the Haar Transform
    k = 1;
    for i = 1:2:(size(hist_hsv,1)-1)
        coef11(k,:,:,p) = (hist_hsv(i,:,:,p) + hist_hsv(i+1,:,:,p))/2;
        k = k + 1;
    end
    
    for i = 1:2:(size(hist_hsv,1)-1)
        coef11(k,:,:,p) = (hist_hsv(i,:,:,p) - hist_hsv(i+1,:,:,p))/2;
        k = k + 1;
    end
    
    k = 1;
    for i = 1:2:(size(hist_hsv,2)-1)
        coef12(:,k,:,p) = (coef11(:,i,:,p) + coef11(:,i+1,:,p))/2;
        k = k + 1;
    end
    
    for i = 1:2:(size(hist_hsv,2)-1)
        coef12(:,k,:,p) = (coef11(:,i,:,p) - coef11(:,i+1,:,p))/2;
        k = k + 1;
    end
    
    k = 1;
    for i = 1:2:(size(hist_hsv,3)-1)
        coef13(:,:,k,p) = (coef12(:,:,i,p) + coef12(:,:,i+1,p))/2;
        k = k + 1;
    end
    
    for i = 1:2:(size(hist_hsv,3)-1)
        coef13(:,:,k,p) = (coef12(:,:,i,p) - coef12(:,:,i+1,p))/2;
        k = k + 1;
    end
    
% iteration 2 of the Haar Transform
    k = 1;
    for i = 1:2:(size(hist_hsv,1)/2-1)
        coef21(k,:,:,p) = (coef13(i,:,:,p) + coef13(i+1,:,:,p))/2;
        k = k + 1;
    end
    
    for i = 1:2:(size(hist_hsv,1)/2-1)
        coef21(k,:,:,p) = (coef13(i,:,:,p) - coef13(i+1,:,:,p))/2;
        k = k + 1;
    end
    
    k = 1;
    for i = 1:2:(size(hist_hsv,2)/2-1)
        coef22(:,k,:,p) = (coef21(:,i,:,p) + coef21(:,i+1,:,p))/2;
        k = k + 1;
    end
    
    for i = 1:2:(size(hist_hsv,2)/2-1)
        coef22(:,k,:,p) = (coef21(:,i,:,p) - coef21(:,i+1,:,p))/2;
        k = k + 1;
    end
    
    k = 1;
    for i = 1:2:(size(hist_hsv,3)/2-1)
        coef23(:,:,k,p) = (coef22(:,:,i,p) + coef22(:,:,i+1,p))/2;
        k = k + 1;
    end
    
    for i = 1:2:(size(hist_hsv,3)/2-1)
        coef23(:,:,k,p) = (coef22(:,:,i,p) - coef22(:,:,i+1,p))/2;
        k = k + 1;
    end
end
% save the coeficient you want to use later on
haarBase = coef11;
save haarBase.mat haarBase
end

