################# includes #################
include_directories(
    animations
    debug
    ${CMAKE_SOURCE_DIR}/libdarkycommon
    ${CMAKE_BINARY_DIR}/libdarkycommon
)

################# configuration #################
configure_file(config-darky.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config-darky.h)

########### next target ###############
set(darky_PART_SRCS
    animations/darkyanimation.cpp
    animations/darkyanimations.cpp
    animations/darkyanimationdata.cpp
    animations/darkybaseengine.cpp
    animations/darkybusyindicatordata.cpp
    animations/darkybusyindicatorengine.cpp
    animations/darkydialdata.cpp
    animations/darkydialengine.cpp
    animations/darkyenabledata.cpp
    animations/darkygenericdata.cpp
    animations/darkyheaderviewdata.cpp
    animations/darkyheaderviewengine.cpp
    animations/darkyscrollbardata.cpp
    animations/darkyscrollbarengine.cpp
    animations/darkyspinboxengine.cpp
    animations/darkyspinboxdata.cpp
    animations/darkystackedwidgetdata.cpp
    animations/darkystackedwidgetengine.cpp
    animations/darkytabbarengine.cpp
    animations/darkytabbardata.cpp
    animations/darkytoolboxengine.cpp
    animations/darkytransitiondata.cpp
    animations/darkytransitionwidget.cpp
    animations/darkywidgetstateengine.cpp
    animations/darkywidgetstatedata.cpp
    debug/darkywidgetexplorer.cpp
    darkyaddeventfilter.cpp
    darkyblurhelper.cpp
    darkyframeshadow.cpp
    darkyhelper.cpp
    darkymdiwindowshadow.cpp
    darkymnemonics.cpp
    darkypropertynames.cpp
    darkyshadowhelper.cpp
    darkysplitterproxy.cpp
    darkystyle.cpp
    darkystyleplugin.cpp
    darkytileset.cpp
    darkywindowmanager.cpp
    darkytoolsareamanager.cpp
)

kconfig_add_kcfg_files(darky_PART_SRCS ../kdecoration/darkysettings.kcfgc)
kconfig_add_kcfg_files(darky_PART_SRCS darkystyleconfigdata.kcfgc)

add_library(darky${QT_MAJOR_VERSION} MODULE ${darky_PART_SRCS})

################# find Qt modules #################
if(QT_MAJOR_VERSION EQUAL 6)
    find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Quick QuickWidgets)
else()
    find_package(Qt5 REQUIRED COMPONENTS Core Gui Widgets Quick QuickWidgets)
endif()

################# link Qt libraries #################
target_link_libraries(darky${QT_MAJOR_VERSION}
    PRIVATE
    Qt${QT_MAJOR_VERSION}::Core
    Qt${QT_MAJOR_VERSION}::Gui
    Qt${QT_MAJOR_VERSION}::Widgets
    Qt${QT_MAJOR_VERSION}::DBus
    Qt${QT_MAJOR_VERSION}::Quick
)

if( DARKY_HAVE_QTQUICK )
    target_link_libraries(darky${QT_MAJOR_VERSION}
        PRIVATE
            Qt${QT_MAJOR_VERSION}::QuickWidgets
            KF${QT_MAJOR_VERSION}::CoreAddons
    )
endif()

################# link KDE Frameworks #################
target_link_libraries(darky${QT_MAJOR_VERSION}
    PRIVATE
    KF${QT_MAJOR_VERSION}::CoreAddons
    KF${QT_MAJOR_VERSION}::ConfigCore
    KF${QT_MAJOR_VERSION}::ConfigGui
    KF${QT_MAJOR_VERSION}::GuiAddons
    KF${QT_MAJOR_VERSION}::IconThemes
    KF${QT_MAJOR_VERSION}::WindowSystem
)

if(QT_MAJOR_VERSION STREQUAL "5")
    target_link_libraries(darky${QT_MAJOR_VERSION} PRIVATE KF5::ConfigWidgets)
    if(DARKY_HAVE_QTQUICK)
        target_link_libraries(darky${QT_MAJOR_VERSION} PRIVATE KF5::Kirigami2)
    endif()
else()
    target_link_libraries(darky${QT_MAJOR_VERSION} PRIVATE KF6::ColorScheme)
    if(DARKY_HAVE_QTQUICK)
        target_link_libraries(darky${QT_MAJOR_VERSION} PRIVATE KF6::KirigamiPlatform)
    endif()
endif()

################# link internal library #################
target_link_libraries(darky${QT_MAJOR_VERSION} PRIVATE darkycommon${QT_MAJOR_VERSION})

################# KDE style integration #################
if(KF${QT_MAJOR_VERSION}FrameworkIntegration_FOUND)
    target_link_libraries(darky${QT_MAJOR_VERSION} PRIVATE KF${QT_MAJOR_VERSION}::Style)
endif()

if (WIN32)
    # As stated in https://docs.microsoft.com/en-us/cpp/c-runtime-library/math-constants M_PI only gets defined
    # when if _USE_MATH_DEFINES is defined
    target_compile_definitions(darky${QT_MAJOR_VERSION} PRIVATE _USE_MATH_DEFINES _BSD_SOURCE)
endif()


########### install files ###############
if (FOR_FLATPAK)
    set(LIB_TARGET ${QT_PLUGINS_DIR}/styles/)
else()
    set(LIB_TARGET ${KDE_INSTALL_QTPLUGINDIR}/styles/)
endif()
install(TARGETS darky${QT_MAJOR_VERSION} DESTINATION ${LIB_TARGET})

if (NOT FOR_FLATPAK)
    install(FILES darky.themerc  DESTINATION  ${KDE_INSTALL_DATADIR}/kstyle/themes)
endif()

########### subdirectories ###############

if (QT_MAJOR_VERSION EQUAL "6" AND TARGET "KF6::KCMUtils" AND NOT FOR_FLATPAK)
    add_subdirectory(config)
endif()

########### tests ###############
include(CTest)
if(BUILD_TESTING)
    add_subdirectory(tests)
endif()
