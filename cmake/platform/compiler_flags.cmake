# Copyright (C) 2013-2015  Dmitriy Vilkov <dav.daemon@gmail.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file LICENSE for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


macro (__init_compiler_feature FEATURE VALUE NAME DESC)
    set (COMPILER_FEATURE_${FEATURE} "${NAME}" CACHE STRINGS "[${VALUE}] ${DESC}")
    set (COMPILER_FEATURE_${FEATURE}_DEFAULT_VALUE ${VALUE})
    list (APPEND COMPILER_FEATURES ${FEATURE})
endmacro ()
macro (__append_to_compiler_feature_ON COMPILER LANG FEATURE VALUE)
    set (LANG ${LANG})
    foreach (l IN LISTS LANG)
        list (APPEND ${COMPILER}_${l}_COMPILER_FEATURE_${FEATURE}_ON ${VALUE})
    endforeach ()
endmacro ()
macro (__append_to_compiler_feature_OFF COMPILER LANG FEATURE VALUE)
    foreach (l IN LISTS LANG)
        list (APPEND ${COMPILER}_${l}_COMPILER_FEATURE_${FEATURE}_OFF ${VALUE})
    endforeach ()
endmacro ()


macro (__setup_compiler_features)
    set (COMPILER_FEATURES)
    __init_compiler_feature (WARNINGS ON "Common warnings" "Turns on/off recommended compiler warnings")
    __init_compiler_feature (DEFINITIONS ON "Common definitions" "Turns on/off recommended compiler definitions")
    __init_compiler_feature (HIDE_SYMBOLS ON "Hide symbols by default" "Set the default symbol visibility to hidden")
    __init_compiler_feature (COMMON_GLOBAL_VARIABLES ON "Common global variables" "Permit multiple definitions of global variables defined in different compilation units by placing the variables in a common block")
    __init_compiler_feature (THREADSAFE_STATICS OFF "Threadsafe statics" "Emit the extra code to use the routines specified in the C++ ABI for thread-safe initialization of local statics")
    __init_compiler_feature (OMIT_FRAME_POINTER OFF "Omit frame pointer" "Don't keep the frame pointer in a register for functions that don't need one")
    __init_compiler_feature (EXCEPTIONS OFF "Exceptions handling" "Generates extra code needed to propagate exceptions")
    __init_compiler_feature (CHECK_NEW OFF "Check result of operator new" "Check that the pointer returned by operator new is non-null before attempting to modify the storage allocated")
    __init_compiler_feature (RTTI OFF "Run-Time Type Identification" "Information about every class with virtual functions for use by the C++ run-time type identification features")
    __init_compiler_feature (STRICT_WARNINGS ON "Strict warnings" "Strict warnings")
    __init_compiler_feature (SHARED_CRT OFF "Shared CRT" "On systems that provide a shared CRT libraries, these options force the use of either the shared or static version")
    __init_compiler_feature (STANDARD_ANSI OFF "ANSI standard" "This turns off certain features of GCC that are incompatible with ISO C90 (when compiling C code), or of 1998 ISO C++ standard plus the 2003 technical corrigendum (when compiling C++ code)")
    __init_compiler_feature (STANDARD_C99 OFF "ISO 9899:1999 standard" "ISO 9899:1999 standard")
    __init_compiler_feature (STANDARD_11 OFF "ISO C11/C++11 standard" "ISO C11, the 2011 revision of the ISO C standard (when compiling C code) and the 2011 ISO C++ standard plus amendments (when compiling C++ code)")
    __init_compiler_feature (STANDARD_GNU_C99 OFF "GNU dialect of ISO C99 standard" "GNU dialect of ISO C99 standard")
    __init_compiler_feature (STANDARD_GNU_11 ON "GNU dialect of ISO C11/C++11 standard" "GNU dialect of ISO C11/C++11 standard")
    __init_compiler_feature (POSITION_INDEPENDENT_CODE OFF "Generate position-independent code (PIC)" "Generate position-independent code (PIC) suitable for use in a shared library, if supported for the target machine")
    __init_compiler_feature (COVERAGE OFF "Add code so that program flow arcs are instrumented" "During execution the program records how many times each branch and call is executed and how many times it is taken or returns")
    __init_compiler_feature (PROFILE OFF "Generate extra code to write profile information" "Generate extra code to write profile information suitable for the analysis programs")
    __init_compiler_feature (ABI_16 OFF "Generate code for a 16-bit environment" "Generate code for a 16-bit environment")
    __init_compiler_feature (ABI_32 OFF "Generate code for a 32-bit environment" "Generate code for a 32-bit environment")
    __init_compiler_feature (ABI_64 OFF "Generate code for a 64-bit environment" "Generate code for a 64-bit environment")
