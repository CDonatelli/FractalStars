
imageFiles = dir('*.bmp');

% for j = 1:length(imageFiles)

    % Fractal Dimension
    % log_e(N) = -D = log(N)/log(e)
    % Where N is the number of segments (cubes)
    % e is the fraction

    x = 1:20; % fraction
    squareN = x.^2;  % squares

    % create a matrix of binary values for "contains star" (1) and "does not
    % contain star" (0)
    image = imread(imageFile);
    [m,n] = size(image);
        if m > n
            image = imrotate(image,90);
        end
    binaryImage = imbinarize(image);
    [m,n] = size(binaryImage);

    containingSquares = [];
    for i = 1:20
       squareHeight = floor(n/i); hIndex = 1:squareHeight:i;
       squareCount = 0;
       currentSquares = mat2tiles(binaryImage ,[squareHeight,squareHeight]);
       [pNum, qNum] = size(currentSquares);
       for p = 1:pNum
           for q = 1:qNum
                currentSquare = cell2mat(currentSquares(p,q));
                squareCount = squareCount + any(currentSquare(:));
           end
       end
       e = 1/i;
%        D = -log(squareCount)/(log(e));
       containingSquares = [containingSquares;[i,squareHeight,squareCount]];
       disp(['We are on iteration ',num2str(i),'.'])
    end
    
    save([imageFile(1:end-4),'2D.mat'],'containingSquares')
    
    Dp1 = polyfit(log(containingSquares(:,2)),log(containingSquares(:,3)),1);
    D1 = abs(Dp1(1));
% end





