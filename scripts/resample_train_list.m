function resample_train_list(list, resampled_list, label_count)
% list = 'list_train.txt';
list_fid = fopen(list,'r');
C = textscan(list_fid,['%s' repmat(' %d',1, label_count)]);
fclose(list_fid);

preserve=zeros(length(C{1}),1);
preserve(1:3) = 1;
preserve(end-4:end) = 1;
p = 3;
while p <= length(C{1}) - 5
    preserve(p) = 1;
    same_flag = 1;
    for j=1:4
        if C{2}(p+j) ~= C{2}(p)
            same_flag = 0;
        end;
    end;
    if same_flag == 1
        p = p+5;
    else
        p = p+1;
    end;
end;

% resampled_list = 'list_train_resample.txt';
list_fid = fopen(resampled_list,'w');
for i=1:length(C{1})
    if preserve(i) == 1
        fprintf(list_fid, '%s', C{1}{i});
        for j=1:label_count
            fprintf(list_fid, ' %d', C{j+1}(i));
        end;
        fprintf(list_fid, '\r\n');
    end;
end;
fclose(list_fid);