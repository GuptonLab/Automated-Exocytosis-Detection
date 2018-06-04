function multiObjectTracking_T(I_file)
%I_file = black and white final segmentation image. This is used for the
%entire process. Used to be just the original file name which was parsed,
%with the correct file ext added on later. For testing, just putting in the
%full BW file name.
%FILE2 = original file or the RM image. Literally only used for overlaying
%the tracking on.

% Create System objects used for reading video, detecting moving objects,
% and displaying the results.
obj = setupSystemObjects();

tracks = initializeTracks(); % Create an empty array of tracks.

nextId = 1; % ID of the next track

% Detect moving objects, and track them across video frames.
[pathstr,name, ~] = fileparts(I_file);
out_file = fullfile(pathstr,[name,'_tracking.tif']);
%frame2 = [name, '_RM_HA_SH_BW.tif'];  Used to parse the original file name
%for the final processing video. Taken out for testing
  [pathstr,name, ~] = fileparts(I_file);
 % I_file = [name, '_RM.tif'];
%for some reason I think I'm subtracting background; literally no reason
%why, since I try to apply it later on to the BW image??? Will comment out
%for now.

%frame2 = [name,'_STD_6.tif'];
frame2 = I_file;
tiff_info = imfinfo(frame2);
info = imfinfo(I_file);
num_images = numel(info);

%{
R = uint32(imread(I_file,1));
for o = 100:num_images
    R = imadd(R,uint32(imread(I_file, o)));
end
R = imdivide(R,num_images);
R = uint16(R);
%}



for ii = 1 : size(tiff_info, 1)
%for ii = 1 : size(tiff_info, 1)
    frame = imread(I_file,ii);
    [area, centroids, bboxes, majoraxis, minoraxis, ...
            perimeter, label, mask, Me, pix] = detectObjects(frame2,ii);
    predictNewLocationsOfTracks();
    [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment();

    updateAssignedTracks();
    updateUnassignedTracks();
    deleteLostTracks();
    createNewTracks(ii);

    displayTrackingResults();
end
T = struct2table(tracks_2,'AsArray',true);
T(:,[3,4,6,7,8,16]) = [];
writetable(T,[name,'_tracking.csv'],'Delimiter',',');
G = struct2table(tracks_2,'AsArray',true);
G(:,[3,4,6,7,8,10,11,12,14,15]) = [];
writetable(G,[name,'_explore.csv'],'Delimiter',',');
fclose('all');
function obj = setupSystemObjects()
        % Connected groups of foreground pixels are likely to correspond to moving
        % objects.  The blob analysis System object is used to find such groups
        % (called 'blobs' or 'connected components'), and compute their
        % characteristics, such as area, centroid, and the bounding box.

        obj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
            'AreaOutputPort', true, 'CentroidOutputPort', true, ...
            'MajorAxisLengthOutputPort', true, 'MinorAxisLengthOutputPort', true, ...
            'PerimeterOutputPort', true, 'LabelMatrixOutputPort', true, ...
            'MinimumBlobArea', 25);
end

function tracks = initializeTracks()
        % create an empty array of tracks
        tracks = struct(...
            'id', {}, ...
            'area', {}, ...
            'bbox', {}, ...
            'kalmanFilter', {}, ...
            'age', {}, ...
            'totalVisibleCount', {}, ...
            'invisible', {}, ...
            'label', {}, ...
            'time', {}, ...
            'majoraxis',{},...
            'minoraxis',{},...
            'perimeter',{},...
            'centroid', {}, ...
            'Me', {}, ...
            'pix', {}, ...
            'consecutiveInvisibleCount', {});
                tracks_2 = struct(...
            'id', {}, ...
            'area', {}, ...
            'bbox', {}, ...
            'kalmanFilter', {}, ...
            'age', {}, ...
            'totalVisibleCount', {}, ...
            'invisible', {}, ...
            'label', {}, ...
            'time', {}, ...
            'majoraxis',{},...
            'minoraxis',{},...
            'perimeter',{},...
            'centroid', {}, ...
            'Me', {}, ...
            'pix', {}, ...
            'consecutiveInvisibleCount', {});
        
