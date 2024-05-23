load('offlineSlamData.mat'); % Load the data; 'scans' variable is expected in the file

% Create a VideoWriter object to write video frames
videoFilename = 'lidar_scans_video.avi';
v = VideoWriter(videoFilename);

% Set the frame rate. A lower frame rate will make each frame display longer.
v.FrameRate = 1; % One frame per second

% Open the VideoWriter object
open(v);

% Iterate through each scan, plot the data, and write the frame to the video
for k = 1:71
    % Create a new figure
    figure;
    
    % Convert polar coordinates to Cartesian coordinates and plot
    x = scans{k}.Ranges(:,1) .* cos(scans{k}.Angles(:,1));
    y = scans{k}.Ranges(:,1) .* sin(scans{k}.Angles(:,1));
    plot(x, y, '.'); % Using '.' for scatter plot style
    title(sprintf('For k=%d', k));
    
    % Capture the current frame
    frame = getframe(gcf);
    
    % Write the frame to the video
    writeVideo(v, frame);
    
    % Close the figure to avoid displaying it
    close(gcf);
end

% Close the VideoWriter object
close(v);

disp('Video creation complete.'); % Optional: Display a message when done
