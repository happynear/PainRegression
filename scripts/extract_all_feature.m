caffe.reset_all();
caffe.set_mode_gpu();
load('video_index.mat')
total_frames = 48391;
model_definition = 'D:\face project\pain\center_loss_models\face_deploy_all.prototxt';
weights = 'D:\face project\pain\center_loss_models\1\face_train_test_iter_5000.caffemodel';
net = caffe.Net(model_definition, weights, 'test');

batch_size = 100;
total_iter = ceil(total_frames/batch_size);

features = zeros(50, total_iter*batch_size);
labels = zeros(2, total_iter*batch_size);

for i=1:total_iter
    disp([i total_iter]);
    f = net.forward({});
    features(:,(i-1)*batch_size + 1: i*batch_size) = net.blobs('ip1_res5').get_data();
    labels(:,(i-1)*batch_size + 1: i*batch_size) = f{2};
end;

features = features(:,1:total_frames);
labels = labels(:,1:total_frames);
identity_label = labels(1,:);
pain_label = labels(2,:);

video_feature = cell(25,1);
video_pain_level = cell(25,1);

for i=1:25
    video_feature_i = cell(length(video_index{i}),1);
    sub_feature = features(:,identity_label==(i-1));
    video_pain_i = cell(length(video_index{i}),1);
    sub_video_pain_label = pain_label(:,identity_label==(i-1));
    start_frame = 0;
    for j = 1:length(video_index{i})
        video_feature_i{j} = sub_feature(:,start_frame + 1:start_frame + video_index{i}(j));
        video_pain_i{j} = sub_video_pain_label(1,start_frame + 1:start_frame + video_index{i}(j));
        start_frame = start_frame + video_index{i}(j);
    end;
    assert(start_frame == size(sub_feature,2));
    video_feature{i} = video_feature_i;
    video_pain_level{i} = video_pain_i;
end;