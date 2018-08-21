
% Fractal Dimension
% log_e(N) = -D = log(N)/log(e)
% Where N is the number of segments (cubes)
% e is the fraction

imageFiles = dir('*.tif');
numImages = size(imageFiles);

x = 1:20; % fraction
cubeN = x.^3;  % cubes

% create a matrix of binary values for "contains star" (1) and "does not
% contain star" (0)
binaryStack = [];
for i = 1:numImages
    image = imread(imageFiles(i).name);
    [m,n] = size(image);
    if m > n
        image = imroate(image,90);
    end
    binaryImage = imbinarize(image);
    binaryStack = cat(3,binaryStack,binaryImage);
end

[height, length, depth] = size(binaryStack);
% cubeStart = floor(height/3);
containingCubes = [];
for i = 1:20
   cubeHeight = floor(height/i); hIndex = 1:cubeHeight:height;
%    cubeLength = floor(height/i); lIndex = 1:cubeLength:length;
%    cubeDepth = floor(depth/i);   dIndex = 1:cubeDepth:depth;
   cubeCount = 0;
   currentCubes = mat2tiles(binaryStack ,[cubeHeight,cubeHeight,cubeHeight]);
   [pNum, qNum, rNum] = size(currentCubes);
   for p = 1:pNum
       for q = 1:qNum
           for r = 1:rNum
               currentCube = cell2mat(currentCubes(p,q,r));
               cubeCount = cubeCount + any(currentCube(:));
           end
       end
   end
   containingCubes = [containingCubes;[i,pNum*qNum*rNum,cubeCount]];
end


% Fractal Dimension
% log_e(N) = -D = log(N)/log(e)
% Where N is the number of segments (cubes)
% e is the fraction

e = 1/20;