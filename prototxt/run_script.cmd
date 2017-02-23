for /L %%i in (1,1,25) do (
	copy /Y face_solver.prototxt .\%%i\face_solver.prototxt
	copy /Y face_train_test.prototxt .\%%i\face_train_test.prototxt
	copy /Y run_solver.bat .\%%i\run_solver.bat
)
for /L %%i in (1,1,25) do (
	cd %%i
	run_solver.bat
	cd ..
)
pause 