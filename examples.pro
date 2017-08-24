;Tor run these examples (and any other program using vigraidl),
;please execute first:

;  CD, "/path/to/vigraidl",CURRENT=old_dir  
;  .COMPILE vigraidl
; CHECK_INSTALL
 
 
PRO examples

PRINT, "loading lenna-image"
img = loadimage(vigraidl_path() + "images/lenna_face.png")
shape = SIZE(img)

PRINT, "testing image padding"
; Causes Memory errors on Windows (bad_alloc on foreign (c) memory allocation)
IF !version.OS_FAMILY EQ 'unix' THEN BEGIN
  img_padd = paddimage(img, 10, 20, 30, 40,  [255.0 , 0.0 , 0.0])
ENDIF ELSE BEGIN
  img_padd = MAKE_ARRAY(shape[1],shape[2]+40,shape[3]+60, /FLOAT, VALUE=0.0)
  img_padd[*,10:10+shape[2]-1,20:20+shape[3]-1] = img
ENDELSE

PRINT, "testing subimage and correlation facilities"
IF !version.OS_FAMILY EQ 'unix' THEN BEGIN
  img_cut = subimage(img, 100, 50, 151, 101) ;;Mask needs to have odd size! Here 51x51
ENDIF ELSE BEGIN
  img_cut = img[*,100:150,100:150] ;;Mask needs to have odd size! Here 51x51
ENDELSE

fcc_res = fastcrosscorrelation(img, img_cut)
fncc_res = fastnormalizedcrosscorrelation(img, img_cut)
pos_matches = localmaxima(fncc_res)
neg_matches = localminima(fncc_res)



PRINT, "performing watershed transform on resized gradient image"
img2a = regionimagetocrackedgeimage( $
          labelimage( $
              watersheds_uf( $
                  ggradient( $
                      resizeimage(img, 2*shape[2], 2*shape[3],  4), $
                      1.0))), $
                0.0)  
img2b = regionimagetocrackedgeimage( $
                      labelimage( $
                        watersheds_rg( $
                          ggradient( $
                            resizeimage(img, 2*shape[2], 2*shape[3],  4), $
                            1.0))), $
                       0.0)

; Causes Memory errors on Windows (bad_alloc on foreign (c) memory allocation)
IF !version.OS_FAMILY EQ 'unix' THEN BEGIN
  PRINT, "performing slic segmentation on lenna image"
  img2_slic = regionimagetocrackedgeimage( slic(img), 0.0)
ENDIF

PRINT, "performing slic segmentation on the red channel of the lenna image"
img2red_slic = regionimagetocrackedgeimage( slic(img[0,*,*]), 0.0)

IF !version.OS_FAMILY EQ 'unix' THEN BEGIN
  PRINT, ""
  PRINT, "extracting slic (RGB) segmentation stats for the red channel seg. of the lenna image"
  img2_slic_stats = extractfeatures(img, slic(img[0,*,*]))

  stats_shape = SIZE(img2_slic_stats)

  FOR i=0, stats_shape[3]-1 DO BEGIN
    PRINT, "Region", i, ":    Size: ", img2_slic_stats[0,0,i],"    Mean Color: (", img2_slic_stats[0,13,i], ",", img2_slic_stats[0,14,i], ",", img2_slic_stats[0,15,i], ")"
  ENDFOR
ENDIF

PRINT, ""
PRINT, "extracting slic (single-band) segmentation stats for the red channel seg. of the lenna image"
img2red_slic_stats = extractfeatures(img[0,*,*], slic(img[0,*,*]))

stats_shape = SIZE(img2red_slic_stats)

FOR i=0, stats_shape[3]-1 DO BEGIN
  PRINT, "Region", i, ":    Size: ", img2red_slic_stats[0,0,i],"    Mean Color: ", img2red_slic_stats[0,9,i]
ENDFOR

PRINT, ""
PRINT, "extracting WT segmentation stats for the lenna image"
img2wt_stats = extractfeatures(img, watersheds_rg(ggradient(img, 5.0)))