end



function [area, centroids, bboxes, majoraxis, minoraxis, ...
        perimeter, label, mask, Me, pix] = detectObjects(frame,ii)

        % Detect foreground.This is actually just going to be our binary
        % mask. Used for all things in this program
        mask = imread(frame,ii);
        % Apply morphological operations to remove noise and fill in
        % holes.See how well this works for the small things, otherwise
        % take it out
        %mask = imopen(mask, strel('rectangle', [3,3]));
        %mask = imclose(mask, strel('rectangle', [15, 15]));
        %mask = imfill(mask, 'holes');
        
        % Perform blob analysis to find connected components.
        [area, centroids, bboxes, majoraxis,minoraxis,perimeter,...
            label] = obj.blobAnalyser.step(mask);
        props = regionprops(label, mask, 'MeanIntensity', 'PixelIdxList');
        Me = cat(1,props.MeanIntensity);
        pix = cat(1,props.PixelIdxList);
        %disp(pix);
        
end

 function predictNewLocationsOfTracks()
        for i = 1:length(tracks)
            bbox = tracks(i).bbox;

            % Predict the current location of the track.
            predictedCentroid = predict(tracks(i).kalmanFilter);

            % Shift the bounding box so that its center is at
            % the predicted location.
            %predictedCentroid = int32(predictedCentroid) - bbox(3:4) / 2;
            %tracks(i).bbox = [predictedCentroid, bbox(3:4)];
        end
 end


