sublist_folder = 'D:\face project\pain\temporal_center';
image_root = 'C:\datasets\Pain\Images';
list = 'list.txt';
caffe.set_mode_gpu();

ground_truth = cell(25,1);
predict = cell(25,1);
feature = cell(25,1);
batch_size = 100;
mae = zeros(25,1);
mse = zeros(25,1);
pearson = zeros(25,1);
lut = ones(1,16) * 5;
lut(1:6) = [0 1 2 3 4 4];
image_width = 96;
image_height = 112;
cut_label = 3;

for i=1:25
    
    caffe.reset_all();
    model_prototxt = fullfile(sublist_folder, 'face_deploy_sequence.prototxt');
    model = fullfile(sublist_folder, num2str(i), 'face_train_test_iter_5000.caffemodel');
    net = caffe.Net(model_prototxt, model, 'test');
    list_fid = fopen(fullfile(sublist_folder, num2str(i), 'list_val.txt'),'r');
    C = textscan(list_fid,'%s %d %d %d');
    fclose(list_fid);
    sub_list = C{1};
    ground_i = double(C{3});
    total_iter = ceil((length(ground_i)-cut_label) / (batch_size - cut_label * 2));
    predict_i = zeros(total_iter * (batch_size - cut_label * 2),1);
    image_point = 1;
    
    for iter = 1:total_iter
        image_data = zeros(image_width,image_height,3,batch_size, 'single');
        for b=1:batch_size
            image_filename = fullfile(image_root, sub_list{image_point});
            image_data(:,:,:,b) = caffe.io.load_image(image_filename);
            image_point = image_point + 1;
            if image_point > length(sub_list)
%                 image_data = image_data(:,:,:,1:b);
                break;
            end;
        end;
        image_point = image_point - cut_label * 2;
        image_data = (image_data - 128) / 128;
%         net.blobs('data').reshape(size(image_data));
        f = net.forward({image_data});
        if iter ==1
            predict_i(1:batch_size-cut_label) = f{1}(1:batch_size-cut_label);
        else
            predict_i((iter-1) * (batch_size - cut_label * 2) + cut_label + 1:iter * (batch_size-cut_label * 2)+ cut_label) = f{1}(cut_label + 1:batch_size-cut_label);
        end;
    end;
    predict_i = predict_i(1:length(ground_i),1);
    predict_i = predict_i .* double(C{4});

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