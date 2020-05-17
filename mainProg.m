function mainProg()
%%% MAIN PROGRAM OF THE CBIR WITH SCD
% Author: David Serrano
% github: davidserra9

% path of the input and output text files
input_Path = 'C:\Users\99dse\Desktop\github\CBIR-SCD\TextFiles\input.txt';
output_Path = 'C:\Users\99dse\Desktop\github\CBIR-SCD\TextFiles\output.txt';

input = fopen(input_Path, 'r');     % open input.txt (read only)
output = fopen(output_Path, 'w');   % open output.txt (write only)

picture2search = 0;                 % number of query images

% detect the number of rows of the input.txt and the number of query iamges
while ~feof(input)
    line = fgetl(input);
    if isempty(line) || strncmp(line,'%',1) || ~ischar(line)
        continue
    end
    picture2search = picture2search + 1;
end
frewind(input);    
formatSpec = '%s';                  % specify the lecture format 
A = strings([1,picture2search]);    % array of strings where we save the name of each query image
for i=1:picture2search
    A(i) = fscanf(input, formatSpec,1);
end
fclose(input);                      % close input.txt

load ('haarBase.mat', 'haarBase');          % load the transformed histograms of the Database

query_numbers = zeros(1,size(A,2));
query_histograms = zeros(size(haarBase,1),size(haarBase,2),size(haarBase,3),size(query_numbers,2));

% get only the numbers of the images to search and get their histogram.
% In a real life case we should calculate the histogram and its Haar
% transformed for each input image. In this case, we look the database and
% get the values.
for i=1:size(A,2)
    query_numbers(i) = str2double(extractBetween(A(i),"ukbench", ".jpg"));
    query_histograms(:,:,:,i)=haarBase(:,:,:,query_numbers(i)+1);
end

% comparison between each query with each image in the data base
% we use the mean value of the Euclidean distance of each level
comparison_matrix = zeros(size(A,2), size(haarBase,4));
for i=1:size(query_numbers,2)
    for j=1:size(haarBase,4)
        distance = query_histograms(:,:,:,i)-haarBase(:,:,:,j);
        comparison_matrix(i,j)= mean(mean(mean(abs(distance))));
    end
end

% get the 10 better results for each query image
results = zeros(size(query_numbers,2),10);
for i=1:size(query_numbers,2)
    [value, index] = mink(comparison_matrix(i,:), 10);
    results(i,:) = index-1;
end

% writing in the output file output.txt
for i = 1:size(query_numbers,2)
    frase = ['Retrieved list for query image ukbench', sprintf('%05d.jpg\n',query_numbers(i))];
    fprintf(output, formatSpec, frase);

    for j = 1:10
        image_name = ['ukbench', sprintf('%05d.jpg\n', results(i,j))];
        fprintf(output, formatSpec, image_name);
    end
end

% PRECISION RECALL CALCULATION

% We divide the Database in groups of 4 images which will be the same
% picture taken with different iluminations and angles
correct_groups = zeros(1,size(query_numbers,2)); %correct groups for each query image
precision = zeros(1,10);
recall = zeros(1,10);

% calculation of the correct groups of the query images
for i=1:size(query_numbers,2)
    correct_groups(i) = floor(query_numbers(i)/4);
end

% look and annotate the hits of the results
for i=1:size(query_numbers,2)
    hits = 0;
    for j=1:10
        if ((floor((results(i,j))/4)) == correct_groups(i))
            hits = hits + 1;
        end
        precision(j) = precision(j) + (hits/j);
        recall(j) = recall(j) + (hits/4);
    end
end  
precision = precision/picture2search;
recall = recall/picture2search;

% calculation to the FScore measure
Fmeasure = zeros(1,10);
for i=1:10
    Fmeasure(i) = (2 * precision(i) * recall(i)) / (precision(i) + recall(i));
end
F_Score = max(Fmeasure);

% plot the precision-recall graph
figure, plot(recall, precision, '-o')
title('precision - recall')
ylim([0,1]);
xlim([0,1]);
grid on;
string = ['FScore: ',num2str(F_Score)];
legend(string);
end


