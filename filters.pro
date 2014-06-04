;###############################################################################
;###################            Generic convolution         ####################

FUNCTION vigra_convolveimage_c, array, array2, kernelMat, width, height, kernel_width, kernel_height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_convolveimage_c', array, array2, DOUBLE(kernelMat), FIX(width), FIX(height), FIX(kernel_width), FIX(kernel_height), $
              VALUE=[0,0,0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION convolveimage_band, array, kernelMat
  shape = SIZE(array)
  kernel_shape = SIZE(kernelMat)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_convolveimage_c(array, array2, kernelMat, shape[1], shape[2], kernel_shape[1], kernel_shape[2])
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters:convolveimage: Convolution with kernel failed!!"
    2: MESSAGE, "Error in vigraidl.filters:convolveimage: Kernel must have odd shape!"
  ENDCASE
END

FUNCTION convolveimage, array, kernelMat
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = convolveimage_band(REFORM(array[band,*,*]),  kernelMat)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################            Separable convolution         ####################

FUNCTION vigra_separableconvolveimage_c, array, array2, kernel_x, kernel_y, width, height, kernel_x_size, kernel_y_size
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_separableconvolveimage_c', array, array2, DOUBLE(kernel_x), DOUBLE(kernel_y), FIX(width), FIX(height), FIX(kernel_x_size), FIX(kernel_y_size), $
              VALUE=[0,0,0,0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION separableconvolveimage_band, array, kernel_x, kernel_y
  shape = SIZE(array)
  kernel_x_size = (SIZE(kernel_x))[2]
  kernel_y_size = (SIZE(kernel_y))[1]
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_separableconvolveimage_c(array, array2, kernel_x, kernel_y, shape[1], shape[2], kernel_x_size, kernel_y_size)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters:separableconvolveimage: Convolution with kernel failed!!"
    2: MESSAGE, "Error in vigraidl.filters:separableconvolveimage: Kernel must have odd shape!"
  ENDCASE
END

FUNCTION separableconvolveimage, array,  kernel_x, kernel_y
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = separableconvolveimage_band(REFORM(array[band,*,*]), kernel_x, kernel_y)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################          Gaussian Smoothing            ####################
FUNCTION vigra_gaussiansmoothing_c, array, array2, width, height, sigma
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_gaussiansmoothing_c', array, array2, FIX(width), FIX(height), FLOAT(sigma), $
              VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION gsmooth_band, array, sigma
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_gaussiansmoothing_c(array, array2, shape[1], shape[2], sigma)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.gsmooth: Gaussian smoothing failed!"
  ENDCASE
END

FUNCTION gsmooth, array, sigma
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = gsmooth_band(REFORM(array[band,*,*]), sigma)
  ENDFOR
  RETURN, res_array
END
	

;###############################################################################
;###################        Gaussian Gradient (x&y)         ####################
FUNCTION vigra_gaussiangradient_c, array, array2_x, array2_y, width, height, sigma
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_gaussiangradient_c', array, array2_x, array2_y, FIX(width), FIX(height), FLOAT(sigma), $
              VALUE=[0,0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION gaussiangradient_band, array, sigma
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2],2, /FLOAT, VALUE = 0.0)
  err = vigra_gaussiangradient_c(array, REFORM(array2[*,*,0]), REFORM(array2[*,*,1]), shape[1], shape[2],  sigma)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.gaussiangradient: Gaussian gradient failed!"
  ENDCASE
END

FUNCTION gaussiangradient, array, sigma
  shape = SIZE(array)
  res_array =   MAKE_ARRAY(shape[1], shape[2], shape[3], 2, /FLOAT, VALUE = 0.0)
  FOR band = 0, shape[1]-1 DO BEGIN
  res_array[band,*,*,*] = gaussiangradient_band(REFORM(array[band,*,*]), sigma)
  ENDFOR
  RETURN, res_array
END

  ;###############################################################################
  ;###################      Gaussian Gradient (Magnitude)     ####################
FUNCTION vigra_gaussiangradientmagnitude_c, array, array2, width, height, sigma
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_gaussiangradientmagnitude_c', array, array2, FIX(width), FIX(height), FLOAT(sigma), $
    VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION ggradient_band, array, sigma
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_gaussiangradientmagnitude_c(array, array2, shape[1], shape[2],  sigma)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.ggradient: Gaussian gradient magnitude failed!"
  ENDCASE
END

FUNCTION ggradient, array, sigma
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*] = ggradient_band(REFORM(array[band,*,*]), sigma)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################        Laplacian Of Gaussian           ####################
FUNCTION vigra_laplacianofgaussian_c, array, array2, width, height, scale
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_laplacianofgaussian_c', array, array2, FIX(width), FIX(height), FLOAT(scale), $
              VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION laplacianofgaussian_band, array, scale
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_laplacianofgaussian_c(array, array2, shape[1], shape[2], scale)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.laplacianofgaussian: Laplacian of Gaussian failed!"
  ENDCASE
