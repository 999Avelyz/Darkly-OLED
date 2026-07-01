### configuration plugin
add_definitions(-DTRANSLATION_DOMAIN=\"darky_style_config\")
set(kstyle_darky_config_PART_SRCS darkystyleconfig.cpp)

set(kstyle_darky_config_PART_SRCS ${kstyle_darky_config_PART_SRCS} darkystyleconfigmodule.cpp)

kconfig_add_kcfg_files(kstyle_darky_config_PART_SRCS ../darkystyleconfigdata.kcfgc)
set(kstyle_darky_config_PART_FORMS ui/darkystyleconfig.ui)
ki18n_wrap_ui(kstyle_darky_config_PART_FORMS_HEADERS ${kstyle_darky_config_PART_FORMS})

kcoreaddons_add_plugin(darkystyleconfig SOURCES
    ${kstyle_darky_config_PART_SRCS}
    ${kstyle_darky_config_PART_FORMS_HEADERS}
    INSTALL_NAMESPACE "kstyle_config"
)

target_link_libraries(darkystyleconfig Qt6::Core Qt6::Gui Qt6::Widgets Qt6::DBus)
target_link_libraries(darkystyleconfig KF6::CoreAddons KF6::ConfigCore KF6::ConfigWidgets KF6::I18n)
if(QT_MAJOR_VERSION STREQUAL "6")
    target_link_libraries(darkystyleconfig KF6::KCMUtils)
endif()
kcmutils_generate_desktop_file(darkystyleconfig)

set(darky_settings_SOURCES main.cpp)
add_executable(darky-settings ${darky_settings_SOURCES} )
target_link_libraries(darky-settings Qt6::Core Qt6::Gui Qt6::Widgets )
target_link_libraries(darky-settings KF6::I18n KF6::KCMUtils KF6::CoreAddons)

set_target_properties(darky-settings PROPERTIES OUTPUT_NAME darky-settings${QT_MAJOR_VERSION})

install(TARGETS darky-settings ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

# icon
ecm_install_icons(ICONS sc-apps-darky-settings.svgz
    DESTINATION ${KDE_INSTALL_ICONDIR}
    THEME hicolor )


