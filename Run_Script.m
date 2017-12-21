function Run_Script(I_file)
%%MASTER SCRIPT
%{

%Start with a folder that has all of your files in it. All of the files
will be run through. Each new file generated will have it's own subname
added to the original file name and be saved in a new folder.The files will
fall in this order:

%Cell Mask(original file): This will segment out the entire neuron.
%Region Merging(Original file,threshold): This is the longest part of the
process, taking roughly 2 hours per image stack (601 frames). This will
smooth out the image and allow detection of events above the background.
%Histogram Equalization(region-merged file): This will equalize each frame
so that all the files in the stack will have roughly the same background.

%Sharpen(equalized region-merged file, sharpen value): This will
dramatically increase each event's intensity above the background.
%BW(Sharpened image): This is what will segment out the events from the
background.
MultiObjectTracking(BW image stack): This is the tracking matrix. It will
determine the birth, lifetime, and death of each exocytic event. It will
only count objects that stay around for at least 3 frames so as to reduce
random noise/incomplete information. From this tracking matrix, the result
files will be generated.


%Generate Cell mask
Cell_Mask

%Merge Regions
Region_merging_final_T

%Histogram equalization
histogram_equalize_T

%sharpen
to_sharpen_T

%convert to mask
to_bw
%}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Actual run code%%%%%%%%%%%%%%%%%%%%%%%%%%
I = I_file;

%Setting up parameters
s = 0.3; %s = sharpening threshold
kap = 30; %kap = the kappa needed for the region merging algorithm

Cell_Mask(I);

%Region_merging_final_T(I,kap);
Detection_algorithm(I,kap);
histogram_equalize_T(I);
to_sharpen_T(I,s);
to_bw_T(I);
multiObjectTracking_T(I);
%multiObjectTracking_T_show_track(I);
Extract_fusion(I);