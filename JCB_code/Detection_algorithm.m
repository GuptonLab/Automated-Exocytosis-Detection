  function Detection_algorithm(title, kap)
  
   num_iter = 100;
   delta_t = 1/7;
   kappa = kap;
   option = 2;
      %title = 'Fabs05_488TIRF_wt_netrin_3_hist_average.tif';
   [pathstr,name, ~] = fileparts(title);
  out_file_seed = fullfile(pathstr,[name,'_RM.tif']);

tiff_info = imfinfo(title); % return tiff structure, one element per ima
tic;
for ii = 1 : size(tiff_info, 1)
    %for ii = 358 : 365*
    s = imread(title,ii);
    s = imgaussfilt(s);
   ad = anisodiff2D(s,num_iter,delta_t,kappa,option);
   %figure, subplot 121, imshow(s,[]), subplot 122, imshow(ad,[])
   ad = mat2gray(ad);
    ad = im2uint16(ad);
    imwrite(ad, out_file_seed, 'Compression','none', 'Writemode', 'append');
end
toc;