endmacro ()


macro (__setup_compiler_languages)
    set (COMPILER_LANGUAGES)
    list (APPEND COMPILER_LANGUAGES C)
    list (APPEND COMPILER_LANGUAGES CXX)
endmacro ()


macro (__setup_compiler_GNU)
    # Useful link: "http://gcc.gnu.org/onlinedocs/gcc/Invoking-GCC.html".
    if (WIN32)
        __append_to_compiler_feature_ON (GNU "C;CXX" DEFINITIONS "-D_UNICODE")
        __append_to_compiler_feature_ON (GNU "C;CXX" DEFINITIONS "-DUNICODE")
        __append_to_compiler_feature_ON (GNU "C;CXX" DEFINITIONS "-DSTRICT")
        __append_to_compiler_feature_ON (GNU "C;CXX" DEFINITIONS "-DWIN32_LEAN_AND_MEAN")
        # Require at least Windows 2000 (MinGW needs at least 0x0501 version; http://msdn.microsoft.com/en-us/library/Aa383745).
        __append_to_compiler_feature_ON (GNU "C;CXX" DEFINITIONS "-D_WIN32_WINNT=0x0501")
        __append_to_compiler_feature_ON (GNU "C;CXX" DEFINITIONS "-DWINVER=0x0501")
    endif()
    # Turn on WARNINGS.
    __append_to_compiler_feature_ON (GNU "C;CXX" WARNINGS "-Wall")
    __append_to_compiler_feature_ON (GNU "C;CXX" WARNINGS "-Wundef")
    __append_to_compiler_feature_ON (GNU "C;CXX" WARNINGS "-Wformat")
    __append_to_compiler_feature_ON (GNU "C;CXX" WARNINGS "-Wno-shadow")
    __append_to_compiler_feature_ON (GNU "C;CXX" WARNINGS "-Wcast-qual")
    __append_to_compiler_feature_ON (GNU "C;CXX" WARNINGS "-Wcast-align")
    __append_to_compiler_feature_ON (GNU "C;CXX" WARNINGS "-Wpointer-arith")
    __append_to_compiler_feature_ON (GNU "C;CXX" WARNINGS "-Wconversion")
    __append_to_compiler_feature_ON (GNU "C" WARNINGS "-Wstrict-prototypes")
    __append_to_compiler_feature_ON (GNU "C" WARNINGS "-Wmissing-prototypes")
    # Turn off WARNINGS.
    __append_to_compiler_feature_ON (GNU "C;CXX" WARNINGS "-Wno-unused-parameter")
    __append_to_compiler_feature_ON (GNU "C;CXX" WARNINGS "-Wno-parentheses")
    __append_to_compiler_feature_ON (GNU "C;CXX" WARNINGS "-Wno-ignored-qualifiers")
    # WARNINGS to ERRORS.
    __append_to_compiler_feature_ON (GNU "C;CXX" WARNINGS "-Werror=return-type")
    # Symbols visibility.
    __append_to_compiler_feature_ON (GNU "C;CXX" HIDE_SYMBOLS "-fvisibility=hidden")
    __append_to_compiler_feature_ON (GNU "CXX" HIDE_SYMBOLS "-fvisibility-inlines-hidden")
    # Turn on/off CODE GEN.
    __append_to_compiler_feature_ON (GNU "C;CXX" COMMON_GLOBAL_VARIABLES "-fcommon")
    __append_to_compiler_feature_OFF (GNU "C;CXX" COMMON_GLOBAL_VARIABLES "-fno-common")
    # Threadsafe statics
    __append_to_compiler_feature_OFF (GNU "CXX" THREADSAFE_STATICS "-fno-threadsafe-statics")
    # Frame pointer.
    __append_to_compiler_feature_ON (GNU "C;CXX" OMIT_FRAME_POINTER "-fomit-frame-pointer")
    __append_to_compiler_feature_OFF (GNU "C;CXX" OMIT_FRAME_POINTER "-fno-omit-frame-pointer")
    # Exceptions.
    __append_to_compiler_feature_ON (GNU "CXX" EXCEPTIONS "-fexceptions")
    __append_to_compiler_feature_OFF (GNU "CXX" EXCEPTIONS "-fno-exceptions")
    # Check result of operator new.
    __append_to_compiler_feature_ON (GNU "CXX" CHECK_NEW "-fcheck-new")
    __append_to_compiler_feature_OFF (GNU "CXX" CHECK_NEW "-fno-check-new")
    # RTTI. Until version 4.3.2, GCC doesn't define a macro to indicate whether RTTI is enabled.
    __append_to_compiler_feature_ON (GNU "CXX" RTTI "-frtti")
    __append_to_compiler_feature_OFF (GNU "CXX" RTTI "-fno-rtti")
    # Strict warnings.
    __append_to_compiler_feature_ON (GNU "C;CXX" STRICT_WARNINGS "-Wextra")
    __append_to_compiler_feature_ON (GNU "C;CXX" STRICT_WARNINGS "-pedantic")
    __append_to_compiler_feature_ON (GNU "C;CXX" STRICT_WARNINGS "-Werror=non-virtual-dtor")
    __append_to_compiler_feature_ON (GNU "C;CXX" STRICT_WARNINGS "-Werror=missing-field-initializers")
    # Static/Dynamic CRT.
    __append_to_compiler_feature_ON (GNU "C;CXX" SHARED_CRT "-shared-libgcc")
    __append_to_compiler_feature_ON (GNU "CXX" SHARED_CRT "-shared-libstdc++")
    __append_to_compiler_feature_OFF (GNU "C;CXX" SHARED_CRT "-static-libgcc")
    __append_to_compiler_feature_OFF (GNU "CXX" SHARED_CRT "-static-libstdc++")
    # C\C++ standards.
    __append_to_compiler_feature_ON (GNU "C;CXX" STANDARD_ANSI "-ansi")
    if (CMAKE_C_COMPILER_VERSION VERSION_GREATER "4.7.1")
        __append_to_compiler_feature_ON (GNU "C" STANDARD_C99 "-std=c99")
        __append_to_compiler_feature_ON (GNU "C" STANDARD_11 "-std=c11")
        __append_to_compiler_feature_ON (GNU "C" STANDARD_GNU_C99 "-std=gnu99")
        __append_to_compiler_feature_ON (GNU "C" STANDARD_GNU_11 "-std=gnu11")
    else ()
        __append_to_compiler_feature_ON (GNU "C" STANDARD_C99 "-std=c9x")
        __append_to_compiler_feature_ON (GNU "C" STANDARD_11 "-std=c1x")
        __append_to_compiler_feature_ON (GNU "C" STANDARD_GNU_C99 "-std=gnu9x")
        __append_to_compiler_feature_ON (GNU "C" STANDARD_GNU_11 "-std=gnu1x")
    endif ()
    if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER "4.7.1")
        __append_to_compiler_feature_ON (GNU "CXX" STANDARD_11 "-std=c++11")
        __append_to_compiler_feature_ON (GNU "CXX" STANDARD_GNU_11 "-std=gnu++11")
    else ()
        __append_to_compiler_feature_ON (GNU "CXX" STANDARD_11 "-std=c++0x")
        __append_to_compiler_feature_ON (GNU "CXX" STANDARD_GNU_11 "-std=gnu++0x")
    endif ()
    # Position Independent Code.
    __append_to_compiler_feature_ON (GNU "C;CXX" POSITION_INDEPENDENT_CODE "-fPIC")
    # Coverage. GCov.
    __append_to_compiler_feature_ON (GNU "C;CXX" COVERAGE "--coverage")
    __append_to_compiler_feature_ON (GNU_LINKER "C;CXX" COVERAGE "--coverage")
    # Profile. GProf.
    __append_to_compiler_feature_ON (GNU "C;CXX" PROFILE "-pg")
    __append_to_compiler_feature_ON (GNU_LINKER "C;CXX" PROFILE "-pg")
    # ABI.
    __append_to_compiler_feature_ON (GNU "C;CXX" ABI_16 "-m16")
    __append_to_compiler_feature_ON (GNU "C;CXX" ABI_32 "-m32")
    __append_to_compiler_feature_ON (GNU "C;CXX" ABI_64 "-m64")
