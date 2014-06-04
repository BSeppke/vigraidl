
FUNCTION vigraidl_path
  CD, CURRENT=CDIR
  RETURN, CDIR
END

FUNCTION vigraidl_version
  RETURN, '1.0.0'
END

FUNCTION idl_bits
  RETURN, STRTRIM(!version.MEMORY_BITS,2)
END

FUNCTION dylib_file
  IF !version.OS EQ 'windows' THEN  RETURN, 'vigra_c.dll' ELSE $
  IF !version.OS EQ 'darwin' THEN   RETURN, 'libvigra_c.dylib' ELSE $
  IF !version.OS EQ 'linux' THEN    RETURN, 'libvigra_c.so' ELSE MESSAGE, 'Error: Only macosx, windows and unix are supported'
END

FUNCTION dylib_path
  RETURN, vigraidl_path() + dylib_file()
END

FUNCTION build_platform
  IF !version.OS EQ 'darwin' THEN   RETURN, 'macosx' + idl_bits() ELSE $
  IF !version.OS EQ 'linux' THEN    RETURN, 'unix'  + idl_bits() ELSE MESSAGE, 'Error: Only macosx and unix are supported for auto-build of vigra_c'
END

FUNCTION base_login_script
  RETURN, '~/.profile'
END

FUNCTION vigra_c_path 
  RETURN, vigraidl_path() +'/vigra_c/'
END

FUNCTION login_script
  IF FILE_TEST(base_login_script()) THEN RETURN, base_login_script() ELSE RETURN, vigra_c_path() + 'fallback.profile'
END

FUNCTION login_cmd
  RETURN, 'source ' + login_script()
END

FUNCTION system_env, arg
 SPAWN, login_cmd() + ' && ' + arg
END

FUNCTION vigra_installed
  PRINT, 'Searching for vigra using <vigra-config --version>'
  RETURN, system_env('vigra-config --version')
END

; The compilation routine (at least for macosx and unix)
FUNCTION build_vigra_c
  IF !version.OS_FAMILY EQ 'unix' THEN BEGIN
    IF vigra_installed() EQ 0 THEN BEGIN
      PRINT, '-------------- BUILDING VIGRA-C-WRAPPER FOR COMPUTER VISION AND IMAGE PROCESSING TASKS --------------'
      IF system_env('cd ' + vigra_c_path() + '&& make ' + build_platform()) EQ 0 THEN BEGIN
        FILE_COPY, vigra_c_path() + 'bin/' + dylib_file(), dylib_path(), /OVERWRITE
      ENDIF ELSE BEGIN 
        MESSAGE, 'making the vigra_c lib failed, although vigra seems to be installed'
      ENDELSE     
    ENDIF ELSE BEGIN
      MESSAGE, 'Vigra is not found. Please check if the prefix path is set correctly in ~/.profile environment file!'
    ENDELSE
  ENDIF ELSE IF !version.OS_FAMILY EQ 'windows' THEN BEGIN
    bindir = vigra_c_path() + 'bin/' + 'win' + idl_bits() + '/'
    SPAWN, 'copy ' + bindir + '*.dll ' + vigraidl_path()
    SPAWN, 'copy ' + vigraidl_path() + 'zlib.dll ' + vigraidl_path() + '/zlibwapi.dll'
  ENDIF ELSE BEGIN
    MESSAGE, 'Only Mac OS X, Unix and Windows are supported for auto build of vigra_c!'
  ENDELSE
  RETURN, 1
END

PRO CHECK_INSTALL
  ;;Enable Auto-Build of the vigra-c-lib if not already present!
  IF FILE_TEST(dylib_path()) EQ 0 THEN BEGIN
    result = build_vigra_c()
  ENDIF
  ;; For Windows: Add the dll directory to the systems path:
  IF !version.OS_FAMILY EQ 'windows' THEN BEGIN
    !PATH = !PATH + vigraidl_path()
  ENDIF
END
