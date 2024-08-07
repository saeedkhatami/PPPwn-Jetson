#! /bin/bash

echo "building..."

cmake -B build -DUSE_SYSTEM_PCAP=OFF
cmake --build build -t ppwn

echo "finished..."