endmacro ()


macro (__setup_compiler_MSVC)
    __append_to_compiler_feature_ON (MSVC "C;CXX" DEFINITIONS "-D_UNICODE")
    __append_to_compiler_feature_ON (MSVC "C;CXX" DEFINITIONS "-DUNICODE")
    __append_to_compiler_feature_ON (MSVC "C;CXX" DEFINITIONS "-DSTRICT")
    __append_to_compiler_feature_ON (MSVC "C;CXX" DEFINITIONS "-DWIN32_LEAN_AND_MEAN")
    __append_to_compiler_feature_ON (MSVC "C;CXX" DEFINITIONS "-GS")
    __append_to_compiler_feature_ON (MSVC "C;CXX" DEFINITIONS "-nologo")
    __append_to_compiler_feature_ON (MSVC "C;CXX" DEFINITIONS "-J")
    __append_to_compiler_feature_ON (MSVC "C;CXX" DEFINITIONS "-Zi")
    # Require at least Windows 2000 (http://msdn.microsoft.com/en-us/library/Aa383745).
    __append_to_compiler_feature_ON (MSVC "C;CXX" DEFINITIONS "-D_WIN32_WINNT=0x0500")
    __append_to_compiler_feature_ON (MSVC "C;CXX" DEFINITIONS "-DWINVER=0x0500")
    # Turn on WARNINGS.
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-W4")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-WX")
    # Turn off WARNINGS.
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4127")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4251")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4275")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4290")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4512")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4355")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4996")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4102")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4505")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4065")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4702")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4530")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4244")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4800")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4245")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4706")
    __append_to_compiler_feature_ON (MSVC "C;CXX" WARNINGS "-wd4100")
    # Frame pointer.
    __append_to_compiler_feature_ON (MSVC "C;CXX" OMIT_FRAME_POINTER "/Oy")
    # Exceptions.
    __append_to_compiler_feature_ON (MSVC "CXX" EXCEPTIONS "-EHsc")
    # RTTI.
    __append_to_compiler_feature_OFF (MSVC "CXX" RTTI "-GR-")
    # Static/Dynamic CRT.
    __append_to_compiler_feature_ON (MSVC "C;CXX" SHARED_CRT "-MD")
    __append_to_compiler_feature_OFF (MSVC "C;CXX" SHARED_CRT "-MT")