stats_shape = SIZE(img2wt_stats)

FOR c=0, stats_shape[1]-1 DO BEGIN
  FOR i=0, stats_shape[3]-1 DO BEGIN
    PRINT, "Band: ", c, "    Region:", i, "    Size: ", img2wt_stats[c,0,i],"    Mean Color: ", img2wt_stats[c,9,i]
  endfor
ENDFOR

PRINT, "performing fft on image"
img_rect = loadimage(vigraidl_path() + "images/rect.png")
img3 = fouriertransform(img_rect[3,*,*]) ;Only use alpha channel
img3ifft = fouriertransforminverse(img3)

PRINT, "testing rotation and reflection functions on image"
img4 = reflectimage( img, 3)
img5 = rotateimage( img, 15.0, 3)


PRINT, "testing affine transformation on image"
theta = (-15 * 3.14157)/ 180.0

rotmat = [[cos(theta), -1*sin(theta), 0], $
          [sin(theta), cos(theta)   , 0], $
          [ 0        ,  0           , 1]]

t1mat = [ [1             ,  0             ,  0], $
          [0             ,  1             ,  0], $
          [-shape[2]/2.0 ,  -shape[3]/2.0 ,  1] ]  

t2mat = [ [1             ,  0            , 0], $
          [0             ,  1            , 0], $
          [shape[2]/2.0  , shape[3]/2.0  , 1] ]

