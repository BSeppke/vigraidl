;###############################################################################
;###################            Generic convolution         ####################

FUNCTION vigra_convolveimage_c, array, kernelMat, array2, width, height, kernel_width, kernel_height, border_treatment
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_convolveimage_c', array, DOUBLE(kernelMat), array2, LONG(width), LONG(height), LONG(kernel_width), LONG(kernel_height), LONG(border_treatment), $
              VALUE=[0,0,0,1,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION convolveimage_band, array, kernelMat, border_treatment

  bt_mode = 3 ;;Reflect by default
  IF N_PARAMS() GT 2 THEN bt_mode = border_treatment  
  
  shape = SIZE(array)
  kernel_shape = SIZE(kernelMat)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_convolveimage_c(array, kernelMat, array2, shape[1], shape[2], kernel_shape[1], kernel_shape[2], border_treatment)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters:convolveimage: Convolution with kernel failed!!"
    2: MESSAGE, "Error in vigraidl.filters:convolveimage: Kernel must have odd shape!"
    3: MESSAGE, "Error in vigraidl.filters:convolveimage: Border treatment mode must be in [0, ..., 5]!"
  ENDCASE
END

FUNCTION convolveimage, array, kernelMat, border_treatment

  bt_mode = 3 ;;Reflect by default
  IF N_PARAMS() GT 2 THEN bt_mode = border_treatment  

  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	  res_array[band,*,*] = convolveimage_band(REFORM(array[band,*,*]),  kernelMat, bt_mode)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################            Separable convolution         ####################

FUNCTION vigra_separableconvolveimage_c, array, kernel_x, kernel_y, array2, width, height, kernel_x_size, kernel_y_size, border_treatment
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_separableconvolveimage_c', array, DOUBLE(kernel_x), DOUBLE(kernel_y), array2, LONG(width), LONG(height), LONG(kernel_x_size), LONG(kernel_y_size), LONG(border_treatment), $
              VALUE=[0,0,0,0,1,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION separableconvolveimage_band, array, kernel_x, kernel_y, border_treatment

  bt_mode = 3 ;;Reflect by default
  IF N_PARAMS() GT 3 THEN bt_mode = border_treatment  
  
  shape = SIZE(array)
  kernel_x_size = (SIZE(kernel_x))[2]
  kernel_y_size = (SIZE(kernel_y))[1]
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_separableconvolveimage_c(array, kernel_x, kernel_y, array2, shape[1], shape[2], kernel_x_size, kernel_y_size, bt_mode)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters:separableconvolveimage: Convolution with kernel failed!!"
    2: MESSAGE, "Error in vigraidl.filters:separableconvolveimage: Kernel must have odd shape!"
    3: MESSAGE, "Error in vigraidl.filters:separableconvolveimage: Border treatment mode must be in [0, ..., 5]!"
  ENDCASE
END

FUNCTION separableconvolveimage, array,  kernel_x, kernel_y,  border_treatment

  bt_mode = 3 ;;Reflect by default
  IF N_PARAMS() GT 3 THEN bt_mode = border_treatment  

  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	  res_array[band,*,*] = separableconvolveimage_band(REFORM(array[band,*,*]), kernel_x, kernel_y, bt_mode)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################          Gaussian Smoothing            ####################
FUNCTION vigra_gaussiansmoothing_c, array, array2, width, height, sigma
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_gaussiansmoothing_c', array, array2, LONG(width), LONG(height), FLOAT(sigma), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_gaussiangradient_c', array, array2_x, array2_y, LONG(width), LONG(height), FLOAT(sigma), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_gaussiangradientmagnitude_c', array, array2, LONG(width), LONG(height), FLOAT(sigma), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_laplacianofgaussian_c', array, array2, LONG(width), LONG(height), FLOAT(scale), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_hessianmatrixofgaussian_c', array, array_xx, array_xy, array_yy, LONG(width), LONG(height), FLOAT(scale), $
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
;###################          Gaussian Sharpening           ####################
FUNCTION vigra_gaussiansharpening_c, array, array2, width, height, sharpening_factor, scale
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_gaussiansharpening_c', array, array2, LONG(width), LONG(height), FLOAT(sharpening_factor), FLOAT(scale), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_simplesharpening_c', array, array2, LONG(width), LONG(height), FLOAT(sharpening_factor), $
              VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION sharpening_band, array, sharpening_factor
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_simplesharpening_c(array, array2, shape[1], shape[2],  sharpening_factor)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.sharpening: Simple sharpening failed!"
  ENDCASE
END

FUNCTION sharpening, array, sharpening_factor
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = sharpening_band(REFORM(array[band,*,*]), sharpening_factor)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################            Median Filtering            ####################
FUNCTION vigra_medianfilter_c, array, array2, width, height, window_width, window_height, border_treatment
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_medianfilter_c', array, array2, LONG(width), LONG(height), LONG(window_width), LONG(window_height), LONG(border_treatment), $
              VALUE=[0,0,1,1,1,1,1], /CDECL, /AUTO_GLUE)
END

FUNCTION medianfilter_band, array, window_width, window_height, border_treatment

  bt_mode = 5 ;;Zero padding by default
  IF N_PARAMS() GT 3 THEN bt_mode = border_treatment

  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_medianfilter_c(array, array2, shape[1], shape[2],  window_width, window_height, bt_mode)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.filters.medianfilter: Median filtering failed!"
    2: MESSAGE, "Error in vigraidl.filters.medianfilter: Border treatment mode must be in [0, 2, 3, 4, 5]!"
  ENDCASE
END

FUNCTION medianfilter, array, window_width, window_height, border_treatment

  bt_mode = 5 ;;Zero padding by default
  IF N_PARAMS() GT 3 THEN bt_mode = border_treatment

  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = medianfilter_band(REFORM(array[band,*,*]), window_width, window_height, bt_mode)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################          Nonlinear Diffusion           ####################
FUNCTION vigra_nonlineardiffusion_c, array, array2, width, height, edge_threshold, scale
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_nonlineardiffusion_c', array, array2, LONG(width), LONG(height), FLOAT(edge_threshold), FLOAT(scale), $
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
;###################             Shock Filter               ####################
FUNCTION vigra_shockfilter_c, array, array2, width, height, sigma, rho, upwind_factor_h, iterations
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_shockfilter_c', array, array2, LONG(width), LONG(height), FLOAT(sigma), FLOAT(rho), FLOAT(upwind_factor_h), LONG(iterations), $
              VALUE=[0,0,1,1,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION shockfilter_band, array, sigma, rho, upwind_factor_h, iterations
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_shockfilter_c(array, array2, shape[1], shape[2], sigma, rho, upwind_factor_h, iterations)
  CASE err OF
    0:  RETURN, array2 
    1:  MESSAGE, "Error in vigraidl.filters.shockfilter: Shock filtering failed!!"
    2:  MESSAGE, "Error in vigraidl.filters.shockfilter: Iterations must be > 0!!"
  ENDCASE
END

FUNCTION shockfilter, array, sigma, rho, upwind_factor_h, iterations
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
  res_array[band,*,*] = shockfilter_band(REFORM(array[band,*,*]), sigma, rho, upwind_factor_h, iterations)
  ENDFOR
  RETURN, res_array
END

  ;###############################################################################
  ;###################       Non-local Mean Filter            ####################
FUNCTION vigra_nonlocalmean_c, array, array2, width, height, policy_type, sigma, meanVal, varRatio, epsilon, sigmaSpatial, searchRadius, patchRadius, sigmaMean, stepSize, iterations, nThreads, verbose
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_nonlocalmean_c', array, array2, LONG(width), LONG(height), $
    LONG(policy_type), FLOAT(sigma), FLOAT(meanVal), FLOAT(varRatio), FLOAT(epsilon), $
    FLOAT(sigmaSpatial), LONG(searchRadius), LONG(patchRadius), FLOAT(sigmaMean), $
    LONG(stepSize), LONG(iterations), LONG(nThreads), BOOLEAN(verbose), $
    VALUE=[0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], /CDECL, /AUTO_GLUE)
END

FUNCTION nonlocalmean_band, array, policy_type, sigma, meanVal, varRatio, epsilon, sigmaSpatial, searchRadius, patchRadius, sigmaMean, stepSize, iterations, nThreads, verbose

  p_policy_type = 1
  p_sigma = 50.0
  p_meanVal = 5.0
  p_varRatio = 0.5
  p_epsilon = 0.00001
  p_sigmaSpatial = 2.0
  p_searchRadius = 5
  p_patchRadius = 2
  p_sigmaMean = 10.0
  p_stepSize = 2
  p_iterations = 2
  p_nThreads = 8
  p_verbose = 1

  IF N_PARAMS() GT  1 THEN p_policy_type = policy_type
  IF N_PARAMS() GT  2 THEN p_sigma = sigma
  IF N_PARAMS() GT  3 THEN p_meanVal = meanVal
  IF N_PARAMS() GT  4 THEN p_varRatio = varRatio
  IF N_PARAMS() GT  5 THEN p_epsilon = epsilon
  IF N_PARAMS() GT  6 THEN p_sigmaSpatial = sigmaSpatial
  IF N_PARAMS() GT  7 THEN p_searchRadius = searchRadius
  IF N_PARAMS() GT  8 THEN p_patchRadius = patchRadius
  IF N_PARAMS() GT  9 THEN p_sigmaMean = sigmaMean
  IF N_PARAMS() GT 10 THEN p_stepSize = stepSize
  IF N_PARAMS() GT 11 THEN p_iterations = iterations
  IF N_PARAMS() GT 12 THEN p_nThreads = nThreads
  IF N_PARAMS() GT 13 THEN p_verbose = verbose

  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_nonlocalmean_c(array, array2, shape[1], shape[2], p_policy_type, p_sigma, p_meanVal, p_varRatio, p_epsilon, p_sigmaSpatial, p_searchRadius, p_patchRadius, p_sigmaMean, p_stepSize, p_iterations, p_nThreads, p_verbose)
  CASE err OF
    0:  RETURN, array2
    1:  MESSAGE, "Error in vigraidl.filters.nonlocalmean: Non-local mean filtering failed!!"
    2:  MESSAGE, "Error in vigraidl.filters.nonlocalmean: Policy type must be either 0 or 1!"
  ENDCASE
END

FUNCTION nonlocalmean, array, policy_type, sigma, meanVal, varRatio, epsilon, sigmaSpatial, searchRadius, patchRadius, sigmaMean, stepSize, iterations, nThreads, verbose
 
  p_policy_type = 1
  p_sigma = 50.0
  p_meanVal = 5.0
  p_varRatio = 0.5
  p_epsilon = 0.00001
  p_sigmaSpatial = 2.0
  p_searchRadius = 5
  p_patchRadius = 2
  p_sigmaMean = 10.0
  p_stepSize = 2
  p_iterations = 2
  p_nThreads = 8
  p_verbose = 1
  
  IF N_PARAMS() GT  1 THEN p_policy_type = policy_type
  IF N_PARAMS() GT  2 THEN p_sigma = sigma
  IF N_PARAMS() GT  3 THEN p_meanVal = meanVal
  IF N_PARAMS() GT  4 THEN p_varRatio = varRatio
  IF N_PARAMS() GT  5 THEN p_epsilon = epsilon
  IF N_PARAMS() GT  6 THEN p_sigmaSpatial = sigmaSpatial
  IF N_PARAMS() GT  7 THEN p_searchRadius = searchRadius
  IF N_PARAMS() GT  8 THEN p_patchRadius = patchRadius
  IF N_PARAMS() GT  9 THEN p_sigmaMean = sigmaMean
  IF N_PARAMS() GT 10 THEN p_stepSize = stepSize
  IF N_PARAMS() GT 11 THEN p_iterations = iterations
  IF N_PARAMS() GT 12 THEN p_nThreads = nThreads
  IF N_PARAMS() GT 13 THEN p_verbose = verbose
  
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*] = nonlocalmean_band(REFORM(array[band,*,*]), p_policy_type, p_sigma, p_meanVal, p_varRatio, p_epsilon, p_sigmaSpatial, p_searchRadius, p_patchRadius, p_sigmaMean, p_stepSize, p_iterations, p_nThreads, p_verbose)
  ENDFOR
  RETURN, res_array
END