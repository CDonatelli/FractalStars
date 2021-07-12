
files = dir;
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
folders = files(dirFlags);

D1mat = []; D2mat = []; nameMat = {}; numMat = {};
for fold = 3:length(folders)
    cd(folders(fold).name)
    name = folders(fold).name(1:end-2);
    num = folders(fold).name(end-2:end);
    [D1, D2, containingCubes] = starFractalDimension();
    D1mat = [D1mat; D1];
    D2mat = [D2mat; D2];
    nameMat{end+1,1} = name;
    numMat{end+1,1} = num;
    cd ..
end

DataTable = table(nameMat, numMat, D1mat, D2mat);