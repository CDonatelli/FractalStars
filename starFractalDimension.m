
%%%%%%% Uncomment for Batch Processing
% files = dir;
% % Get a logical vector that tells which is a directory.
% dirFlags = [files.isdir];
% folders = files(dirFlags);
% for fold = 3:length(folders)
%     cd(folders(fold).name)
%     name = folders(fold).name(1:end-11);
%%%%%%% Uncomment for Batch Processing

function [D1, D2, containingCubes] = starFractalDimension()
    % Fractal Dimension
    % log_e(N) = -D = log(N)/log(e)
    % Where N is the number of segments (cubes)
    % e is the fraction

    imageFiles = dir('*.bmp');
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
            image = imrotate(image,90);
        end
        binaryStack = cat(3,binaryStack,image);
        if rem(i,20) == 0
            disp(['We have binarized and stacked image ',num2str(i),'.'])
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
       e = 1/cubeHeight;
%        D = -log(cubeCount)/(log(e));
       containingCubes = [containingCubes;[i,cubeHeight,cubeCount]];
       disp(['We are on iteration ',num2str(i),'.'])
    end
    cubeTime = toc/60;
% Change name to match the specimen you are processing
    save(['LeptArm01.mat'],'containingCubes')
 
    Dp1 = polyfit(log(containingCubes(:,2)),log(containingCubes(:,3)),1);
    D1 = abs(Dp1(1));
    
    Dp2 = polyfit(log(containingCubes(:,2).^2),log(containingCubes(:,3)),1);
    D2 = abs(Dp2(1));

    figure
    plot(log(containingCubes(:,1)), log(containingCubes(:,3)),'b-o')

end
%%%%%%% Uncomment for Batch Processing
%     save([name, '.mat'],'containingCubes')
%     cd ..
% end
%%%%%%% Uncomment for Batch Processing