
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
tic
for i = 1:numImages
    image = imread(imageFiles(i).name);
    [m,n] = size(image);
    if m > n
        image = imroate(image,90);
    end
    binaryImage = imbinarize(image);
    binaryStack = cat(3,binaryStack,binaryImage);
    if rem(i,20) == 0
        disp(['We have binarized image ',num2str(i),'.'])
    end
end
stackTime = toc/60;

[height, length, depth] = size(binaryStack);
% cubeStart = floor(height/3);
tic
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
   e = 1/i;
   D = -log(cubeCount)/(log(e));
   containingCubes = [containingCubes;[i,pNum*qNum*rNum,cubeCount,D]];
   disp(['We are on iteration ',num2str(i),'.'])
end
cubeTime = toc/60;

% Fractal Dimension
% log_e(N) = -D = log(N)/log(e)
% Where N is the number of segments (cubes)
% e is the fraction