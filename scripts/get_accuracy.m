mae = zeros(25,1);
mse = zeros(25,1);
pearson = zeros(25,1);
icc = zeros(25,1);
for i=1:25
    mae(i) = mean(abs(ground_truth{i}- predict{i}));
    mse(i) = mean((predict{i}-ground_truth{i}).^2);
%     mae(i) = mean(abs(ground_truth{i}- zeros(size(predict{i}))));
%     mse(i) = mean((zeros(size(predict{i}))-ground_truth{i}).^2);
    cov_gp = cov(ground_truth{i}, predict{i});
    pearson(i) = cov_gp(1,2) / sqrt(cov_gp(1,1) * cov_gp(2,2));
    icc(i) = 2 * cov_gp(1,2) / (cov_gp(1,1) + cov_gp(2,2));
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
    wmae(i) = mean(abs(ground_truth{i}- predict{i}) .* label_weight);
    wmse(i) = mean((predict{i}-ground_truth{i}).^2 .* label_weight);
%     wmae(i) = mean(abs(ground_truth{i}- zeros(size(predict{i}))) .* label_weight);
%     wmse(i) = mean((zeros(size(predict{i}))-ground_truth{i}).^2 .* label_weight);
end;
fprintf('weighted mean MAE:%f\r\n', mean(wmae));
fprintf('weighted mean MSE:%f\r\n', mean(wmse));