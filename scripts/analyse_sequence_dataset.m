target_metric = 'AFF';
sequence_label_folder = 'Sequence_Labels';
identity_list = dir('./Images');
identity_list = identity_list(3:end);

for i=1:length(identity_list)
    subset_list = dir(fullfile('./Images',identity_list(i).name));
    subset_list = subset_list(3:end);
    for j=1:length(subset_list)
        image_list = dir(fullfile('./Images',identity_list(i).name, subset_list(j).name));
        image_list = image_list(3:end);