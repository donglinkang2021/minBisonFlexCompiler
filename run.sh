cmake -S . -B build
cmake --build build
./build/calc input.txt
./build/calc input.txt > output/test.s
gcc -m32 -no-pie output/test.s -o output/test
./output/test