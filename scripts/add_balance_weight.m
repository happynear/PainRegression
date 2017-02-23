function add_balance_weight(list, label_count, label_index)
% list = 'list_train.txt';
% label_count = 2;
% label_index = 3;
list_fid = fopen(list,'r');
C = textscan(list_fid,['%s' repmat(' %d',1, label_count)]);
fclose(list_fid);

label  = C{label_index};
unique_label = unique(label);
weights = zeros(length(unique_label), 1);
weight_map = containers.Map(unique_label, 1:length(unique_label));
for i=1:length(unique_label)
    weights(i) = sum(label==unique_label(i));
end;

mean_weights = mean(weights);
weights = mean_weights ./ weights;

list_fid = fopen(list,'w');
for i=1:length(C{1})
    fprintf(list_fid, '%s', C{1}{i});
    for j=1:label_count
        fprintf(list_fid, ' %d', C{j+1}(i));
    end;
    fprintf(list_fid, ' %f\r\n', weights(weight_map(int32(C{label_index}(i)))));
end;
fclose(list_fid);