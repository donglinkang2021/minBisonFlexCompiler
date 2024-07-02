# Minimal C Compiler

> Flex+Bison+Cmake, written in C

Simple C compiler, which can compile a subset of C language.

- [x] function definition
- [x] variable declaration
- [x] function call
- [x] arithmetic operation
- [x] if-else statement
- [x] while statement
- [x] return statement
- [x] printf

## Test

```shell
linkdom@ubuntu:~/Desktop/myCompiler/c_version$ ./submit.sh 
-- Configuring done
-- Generating done
-- Build files have been written to: /home/linkdom/Desktop/myCompiler/c_version/build
[100%] Built target calc
Evaluating file: samples2/cases/e01.c
Evaluating file: samples2/cases/e02.c
Evaluating file: samples2/cases/e03.c
Evaluating file: samples2/cases/e04.c
Evaluating file: samples2/cases/e05.c
Evaluating file: samples2/cases/e06.c
Evaluating file: samples2/cases/e07.c
Evaluating file: samples2/cases/e08.c
linkdom@ubuntu:~/Desktop/myCompiler/c_version$ ./submit.sh 
-- Configuring done
-- Generating done
-- Build files have been written to: /home/linkdom/Desktop/myCompiler/c_version/build
[100%] Built target calc
Evaluating file: samples/cases/e01.c
Evaluating file: samples/cases/e02.c
Evaluating file: samples/cases/e03.c
Evaluating file: samples/cases/e04.c
Evaluating file: samples/cases/e05.c
Evaluating file: samples/cases/e06.c
Evaluating file: samples/cases/e07.c
Evaluating file: samples/cases/e08.c
```