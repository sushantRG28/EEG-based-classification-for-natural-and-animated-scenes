parentFolder = 'E:\Books\appina sir\Final recordings MAT';
numLabels = 100;

% Explicitly set subject folder names in required order
subjectNames = {'S1', 'S2', 'S3', 'S4', 'S5', ...
                'S6', 'S7', 'S8', 'S9'};
numSubjects = numel(subjectNames);

Natural=[];
Animated=[];

for subjIdx = 1:numSubjects
    subjectName = subjectNames{subjIdx};
    subjectFolder = fullfile(parentFolder, subjectName);
    
    % Look for the 'natural' data file in the subject's folder
    naturalFiles = dir(fullfile(subjectFolder, '*natural*.mat'));
    animatedfiles=dir(fullfile(subjectFolder, '*animated*.mat'));
    if ~isempty(naturalFiles) && ~isempty(animatedfiles)

        dataPath_natural = fullfile(subjectFolder, naturalFiles(1).name);
        dataStruct_natural = load(dataPath_natural);
        data_natural = dataStruct_natural.data; % Extraction as in your code

        dataPath_animated = fullfile(subjectFolder, animatedfiles(1).name);
        dataStruct_animated = load(dataPath_animated);
        data_animated = dataStruct_animated.data; % Extraction as in your code
      
       natural_each = extractOutput(data_natural,subjIdx);
       animated_each = extractOutput(data_animated,subjIdx);

       % Truncate the last 3000 rows for each cell element:
        for i = 1:numel(natural_each)
            if size(natural_each{i}, 1) > 3000
                natural_each{i} = natural_each{i}(end-2999:end, :);
            end
        end
        
        for i = 1:numel(animated_each)
            if size(animated_each{i}, 1) > 3000
                animated_each{i} = animated_each{i}(end-2999:end, :);
            end
        end

       Natural=[Natural;natural_each];
       Animated=[Animated;animated_each];
    else
        warning('Natural .mat file not found for subject folder: %s', subjectName);
    end
end


for subjIdx = 1:numSubjects
    for image=1:100
        check_size_Natural=Natural{subjIdx,image};
        check_size_Animated=Animated{subjIdx,image};
        if size(check_size_Natural,1) >=2 && size(check_size_Natural,1) <= 10
            if image > 1   % only replace if previous column exists
                Natural{subjIdx,image} = Natural{subjIdx,image-1};
            else
                % If image == 1, no previous column exists
                % You can decide: leave it as is, or set it empty
                Natural{subjIdx,image} = [];
            end
        else if size(check_size_Animated,1) >=2 && size(check_size_Animated,1) <= 10
                if image > 1   % only replace if previous column exists
                    Animated{subjIdx,image} = Animated{subjIdx,image-1};
                else
                % If image == 1, no previous column exists
                % You can decide: leave it as is, or set it empty
                    Animated{subjIdx,image} = [];
                end
        end
        end
        end
    end


feature_all_channels = cell(100, 10);

for i = 1:10
    features_all = dftcombinedsubjectloop(Natural, Animated, i);
    feature_all_channels(:, i) = features_all;
    fprintf('Finished processing channel %d\n', i);
end