;To load the vigraidl bindings please correct the vigraidl_path function
;to to point to the correct path.
;
;Afterwards, to load the bindings, execute first:
;  CD, "/path/to/vigraidl",CURRENT=old_dir  
;  .COMPILE vigraidl
;  CHECK_INSTALL

;include the contents of the configuration file
@config

;include other files for the function bindings to the vigra
@impex
@splineimageview
@filters
@imgproc
@segmentation
@morphology
