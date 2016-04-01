;###############################################################################
;###################         Resize image                   ####################
FUNCTION vigra_resizeimage_c, array, array2, width, height,  width2, height2, resize_mode
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_resizeimage_c', array, array2, FIX(width), FIX(height), FIX(width2), FIX(height2), FIX(resize_mode), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_rotateimage_c', array, array2, FIX(width), FIX(height), FLOAT(angle), FIX(resize_mode), $
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

FUNCTION vigra_affinewarpimage_c, array, array2, affineMat, width, height,  resize_mode
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_affinewarpimage_c', array, array2, DOUBLE(affineMat), FIX(width), FIX(height), FIX(resize_mode), $
              VALUE=[0,0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION affinewarpimage_band, array, affineMat, resize_mode
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_affinewarpimage_c(array, array2, affineMat, shape[1], shape[2], resize_mode)
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_reflectimage_c', array, array2, FIX(width), FIX(height), FIX(reflect_mode), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_fouriertransform_c', array, array2, array3, FIX(width), FIX(height),  $
              VALUE=[0,0,0,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION fouriertransform_band, array
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  array3 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_fouriertransform_c(array, array2, array3, shape[1], shape[2])
  CASE err OF
    0: RETURN, COMPLEX(array2, array3)
    1: MESSAGE, "Error in vigraidl.imgproc:fouriertransform: FastFourier Transform of image failed!!"
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
;###################         Fast cross correlation         ####################
FUNCTION vigra_fastcrosscorrelation_c, array, array2, array3, width, height, mask_width, mask_height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_fastcrosscorrelation_c', array, array2,  array3, FIX(width), FIX(height), FIX(mask_width), FIX(mask_height), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_fastnormalizedcrosscorrelation_c', array, array2,  array3, FIX(width), FIX(height), FIX(mask_width), FIX(mask_height), $
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
FUNCTION vigra_localmaxima_c, array, array2, width, height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_localmaxima_c', array, array2, FIX(width), FIX(height),  $
              VALUE=[0,0,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION localmaxima_band, array
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_localmaxima_c(array, array2, shape[1], shape[2])
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.imgproc:localmaxima: Extraction of local maxima of the image failed!!"
  ENDCASE
END

FUNCTION localmaxima, array
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = localmaxima_band(REFORM(array[band,*,*]))
  ENDFOR
  RETURN, res_array
END	  

;###############################################################################
;###################        Local minima extraction         ####################
FUNCTION vigra_localminima_c, array, array2, width, height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_localminima_c', array, array2, FIX(width), FIX(height),  $
              VALUE=[0,0,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION localminima_band, array
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_localminima_c(array, array2, shape[1], shape[2])
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.imgproc:localminima: Extraction of local minima of the image failed!!"
  ENDCASE
END

FUNCTION localminima, array
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = localminima_band(REFORM(array[band,*,*]))
  ENDFOR
  RETURN, res_array
END	  

;###############################################################################
;###################             Subimage                   ####################
FUNCTION vigra_subimage_c, array, array2, width, height, left, upper, right, lower
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_subimage_c', array, array2, FIX(width), FIX(height), FIX(left), FIX(upper), FIX(right), FIX(lower),  $
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