;###############################################################################
;#############                   Structure Tensor                 ##############
FUNCTION vigra_structuretensor_c, array, array_xx,array_xy,array_yy, width, height, inner_scale, outer_scale
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_structuretensor_c', array, array_xx, array_xy, array_yy, LONG(width), LONG(height), FLOAT(inner_scale),FLOAT(outer_scale), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_boundarytensor_c', array, array_xx, array_xy, array_yy, LONG(width), LONG(height), FLOAT(scale), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_boundarytensor1_c', array, array_xx, array_xy, array_yy, LONG(width), LONG(height), FLOAT(scale), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_tensoreigenrepresentation_c', array_xx, array_xy, array_yy, array2_xx, array2_xy, array2_yy, LONG(width), LONG(height), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_tensortrace_c', array_xx, array_xy, array_yy, array2, LONG(width), LONG(height), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_tensortoedgecorner_c', array_xx, array_xy, array_yy, array2_xx, array2_xy, array2_yy, LONG(width), LONG(height), $
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
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_hourglassfilter_c', array_xx, array_xy, array_yy, array2_xx, array2_xy, array2_yy, LONG(width), LONG(height), FLOAT(sigma), FLOAT(rho), $
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
