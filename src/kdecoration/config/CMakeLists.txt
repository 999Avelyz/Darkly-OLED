#####  config classes ææææææ

set(darkydecoration_config_SRCS
  ../darkyexceptionlist.cpp
    darkyconfigwidget.cpp
    darkydetectwidget.cpp
    darkyexceptiondialog.cpp
    darkyexceptionlistwidget.cpp
    darkyexceptionmodel.cpp
    darkyitemmodel.cpp
)
ki18n_wrap_ui(darkydecoration_config_SRCS
    ui/darkyconfigurationui.ui
    ui/darkydetectwidget.ui
    ui/darkyexceptiondialog.ui
    ui/darkyexceptionlistwidget.ui
)

kcoreaddons_add_plugin(kcm_darkydecoration SOURCES kcm_darkydecoration.cpp ${darkydecoration_config_SRCS} INSTALL_NAMESPACE "${KDECORATION_KCM_PLUGIN_DIR}")
kconfig_add_kcfg_files(kcm_darkydecoration ../darkysettings.kcfgc)
target_include_directories(kcm_darkydecoration PRIVATE ${CMAKE_SOURCE_DIR}/kdecoration ${CMAKE_BINARY_DIR}/kdecoration/)
target_link_libraries(kcm_darkydecoration
     PUBLIC
        Qt6::Core
        Qt6::Gui
        Qt6::DBus
        KDecoration3::KDecoration
     PRIVATE
        KF6::CoreAddons
        KF6::ConfigWidgets
        KF6::GuiAddons
        KF6::I18n
        KF6::IconThemes
        KF6::WindowSystem
        KF6::KCMUtils
)
kcmutils_generate_desktop_file(kcm_darkydecoration)