END

FUNCTION laplacianofgaussian, array, scale
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = laplacianofgaussian_band(REFORM(array[band,*,*]), scale)
  ENDFOR
  RETURN, res_array
END


;###############################################################################
;#############    Hessian Matrix of 2. order deriv gaussians      ##############
FUNCTION vigra_hessianmatrixofgaussian_c, array, array_xx,array_xy,array_yy, width, height, scale
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_hessianmatrixofgaussian_c', array, array_xx, array_xy, array_yy, FIX(width), FIX(height), FLOAT(scale), $
              VALUE=[0,0,0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION hessianmatrixofgaussian_band, array, scale
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2],3, /FLOAT, VALUE = 0.0)
  err = vigra_laplacianofgaussian_c(array, REFORM(array2[*,*,0]),REFORM(array2[*,*,1]),REFORM(array2[*,*,2]), shape[1], shape[2], scale)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.hessianmatrixofgaussian: Hessian Matrix of Gaussian failed!"
  ENDCASE
END

FUNCTION hessianmatrixofgaussian, array, scale
  shape = SIZE(array)
  res_array =  MAKE_ARRAY(shape[1], shape[2],shape[3],3, /FLOAT, VALUE = 0.0)
  FOR band = 0, shape[1]-1 DO BEGIN
  res_array[band,*,*,*] = hessianmatrixofgaussian_band(REFORM(array[band,*,*]), scale)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;#############                   Structure Tensor                 ##############
FUNCTION vigra_structuretensor_c, array, array_xx,array_xy,array_yy, width, height, inner_scale, outer_scale
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_structuretensor_c', array, array_xx, array_xy, array_yy, FIX(width), FIX(height), FLOAT(inner_scale),FLOAT(outer_scale), $
    VALUE=[0,0,0,0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION structuretensor_band, array, inner_scale, outer_scale
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2],3, /FLOAT, VALUE = 0.0)
  err = vigra_structuretensor_c(array, REFORM(array2[*,*,0]),REFORM(array2[*,*,1]),REFORM(array2[*,*,2]), shape[1], shape[2], inner_scale, outer_scale)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.structuretensor: Structure Tensor failed!"
  ENDCASE
END

FUNCTION structuretensor, array, inner_scale, outer_scale
  shape = SIZE(array)
  res_array =  MAKE_ARRAY(shape[1], shape[2],shape[3],3, /FLOAT, VALUE = 0.0)
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*,*] = structuretensor_band(REFORM(array[band,*,*]), inner_scale, outer_scale)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;#############              Koethes Boundary Tensor               ##############
FUNCTION vigra_boundarytensor_c, array, array_xx,array_xy,array_yy, width, height, scale
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_boundarytensor_c', array, array_xx, array_xy, array_yy, FIX(width), FIX(height), FLOAT(scale), $
    VALUE=[0,0,0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION boundarytensor_band, array, scale
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2],3, /FLOAT, VALUE = 0.0)
  err = vigra_boundarytensor_c(array, REFORM(array2[*,*,0]),REFORM(array2[*,*,1]),REFORM(array2[*,*,2]), shape[1], shape[2], scale)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.boundarytensor: Boundary Tensor failed!"
  ENDCASE
END

