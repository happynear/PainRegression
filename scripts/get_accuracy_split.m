mae = zeros(25,1);
mse = zeros(25,1);
pearson = zeros(25,1);
icc = zeros(25,1);
for i=1:25
    start_frame = 0;
    for j = 1:length(video_index{i})
        ground_ij = ground_truth{i}(start_frame+1:start_frame+video_index{i}(j));
        predict_ij = predict{i}(start_frame+1:start_frame+video_index{i}(j));
        mae(i) = mae(i) + mean(abs(ground_ij - predict_ij));
        mse(i) = mse(i) + mean((ground_ij-predict_ij).^2);
        cov_gp = cov(ground_ij, predict_ij);
        pearson(i) = pearson(i) + cov_gp(1,2) / sqrt(cov_gp(1,1) * cov_gp(2,2));
        icc(i) = icc(i) + 2 * cov_gp(1,2) / (cov_gp(1,1) + cov_gp(2,2));
    end;
    mae(i) = mae(i) / length(video_index{i});
    mse(i) = mse(i) / length(video_index{i});
    pearson(i) = pearson(i) / length(video_index{i});
    icc(i) = icc(i) / length(video_index{i});
end;
fprintf('mean MAE:%f\r\n', mean(mae));
fprintf('mean MSE:%f\r\n', mean(mse));
fprintf('mean Pearson:%f\r\n', mean(pearson(~isnan(pearson))));
fprintf('mean ICC:%f\r\n', mean(icc));

wmae = zeros(25,1);
wmse = zeros(25,1);
for i=1:25
    unique_gt = unique(ground_truth{i});
    weights = zeros(length(unique_gt),1);
    for j=1:length(unique_gt)
        weights(j) = sum(ground_truth{i}==unique_gt(j));
    end;
    weights = mean(weights) ./ weights;
    weight_map = containers.Map(unique_gt, weights);
    label_weight = zeros(1, length(ground_truth{i}));
    for j=1:length(label_weight)
        label_weight(j) = weight_map(ground_truth{i}(j));
    end;
    start_frame = 0;
    for j = 1:length(video_index{i})
        ground_ij = ground_truth{i}(start_frame+1:start_frame+video_index{i}(j));
        predict_ij = predict{i}(start_frame+1:start_frame+video_index{i}(j));
        label_weight_ij = label_weight(start_frame+1:start_frame+video_index{i}(j));
        wmae(i) = wmae(i) + mean(abs(ground_ij- predict_ij) .* label_weight_ij);
        wmse(i) = wmse(i) + mean((ground_ij-predict_ij).^2 .* label_weight_ij);
    end;
    wmae(i) = wmae(i) / length(video_index{i});
    wmse(i) = wmse(i) / length(video_index{i});
end;
fprintf('weighted mean MAE:%f\r\n', mean(wmae));
fprintf('weighted mean MSE:%f\r\n', mean(wmse));