function [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment()
        
        nTracks = length(tracks);
        nDetections = size(centroids, 1);

        % Compute the cost of assigning each detection to each track.
        cost = zeros(nTracks, nDetections);
        for i = 1:nTracks

            cost(i, :) = distance(tracks(i).kalmanFilter, centroids);
        end

        % Solve the assignment problem.
        unassignedTrackCost = 7;
        unassignedDetectionCost = 7;
        [assignments, unassignedTracks, unassignedDetections] = ...
            assignDetectionsToTracks(cost, unassignedTrackCost, unassignedDetectionCost);
end

function updateAssignedTracks()
        numAssignedTracks = size(assignments, 1);
        for i = 1:numAssignedTracks
            trackIdx = assignments(i, 1);
            detectionIdx = assignments(i, 2);
            centroid = centroids(detectionIdx, :);
            areaU = area(detectionIdx, :);
            bbox = bboxes(detectionIdx, :);
            MeU = Me(detectionIdx, :);
            pixU = pix(detectionIdx, :);
            majorU = majoraxis(detectionIdx, :);
            minorU = minoraxis(detectionIdx, :);
            % Update track's age.
            tracks(trackIdx).age = tracks(trackIdx).age + 1;

            % Correct the estimate of the object's location
            % using the new detection.
            correct(tracks(trackIdx).kalmanFilter, centroid);

            % Replace predicted bounding box with detected
            % bounding box.
            tracks(trackIdx).bbox = bbox;

            %add new area
            tracks(trackIdx).area(tracks(trackIdx).age) = areaU;
            %add new mean
            tracks(trackIdx).Me(tracks(trackIdx).age) = MeU;
            
            %update major/minor axis
            tracks(trackIdx).majoraxis(tracks(trackIdx).age) = majorU;
            tracks(trackIdx).minoraxis(tracks(trackIdx).age) = minorU;
            
            %add new pixelList
            %tracks(trackIdx).pix(tracks(trackIdx).age) = pixU;
            
            %disp(tracks(trackIdx).area(:));
            % Update visibility.
            tracks(trackIdx).totalVisibleCount = ...
                tracks(trackIdx).totalVisibleCount + 1;
            tracks(trackIdx).consecutiveInvisibleCount = 0;
        end
end

function updateUnassignedTracks()
        for i = 1:length(unassignedTracks)
            ind = unassignedTracks(i);
            tracks(ind).invisible = 1;
            tracks(ind).consecutiveInvisibleCount = ...
            tracks(ind).consecutiveInvisibleCount + 1;
        end
end

  function deleteLostTracks()
        if isempty(tracks)
            return;
        end

        ageThreshold = 2;

        % Compute the fraction of the track's age for which it was visible.
        ages = [tracks(:).age];
        totalVisibleCounts = [tracks(:).totalVisibleCount];
        visibility = totalVisibleCounts ./ ages;

        % Find the indices of 'lost' tracks.
        lostInds = (ages < ageThreshold & [tracks(:).invisible] == 1);
        EndInds = [tracks(:).invisible] == 1;
        % Delete lost tracks.
        tracks_2(EndInds) = tracks(EndInds);
        tracks = tracks(~lostInds);
  end

function createNewTracks(time)
        area = area(unassignedDetections, :);
        centroids = centroids(unassignedDetections, :);
        bboxes = bboxes(unassignedDetections, :);
        majoraxis = majoraxis(unassignedDetections, :);
        minoraxis = minoraxis(unassignedDetections, :);
        perimeter = perimeter(unassignedDetections, :);
        label = label(unassignedDetections, :);
        Me = Me(unassignedDetections, :);
        pix = pix(unassignedDetections, :);
        for i = 1:size(centroids, 1)
            
            areaZ(1) = area(i,:);
            centroid = centroids(i,:);
            bbox(1,:,1) = bboxes(i, :);
            majoraxisZ(1) = majoraxis(i, :);
            minoraxisZ(1) = minoraxis(i, :);
            perim(1) = perimeter(i, :);
            labelZ(1,:,1) = label(i, :);
            Mez(1) = Me(i,:);
            pixZ(1, :, :) = pix(i, :);
            % Create a Kalman filter object.
            kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
                centroid, [200, 50], [100, 25], 100);

            % Create a new track.
            newTrack = struct(...
                'id', nextId, ...
                'area', areaZ,...
                'bbox', bbox, ...
                'kalmanFilter', kalmanFilter, ...
                'age', 1, ...
                'totalVisibleCount', 1, ...
                'invisible',0, ...
                'label', labelZ,...
                'time', time,...
                'majoraxis', majoraxisZ,...
                'minoraxis', minoraxisZ,...
                'perimeter', perim, ...
                'centroid', centroid, ...
                'Me', Mez, ...
                'pix', pixZ, ...
                'consecutiveInvisibleCount', 0);

            % Add it to the array of tracks.
            tracks(end + 1) = newTrack;
            % Increment the next id.
            nextId = nextId + 1;
        end
    end
function displayTrackingResults()
        % Convert the frame and the mask to uint8 RGB.
        frame = im2uint8(frame);
        mask = uint8(repmat(mask, [1, 1, 3])) .* 255;

        minVisibleCount = 1;
        if ~isempty(tracks)

            % Noisy detections tend to result in short-lived tracks.
            % Only display tracks that have been visible for more than
            % a minimum number of frames.
            reliableTrackInds = ...
                [tracks(:).totalVisibleCount] > minVisibleCount;
            reliableTracks = tracks(reliableTrackInds);

            % Display the objects. If an object has not been detected
            % in this frame, display its predicted bounding box.
            if ~isempty(reliableTracks)
                % Get bounding boxes.
                bboxes = cat(1, reliableTracks.bbox);
                
                %get labels
               
                % Get ids.
                ids = int32([reliableTracks(:).id]);

                % Create labels for objects indicating the ones for
                % which we display the predicted rather than the actual
                % location.
                
                labels = cellstr(int2str(ids'));
                %{
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {' predicted'};
                labels = strcat(labels, isPredicted);
                %}
                % Draw the objects on the frame.
                frame = insertShape(frame, 'rectangle', ...
                   bboxes, 'Color', 'black');

                % Draw the objects on the mask.
               % mask = insertObjectAnnotation(mask, 'rectangle', ...
                   % bboxes, labels);
            end
        end

        % Display the mask and the frame.
        imwrite(frame, out_file, 'Compression','none', 'Writemode', 'append');
        %imshow(frame,[])
       
end
end