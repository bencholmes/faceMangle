function Inew = imageMangle(I, nBlocks, maxOffset, addColour, spread, varargin)
% IMAGEMANGLE Rearange an image matrix by randomly moving blocks.
%
% Author:       Ben Holmes
% Init. Date:   2018/06/14
% Version:      0.1
% License:      CC0
%
% Inputs:
%   I:          2D image matrix of form NxNx3, must be uint8. N must be a
%   power of 2.
%
%   nBlocks:    Scalar, the number of blocks into which to divide the 
%   image.
%
%   maxOffset:  Scalar, the furthest number of blocks that a given block 
%   can move.
%
%   addColour:  3x1 vector uint8 defining the colour to add to moved
%   blocks.
%
%   spread:     String, 'all' for mangling everywhere equally, 'direction'
%   for choosing a direction in which to increase the mangling.
%
%   xPow:       If 'direction', chooses the direction and power of the
%   scaling in the x Direction. Negative powers inverse the direction.
%
%   yPow:       If 'direction', chooses the direction and power of the
%   scaling in the y Direction. Negative powers inverse the direction.
%
% Output:
%   Inew:       Mangled matrix.

if strcmp(spread, 'direction')
    xPow = varargin{1};
    yPow = varargin{2};
end

if size(I,1) ~= size(I,2)
    error('Image must be square.');
end

if floor(log2(size(I,1))) - log2(size(I,1)) > 0
    error('Image size must be a factor of two.');
end


% Original orders
xOrder = (1:nBlocks);
yOrder = (1:nBlocks);

if strcmp(spread,'all')
    % Uniform distribution of x and y blocks limited to maxOffset.
    xRnd = floor((1+2*maxOffset)*rand(1,nBlocks))-maxOffset;
    yRnd = floor((1+2*maxOffset)*rand(1,nBlocks))-maxOffset;
    
elseif strcmp(spread,'direction')
    
    % Use power sign to flip direction
    if xPow >0
        xRange = linspace(0,1,nBlocks).^xPow;
    elseif xPow < 0
        xRange = linspace(1,0,nBlocks).^abs(xPow);
    else
        xRange = zeros(1,nBlocks);
    end
    
    if yPow >0
        yRange = linspace(0,1,nBlocks).^yPow;
    elseif yPow < 0
        yRange = linspace(1,0,nBlocks).^abs(yPow);
    else
        yRange = zeros(1,nBlocks);
    end
    
    % Uniform distribution with directional factor.
    xRnd = floor(xRange.*(1+2*maxOffset).*rand(1,nBlocks))...
            - floor(xRange.*maxOffset);
    yRnd = floor(yRange.*(1+2*maxOffset).*rand(1,nBlocks))...
            - floor(yRange.*maxOffset);
    
else
    error('Spread is not properly defined.');
end

% Add noise.
xOrder = xOrder + xRnd;
yOrder = yOrder + yRnd;

% Limit the order
xOrder = min(max(xOrder,1),nBlocks);
yOrder = min(max(yOrder,1),nBlocks);

% Mangle
Inew = reorder2D(I, xOrder, yOrder, addColour);

end

