%% Filtering on MRI image (breast cancer)
% Image is obtained from: 
% https://pubs.rsna.org/doi/full/10.1148/radiol.2019182947
% Figure 6.a
%% Load the data
% Read the image
tumor = imread("breast_cancer.jpeg");

% For filtering we need to reduce the image to 2-D
tumor = tumor(:,:,1);

% Binarize the image
btumor = imbinarize(tumor);

% Display both images
figure(1)
imshowpair(tumor,btumor,'montage')
title('Original and Binarized Image')

%% Create an averaging filter
filtsize = [80 80];
avg = fspecial('average',filtsize);

% Apply the filter to the original image
Avgtumor = imfilter(tumor,avg,'symmetric');
figure(2)
subplot(121)
imshow(Avgtumor), title('Average Filtered Image')

% Apply the filter to the binarized image
AvgBtumor = imfilter(btumor,avg,'symmetric');
figure(2)
subplot(122)
imshow(AvgBtumor)
title('Average Filtered and Binarized Image')

% Interpretation:
% As filter size increases, we get close to remove noise but also
% we lose resolution of the original image.
%% Nonlinear Filtering
% Create and apply a median filter
filtsize = [16 16];
Medtumor = medfilt2(tumor,filtsize);

% Binarize the filtered image
MedBtumor = imbinarize(Medtumor);

% Display both images
figure(3)
imshowpair(Medtumor,MedBtumor,'montage')
title('Median Filtered Image')

% Create a Wiener filter
filterSize = [32 32];
Wtumor = wiener2(tumor,filterSize);

% Binarize the filtered image
WBtumor = imbinarize(Wtumor);

% Display both images 
figure(4)
imshowpair(Wtumor,WBtumor,'montage')
title('Wiener Filtered Image')
% Wiener filter is adaptive. There is less smoothing in areas of higher variation to preserve detail.

%% Image Quality Evaluation
% Calculate the NIQE (Natural Image Quality Evaluator) score
niqeAvg = niqe(Avgtumor);
niqeMed = niqe(Medtumor);
niqeW = niqe(Wtumor);

% Calculate BRISQUE(Blind/Referenceless Image Spatial Quality Evaluator) score
bAvg = brisque(Avgtumor);
bMed = brisque(Medtumor);
bWien = brisque(Wtumor);

%% Removing Background
% Define a disk-shaped neighborhood
nhood = strel('disk',25);

% Remove background illumination
tumorTop = imtophat(Medtumor,nhood);

% Binarize the background removed image
tumorTopB = imbinarize(tumorTop);

% Display both images
figure(5)
imshowpair(tumorTop,tumorTopB,'montage')
title('Background illumination is removed.')

%% end