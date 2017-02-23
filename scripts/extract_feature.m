sublist_folder = 'D:\face project\pain\center_loss_models';
list = 'list.txt';
caffe.set_mode_gpu();

list_fid = fopen(list,'r');
C = textscan(list_fid,'%s %d %d');
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

ground_truth = cell(25,1);
predict = cell(25,1);
feature = cell(25,1);
batch_size = 100;
mae = zeros(25,1);
mse = zeros(25,1);
pearson = zeros(25,1);
lut = ones(1,16) * 5;
lut(1:6) = [0 1 2 3 4 4];

for i=1:25
    
    caffe.reset_all();
    original_prototxt = fullfile(sublist_folder, 'face_deploy.prototxt');
    original_net_model = fileread(original_prototxt);
    original_net_model = strrep(original_net_model,'list_val.txt',strrep(fullfile(sublist_folder, num2str(i), 'list_val.txt'),'\','/'));
    new_prototxt = fullfile(sublist_folder, 'face_deploy_i.prototxt');
    fid = fopen(new_prototxt,'w');
    fprintf(fid,'%s\r\n',original_net_model);
    fclose(fid);

    model = fullfile(sublist_folder, num2str(i), 'face_train_test_iter_5000.caffemodel');
    net = caffe.Net(new_prototxt, model, 'test');
    
    subclass_num = sum(person_id == i);
    fprintf('%dth class, %d samples, ',i, subclass_num);
    forward_times = ceil(subclass_num / 100);
    predict_i = zeros(1, forward_times * 100);
    ground_i = zeros(1, forward_times * 100);
    feature_i = zeros(50, forward_times * 100);
    for j=1:forward_times
        f = net.forward({});
        predict_i((j-1)*batch_size + 1: j*batch_size) = f{1};
        ground_i((j-1)*batch_size + 1: j*batch_size) = f{2};
        feature_i(:,(j-1)*batch_size + 1: j*batch_size) = net.blobs('ip1_res5').get_data();
    end;
    predict_i = predict_i(1:subclass_num);
    ground_i = ground_i(1:subclass_num);
    feature_i = feature_i(:,1:subclass_num);
    ground_truth{i} = ground_i;
    predict{i} = predict_i;
    feature{i} = feature_i;
    mae(i) = mean(abs(predict_i-ground_i));
    mse(i) = mean((predict_i-ground_i).^2);
    cov_gp = cov(ground_i, predict_i);
    pearson(i) = cov_gp(1,2) / sqrt(cov_gp(1,1) * cov_gp(2,2));
    fprintf('MAE:%f MSE:%f Pearson:%f\r\n',mae(i),mse(i),pearson(i));
end;
fprintf('mean MAE:%f\r\n', mean(mae));
fprintf('mean MSE:%f\r\n', mean(mse));
fprintf('mean Pearson:%f\r\n', mean(pearson(~isnan(pearson))));
figure(1);
plot(ground_truth{1},'b');
hold on;
plot(predict{1},'r');
hold off;
caffe.reset_all();