endmacro ()


macro (__setup_compiler_BORLAND)
endmacro ()


macro (__setup_compiler_SunPro)
    # Exceptions. Sun Pro doesn't provide macros to indicate whether exceptions are enabled.
    __append_to_compiler_feature_ON (SunPro "CXX" EXCEPTIONS "-features=except")
    __append_to_compiler_feature_ON (SunPro "CXX" EXCEPTIONS "-DPLATFORM_COMPILER_SUPPORTS_EXCEPTIONS=1")
    __append_to_compiler_feature_OFF (SunPro "CXX" EXCEPTIONS "-features=no%except")
    __append_to_compiler_feature_OFF (SunPro "CXX" EXCEPTIONS "-DPLATFORM_COMPILER_SUPPORTS_EXCEPTIONS=0")
    # RTTI. Sun Pro doesn't provide macros to indicate whether RTTI is enabled.
    __append_to_compiler_feature_ON (SunPro "CXX" RTTI "-features=rtti")
    __append_to_compiler_feature_OFF (SunPro "CXX" RTTI "-features=no%rtti")
endmacro ()


macro (__setup_compiler_VisualAge)
    # Exceptions.
    __append_to_compiler_feature_ON (VisualAge "CXX" EXCEPTIONS "-qeh")
    __append_to_compiler_feature_OFF (VisualAge "CXX" EXCEPTIONS "-qnoeh")
    # RTTI. Until version 9.0, Visual Age doesn't define a macro to indicate whether RTTI is enabled.
    __append_to_compiler_feature_ON (VisualAge "CXX" RTTI "-qrtti")
    __append_to_compiler_feature_OFF (VisualAge "CXX" RTTI "-qnortti")
