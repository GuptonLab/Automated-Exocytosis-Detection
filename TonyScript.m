%% Image analysis of focal adhesions for Anthony

fname = '~/Downloads/AJM 001 WT 488WF.tif';
info = imfinfo(fname);
num_images = numel(info);
actRaw = [];

for k = 1:num_images
    A = imread(fname, k);
    actRaw(:,:,k) = A;
end

fname = '~/Downloads/AJM 001 WT 561WF.tif';
info = imfinfo(fname);
num_images = numel(info);
faRaw = [];

for k = 1:num_images
    A = imread(fname, k);
    faRaw(:,:,k) = A;
end

%% Create MAsks
sigma=5; %sets gaussian blur width
q=.9; %sets dynamic quantile threshold
for i = 1:num_images
    im = actRaw(:,:,i);
    im = imgaussfilt(im,sigma);
    thresh = quantile(im(:),q);
    bw = im > thresh;
    BW(:,:,i)=bw;
end
%%
masked=[]; decon=[];
se = [-1 -1 -1 -1 -1 -1 -1;
    -1 -4 -2 -1 -2 -4 -1; 
    -1 -2 8 12 8 -2 -1;
    -1 -1 12 24 12 -1 -1;
    -1 -2 8 12 8 -2 -1;
    -1 -4 -2 -1 -2 -4 -1;
    -1 -1 -1 -1 -1 -1 -1;];

for i = 1:num_images
    masked = faRaw(:,:,i).*BW(:,:,i);
    decon(:,:,i) = conv2(masked, se);
    %imshow(decon(:,:,i),[])
    %pause()
end

%% Count spots
q =.9995; spots = [];S = struct; nSpots = [];
for i = 1:num_images
    im = decon(:,:,i);
    thresh = quantile(im(:),q);
    spots(:,:,i) = decon(:,:,i) > thresh;
    tmp = bwconncomp(spots(:,:,i),4);
    nSpots(i) = tmp.NumObjects;
end
%% Plot
i=1;
m = mean(nSpots);
st = std(nSpots);
L = bwlabel(spots(:,:,1),4);
RGB = label2rgb(L);
figure(1);
imshow(faRaw(:,:,i),[],'InitialMagnification',300); 
title('Raw Image')
figure(2)
imshow(RGB,[],'InitialMagnification',300)
title('identified spots')
figure(3)
boxplot(nSpots)
title(sprintf('All cells: Mean = %d, STD = %d',m,st))





