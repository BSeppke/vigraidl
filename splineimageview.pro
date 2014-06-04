;###############################################################################
;###################           SplineImageView Creation     ####################

FUNCTION vigra_create_splineimageview_c, array, width, height, degree
    adr = CALL_EXTERNAL(dylib_path() , 'vigra_create_splineimageview' + STRTRIM(degree,1) +'_address_c', array, FIX(width), FIX(height), $
                          VALUE=[0,1,1], /L64_VALUE, /CDECL, /AUTO_GLUE)
    RETURN, adr
END    

;###############################################################################
;###################          SplineImageView Deletion      ####################
FUNCTION vigra_delete_splineimageview_c, siv
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_delete_splineimageview' + STRTRIM(siv.deg,1) +'_by_address_c', siv.adr, $
                          VALUE=[1], /CDECL, /AUTO_GLUE)
END


;###############################################################################
;###################          SplineImageView Accessors     ####################
FUNCTION vigra_splineimageview_accessor, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_accessor_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END
 
; First order derivatives
FUNCTION vigra_splineimageview_dx, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_dx_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END 

FUNCTION vigra_splineimageview_dy, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_dy_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END 

;Second order derivatives
FUNCTION vigra_splineimageview_dxx, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_dxx_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END

FUNCTION vigra_splineimageview_dxy, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_dxy_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END

FUNCTION vigra_splineimageview_dyy, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_dyy_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END 

;Third order derivatives
FUNCTION vigra_splineimageview_dx3, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_dx3_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END

FUNCTION vigra_splineimageview_dxxy, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_dxxy_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END

FUNCTION vigra_splineimageview_dxyy, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_dxyy_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END 

FUNCTION vigra_splineimageview_dy3, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_dy3_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END


;SQUARE GRADIENT MEASURES
; First order derivatives
FUNCTION vigra_splineimageview_g2x, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_g2x_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END

FUNCTION vigra_splineimageview_g2y, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_g2y_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END

;Second order derivatives
FUNCTION vigra_splineimageview_g2xx, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_g2xx_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END

FUNCTION vigra_splineimageview_g2xy, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_g2xy_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END

FUNCTION vigra_splineimageview_g2yy, siv, x, y
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_splineimageview' + STRTRIM(siv.deg,1) +'_g2yy_by_address_c', siv.adr, double(x), double(y), $
    VALUE=[1,1,1], /F_VALUE, /CDECL, /AUTO_GLUE)
END


FUNCTION create_splineimageview_band, array, degree
  IF (degree GE 1) AND (degree LE 5) THEN BEGIN
    shape = SIZE(array)
    siv_adr = vigra_create_splineimageview_c(array, shape[1], shape[2], degree)
    RETURN, {vigraidl_SIV, adr:siv_adr, deg:degree}
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.create_splineimageview: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION create_splineimageview, array, degree
  shape = SIZE(array)
  siv0 = create_splineimageview_band(REFORM(array[0,*,*]),  degree)
  siv_array = REPLICATE(siv0,shape[1])
  FOR band = 1, shape[1]-1 DO BEGIN
	   siv_array[band] = create_splineimageview_band(REFORM(array[band,*,*]),  degree)
  ENDFOR
  RETURN, siv_array
END


FUNCTION delete_splineimageview_band, siv
IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    res = vigra_delete_splineimageview_c(siv)
    RETURN, res
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.delete_splineimageview_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

PRO delete_splineimageview, siv_array
  shape = SIZE(siv_array)
  res = 0
  FOR band = 0, shape[1]-1 DO BEGIN
    res = res + delete_splineimageview_band(siv_array[band])
    siv_array[band] = {vigraidl_SIV, adr:0, deg:0}
  ENDFOR
  IF res NE 0 THEN MESSAGE, "Error in vigraidl.splineimageview.delete_splineimageview: Freeing of the foreign memory failed!"
END

;;VALUE ACCESSOR
FUNCTION splineimageview_value_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_accessor(siv,x,y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_value_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_value, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_value_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END



;;FIRST ORDER DERIVATIVES VALUE ACCESSOR
FUNCTION splineimageview_dx_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_dx(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_dx_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_dx, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_dx_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END

FUNCTION splineimageview_dy_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_dy(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_dy_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_dy, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_dy_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END



;;SECOND ORDER DERIVATIVES VALUE ACCESSOR
FUNCTION splineimageview_dxx_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_dxx(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_dxx_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_dxx, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_dxx_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END

FUNCTION splineimageview_dxy_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_dxy(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_dxy_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_dxy, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_dxy_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END


FUNCTION splineimageview_dyy_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_dyy(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_dyy_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_dyy, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_dyy_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END



;;THIRD ORDER DERIVATIVES VALUE ACCESSOR
FUNCTION splineimageview_dx3_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_dx3(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_dx3_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_dx3, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_dx3_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END

FUNCTION splineimageview_dxxy_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_dxxy(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_dxxy_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_dxxy, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_dxxy_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END


FUNCTION splineimageview_dxyy_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_dxyy(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_dxyy_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_dxyy, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_dxyy_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END


FUNCTION splineimageview_dy3_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_dy3(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_dy3_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_dy3, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_dy3_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END


;;FIRST ORDER DERIVATIVES Gaussian Graient squared ACCESSOR
FUNCTION splineimageview_g2x_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_g2x(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_dx_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_g2x, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_g2x_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END

FUNCTION splineimageview_g2y_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_g2y(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_g2y_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_g2y, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_g2y_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END



;;SECOND ORDER DERIVATIVES VALUE ACCESSOR
FUNCTION splineimageview_g2xx_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_g2xx(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_g2xx_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_g2xx, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_g2xx_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END

FUNCTION splineimageview_g2xy_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_g2xy(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_g2xy_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_g2xy, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_g2xy_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END


FUNCTION splineimageview_g2yy_band, siv,x,y
  IF (siv.deg GE 1) AND (siv.deg LE 5) THEN BEGIN
    RETURN, vigra_splineimageview_g2yy(siv, x, y)
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.splineimageview.splineimageview_g2yy_band: Only degrees >0 and <6 are allowed"
  ENDELSE
END

FUNCTION splineimageview_g2yy, siv_array,x,y
  shape = SIZE(siv_array)
  res = MAKE_ARRAY(shape[1], /FLOAT)
  FOR band = 0, shape[1]-1 DO BEGIN
    res[band] =  splineimageview_g2yy_band(siv_array[band],x,y)
  ENDFOR
  RETURN, res
END
