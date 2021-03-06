;############ Getting Dimensions and # of Bands of an image-file    ############
FUNCTION vigra_imagewidth_c, filename
   RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_imagewidth_c',filename,VALUE=[1],/CDECL, /AUTO_GLUE)
END

FUNCTION vigra_imageheight_c, filename
   RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_imageheight_c',filename,VALUE=[1],/CDECL, /AUTO_GLUE)
END

FUNCTION vigra_imagenumbands_c, filename
   RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_imagenumbands_c',filename,VALUE=[1],/CDECL, /AUTO_GLUE)
END

;###############################################################################
;###################             Loading images             ####################
FUNCTION vigra_importgrayimage_c, array, width, height, filename
	RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_importgrayimage_c', array, width, height, filename, $
							VALUE=[0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION loadgrayimage, filename
	width  = vigra_imagewidth_c(filename)
    	height = vigra_imageheight_c(filename)
	IF  width EQ 0 OR height EQ 0 THEN BEGIN
		MESSAGE, "Error in vigraidl.impex.loadgrayimage: Image not found"
	ENDIF ELSE BEGIN
     	array = MAKE_ARRAY(1,width, height, /FLOAT, VALUE = 0.0)
      	err = vigra_importgrayimage_c(array, width, height, filename)
    	CASE err OF
    		0: 	RETURN, array
    		1:	MESSAGE, "Error in vigraidl.impex.loadgrayimage: Image cannot be loaded by vigra!"
    		2: 	MESSAGE, "Error in vigraidl.impex.loadgrayimage: Image is not grayscale!"
	    	3:	MESSAGE, "Error in vigraidl.impex.loadgrayimage: Sizes do not match!"
	    ENDCASE
	ENDELSE
END

FUNCTION vigra_importrgbimage_c, array_r, array_g, array_b, width, height, filename
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_importrgbimage_c', array_r, array_g, array_b, width, height, filename, $
              VALUE=[0,0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION loadrgbimage, filename
  width  = vigra_imagewidth_c(filename)
      height = vigra_imageheight_c(filename)
  IF  width EQ 0 OR height EQ 0 THEN BEGIN
    MESSAGE, "Error in vigraidl.impex.loadrgbimage: Image not found"
  ENDIF ELSE BEGIN
      array_r = MAKE_ARRAY(width, height, /FLOAT, VALUE = 0.0)
      array_g = MAKE_ARRAY(width, height, /FLOAT, VALUE = 0.0)
      array_b = MAKE_ARRAY(width, height, /FLOAT, VALUE = 0.0)
      
      err = vigra_importrgbimage_c(array_r, array_g, array_b, width, height, filename)
      array = MAKE_ARRAY(3, width, height, /FLOAT, VALUE = 0.0)
      array[0,*,*] = array_r
      array[1,*,*] = array_g
      array[2,*,*] = array_b
      
      CASE err OF
        0:  RETURN, array
        1:  MESSAGE, "Error in vigraidl.impex.loadrgbimage: Image cannot be loaded by vigra!"
        2:  MESSAGE, "Error in vigraidl.impex.loadrgbimage: Image is not rgb!"
        3:  MESSAGE, "Error in vigraidl.impex.loadrgbimage: Sizes do not match!"
      ENDCASE
  ENDELSE
END

FUNCTION vigra_importrgbaimage_c, array_r, array_g, array_b, array_a, width, height, filename
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_importrgbaimage_c', array_r, array_g, array_b, array_a, width, height, filename, $
    VALUE=[0,0,0,0,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION loadrgbaimage, filename
  width  = vigra_imagewidth_c(filename)
  height = vigra_imageheight_c(filename)
  IF  width EQ 0 OR height EQ 0 THEN BEGIN
    MESSAGE, "Error in vigraidl.impex.loadrgbaimage: Image not found"
  ENDIF ELSE BEGIN
    array_r = MAKE_ARRAY(width, height, /FLOAT, VALUE = 0.0)
    array_g = MAKE_ARRAY(width, height, /FLOAT, VALUE = 0.0)
    array_b = MAKE_ARRAY(width, height, /FLOAT, VALUE = 0.0)
    array_a = MAKE_ARRAY(width, height, /FLOAT, VALUE = 0.0)

    err = vigra_importrgbaimage_c(array_r, array_g, array_b, array_a, width, height, filename)
    array = MAKE_ARRAY(4, width, height, /FLOAT, VALUE = 0.0)
    array[0,*,*] = array_r
    array[1,*,*] = array_g
    array[2,*,*] = array_b
    array[3,*,*] = array_a

    CASE err OF
      0:  RETURN, array
      1:  MESSAGE, "Error in vigraidl.impex.loadrgbaimage: Image cannot be loaded by vigra!"
      2:  MESSAGE, "Error in vigraidl.impex.loadrgbaimage: Image is not rgb!"
      3:  MESSAGE, "Error in vigraidl.impex.loadrgbaimage: Sizes do not match!"
    ENDCASE
  ENDELSE
END

FUNCTION loadimage, filename
	numbands = vigra_imagenumbands_c(filename)
	CASE numbands OF
		1: RETURN, loadgrayimage(filename)
    3: RETURN, loadrgbimage(filename)
		4: RETURN, loadrgbaimage(filename)
		ELSE: MESSAGE,"Error in vigraidl.impex.loadimage: Image has neither 1 nor 3 nor 4 bands and thus cannot be loaded!"
	ENDCASE
END


;###############################################################################
;###################             Saving images              ####################
FUNCTION vigra_exportgrayimage_c, array, width, height, filename, rescale_range
	RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_exportgrayimage_c', array, width, height, filename, rescale_range, $
							VALUE=[0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION savegrayimage, array, filename, rescale_range
  rs_mode = 1 ;;Rescale range from min...max by default
  IF N_PARAMS() GT 2 THEN rs_mode = rescale_range

  shape = SIZE(array)
	err = vigra_exportgrayimage_c(array[0,*,*], shape[2], shape[3], filename, rs_mode)
    CASE err OF
    	0: 	RETURN,1
    	1:	MESSAGE, "Error in vigraidl.impex.savegrayimage: Image cannot be saved by vigra!"
	ENDCASE
END

FUNCTION vigra_exportrgbimage_c, array_r, array_g, array_b, width, height, filename, rescale_range
	RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_exportrgbimage_c', array_r, array_g, array_b, width, height, filename, rescale_range, $
							VALUE=[0,0,0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION savergbimage, array, filename, rescale_range
  rs_mode = 1 ;;Rescale range from min...max by default
  IF N_PARAMS() GT 2 THEN rs_mode = rescale_range
  
  shape = SIZE(array)
  err = vigra_exportrgbimage_c(REFORM(array[0,*,*]), REFORM(array[1,*,*]), REFORM(array[2,*,*]), shape[2], shape[3], filename, rs_mode)
  CASE err OF
    0:  RETURN,1
    1:  MESSAGE, "Error in vigraidl.impex.savergbimage: Image cannot be saved by vigra!"
  ENDCASE
END

FUNCTION vigra_exportrgbaimage_c, array_r, array_g, array_b, array_a, width, height, filename, rescale_range
  RETURN, CALL_EXTERNAL(dylib_path() , 'vigra_exportrgbaimage_c', array_r, array_g, array_b, array_a, width, height, filename, rescale_range, $
    VALUE=[0,0,0,0,1,1,1,1],/CDECL, /AUTO_GLUE)
END

FUNCTION savergbaimage, array, filename, rescale_range
  rs_mode = 1 ;;Rescale range from min...max by default
  IF N_PARAMS() GT 2 THEN rs_mode = rescale_range

  shape = SIZE(array)
  err = vigra_exportrgbaimage_c(REFORM(array[0,*,*]), REFORM(array[1,*,*]), REFORM(array[2,*,*]), REFORM(array[3,*,*]), shape[2], shape[3], filename, rs_mode)
  CASE err OF
    0:  RETURN,1
    1:  MESSAGE, "Error in vigraidl.impex.savergbaimage: Image cannot be saved by vigra!"
  ENDCASE
END


FUNCTION saveimage, array, filename, rescale_range
  rs_mode = 1 ;;Rescale range from min...max by default
  IF N_PARAMS() GT 2 THEN rs_mode = rescale_range
  
  shape = SIZE(array)
  CASE shape[1] OF
    1: 	RETURN, savegrayimage(array, filename, rs_mode)
    3:  RETURN, savergbimage(array, filename, rs_mode)
    4:  RETURN, savergbaimage(array, filename, rs_mode)
    ELSE:	MESSAGE, "Error in vigraidl.impex.saveimage: Image has neither 1 nor 3 nor 4 bands and thus cannot be saved by vigra!"
	ENDCASE
END