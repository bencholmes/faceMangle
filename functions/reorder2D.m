function Inew = reorder2D(I, xOrder, yOrder, addColour)

if ~exist('addColour','var')
    addColour = uint8([0; 0; 0]);
end

xLength = size(I,1);
yLength = size(I,2);

nXBlocks = length(xOrder);
nYBlocks = length(yOrder);

xBlocks = cell(1,nXBlocks);

for nn=1:nXBlocks
    xBlocks{nn} = (nn-1)*(xLength/nXBlocks)+1:nn*(xLength/nXBlocks);
end

yBlocks = cell(1,nYBlocks);

for nn=1:nYBlocks
    yBlocks{nn} = (nn-1)*(yLength/nYBlocks)+1:nn*(yLength/nYBlocks);
end

% Form original block order.
xOrigOrder = 1:nXBlocks;
yOrigOrder = 1:nYBlocks;

% Find the distance from the original order.
xRnd = xOrder - xOrigOrder;
yRnd = yOrder - yOrigOrder;

colourBlock = uint8(permute(repmat(addColour,1,xLength/nXBlocks,yLength/nYBlocks),[3 2 1]));

Inew = I;
for nn=1:nXBlocks
    for mm=1:nYBlocks
        colourFactor = abs((xRnd(nn)+yRnd(mm)./(max(xRnd)+max(yRnd))));
        
        Inew(yBlocks{yOrigOrder(mm)}, xBlocks{xOrigOrder(nn)}, :) = ...
            I(yBlocks{yOrder(mm)}, xBlocks{xOrder(nn)}, :) + ...
            colourFactor*colourBlock;
    end
end

end

