;###############################################################################
;###################         Label image                    ####################
FUNCTION vigra_labelimage_c, array, array2, width, height, eight_connectivity
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_labelimage_c', array, array2, FIX(width), FIX(height), BOOLEAN(eight_connectivity), $
              VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION labelimage_band, array, eight_connectivity
  IF N_Elements(eight_connectivity) EQ 0 THEN eight_connectivity = 1
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_labelimage_c(array, array2, shape[1], shape[2], eight_connectivity)
  IF err EQ -1 THEN BEGIN
    MESSAGE, "Error in vigraidl.segmentation.labelimage: Labeling of image failed!"
  ENDIF ELSE BEGIN
    RETURN, array2
  ENDELSE
END
	  
FUNCTION labelimage, array, eight_connectivity
  IF N_Elements(eight_connectivity) EQ 0 THEN eight_connectivity = 1
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
	res_array[band,*,*] = labelimage_band(REFORM(array[band,*,*]), eight_connectivity)
  ENDFOR
  RETURN, res_array
END
    
;###############################################################################
;###################      Watershed Transform (Union-Find)  ####################
FUNCTION vigra_watershedsunionfind_c, array, array2, width, height, eight_connectivity
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_watershedsunionfind_c', array, array2, FIX(width), FIX(height), BOOLEAN(eight_connectivity),  $
              VALUE=[0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION watersheds_uf_band, array, eight_connectivity
  IF N_Elements(eight_connectivity) EQ 0 THEN eight_connectivity = 1
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_watershedsunionfind_c(array, array2, shape[1], shape[2], eight_connectivity)
  IF err EQ -1 THEN BEGIN
    MESSAGE, "Error in vigraidl.segmentation.watersheds_uf: Watershed Transform of image failed!"
  ENDIF ELSE BEGIN
    RETURN, array2
  ENDELSE
END
    
FUNCTION watersheds_uf, array, eight_connectivity
  IF N_Elements(eight_connectivity) EQ 0 THEN eight_connectivity = 1
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
  res_array[band,*,*] = watersheds_uf_band(REFORM(array[band,*,*]), eight_connectivity)
  ENDFOR
  RETURN, res_array
END


;###############################################################################
;###################  Watershed Transform (Region-growing)  ####################
FUNCTION vigra_watershedsregiongrowing_c, array, array2, width, height, eight_connectivity, keep_contours, use_turbo, stop_cost
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_watershedsregiongrowing_c', array, array2, FIX(width), FIX(height),  $
    BOOLEAN(eight_connectivity), BOOLEAN(keep_contours), BOOLEAN(use_turbo), DOUBLE(stop_cost), $
    VALUE=[0,0,1,1,1,1,1,1], /CDECL, /AUTO_GLUE)
END

FUNCTION watersheds_rg_band, array, seeds, eight_connectivity , keep_contours, use_turbo, stop_cost
  IF N_ELEMENTS(seeds) EQ 0 THEN BEGIN
    seeds = labelimage_band(localminima_band(array)) - 1
  ENDIF
  IF N_ELEMENTS(eight_connectivity) EQ 0 THEN eight_connectivity = 1
  IF N_ELEMENTS(keep_contours) EQ 0 THEN keep_contours = 0
  IF N_ELEMENTS(use_turbo) EQ 0 THEN use_turbo = 0
  IF N_ELEMENTS(stop_cost) EQ 0 THEN stop_cost = -1.0
 
  shape = SIZE(array)
  array2 = seeds
  err = vigra_watershedsregiongrowing_c(array, array2, shape[1], shape[2], eight_connectivity, keep_contours, use_turbo, stop_cost)
  IF err EQ -1 THEN BEGIN
    MESSAGE, "Error in vigraidl.segmentation.watersheds_rg: Watershed Transform of image failed!"
  ENDIF ELSE BEGIN
    RETURN, array2
  ENDELSE
END

