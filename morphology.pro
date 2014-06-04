;###############################################################################
;###################         Erode image                   ####################
FUNCTION vigra_discerosion_c, array, array2, width, height, radius
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_discerosion_c', array, array2, FIX(width), FIX(height), FIX(radius), $
              VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION erodeimage_band, array, radius
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_discerosion_c(array, array2, shape[1], shape[2], radius)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.morphology:erodeimage: Erosion of image failed!!"
  ENDCASE
END

FUNCTION erodeimage, array, radius
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = erodeimage_band(REFORM(array[band,*,*]), radius)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################         Dilate image                   ####################
FUNCTION vigra_discdilation_c, array, array2, width, height, radius
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_discdilation_c', array, array2, FIX(width), FIX(height), FIX(radius), $
              VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION dilateimage_band, array, radius
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_discdilation_c(array, array2, shape[1], shape[2], radius)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.morphology:dilateimage: Dilation of image failed!!"
  ENDCASE
END

FUNCTION dilateimage, array, radius
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = dilateimage_band(REFORM(array[band,*,*]), radius)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################         Opening  image                 ####################

FUNCTION openingimage_band, array, radius
  RETURN, dilateimage_band(erodeimage_band(array, radius), radius)
END

FUNCTION openingimage, array, radius
  RETURN, dilateimage(erodeimage(array, radius), radius)
END


;###############################################################################
;###################         Closing image                  ####################

FUNCTION closingimage_band, array, radius
  RETURN, erodeimage_band(dilateimage_band(array, radius), radius)
END

FUNCTION closingimage, array, radius
  RETURN, erodeimage(dilateimage(array, radius), radius)
END


;###############################################################################
;###################         Upwind image                   ####################
FUNCTION vigraext_upwind_c, array, array2, width, height, radius
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigraext_upwind_c', array, array2, FIX(width), FIX(height), FLOAT(radius), $
    VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION upwindimage_band, array, radius
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigraext_upwind_c(array, array2, shape[1], shape[2], radius)
  CASE err OF
    0: RETURN, array2
    1: MESSAGE, "Error in vigraidl.morphology:upwindimage: Upwinding of image failed!!"
  ENDCASE
END

FUNCTION upwindimage, array, radius
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*] = upwindimage_band(REFORM(array[band,*,*]), radius)
  ENDFOR
  RETURN, res_array
END
