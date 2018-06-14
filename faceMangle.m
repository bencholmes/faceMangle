clear;

%% Load photo
% Format must be of NxMx3 photo where the third dimension is the RGB, and
% the data is all in uint8.
fName = 'cabinet-card-photo';
% fName = 'liz4';
[I, map] = imread(sprintf('./image/%s.jpg',fName), 'jpg');

%% Fit to a power of 2 square size
% Scale and crop any photo to make it square.

[minDim, minDimInd] = min([size(I,1) size(I,2)]);

minP2 = floor(log2(minDim));
newSize = 2^(minP2);

% Scale down to the nearest power of 2
scaleRatio = minDim/newSize;
Iscaled = imresize(I, newSize/minDim);

% Crop the other axis to make it exactly square
Iscaled = Iscaled(1:newSize,1:newSize,:);

%% Setup plot
figure(1);
clf;

%% Mangle just in X direction

% Arguments: Image, number of blocks, max distance, added colour,
% direction, power of direction
mangledX = imageMangle(Iscaled, 2^4, 4, [0;0;0], 'direction', -1, 0);

figure(2);
clf;

plot(100*linspace(0,1,100),100*(linspace(0,1,100)));
hold on;
plot(100*linspace(0,1,100),100*(linspace(0,1,100).^3));
plot(100*linspace(0,1,100),100*(linspace(1,0,100).^1));
plot(100*linspace(0,1,100),100*(linspace(1,0,100).^3));
legend('Power = 1','Power = 3','Power = -1','Power = -3');
title('Power control');
xlabel('X or Y position (%)');
ylabel('Amount of mangling (%)');
print(gcf,'./image/Power-control.png','-dpng','-r512');

figure(1)
subplot(1,3,1)
imshow(mangledX);
title('Mangled in X direction only');

% imwrite(mangledX,sprintf('image/%s-mangled-xdir.jpg',fName))
%% Mangle everywhere with colour

% Colours add a bit of colour to a block dependent on how much it is moved.
% Set to [0; 0; 0] for no added colour.
addColours = {[12; 3; 3];...
              [5; 3; 12];...
              [32; 3; 3];...
              [12; 3; 32];...
              [12; 31; 3];...
              [12; 50; 50]};
          
nColours = length(addColours);

mangledAll = imageMangle(Iscaled, 2^5, 2, addColours{floor(nColours*rand(1))+1}, 'all');

figure(1)
subplot(1,3,2)
imshow(mangledAll)
title('Mangled everywhere with colour');

% imwrite(mangledAll,sprintf('image/%s-mangled-allColour.jpg',fName))

%% Mangle in a loop
% Loop through big to small block sizes
mangledLoop = Iscaled;

% Low numbers here mean big blocks, high numbers mean small blocks
blockRange = min(3:6, minP2);
nSteps = length(blockRange);

power = 4;

maxOffset = floor(linspace(3,2,nSteps));

for nn=1:nSteps
    % Mangle over a direction.
    mangledLoop = imageMangle(mangledLoop, 2^blockRange(nn), maxOffset(nn), addColours{floor(nColours*rand(1))+1}, 'direction', -power, power);
    mangledLoop = imageMangle(mangledLoop, 2^blockRange(nn), maxOffset(nn), addColours{floor(nColours*rand(1))+1}, 'direction', power, -power);
end
figure(1)
subplot(1,3,3)
imshow(mangledLoop)
title('Mangled in a loop');

print(gcf,sprintf('image/%s-mangled-set.png',fName),'-dpng','-r512');

% imwrite(mangledLoop,sprintf('image/%s-mangled-loop.jpg',fName))