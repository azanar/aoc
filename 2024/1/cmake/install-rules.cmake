install(
    TARGETS one_exe
    RUNTIME COMPONENT one_Runtime
)

if(PROJECT_IS_TOP_LEVEL)
  include(CPack)
endif()
