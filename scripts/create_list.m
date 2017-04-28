identity_list = dir('./Images');
identity_list = identity_list(3:end);
list = 'list.txt';
list_fid = fopen(list,'w');
lut = ones(1,16) * 5;
lut(1:6) = [0 1 2 3 4 4];

video_index = cell(length(identity_list),1);

for i=1:length(identity_list)
    subset_list = dir(fullfile('./Images',identity_list(i).name));
    subset_list = subset_list(3:end);
    sub_video_index = zeros(length(subset_list),1);
    for j=1:length(subset_list)
        image_list = dir(fullfile('./Images',identity_list(i).name, subset_list(j).name));
        image_list = image_list(3:end);
        disp([fullfile('./Images',identity_list(i).name, subset_list(j).name) ' ' num2str(length(image_list)) ' files']);
        sub_video_index(j) = length(image_list);
        for k=1:length(image_list)
            filename = fullfile(pwd, 'Images',identity_list(i).name, subset_list(j).name, image_list(k).name);     
            [a, b, c] = fileparts(filename);
            if strcmp(c,'.png')==0
                continue;
            end;
%             image = imread(filename);
%             assert(size(image,1)==112 && size(image,2)==96);
            label_file = fullfile('./Frame_Labels/PSPI',identity_list(i).name, subset_list(j).name, [b '_facs.txt']);
            label = textread(label_file);
            mask = 1;
            if k<=3 || k>=length(image_list)-2
                mask = 0;
            end;
            fprintf(list_fid,'%s %d\n', fullfile(identity_list(i).name, subset_list(j).name, image_list(k).name), lut(uint8(label) + 1));
            % fprintf(list_fid,'%s %d %d %d\r\n', fullfile(identity_list(i).name, subset_list(j).name, image_list(k).name), uint8(i-1), lut(uint8(label) + 1), mask);
        end;
    end;
    video_index{i} = sub_video_index;
end;
fclose(list_fid);
