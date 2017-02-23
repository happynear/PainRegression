md models
for /L %%i in (1,1,25) do (
	md .\models\%%i
	md .\models\%%i\log
	copy /Y .\%%i\face_train_test_iter_5000.caffemodel .\models\%%i\face_train_test_iter_5000.caffemodel
	copy /Y .\%%i\list_val.txt .\models\%%i\list_val.txt
	copy /Y .\%%i\log\*.* .\models\%%i\log\*.*
)
pause 