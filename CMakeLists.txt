cmake_minimum_required(VERSION 3.16)
project(simple_c)
set(CMAKE_CXX_STANDARD 14) 
add_compile_options(-pedantic) 
# add_compile_options(-fsanitize=address) 

set(SRC_DIR "src")
set(PARSER_DIR ${CMAKE_CURRENT_BINARY_DIR})

## Flex/Bison configuration 
find_package(BISON)
find_package(FLEX)

set(LEXER_OUT ${PARSER_DIR}/lexer.c)
set(PARSER_OUT ${PARSER_DIR}/parser.c)

flex_target(
    LEXER 
    ${SRC_DIR}/lexer.l ${LEXER_OUT} 
    DEFINES_FILE ${PARSER_DIR}/lexer.h
)
bison_target(
    PARSER 
    ${SRC_DIR}/parser.y ${PARSER_OUT} 
    DEFINES_FILE ${PARSER_DIR}/parser.h
)
add_flex_bison_dependency(LEXER PARSER)

include_directories(
    ${CMAKE_SOURCE_DIR}/include 
    ${CMAKE_SOURCE_DIR}/src
)

add_executable(
    calc
    ${SRC_DIR}/main.c
    ${SRC_DIR}/utils.c
    ${SRC_DIR}/symbol.c
    ${SRC_DIR}/code.c
    ${LEXER_OUT}
    ${PARSER_OUT}
)
target_include_directories(calc PRIVATE ${PARSER_DIR})