;###############################################################################
;###################         Resize image                   ####################
FUNCTION vigra_resizeimage_c, array, array2, width, height,  width2, height2, resize_mode
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_resizeimage_c', array, array2, LONG(width), LONG(height), LONG(width2), LONG(height2), LONG(resize_mode), $
              VALUE=[0,0,1,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION resizeimage_band, array, width2, height2, resize_mode
  shape = SIZE(array)
  array2 = MAKE_ARRAY(width2, height2, /FLOAT, VALUE = 0.0)
  err = vigra_resizeimage_c(array, array2, shape[1], shape[2], width2, height2, resize_mode)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.imgproc:resizeimage: Resize of image failed!!"
    2: MESSAGE, "Error in vigraidl.imgproc:resizeimage: Resize mode must be in {0,1,2,3,4}!!"
  ENDCASE
END

FUNCTION  resizeimage, array, width2, height2, resize_mode
  shape = SIZE(array)
  res_array =  MAKE_ARRAY(shape[1], width2, height2, /FLOAT, VALUE = 0.0)
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = resizeimage_band(REFORM(array[band,*,*]), width2, height2, resize_mode)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################         Rotate image                   ####################
FUNCTION vigra_rotateimage_c, array, array2, width, height, angle, resize_mode
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_rotateimage_c', array, array2, LONG(width), LONG(height), FLOAT(angle), LONG(resize_mode), $
              VALUE=[0,0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION rotateimage_band, array, angle, resize_mode
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_rotateimage_c(array, array2, shape[1], shape[2], angle, resize_mode)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.imgproc:rotateimage: Rotation of image failed!!"
    2: MESSAGE, "Error in vigraidl.imgproc:rotateimage: Resize mode must be in {0,1,2,3,4}!!"
  ENDCASE
END

FUNCTION rotateimage, array, angle, resize_mode
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = rotateimage_band(REFORM(array[band,*,*]),  angle, resize_mode)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################         Affine transform image         ####################

FUNCTION vigra_affinewarpimage_c, array, affineMat, array2, width, height,  resize_mode
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_affinewarpimage_c', array, DOUBLE(affineMat), array2, LONG(width), LONG(height), LONG(resize_mode), $
              VALUE=[0,0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION affinewarpimage_band, array, affineMat, resize_mode
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_affinewarpimage_c(array, affineMat, array2, shape[1], shape[2], resize_mode)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.imgproc:affinewarpimage: Affine transform of image failed!!"
    2: MESSAGE, "Error in vigraidl.imgproc:affinewarpimage: Resize mode must be in {0,1,2,3,4}!!"
  ENDCASE
END

FUNCTION affinewarpimage, array, affineMat, resize_mode
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = affinewarpimage_band(REFORM(array[band,*,*]),  affineMat, resize_mode)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################         Reflect image                  ####################
FUNCTION vigra_reflectimage_c, array, array2, width, height, reflect_mode
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_reflectimage_c', array, array2, LONG(width), LONG(height), LONG(reflect_mode), $
              VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION reflectimage_band, array, reflect_mode
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_reflectimage_c(array, array2, shape[1], shape[2], reflect_mode)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.imgproc:reflectimage: Reflection of image failed!!"
    2: MESSAGE, "Error in vigraidl.imgproc:reflectimage: Reflection mode must be in {1 (= horizontal), 2 (= vertical), 3 (=both)}!!"
  ENDCASE
END

FUNCTION reflectimage, array, reflect_mode
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = reflectimage_band(REFORM(array[band,*,*]), reflect_mode)
  ENDFOR
  RETURN, res_array
END	  

;###############################################################################
;###################         Fast Fourier Transform         ####################
FUNCTION vigra_fouriertransform_c, array, array2, array3, width, height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_fouriertransform_c', array, array2, array3, LONG(width), LONG(height),  $
              VALUE=[0,0,0,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION fouriertransform_band, array
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  array3 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_fouriertransform_c(array, array2, array3, shape[1], shape[2])
  CASE err OF
    0: RETURN, COMPLEX(array2, array3)
    1: MESSAGE, "Error in vigraidl.imgproc:fouriertransform: Fast Fourier Transform of image failed!!"
  ENDCASE
END

FUNCTION fouriertransform, array
  shape = SIZE(array)
  res_array =  MAKE_ARRAY(shape[1], shape[2], shape[3], /COMPLEX, VALUE = 0.0)
  FOR band = 0, shape[1]-1 DO BEGIN
  res_array[band,*,*] = fouriertransform_band(REFORM(array[band,*,*]))
  ENDFOR
  RETURN, res_array
END


;###############################################################################
;###################     Inverse Fast Fourier Transform     ####################
FUNCTION vigra_fouriertransforminverse_c, array, array2, array3, array4, width, height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_fouriertransforminverse_c', array, array2, array3, array4, LONG(width), LONG(height),  $
    VALUE=[0,0,0,0,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION fouriertransforminverse_band, array
  shape = SIZE(array)
  real_arr = REAL_PART(array)
  imag_arr = IMAGINARY(array)
  array3 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  array4 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_fouriertransforminverse_c(real_arr, imag_arr, array3, array4, shape[1], shape[2])
  CASE err OF
    0: RETURN, COMPLEX(array3, array4)
    1: MESSAGE, "Error in vigraidl.imgproc:fouriertransforminverse: Inverse Fast Fourier Transform of image failed!!"
  ENDCASE
END

FUNCTION fouriertransforminverse, array
  shape = SIZE(array)
  res_array =  MAKE_ARRAY(shape[1], shape[2], shape[3], /COMPLEX, VALUE = 0.0)
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*] = fouriertransforminverse_band(REFORM(array[band,*,*]))
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################         Fast cross correlation         ####################
FUNCTION vigra_fastcrosscorrelation_c, array, array2, array3, width, height, mask_width, mask_height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_fastcrosscorrelation_c', array, array2,  array3, LONG(width), LONG(height), LONG(mask_width), LONG(mask_height), $
              VALUE=[0,0,0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION fastcrosscorrelation_band, array, mask
  shape = SIZE(array)
  mask_shape = SIZE(mask)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_fastcrosscorrelation_c(array, mask, array2, shape[1], shape[2], mask_shape[1], mask_shape[2])
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.imgproc:fastcrosscorrelation: Fast cross-correlation of image failed!!"
  ENDCASE
END

FUNCTION fastcrosscorrelation, array, mask
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = fastcrosscorrelation_band(REFORM(array[band,*,*]), REFORM(mask[band,*,*]))
  ENDFOR
  RETURN, res_array
END	  

;###############################################################################
;###################   Fast normalized cross correlation    ####################
FUNCTION vigra_fastnormalizedcrosscorrelation_c, array, array2, array3, width, height, mask_width, mask_height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_fastnormalizedcrosscorrelation_c', array, array2,  array3, LONG(width), LONG(height), LONG(mask_width), LONG(mask_height), $
              VALUE=[0,0,0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION fastnormalizedcrosscorrelation_band, array, mask
  shape = SIZE(array)
  mask_shape = SIZE(mask)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_fastnormalizedcrosscorrelation_c(array, mask, array2, shape[1], shape[2], mask_shape[1], mask_shape[2])
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.imgproc:fastnormalizedcrosscorrelation: Fast normalized cross-correlation of image failed!!"
  ENDCASE
END

FUNCTION fastnormalizedcrosscorrelation, array, mask
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = fastnormalizedcrosscorrelation_band(REFORM(array[band,*,*]), REFORM(mask[band,*,*]))
  ENDFOR
  RETURN, res_array
END	  

;###############################################################################
;###################        Local maxima extraction         ####################
FUNCTION vigra_localmaxima_c, array, array2, width, height, eight_connectivity
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_localmaxima_c', array, array2, LONG(width), LONG(height), BOOLEAN(eight_connectivity), $
              VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION localmaxima_band, array, eight_connectivity
  IF N_Elements(eight_connectivity) EQ 0 THEN eight_connectivity = 1
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_localmaxima_c(array, array2, shape[1], shape[2], eight_connectivity)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.imgproc:localmaxima: Extraction of local maxima of the image failed!!"
  ENDCASE
END

FUNCTION localmaxima, array, eight_connectivity
  IF N_Elements(eight_connectivity) EQ 0 THEN eight_connectivity = 1
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = localmaxima_band(REFORM(array[band,*,*]), eight_connectivity)
  ENDFOR
  RETURN, res_array
END	  

;###############################################################################
;###################        Local minima extraction         ####################
FUNCTION vigra_localminima_c, array, array2, width, height, eight_connectivity
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_localminima_c', array, array2, LONG(width), LONG(height), BOOLEAN(eight_connectivity),  $
              VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION localminima_band, array, eight_connectivity
  IF N_Elements(eight_connectivity) EQ 0 THEN eight_connectivity = 1
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_localminima_c(array, array2, shape[1], shape[2], eight_connectivity)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.imgproc:localminima: Extraction of local minima of the image failed!!"
  ENDCASE
END

FUNCTION localminima, array, eight_connectivity
  IF N_Elements(eight_connectivity) EQ 0 THEN eight_connectivity = 1
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = localminima_band(REFORM(array[band,*,*]), eight_connectivity)
  ENDFOR
  RETURN, res_array
END	  

;###############################################################################
;###################             Subimage                   ####################
FUNCTION vigra_subimage_c, array, array2, width, height, left, upper, right, lower
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_subimage_c', array, array2, LONG(width), LONG(height), LONG(left), LONG(upper), LONG(right), LONG(lower),  $
    VALUE=[0,0,1,1,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION subimage_band, array, left, upper, right, lower
  shape = SIZE(array)
  cut_width = right - left
  cut_height = lower - upper
  array2 = MAKE_ARRAY(cut_width, cut_height, /FLOAT, VALUE = 0.0)
  err = vigra_subimage_c(array, array2, shape[1], shape[2], left, upper, right, lower)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.imgproc:subimage: Subimage extraction failed!!"
    2: MESSAGE, "Error in vigraidl.imgproc:subimage: Constraints not fullfilled: left < right, upper < lower, right - left <= width, lower - upper <= height!!"
  ENDCASE
END

FUNCTION  subimage, array, left, upper, right, lower
  shape = SIZE(array)
  cut_width = right - left
  cut_height = lower - upper
  res_array =  MAKE_ARRAY(shape[1], cut_width, cut_height, /FLOAT, VALUE = 0.0)
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*] = subimage_band(REFORM(array[band,*,*]), left, upper, right, lower)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################             Subimage                   ####################
FUNCTION vigra_paddimage_c, array, array2, width, height, left, upper, right, lower, value
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_paddimage_c', array, array2, LONG(width), LONG(height), LONG(left), LONG(upper), LONG(right), LONG(lower), FLOAT(value), $
    VALUE=[0,0,1,1,1,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION paddimage_band, array, left, upper, right, lower, value
  shape = SIZE(array)
  w = shape[1]
  h = shape[2]
  IF N_PARAMS() LT 6 THEN value = 0.0
  padd_width = right + w + left
  padd_height = lower + h + upper
  array2 = MAKE_ARRAY(padd_width, padd_height, /FLOAT, VALUE = value)
  err = vigra_paddimage_c(array, array2, w, h, left, upper, right, lower, value)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.imgproc:paddimage: Padded image extraction failed!!"
    2: MESSAGE, "Error in vigraidl.imgproc:paddimage: Constraints not fullfilled: left & right >=0, upper & lower >=0!!"
  ENDCASE
END

FUNCTION  paddimage, array, left, upper, right, lower, value
  shape = SIZE(array)
  b = shape[1]
  w = shape[2]
  h = shape[3]
  IF N_PARAMS() LT 6 THEN value = MAKE_ARRAY(b, /FLOAT, VALUE = 0.0)
  padd_width = right + w + left
  padd_height = lower + h + upper
  res_array =  MAKE_ARRAY(b, padd_width, padd_height, /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*] = paddimage_band(REFORM(array[band,*,*]), left, upper, right, lower, value[band])
  ENDFOR
  RETURN, res_array
END