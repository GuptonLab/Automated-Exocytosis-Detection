function to_sharpen_T(I_file,s)
%generally s = 0.1-0.3
tiff_info = imfinfo(I_file);
[pathstr,name, ~] = fileparts(I_file);
I_file_F = [name,'_RM_T.tif'];
%hist_averaging(master);
%I_file = 'Fabs05_488TIRF_wt_netrin_1_WOO_100_mod_final_hist_average.tif';

tiff_info2 = imfinfo(I_file_F);
out_file_coral3 = fullfile(pathstr,[name,'_SH.tif']);


for ii = 1 : size(tiff_info2, 1)
what = imread(I_file_F,ii);

what2 = imsharpen(what, 'Radius', 50, 'Amount', 12, 'Threshold', s);
imwrite(what2, out_file_coral3, 'Compression','none', 'Writemode', 'append');

end