endmacro ()


macro (__setup_compiler_HP)
    __append_to_compiler_feature_ON (HP "C;CXX" DEFINITIONS "-AA")
    __append_to_compiler_feature_ON (HP "C;CXX" DEFINITIONS "-mt")
    # Exceptions.
    __append_to_compiler_feature_ON (HP "CXX" EXCEPTIONS "-DPLATFORM_COMPILER_SUPPORTS_EXCEPTIONS=1")
    __append_to_compiler_feature_OFF (HP "CXX" EXCEPTIONS "+noeh")
    __append_to_compiler_feature_OFF (HP "CXX" EXCEPTIONS "-DPLATFORM_COMPILER_SUPPORTS_EXCEPTIONS=0")
endmacro ()


macro (setup_compiler)
    if (CMAKE_CROSSCOMPILING)
        message (STATUS "Cross compiling to: " ${CMAKE_SYSTEM_NAME} " " ${CMAKE_SYSTEM_VERSION})
    else ()
        message (STATUS "System: " ${CMAKE_SYSTEM_NAME} " " ${CMAKE_SYSTEM_VERSION})
    endif ()
    message (STATUS "Processor: " ${CMAKE_SYSTEM_PROCESSOR})

    if (CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_GNUC OR CMAKE_COMPILER_IS_GNUCC)
        __setup_compiler_GNU ()
        set (COMPILER_IS_GNU YES)
        message(STATUS "Compiler: GCC")
    elseif (MSVC)
        __setup_compiler_MSVC ()
        set (COMPILER_IS_MSVC YES)
        message(STATUS "Compiler: MSVC, version: " ${MSVC_VERSION})
    elseif (BORLAND)
        __setup_compiler_BORLAND ()
        set (COMPILER_IS_BORLAND YES)
        message(STATUS "Compiler: BCC")
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "SunPro")
        __setup_compiler_SunPro ()
        set (COMPILER_IS_SunPro YES)
        message(STATUS "Compiler: SunPro")
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "VisualAge" OR CMAKE_CXX_COMPILER_ID STREQUAL "XL")
        # CMake 2.8 changes Visual Age's compiler ID to "XL".
        __setup_compiler_VisualAge ()
        set (COMPILER_IS_VisualAge YES)
        message(STATUS "Compiler: VisualAge")
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "HP")
        __setup_compiler_HP ()
        set (COMPILER_IS_HP YES)
        message(STATUS "Compiler: HP")
    else ()
        message (FATAL_ERROR "Unknown compiler")
    endif ()

    __setup_compiler_features ()
endmacro ()

