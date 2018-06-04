function payground2(I_file)
% Detect exocytosis in a single frame

%set the file name to I_file for easier handling
%I_file = 'Stream_2.tif';

%Obtain information from the file
tiff_info = imfinfo(I_file);
[pathstr,name, ~] = fileparts(I_file);

%create a file name to be saved
out_file = fullfile(pathstr,[name,'_thenewdeal.tif']);

%Find the cell mask
mask = [name, '_mask_file.tif'];
maskForT = imread(mask);
maskForT = bwareafilt(maskForT,1);

%Loop through each of the images
for ii = 1 : size(tiff_info, 1)
    
    %read in the image to be tested and convert to double
    testFig2 = imread(I_file,ii);
    testFig2 = double(testFig2);

    %Filter with a gaussian
    testFig2 = imgaussfilt(testFig2,2);

    %Find maxima only in the region of interest
    %pks = imregionalmax(testFig2);
    %figure,imshow(pks);

    %Using only the pixels in the cell mask, look at the histogram and
    pixelsToTest = regionprops(maskForT,testFig2, 'PixelValues');

    %find the mean and standard deviation of the pixels in the cell
    meanP = mean(pixelsToTest.PixelValues);
    st = std(pixelsToTest.PixelValues);
    st2m = meanP+(3*st);
    
    %Find only the pixels that are 4 standard deviations away from the mean
    testFig3 = testFig2 > st2m;
    testFig3 = immultiply(testFig3,maskForT);
    
    %Save the image into a file
    imwrite(testFig3, out_file, 'Compression','none', 'Writemode', 'append');
end

%Perform Gaussian fitting on the maxima that have been thresholded
