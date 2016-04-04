;###############################################################################
;###################         Label image                    ####################
FUNCTION vigra_labelimage_c, array, array2, width, height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_labelimage_c', array, array2, FIX(width), FIX(height),  $
              VALUE=[0,0,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION labelimage_band, array
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_labelimage_c(array, array2, shape[1], shape[2])
  IF err EQ -1 THEN BEGIN
    MESSAGE, "Error in vigraidl.segmentation.labelimage: Labeling of image failed!"
  ENDIF ELSE BEGIN
    RETURN, array2
  ENDELSE
END
	  
FUNCTION labelimage, array
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = labelimage_band(REFORM(array[band,*,*]))
  ENDFOR
  RETURN, res_array
END
	  
;###############################################################################
;###################      Watershed Transform (Union-Find)  ####################
FUNCTION vigra_watersheds_c, array, array2, width, height
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_watersheds_c', array, array2, FIX(width), FIX(height),  $
              VALUE=[0,0,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION watersheds_band, array
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_watersheds_c(array, array2, shape[1], shape[2])
  IF err EQ -1 THEN BEGIN
    MESSAGE, "Error in vigraidl.segmentation.watersheds: Watershed Transform of image failed!"
  ENDIF ELSE BEGIN
    RETURN, array2
  ENDELSE
END
	  
FUNCTION watersheds, array
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = watersheds_band(REFORM(array[band,*,*]))
  ENDFOR
  RETURN, res_array
END
	  
;###############################################################################
;###################      Canny Edge-Detection              ####################
FUNCTION vigra_cannyedgeimage_c, array, array2, width, height,scale, gradient_threshold, mark
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_cannyedgeimage_c', array, array2, FIX(width), FIX(height), FLOAT(scale), FLOAT(gradient_threshold), FLOAT(mark), $
              VALUE=[0,0,1,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION cannyedgeimage_band, array, scale, gradient_threshold, mark
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_cannyedgeimage_c(array, array2, shape[1], shape[2], scale, gradient_threshold, mark)
  IF err EQ 0 THEN BEGIN
    RETURN, array2
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.segmentation:cannyedgeimage: Canny Edge Detection of image failed!"
  ENDELSE
END 

FUNCTION cannyedgeimage, array, scale, gradient_threshold, mark
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = cannyedgeimage_band(REFORM(array[band,*,*]), scale, gradient_threshold, mark)
  ENDFOR
  RETURN, res_array
END
	  
;###############################################################################
;################    Difference of Exponential Edge-Detection  #################
FUNCTION vigra_differenceofexponentialedgeimage_c, array, array2, width, height,scale, gradient_threshold, mark
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_differenceofexponentialedgeimage_c', array, array2, FIX(width), FIX(height), FLOAT(scale), FLOAT(gradient_threshold), FLOAT(mark), $
              VALUE=[0,0,1,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION differenceofexponentialedgeimage_band, array, scale, gradient_threshold, mark
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_differenceofexponentialedgeimage_c(array, array2, shape[1], shape[2], scale, gradient_threshold, mark)
  IF err EQ 0 THEN BEGIN
    RETURN, array2
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraidl.segmentation:differenceofexponentialedgeimage: Difference of Exponential Edge Detection of image failed!"
  ENDELSE
END

FUNCTION differenceofexponentialedgeimage, array, scale, gradient_threshold, mark
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = differenceofexponentialedgeimage_band(REFORM(array[band,*,*]), scale, gradient_threshold, mark)
  ENDFOR
  RETURN, res_array
END
	  

;###############################################################################
;###################     RegionImage -> CrackEdgeImage      ####################
FUNCTION vigra_regionimagetocrackedgeimage_c, array, array2, width, height,  mark
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_regionimagetocrackedgeimage_c', array, array2, FIX(width), FIX(height), FLOAT(mark), $
              VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION regionimagetocrackedgeimage_band, array, mark
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1]*2-1, shape[2]*2-1, /FLOAT, VALUE = 0.0)
  err = vigra_regionimagetocrackedgeimage_c(array, array2, shape[1], shape[2], mark)
  IF err EQ 0 THEN BEGIN
    RETURN, array2
  ENDIF ELSE BEGIN
    MESSAGE, "Error in vigraplt.segmentation:regionimagetocrackedgeimage: Creation of CrackEdgeImage failed!"
  ENDELSE
END

FUNCTION regionimagetocrackedgeimage, array, mark
  shape = SIZE(array)
  res_array =  MAKE_ARRAY(shape[1], shape[2]*2-1, shape[3]*2-1, /FLOAT, VALUE = 0.0)
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = regionimagetocrackedgeimage_band(REFORM(array[band,*,*]), mark)
  ENDFOR
  RETURN, res_array
END
	  