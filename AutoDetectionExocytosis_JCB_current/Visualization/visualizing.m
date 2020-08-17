 
%image_path = ([pwd '/PreProcessed/',name,'_PreProcessed.tif']);

I = imread('VAMP2pHluorin_488_wt_4.tif');
I = imadjust(I);
m = readtable('VAMP2pHluorin_488_wt_4_Processed_tracking.csv');

radi = repmat(10,size(m.centroid_1,1),1);
image = insertShape(I,'Circle',[m.centroid_1 m.centroid_2 radi], 'LineWidth',4, 'Color','red');

figure, imshow(image);

3imwrite(image,"example.png");


blegh = insertShape(I,'Rectangle',[m.bbox_1 m.bbox_2 m.bbox_3 m.bbox_4],'LineWidth',4,'Color','red');

figure, imshow(blegh,[]);


%% Make a nice image of the file to be read in. Do the adjusting in imagej or elsewhere.
I_name = 'stream_1_what'
I_trackfile = 'Stream_1_what'

I = imread(I_name);
m = readtable(I_trackfile);
radi = repmat(10,size(m.centroid_1,1),1)
image = insertShape(I,'Circle',[m.centroid_1 m.centroid_2 radi], 'LineWidth',4, 'Color','red');

figure, imshow(image);

