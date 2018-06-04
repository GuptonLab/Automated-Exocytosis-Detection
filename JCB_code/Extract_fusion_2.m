function Extract_fusion_2(I_file)

tiff_info = imfinfo(I_file);
[pathstr,name, ~] = fileparts(I_file);

out_file = fullfile(pathstr,[name,'_final_NBD.csv']);

I2 = I_file;
I2a = [name,'_thenewdeal.tif'];
I2b = [name,'_xyz.csv'];
mask = [name, '_mask_file.tif'];
expf = readtable(I2b, 'Delimiter', 'comma');

Xv = expf.centroid_1;
Yv = expf.centroid_2;
timez = expf.time;
disp(length(timez));

for ii = 1:length(timez)
%Read in the files at each time
L = imread(I2a,timez(ii));
real = imread(I2,(timez(ii)+1));

%extract the number of objects to loop through
[GLFS, num] = bwlabel(L);

%Get the pixel list of the black and white image
s = regionprops(L,'PixelList', 'PixelIdxList','Centroid');

%Get the co-ordinate of the tracked object in question
 sc = [round(Xv(ii)),round(Yv(ii))];
 
 %Loop through each of the objects in the frame
 for kk = 1:num
      pixelCoords = [s(kk).PixelList]; % Get coords of eack blob.
      Insidek = ismember(pixelCoords, sc, 'rows');
      if sum(Insidek) == 1
          truthi = kk;
      end

 end
  
 %now we have the object. We are going to track it
 tracOb = s(truthi).PixelIdxList;
 
 dd = 1; %for counting the flourescent index
 fram_num(ii) = timez(ii); %going to add the frame # and obj# for easy analysis
 obj_num(ii) = truthi;
  center(ii,:) = cat(1,round(s(truthi).Centroid));
  
 %also adding the centroid

 %Grab the mean fluorescence from each of the image frames before/after
 for ff = (timez(ii)-20):(timez(ii)+30)
     if (0 < ff && ff < 1000)
        temp_real = imread(I2,ff);
        mean_fl(ii,dd) = mean(temp_real(tracOb));
        dd = dd+1;
     else
         mean_fl(ii,dd) = 0;
         dd = dd+1;
     end
 end
 
 %{
 k=1;
 blobCentroid = sc(k).Centroid;
 pixelCoords = [s(k).PixelList]; % Get coords of blob #1.
 Insidek = ismember(pixelCoords, blobCentroid(1,:), 'rows');
then
sum(Insidek) is 
giving me zero all values but if i used round as

 Insidek = ismember(pixelCoords, round(blobCentroid(1,:)), 'rows');
I found 
sum(Insidek) is 1 for a centroid who is inside otherwise it is zero.
%}
end

obj_num = transpose(obj_num);
fram_num = transpose(fram_num);
disp('wat');
disp(size(center));
disp(size(fram_num));
disp(size(obj_num));
disp(size(mean_fl));
fin = cat(2,center,fram_num,obj_num,mean_fl);
csvwrite(out_file,fin);