FUNCTION boundarytensor, array, scale
  shape = SIZE(array)
  res_array =  MAKE_ARRAY(shape[1], shape[2],shape[3],3, /FLOAT, VALUE = 0.0)
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*,*] = boundarytensor_band(REFORM(array[band,*,*]), scale)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;############ Koethes Boundary Tensor (without 0th order response) #############
FUNCTION vigra_boundarytensor1_c, array, array_xx,array_xy,array_yy, width, height, scale
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_boundarytensor1_c', array, array_xx, array_xy, array_yy, FIX(width), FIX(height), FLOAT(scale), $
    VALUE=[0,0,0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION boundarytensor1_band, array, scale
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2],3, /FLOAT, VALUE = 0.0)
  err = vigra_boundarytensor1_c(array, REFORM(array2[*,*,0]),REFORM(array2[*,*,1]),REFORM(array2[*,*,2]), shape[1], shape[2], scale)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.boundarytensor: Boundary Tensor failed!"
  ENDCASE
END

FUNCTION boundarytensor1, array, scale
  shape = SIZE(array)
  res_array =  MAKE_ARRAY(shape[1], shape[2],shape[3],3, /FLOAT, VALUE = 0.0)
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*,*] = boundarytensor1_band(REFORM(array[band,*,*]), scale)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;############          Tensor to Eigenvalue representation         #############
FUNCTION vigra_tensoreigenrepresentation_c, array_xx,array_xy,array_yy, array2_xx,array2_xy,array2_yy, width, height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_tensoreigenrepresentation_c', array_xx, array_xy, array_yy, array2_xx, array2_xy, array2_yy, FIX(width), FIX(height), $
    VALUE=[0,0,0,0,0,0,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION tensoreigenrepresentation_band, array
  shape = SIZE(array)
  array2 = array
  err = vigra_tensoreigenrepresentation_c( REFORM(array[*,*,0]),REFORM(array[*,*,1]),REFORM(array[*,*,2]), REFORM(array2[*,*,0]),REFORM(array2[*,*,1]),REFORM(array2[*,*,2]), shape[1], shape[2])
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.tensoreigenrepresentation: Eigenrepresentation of Tensor failed!"
  ENDCASE
END

FUNCTION tensoreigenrepresentation, array
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*,*] = tensoreigenrepresentation_band(REFORM(array[band,*,*,*]))
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;############                     Tensor Trace                     #############
FUNCTION vigra_tensortrace_c, array_xx,array_xy,array_yy, array2, width, height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_tensortrace_c', array_xx, array_xy, array_yy, array2, FIX(width), FIX(height), $
    VALUE=[0,0,0,0,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION tensortrace_band, array
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2],/FLOAT, VALUE = 0.0)
  err = vigra_tensortrace_c( REFORM(array[*,*,0]),REFORM(array[*,*,1]),REFORM(array[*,*,2]), array2, shape[1], shape[2])
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.tensortrace: Trace of Tensor failed!"
  ENDCASE
END

FUNCTION tensortrace, array
  shape = SIZE(array)
  res_array = MAKE_ARRAY(shape[1], shape[2], shape[3],/FLOAT, VALUE = 0.0)
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*] = tensortrace_band(REFORM(array[band,*,*,*]))
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;############          Tensor to Edge/Corner representation        #############
FUNCTION vigra_tensortoedgecorner_c, array_xx,array_xy,array_yy, array2_xx,array2_xy,array2_yy, width, height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_tensortoedgecorner_c', array_xx, array_xy, array_yy, array2_xx, array2_xy, array2_yy, FIX(width), FIX(height), $
    VALUE=[0,0,0,0,0,0,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION tensortoedgecorner_band, array
  shape = SIZE(array)
  array2 = array
  err = vigra_tensortoedgecorner_c( REFORM(array[*,*,0]),REFORM(array[*,*,1]),REFORM(array[*,*,2]), REFORM(array2[*,*,0]),REFORM(array2[*,*,1]),REFORM(array2[*,*,2]), shape[1], shape[2])
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.tensortoedgecorner: Edge/Corner-representation of Tensor failed!"
  ENDCASE
END

FUNCTION tensortoedgecorner, array
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*,*] = tensortoedgecorner_band(REFORM(array[band,*,*,*]))
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;############              Hourglass Filter of a Tensor            #############
FUNCTION vigra_hourglassfilter_c, array_xx,array_xy,array_yy, array2_xx,array2_xy,array2_yy, width, height, sigma, rho
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_hourglassfilter_c', array_xx, array_xy, array_yy, array2_xx, array2_xy, array2_yy, FIX(width), FIX(height), FLOAT(sigma), FLOAT(rho), $
    VALUE=[0,0,0,0,0,0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION hourglassfilter_band, array, sigma, rho
  shape = SIZE(array)
  array2 = array
  err = vigra_hourglassfilter_c( REFORM(array[*,*,0]),REFORM(array[*,*,1]),REFORM(array[*,*,2]), REFORM(array2[*,*,0]),REFORM(array2[*,*,1]),REFORM(array2[*,*,2]), shape[1], shape[2], sigma, rho)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.hourglassfilter: Hourglass-Filtering of Tensor failed!"
  ENDCASE
END

FUNCTION hourglassfilter, array, sigma, rho
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*,*] = hourglassfilter_band(REFORM(array[band,*,*,*]), sigma, rho)
  ENDFOR
  RETURN, res_array
