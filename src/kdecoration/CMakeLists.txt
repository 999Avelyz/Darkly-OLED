add_definitions(-DTRANSLATION_DOMAIN="darky_kwin_deco")

################# configuration #################
configure_file(config-darky.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config-darky.h )

################# includes #################
include_directories(${CMAKE_SOURCE_DIR}/libdarkycommon)
include_directories(${CMAKE_BINARY_DIR}/libdarkycommon)

################# newt target #################
### plugin classes
set(darkydecoration_SRCS
    darkybutton.cpp
    darkydecoration.cpp
    darkyexceptionlist.cpp
    darkysettingsprovider.cpp
)
### build library
kconfig_add_kcfg_files(darkydecoration_SRCS darkysettings.kcfgc)
add_library(darkydecoration MODULE
    ${darkydecoration_SRCS}
    ${darkydecoration_config_SRCS}
    ${darkydecoration_config_PART_FORMS_HEADERS})

set_target_properties(darkydecoration PROPERTIES
    OUTPUT_NAME org.kde.darky
)

target_link_libraries(darkydecoration
     PRIVATE
        darkycommon6
        KF6::CoreAddons
        KF6::ConfigWidgets
        KF6::GuiAddons
        KF6::I18n
        KF6::IconThemes
        KF6::WindowSystem
        KF6::KCMUtils
        Qt6::DBus
        KDecoration3::KDecoration
)
install(TARGETS darkydecoration DESTINATION ${KDE_INSTALL_PLUGINDIR}/${KDECORATION_PLUGIN_DIR})
install(FILES config/darkydecorationconfig.desktop DESTINATION  ${KDE_INSTALL_DATADIR}/kservices6)
add_subdirectory(config)
