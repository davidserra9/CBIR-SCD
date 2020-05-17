function histogramHSV(bins_H,bins_S, bins_V)
%%% HISTOGRAMS IN THE COLOR SPACE HSV OF THE DATABASE
% Author: David Serrano
% github: davidserra9
Kentucky_Path = 'C:\Users\99dse\Desktop\github\CBIR-SCD\UKentuckyDatabase\UKentuckyDatabase\';
N = 2000;   % Num images database

% Example values: equivalent to 256 bits
% bins_H = 16;
% bins_S = 4;
% bins_V = 4;

% histograms in HSV of the images of the database
hist_hsv = zeros(bins_H, bins_S, bins_V, N);

imgRows    = 480;
imgColumns = 640;

for p = 0:(N-1)
    picture_name = [Kentucky_Path, 'ukbench', sprintf('%05d.jpg', p)];
    img = imread(picture_name);     % read image ukbenchp
    img_hsv = rgb2hsv(img);         % change to color space HSV
    
% divide the 3 components of the space
    hue        = img_hsv(:,:,1);    % hue
    saturation = img_hsv(:,:,2);    % saturation
    value      = img_hsv(:,:,3);    % value
   
% arrays to quantify the components in the bins received by parameters
    hue_quant        = zeros(imgRows, imgColumns);
    saturation_quant = zeros(imgRows, imgColumns);
    value_quant      = zeros(imgRows, imgColumns);

    pos = zeros(imgRows * imgColumns, 3);
    
% max values of the components to later on normalize
    MaxH = max(hue(:));
    MaxS = max(saturation(:));
    MaxV = max(value(:));

% quantification of the components 
k = 1;  
for i = 1:imgRows
    for j = 1:imgColumns
        hue_quant(i,j)        = round(bins_H * hue(i,j) / MaxH);
        saturation_quant(i,j) = round(bins_S * saturation(i,j) / MaxS);
        value_quant(i, j)     = round(bins_V * value(i,j) / MaxV); 
        pos(k, 1) = hue_quant(i, j);
        pos(k, 2) = saturation_quant(i, j);
        pos(k, 3) = value_quant(i, j);
        k = k + 1; 
    end
end
    
% histogram 
    for i = 1:imgRows * imgColumns
        bool=true;
        if ((pos(i,1) * pos(i,2) * pos(i,3)) == 0)
            bool = false;
        end
        if bool == true
            hist_hsv(pos(i, 1), pos(i, 2), pos(i, 3), (p+1)) = hist_hsv(pos(i, 1), pos(i, 2), pos(i, 3),(p+1)) + 1;
        end
    end
end

% save the variable of the histogram of the data base
save hist_hsv.mat hist_hsv
end