macro (__get_compiler_feature_value LANG FEATURE VALUE COMPILER_FLAGS LINKER_FLAGS)
    if (COMPILER_IS_GNU)
        if (VALUE)
            list (APPEND ${COMPILER_FLAGS} ${GNU_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
            list (APPEND ${LINKER_FLAGS} ${GNU_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
        else ()
            list (APPEND ${COMPILER_FLAGS} ${GNU_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
            list (APPEND ${LINKER_FLAGS} ${GNU_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
        endif ()
    elseif (COMPILER_IS_MSVC)
        if (VALUE)
            list (APPEND ${COMPILER_FLAGS} ${MSVC_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
            list (APPEND ${LINKER_FLAGS} ${MSVC_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
        else ()
            list (APPEND ${COMPILER_FLAGS} ${MSVC_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
            list (APPEND ${LINKER_FLAGS} ${MSVC_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
        endif ()
    elseif (COMPILER_IS_BORLAND)
        if (VALUE)
            list (APPEND ${COMPILER_FLAGS} ${BORLAND_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
            list (APPEND ${LINKER_FLAGS} ${BORLAND_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
        else ()
            list (APPEND ${COMPILER_FLAGS} ${BORLAND_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
            list (APPEND ${LINKER_FLAGS} ${BORLAND_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
        endif ()
    elseif (COMPILER_IS_SunPro)
        if (VALUE)
            list (APPEND ${COMPILER_FLAGS} ${SunPro_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
            list (APPEND ${LINKER_FLAGS} ${SunPro_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
        else ()
            list (APPEND ${COMPILER_FLAGS} ${SunPro_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
            list (APPEND ${LINKER_FLAGS} ${SunPro_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
        endif ()
    elseif (COMPILER_IS_VisualAge)
        if (VALUE)
            list (APPEND ${COMPILER_FLAGS} ${VisualAge_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
            list (APPEND ${LINKER_FLAGS} ${VisualAge_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
        else ()
            list (APPEND ${COMPILER_FLAGS} ${VisualAge_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
            list (APPEND ${LINKER_FLAGS} ${VisualAge_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
        endif ()
    elseif (COMPILER_IS_HP)
        if (VALUE)
            list (APPEND ${COMPILER_FLAGS} ${HP_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
            list (APPEND ${LINKER_FLAGS} ${HP_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
        else ()
            list (APPEND ${COMPILER_FLAGS} ${HP_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
            list (APPEND ${LINKER_FLAGS} ${HP_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
        endif ()
    else ()
        message (FATAL_ERROR "Unknown compiler")
    endif ()
endmacro ()

macro (__get_compiler_feature_value_default LANG FEATURE COMPILER_FLAGS LINKER_FLAGS)
    if (COMPILER_IS_GNU)
        if (COMPILER_FEATURE_${FEATURE}_DEFAULT_VALUE)
            list (APPEND ${COMPILER_FLAGS} ${GNU_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
            list (APPEND ${LINKER_FLAGS} ${GNU_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
        else ()
            list (APPEND ${COMPILER_FLAGS} ${GNU_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
            list (APPEND ${LINKER_FLAGS} ${GNU_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
        endif ()
    elseif (COMPILER_IS_MSVC)
        if (COMPILER_FEATURE_${FEATURE}_DEFAULT_VALUE)
            list (APPEND ${COMPILER_FLAGS} ${MSVC_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
            list (APPEND ${LINKER_FLAGS} ${MSVC_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
        else ()
            list (APPEND ${COMPILER_FLAGS} ${MSVC_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
            list (APPEND ${LINKER_FLAGS} ${MSVC_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
        endif ()
    elseif (COMPILER_IS_BORLAND)
        if (COMPILER_FEATURE_${FEATURE}_DEFAULT_VALUE)
            list (APPEND ${COMPILER_FLAGS} ${BORLAND_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
            list (APPEND ${LINKER_FLAGS} ${BORLAND_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
        else ()
            list (APPEND ${COMPILER_FLAGS} ${BORLAND_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
            list (APPEND ${LINKER_FLAGS} ${BORLAND_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
        endif ()
    elseif (COMPILER_IS_SunPro)
        if (COMPILER_FEATURE_${FEATURE}_DEFAULT_VALUE)
            list (APPEND ${COMPILER_FLAGS} ${SunPro_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
            list (APPEND ${LINKER_FLAGS} ${SunPro_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
        else ()
            list (APPEND ${COMPILER_FLAGS} ${SunPro_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
            list (APPEND ${LINKER_FLAGS} ${SunPro_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
        endif ()
    elseif (COMPILER_IS_VisualAge)
        if (COMPILER_FEATURE_${FEATURE}_DEFAULT_VALUE)
            list (APPEND ${COMPILER_FLAGS} ${VisualAge_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
            list (APPEND ${LINKER_FLAGS} ${VisualAge_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
        else ()
            list (APPEND ${COMPILER_FLAGS} ${VisualAge_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
            list (APPEND ${LINKER_FLAGS} ${VisualAge_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
        endif ()
    elseif (COMPILER_IS_HP)
        if (COMPILER_FEATURE_${FEATURE}_DEFAULT_VALUE)
            list (APPEND ${COMPILER_FLAGS} ${HP_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
            list (APPEND ${LINKER_FLAGS} ${HP_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_ON})
        else ()
            list (APPEND ${COMPILER_FLAGS} ${HP_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
            list (APPEND ${LINKER_FLAGS} ${HP_LINKER_${LANG}_COMPILER_FEATURE_${FEATURE}_OFF})
        endif ()
    else ()
        message (FATAL_ERROR "Unknown compiler")
    endif ()
endmacro ()

#
# OUTPUT (l means for each input LANGUAGE):
#   COMPILER_${l}_FLAGS
#   LINKER_${l}_FLAGS
#
function (process_compiler_features USE_DEFAULT_FEATURES LANGUAGES ...)
    set (ARGS ${ARGV})
    list (REMOVE_AT ARGS 0 1)
    set (DEFAULT_FEATURES)

    if (USE_DEFAULT_FEATURES)
        list (APPEND DEFAULT_FEATURES WARNINGS)
        list (APPEND DEFAULT_FEATURES DEFINITIONS)
        list (APPEND DEFAULT_FEATURES HIDE_SYMBOLS)
        list (APPEND DEFAULT_FEATURES COMMON_GLOBAL_VARIABLES)
        list (APPEND DEFAULT_FEATURES THREADSAFE_STATICS)
        list (APPEND DEFAULT_FEATURES OMIT_FRAME_POINTER)
        list (APPEND DEFAULT_FEATURES EXCEPTIONS)
        list (APPEND DEFAULT_FEATURES CHECK_NEW)
        list (APPEND DEFAULT_FEATURES RTTI)
        list (APPEND DEFAULT_FEATURES STRICT_WARNINGS)
        list (APPEND DEFAULT_FEATURES SHARED_CRT)
        list (APPEND DEFAULT_FEATURES STANDARD_ANSI)
        list (APPEND DEFAULT_FEATURES STANDARD_C99)
        list (APPEND DEFAULT_FEATURES STANDARD_11)
        list (APPEND DEFAULT_FEATURES STANDARD_GNU_C99)
        list (APPEND DEFAULT_FEATURES STANDARD_GNU_11)
        list (APPEND DEFAULT_FEATURES POSITION_INDEPENDENT_CODE)
        list (APPEND DEFAULT_FEATURES COVERAGE)
        list (APPEND DEFAULT_FEATURES PROFILE)
        list (APPEND DEFAULT_FEATURES ABI_16)
        list (APPEND DEFAULT_FEATURES ABI_32)
        list (APPEND DEFAULT_FEATURES ABI_64)
    endif ()

    set (LANGUAGES ${LANGUAGES})
    foreach (l IN LISTS LANGUAGES)
        list (REMOVE_ITEM ARGS ${l})
    endforeach ()

    foreach (opt IN LISTS ARGS)
        if (opt MATCHES "^[^:]+:[^:]+$")
            string (REGEX REPLACE "^([^:]+):[^:]+$" "\\1" FEATURE "${opt}")

            set (FOUND NO)
            foreach (f IN LISTS COMPILER_FEATURES)
                if (f STREQUAL FEATURE)
                    set (FOUND YES)
                    break ()
                endif ()
            endforeach ()

            if (NOT FOUND)
                message (FATAL_ERROR "Requested compiler feature \"${FEATURE}\" is not supported!")
            endif ()

            string (REGEX REPLACE "^[^:]+:([^:]+)$" "\\1" VALUE "${opt}")

            foreach (l IN LISTS LANGUAGES)
                __get_compiler_feature_value (${l} ${FEATURE} ${VALUE} FEATURES_${l}_VALUE FEATURES_${l}_LINKER_VALUE)
            endforeach ()

            if (USE_DEFAULT_FEATURES)
                list (REMOVE_ITEM DEFAULT_FEATURES ${FEATURE})
            endif ()
        else ()
            message (FATAL_ERROR "Invalid argument \"${opt}\"!\n Should be <feature:bool_value> pair.")
        endif ()
    endforeach ()

    foreach (opt IN LISTS DEFAULT_FEATURES)
        foreach (l IN LISTS LANGUAGES)
            __get_compiler_feature_value_default (${l} ${opt} FEATURES_${l}_VALUE FEATURES_${l}_LINKER_VALUE)
        endforeach ()
    endforeach ()

    foreach (l IN LISTS LANGUAGES)
        set (COMPILER_${l}_FLAGS ${FEATURES_${l}_VALUE} PARENT_SCOPE)
        set (LINKER_${l}_FLAGS ${FEATURES_${l}_LINKER_VALUE} PARENT_SCOPE)
    endforeach ()
endfunction ()