END


;###############################################################################
;###################          Gaussian Sharpening           ####################
FUNCTION vigra_gaussiansharpening_c, array, array2, width, height, sharpening_factor, scale
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_gaussiansharpening_c', array, array2, FIX(width), FIX(height), FLOAT(sharpening_factor), FLOAT(scale), $
              VALUE=[0,0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION gsharpening_band, array, sharpening_factor, scale
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_gaussiansharpening_c(array, array2, shape[1], shape[2],  sharpening_factor, scale)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.gsharpening: Gaussian sharpening failed!"
  ENDCASE
END

FUNCTION gsharpening, array, sharpening_factor, scale
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = gsharpening_band(REFORM(array[band,*,*]), sharpening_factor, scale)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################            Simple Sharpening           ####################
FUNCTION vigra_simplesharpening_c, array, array2, width, height, sharpening_factor
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_simplesharpening_c', array, array2, FIX(width), FIX(height), FLOAT(sharpening_factor), $
              VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION sharpening_band, array, sharpening_factor, scale
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_simplesharpening_c(array, array2, shape[1], shape[2],  sharpening_factor)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.sharpening: Simple sharpening failed!"
  ENDCASE
END

FUNCTION sharpening, array, sharpening_factor, scale
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = sharpening_band(REFORM(array[band,*,*]), sharpening_factor, scale)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################          Nonlinear Diffusion           ####################
FUNCTION vigra_nonlineardiffusion_c, array, array2, width, height, edge_threshold, scale
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_nonlineardiffusion_c', array, array2, FIX(width), FIX(height), FLOAT(edge_threshold), FLOAT(scale), $
              VALUE=[0,0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION nonlineardiffusion_band, array, edge_threshold, scale
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_nonlineardiffusion_c(array, array2, shape[1], shape[2],  edge_threshold, scale)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigracl.filters.nonlineardiffusion: Non linear Diffusion failed!!"
  ENDCASE
END

FUNCTION nonlineardiffusion, array, edge_threshold, scale
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = nonlineardiffusion_band(REFORM(array[band,*,*]), edge_threshold, scale)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################          Distance Transform            ####################
FUNCTION vigra_distancetransform_c, array, array2, width, height, background_label, norm
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_distancetransform_c', array, array2, FIX(width), FIX(height), FLOAT(background_label), FIX(norm), $
              VALUE=[0,0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION distancetransform_band, array, background_label, norm
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_distancetransform_c(array, array2, shape[1], shape[2], background_label, norm)
  CASE err OF
    0:  RETURN, array2 
    1:  MESSAGE, "Error in vigraidl.filters.distancetransform: Distance transformation failed!!"
    2:  MESSAGE, "Error in vigraidl.filters.distancetransform: Norm must be in {0,1,2} !!"
  ENDCASE
END

FUNCTION distancetransform, array, background_label, norm
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = distancetransform_band(REFORM(array[band,*,*]), background_label, norm)
  ENDFOR
  RETURN, res_array
END