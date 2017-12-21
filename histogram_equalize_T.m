function histogram_equalize_T(I_file)

tic;
  [pathstr,name, ~] = fileparts(I_file);
  I_file = [name, '_RM.tif'];
tiff_info = imfinfo(I_file); % return tiff structure, one element per image
tiff_stack = imread(I_file, 1) ; % read in first image

expression_levels = zeros(1,length(I_file));
after_correction = zeros(1,length(I_file));
pos = zeros(1,length(I_file));
%%%%%concatenate each successive tiff to tiff_stack

  out_file_coral = fullfile(pathstr,[name,'_RM_T.tif']);
tiff_info = imfinfo(I_file);
for ii = 1 : size(tiff_info, 1)
    temp_tiff = imread(I_file, ii);
    expression_levels(ii) = mean(temp_tiff(:));
    coral_image = temp_tiff*(expression_levels(1)/expression_levels(ii));
     after_correction(ii) = mean(coral_image(:));
    pos(ii) = ii;
    imwrite(coral_image, out_file_coral, 'Compression','none', 'Writemode', 'append');
    %%%tiff_stack = cat(3 , tiff_stack, temp_tiff);
    
end
  %csvwrite('expression_levels.csv',expression_levels);
  %csvwrite('after_cor.csv', after_correction);
  
plot(expression_levels);
hold on;
plot(after_correction);
toc;