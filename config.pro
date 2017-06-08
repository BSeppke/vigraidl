FUNCTION vigraidl_path
  CD, CURRENT=CDIR
  IF !version.OS EQ 'Win32' THEN RETURN, CDIR+"\" ELSE RETURN, CDIR +"/"
END

FUNCTION vigraidl_version
  RETURN, '1.0.0'
END

FUNCTION idl_bits
  RETURN, STRTRIM(!version.MEMORY_BITS,2)
END

FUNCTION dylib_file
  IF !version.OS EQ 'Win32' THEN  RETURN, 'vigra_c.dll' ELSE $
  IF !version.OS EQ 'darwin' THEN   RETURN, 'libvigra_c.dylib' ELSE $
  IF !version.OS EQ 'linux' THEN    RETURN, 'libvigra_c.so' ELSE MESSAGE, 'Error: Only macosx, windows and unix are supported'
END

FUNCTION dylib_path
  RETURN, vigraidl_path() + dylib_file()
END

FUNCTION cmake_flags
  IF idl_bits() EQ 32 THEN   RETURN, '-DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-m32 -DCMAKE_C_FLAGS=-m32'  ELSE RETURN, '-DCMAKE_BUILD_TYPE=Release'
END

FUNCTION vigra_c_path 
  RETURN, vigraidl_path() +'vigra_c/'
END

FUNCTION system_call, arg
  SPAWN, arg, EXIT_STATUS=stat
  RETURN, stat ;;Attention: Zero on success!
END

FUNCTION vigra_version
  SPAWN, 'vigra-config --version', version_string
  PRINT, version_string
  RETURN, STRSPLIT(version_string, '.', /EXTRACT)
END

FUNCTION vigra_installed
  PRINT, 'Searching for vigra >= 1.11.0 using <vigra-config --version>'
  ver = vigra_version()
  ver_size = SIZE(ver)
  IF (ver_size[1] EQ 3) THEN BEGIN
    IF  (ver[0] EQ 1 AND ver[1] GE 11) OR (ver[0] GT 1) THEN BEGIN
      RETURN, 1
    ENDIF
  ENDIF
  RETURN, 0
END

; The compilation routine (at least for macosx and unix)
FUNCTION build_vigra_c
  IF !version.OS_FAMILY EQ 'unix' THEN BEGIN
    ; Add MacPorts path for Mac OS X, if not already there
    IF !version.OS EQ 'darwin' AND STRPOS(GETENV('PATH'), '/opt/local/bin:') EQ -1 THEN BEGIN
      SETENV, 'PATH=/opt/local/bin:' + GETENV('PATH')
    ENDIF
    IF vigra_installed() THEN BEGIN
      PRINT, '-------------- BUILDING VIGRA-C-WRAPPER FOR COMPUTER VISION AND IMAGE PROCESSING TASKS --------------'
      IF system_call('cd ' + vigra_c_path() + ' && mkdir -p build && cd build && cmake ' + cmake_flags() + ' .. && make && cd .. && rm -rf ./build') EQ 0 THEN BEGIN
        FILE_COPY, vigra_c_path() + 'bin/' + dylib_file(), dylib_path(), /OVERWRITE
      ENDIF ELSE BEGIN 
        MESSAGE, 'making the vigra_c lib failed, although vigra seems to be installed'
      ENDELSE     
    ENDIF ELSE BEGIN
      MESSAGE, 'Vigra is not found. Please check if the prefix path is set correctly in ~/.profile environment file!'
    ENDELSE
  ENDIF ELSE IF !version.OS_FAMILY EQ 'Windows' THEN BEGIN
    bindir = vigra_c_path() + 'bin\' + 'win' + idl_bits() + '\'
    FILE_COPY, bindir + '*.dll', vigraidl_path(), /OVERWRITE
  ENDIF ELSE BEGIN
    MESSAGE, 'Only Mac OS X, Unix and Windows are supported for auto build of vigra_c!'
  ENDELSE
  RETURN, 1
END

PRO CHECK_INSTALL   
  ;;Install error handler
  CATCH, Error_status
  
  IF Error_status NE 0 THEN BEGIN
    result = build_vigra_c()
    CATCH, /CANCEL
  ENDIF
  
  ;;Enable Auto-Build if the lib cannot be loaded:
  test = CALL_EXTERNAL(dylib_path() , 'vigra_imagewidth_c', "foo.png",VALUE=[1], /CDECL, /AUTO_GLUE)

  
  ;; For Windows: Add the dll directory to the systems path:
  IF !version.OS_FAMILY EQ 'Windows' THEN BEGIN
    !MAKE_DLL.LD = 'link /out:%L /nologo /dll %O /def:%E "' + !DLM_PATH + '\\idl.lib" msvcrt.lib legacy_stdio_definitions.lib %X'
    !PATH = !PATH + ";" + vigraidl_path()
  ENDIF
END
