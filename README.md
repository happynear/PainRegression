# PainRegression

Transferring Face Verification Nets To Pain and Expression Regression

https://arxiv.org/abs/1702.06925

#Requirements

1. My Caffe (https://github.com/happynear/caffe-windows/tree/ms). If you don't want to train with class-balance sampling ([image_data_layer.cpp](https://github.com/happynear/caffe-windows/blob/ms/src/caffe/layers/image_data_layer.cpp)) and observing Pearson Correlation during training ([correlation_loss_layer.cpp](https://github.com/happynear/caffe-windows/blob/ms/src/caffe/layers/correlation_loss_layer.cpp)), you may use the official Caffe.
2. Matlab,
3. GPU with CUDA support,
4. MTCNN face and facial landmark detector(https://github.com/kpzhang93/MTCNN_face_detection_alignment).

#Training

1. Download the UNBC-McMaster Shoulder Pain Dataset(http://www.pitt.edu/~emotion/um-spread.htm). 

2. Download the pre-trained face verification model from [Google Drive](https://drive.google.com/file/d/0B0OhXbSTAU1HUTVhNE1sX1o2STQ/view?usp=sharing).

3. Detect and align the faces in the dataset by [scripts/general_align.m](https://github.com/happynear/PainRegression/blob/master/scripts/general_align.m).

4. Create list for Caffe's ImageData layer by [scripts/create_list.m](https://github.com/happynear/PainRegression/blob/master/scripts/create_list.m) and [scripts/create_sublist.m](https://github.com/happynear/PainRegression/blob/master/scripts/create_sublist.m)(For cross-validation).

5. Copy all the folders created by [scripts/create_sublist.m](https://github.com/happynear/PainRegression/blob/master/scripts/create_sublist.m) to prototxt and run `prototxt/run_scripts.cmd`.

It takes about 4-6 hours to train all 25-fold cross validation.

#Validation

1. Use [scripts/extract_feature.m](https://github.com/happynear/PainRegression/blob/master/scripts/extract_feature.m) to extract results from the 25-fold cross-validation.

2. Get the performance by [scripts/get_accuracy.m](https://github.com/happynear/PainRegression/blob/master/scripts/get_accuracy.m).

We suggest further works to use the new evaluation metrics, wMAE and wMSE proposed in our work. The evaluation codes are in [scripts/get_accuracy.m].

#License

This code is distributed under MIT LICENSE

#Contact

Feng Wang feng.wff(at)gmail.com,
please replace (at) with @.
