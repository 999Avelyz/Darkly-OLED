add_library(darkycommon${QT_MAJOR_VERSION} OBJECT darkyboxshadowrenderer.cpp)

set_target_properties(darkycommon${QT_MAJOR_VERSION} PROPERTIES POSITION_INDEPENDENT_CODE TRUE)

target_link_libraries(darkycommon${QT_MAJOR_VERSION}
    PUBLIC
        Qt${QT_MAJOR_VERSION}::Core
        Qt${QT_MAJOR_VERSION}::Gui)
