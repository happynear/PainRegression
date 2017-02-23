list = 'list.txt';
list_fid = fopen(list,'r');
C = textscan(list_fid,'%s %d %d %d');
fclose(list_fid);
folder_map = containers.Map;
person_id = zeros(length(C{1}),1);

for i=1:length(C{1})
    path_split = strsplit(C{1}{i},'\');
    if ~isKey(folder_map,path_split{1})
        folder_map(path_split{1}) = length(folder_map.keys) + 1;
    end;
    person_id(i) = folder_map(path_split{1});
end;

subfolder = 'sublist';
if exist(subfolder,'dir')==0
    mkdir(subfolder);
end;

total_person = max(person_id);
for p = 1:total_person
    disp(p);
    if exist(fullfile(subfolder,num2str(p)),'dir')==0
        mkdir(fullfile(subfolder,num2str(p)));
    end;
    list_train = fopen(fullfile(subfolder,num2str(p),'list_train.txt'),'w');
    list_val = fopen(fullfile(subfolder,num2str(p),'list_val.txt'),'w');
    for i=1:length(C{1})
        if person_id(i) == p
            fprintf(list_val, '%s %d %d %d\r\n', C{1}{i}, C{2}(i), C{3}(i), C{4}(i));
        else
            fprintf(list_train, '%s %d %d %d\r\n', C{1}{i}, C{2}(i), C{3}(i), C{4}(i));
        end;
    end;
    fclose(list_train);
    fclose(list_val);
    resample_train_list(fullfile(subfolder,num2str(p),'list_train.txt'), fullfile(subfolder,num2str(p),'list_train_resample.txt'), 3);
%     add_balance_weight(fullfile(subfolder,num2str(p),'list_train.txt'), 2, 3);
%     add_balance_weight(fullfile(subfolder,num2str(p),'list_val.txt'), 2, 3);
%     add_balance_weight(fullfile(subfolder,num2str(p),'list_train_resample.txt'), 2, 3);
end;