img6 =  affinewarpimage( img , t2mat # (rotmat # t1mat) ,  3)




PRINT, "performing distance transform on canny edges of image"
img7 = distancetransform(cannyedgeimage( img,  1.8,  0.1,  100.0),  0.0,  2)

PRINT, "testing difference of exponential edge detection on image"
img8 = differenceofexponentialedgeimage( img, 1.8, 0.5, 100.0)

PRINT, "testing nearly all filters"
img9  = gsmooth( img, 3.0)
img10 = laplacianofgaussian( img, 3.0)
img11 = gsharpening( img, 0.5, 3.0)
img12 = sharpening( img, 3.0)
img13 = nonlineardiffusion( img, 0.1, 2.0)

; Tensor tests
img_st = structuretensor(img, 1.0, 4.0)

; boundary tensor
img_bt = boundarytensor(img, 1.0)

; boundary tensor without 0 order parts
img_bt = boundarytensor1(img, 1.0)

;tensor trace
img_st_tt = tensortrace(img_st)

; Causes Memory errors on Windows (bad_alloc on foreign (c) memory allocation)
IF !version.OS_FAMILY EQ 'unix' THEN BEGIN
  ;;tensor to eigen repr.
  img_st_te  = tensoreigenrepresentation(img_st)
  
  ;tensor to edge corner
  img_st_ec = tensortoedgecorner(img_st)
ENDIF

;tensor to hourglass-filtered tensor
img_st_hg = hourglassfilter(img_st, 1.0, 1.0)


PRINT, "testing some convolutions"

gauss_kernel = [  [1.0 , 2.0 , 1.0], $
                  [2.0 , 4.0 , 2.0], $
                  [1.0 , 2.0 , 1.0] ]/16.0
mean_kernel =  [  [1.0 , 1.0 , 1.0], $
                  [1.0 , 1.0 , 1.0], $
                  [1.0 , 1.0 , 1.0] ]/9.0
                  
sep_x_kernel =  [ [1.0], $
                  [1.0], $
                  [1.0] ]/3.0
sep_y_kernel =  [ [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] ]/9.0

img14 = convolveimage( img, gauss_kernel)
img15 = convolveimage( img, mean_kernel, 2) ;;Test for REPEAT border mode

; Causes Memory errors on Windows (bad_alloc on foreign (c) memory allocation)
IF !version.OS_FAMILY EQ 'unix' THEN BEGIN
  img16 = separableconvolveimage( img, sep_x_kernel, sep_y_kernel)
ENDIF

img17 = medianfilter( img, 3, 3)


PRINT, "testing the spline image view"
siv = create_splineimageview(img,2)
pos_x = 11.23
pos_y = 23.42
res = splineimageview_value(siv, pos_x, pos_y)

PRINT, splineimageview_dx(siv, pos_x, pos_y)
PRINT, splineimageview_dy(siv, pos_x, pos_y)

PRINT, splineimageview_dxx(siv, pos_x, pos_y)
PRINT, splineimageview_dxy(siv, pos_x, pos_y)
PRINT, splineimageview_dyy(siv, pos_x, pos_y)

PRINT, splineimageview_dx3(siv, pos_x, pos_y)
PRINT, splineimageview_dxxy(siv, pos_x, pos_y)
PRINT, splineimageview_dxyy(siv, pos_x, pos_y)
PRINT, splineimageview_dy3(siv, pos_x, pos_y)

PRINT, splineimageview_g2x(siv, pos_x, pos_y)
PRINT, splineimageview_g2y(siv, pos_x, pos_y)

PRINT, splineimageview_g2xx(siv, pos_x, pos_y)
PRINT, splineimageview_g2xy(siv, pos_x, pos_y)
PRINT, splineimageview_g2yy(siv, pos_x, pos_y)

PRINT, "saving resulting images"

result_path = vigraidl_path() + "results/"

IF FILE_TEST(result_path, /DIRECTORY) EQ 0 THEN FILE_MKDIR, result_path

res = saveimage(img2a, result_path + "lenna-relabeled-watersheds-uf-on-resized-gradient-image.png")
res = saveimage(img2b, result_path + "lenna-relabeled-watersheds-rg-on-resized-gradient-image.png")
res = saveimage(img2red_slic, result_path + "lenna-red-slic.png")

res = saveimage( REAL_PART(img3),  result_path + "rect-fft-real.png")
res = saveimage( IMAGINARY(img3) , result_path + "rect-fft-imag.png")
res = saveimage( ABS(img3) ,       result_path + "rect-fft-magnitude.png")
res = saveimage( SQRT(ABS(img3)) , result_path + "rect-fft-sqrt-magnitude.png")
res = saveimage( REAL_PART(img3ifft),  result_path + "rect-fft-ifft-real.png")
res = saveimage( IMAGINARY(img3ifft) , result_path + "rect-fft-ifft-imag.png")

res = saveimage( img4 ,  result_path + "lenna-reflected-both.png")
res = saveimage( img5 ,  result_path + "lenna-rotated-15deg.png")
res = saveimage( img6 ,  result_path + "lenna-aff-rotated-15deg.png")
res = saveimage( img7 ,  result_path + "lenna-disttransform-on-canny.png")
res = saveimage( img8 ,  result_path + "lenna-diff_of_exp.png")
res = saveimage( img9 ,  result_path + "lenna-gsmooth-3.0.png")
res = saveimage( img10,  result_path + "lenna-log-3.0.png")
res = saveimage( img_padd,  result_path + "lenna-padded.png")
res = saveimage( img11,  result_path + "lenna-gsharpening-0.5-3.0.png")
res = saveimage( img12,  result_path + "lenna-sharpening-3.0.png")
res = saveimage( img13,  result_path + "lenna-nonlineardiffusion-0.1-2.0.png")
res = saveimage( img14,  result_path + "lenna-gauss-convolve.png")
res = saveimage( img15,  result_path + "lenna-mean-convolve.png")
res = saveimage( img17,  result_path + "lenna-medianfilter-3x3.png")

;Non-created images, due to Memory errors on Windows (bad_alloc on foreign (c) memory allocation)
IF !version.OS_FAMILY EQ 'unix' THEN BEGIN
  res = saveimage(img2_slic, result_path + "lenna-slic.png")
  res = saveimage( img16,  result_path + "lenna-sep-convolve.png")
ENDIF

end