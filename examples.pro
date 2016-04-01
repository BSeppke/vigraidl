;Tor run these examples (and any other program using vigraidl),
;please execute first:

;  CD, "/path/to/vigraidl",CURRENT=old_dir  
;  .COMPILE vigraidl
; CHECK_INSTALL
 
 
PRO examples

PRINT, "loading lenna-image"
img = loadimage(vigraidl_path() + "images/lenna_face.png")
shape = SIZE(img)

PRINT, "testing subimage and correlation facilities"
img_cut = subimage(img, 100, 50, 151, 101) ;;Mask needs to have odd size!

fcc_res = fastcrosscorrelation(img, img_cut)
fncc_res = fastnormalizedcrosscorrelation(img, img_cut)
pos_matches = localmaxima(fncc_res)
neg_matches = localminima(fncc_res)



PRINT, "performing watershed transform on resized gradient image"
img2 = regionimagetocrackedgeimage( $
          labelimage( $
              watersheds( $
                  ggradient( $
                      resizeimage(img, 2*shape[2], 2*shape[3],  4), $
                      1.0))), $
                0.0)

PRINT, "performing fft on image"
img3 = fouriertransform(loadimage(vigraidl_path() + "images/rect.gif"))

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

;;tensor to eigen repr.
img_st_te  = tensoreigenrepresentation(img_st)

;tensor trace
img_st_tt = tensortrace(img_st)

;tensor to edge corner
img_st_ec = tensortoedgecorner(img_st)

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
img15 = convolveimage( img, mean_kernel)
img16 = separableconvolveimage( img, sep_x_kernel, sep_y_kernel)


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
res = saveimage(img2, vigraidl_path() +  "images/lenna-relabeled-watersheds-on-resized-gradient-image.png")

res = saveimage( REAL_PART(img3), vigraidl_path() +  "images/rect-fft-real.png")
res = saveimage( IMAGINARY(img3) , vigraidl_path() +  "images/rect-fft-imag.png")
res = saveimage( ABS(img3) , vigraidl_path() +  "images/rect-fft-magnitude.png")
res = saveimage( SQRT(ABS(img3)) , vigraidl_path() +  "images/rect-fft-sqrt-magnitude.png")

res = saveimage( img4 ,  vigraidl_path() +  "images/lenna-reflected-both.png")
res = saveimage( img5 ,  vigraidl_path() +  "images/lenna-rotated-15deg.png")
res = saveimage( img6 ,  vigraidl_path() +  "images/lenna-aff-rotated-15deg.png")
res = saveimage( img7 ,  vigraidl_path() +  "images/lenna-disttransform-on-canny.png")
res = saveimage( img8 ,  vigraidl_path() +  "images/lenna-diff_of_exp.png")
res = saveimage( img9 ,  vigraidl_path() +  "images/lenna-gsmooth-3.0.png")
res = saveimage( img10,  vigraidl_path() +  "images/lenna-log-3.0.png")
res = saveimage( img11,  vigraidl_path() +  "images/lenna-gsharpening-0.5-3.0.png")
res = saveimage( img12,  vigraidl_path() +  "images/lenna-sharpening-3.0.png")
res = saveimage( img13,  vigraidl_path() +  "images/lenna-nonlineardiffusion-0.1-2.0.png")
res = saveimage( img14,  vigraidl_path() +  "images/lenna-gauss-convolve.png")
res = saveimage( img15,  vigraidl_path() +  "images/lenna-mean-convolve.png")
res = saveimage( img16,  vigraidl_path() +  "images/lenna-sep-convolve.png")


end