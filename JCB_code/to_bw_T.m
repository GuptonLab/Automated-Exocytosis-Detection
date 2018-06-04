function to_bw_T(I_file)


[pathstr,name, ~] = fileparts(I_file);

I_file2 = [name,'_SH.tif'];
%I_file2 = I_file;
tiff_info = imfinfo(I_file2);
out_file_coral = fullfile(pathstr,[name,'_BW_fin.tif']);
maskname = [name,'_mask_file.tif'];
mask = imread(maskname);

for ii = 1 : size(tiff_info, 1)
what = imread(I_file2,ii);
bw = im2bw(what,0.35);
bw = immultiply(bw,mask);
imwrite(bw, out_file_coral, 'Compression','none', 'Writemode', 'append');
end


%multiObjectTracking();

