# Tests

Setup the environment.

```shell
python3 -m pip install -r requirements.txt
```

Test 1: Compare the packet generated by the C++ version and the Python version.

```shell
cmake -B build -DBUILD_TEST=ON -DPython3_EXECUTABLE=$(which python3)
cmake --build build pppwn_py
```

Test 2: Replace some functions in pppwn.py with C++ version, and run with a real ps4 to test.

```shell
cmake -B build -DBUILD_TEST=ON -DPython3_EXECUTABLE=$(which python3) -DIFACE=en10 -DFW=900 -DSTAGE1="<path>" -DSTAGE2="<path>"
cmake --build build pppwn_pybind
```

Test 3: Output the packet generated by the C++ version.

```shell
cmake -B build -DBUILD_TEST=ON
cmake --build build pppwn_output
```