FUNCTION watersheds_rg, array, seeds, eight_connectivity , keep_contours, use_turbo, stop_cost
  IF N_ELEMENTS(seeds) EQ 0 THEN BEGIN
    seeds = labelimage(localminima(array)) - 1
  ENDIF
  IF N_ELEMENTS(eight_connectivity) EQ 0 THEN eight_connectivity = 1
  IF N_ELEMENTS(keep_contours) EQ 0 THEN keep_contours = 0
  IF N_ELEMENTS(use_turbo) EQ 0 THEN use_turbo = 0
  IF N_ELEMENTS(stop_cost) EQ 0 THEN stop_cost = -1.0
  
  shape = SIZE(array)
  res_array =  array
  FOR band = 0, shape[1]-1 DO BEGIN
    res_array[band,*,*] = watersheds_rg_band(REFORM(array[band,*,*]), REFORM(seeds[band,*,*]), eight_connectivity, keep_contours, use_turbo, stop_cost)
  ENDFOR
  RETURN, res_array
END

;###############################################################################
;###################       SLIC Segmentation Algorithm      ####################
FUNCTION vigra_slic_gray_c, array, array2, width, height, seedDistance, intensityScaling, iterations
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_slic_gray_c', array, array2, FIX(width), FIX(height), FIX(seedDistance), DOUBLE(intensityScaling), FIX(iterations), $
    VALUE=[0,0,1,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION slic_band, array, seedDistance, intensityScaling, iterations
  IF N_ELEMENTS(seedDistance) EQ 0 THEN seedDistance=15
  IF N_ELEMENTS(intensityScaling) EQ 0 THEN intensityScaling=20.0
  IF N_ELEMENTS(iterations) EQ 0 THEN iterations=40
  shape = SIZE(array)
  array2 = MAKE_ARRAY(shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_slic_gray_c(array, array2, shape[1], shape[2], seedDistance, intensityScaling, iterations)
  IF err EQ -1 THEN BEGIN
    MESSAGE, "Error in vigraidl.segmentation.slic_band: SLIC segmentation of image failed!"
  ENDIF ELSE BEGIN
    RETURN, array2
  ENDELSE
END

FUNCTION vigra_slic_rgb_c, array_r, array_g, array_b, array2, width, height, seedDistance, intensityScaling, iterations
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_slic_rgb_c', array_r, array_g, array_b, array2, FIX(width), FIX(height), FIX(seedDistance), DOUBLE(intensityScaling), FIX(iterations), $
    VALUE=[0,0,0,0,1,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION slic_rgb, array_r, array_g, array_b, seedDistance, intensityScaling, iterations
  IF N_ELEMENTS(seedDistance) EQ 0 THEN seedDistance=15
  IF N_ELEMENTS(intensityScaling) EQ 0 THEN intensityScaling=20.0
  IF N_ELEMENTS(iterations) EQ 0 THEN iterations=40
  shape = SIZE(array_r)
  array2 = MAKE_ARRAY(1, shape[1], shape[2], /FLOAT, VALUE = 0.0)
  err = vigra_slic_rgb_c(array_r, array_g, array_b, array2, shape[1], shape[2], seedDistance, intensityScaling, iterations)
  IF err EQ -1 THEN BEGIN
    MESSAGE, "Error in vigraidl.segmentation.slic_rgb: SLIC segmentation of image failed!"
  ENDIF ELSE BEGIN
    RETURN, array2
  ENDELSE
END

FUNCTION slic, array, seedDistance, intensityScaling, iterations
  IF N_ELEMENTS(seedDistance) EQ 0 THEN seedDistance=15
  IF N_ELEMENTS(intensityScaling) EQ 0 THEN intensityScaling=20.0
  IF N_ELEMENTS(iterations) EQ 0 THEN iterations=40
  shape = SIZE(array)
  IF shape[0] EQ 3 AND shape[1] EQ 3 THEN BEGIN
    res_array = slic_rgb(REFORM(array[0,*,*]), REFORM(array[1,*,*]), REFORM(array[2,*,*]), seedDistance, intensityScaling, iterations)
  ENDIF ELSE BEGIN
    res_array =  array
    FOR band = 0, shape[1]-1 DO BEGIN
      res_array[band,*,*] = slic_band(REFORM(array[band,*,*]), seedDistance, intensityScaling, iterations)
    ENDFOR
  ENDELSE
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
	  