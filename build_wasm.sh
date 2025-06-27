#!/usr/bin/env bash
# cd onnxruntime
# ./build.sh --config Release --build_wasm_static_lib --skip_tests --disable_wasm_exception_catching --disable_rtti --parallel

# cd ..
# cp -r onnxruntime/include/* onnxruntime-wasm/wasm/include/
# cp -r onnxruntime/build/Linux/Release/libonnxruntime_webassembly.a onnxruntime-wasm/wasm/lib

# ./build.sh --build_wasm_static_lib --enable_wasm_threads --skip_tests --enable_wasm_debug_info --parallel --emscripten_settings SAFE_STACK 1
# cp -r onnxruntime/include/* onnxruntime-wasm/wasm/include/
# cp -r onnxruntime/build/Linux/Debug/libonnxruntime_webassembly.a onnxruntime-wasm/wasm/lib

BUILD_TYPE=Debug
BUILD_OUTPUT="BIN"
ONNX_TYPE="WASM"
sysOS=$(uname -s)
EMROOT=onnxruntime/cmake/external/emsdk/upstream/emscripten
NUM_THREADS=1
if [ $sysOS == "Darwin" ]; then
  #echo "I'm MacOS"
  NUM_THREADS=$(sysctl -n hw.ncpu)
elif [ $sysOS == "Linux" ]; then
  #echo "I'm Linux"
  NUM_THREADS=$(grep ^processor /proc/cpuinfo | wc -l)
else
  echo "Other OS: $sysOS"
fi

mkdir -p $sysOS-$ONNX_TYPE-$BUILD_OUTPUT
pushd $sysOS-$ONNX_TYPE-$BUILD_OUTPUT

echo "cmake -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DOCR_OUTPUT=$BUILD_OUTPUT -DOCR_ONNX=$ONNX_TYPE .."
cmake -DCMAKE_TOOLCHAIN_FILE=$EMROOT/cmake/Modules/Platform/Emscripten.cmake -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DOCR_OUTPUT=$BUILD_OUTPUT -DOCR_ONNX=$ONNX_TYPE ..
cmake --build . --config $BUILD_TYPE -j $NUM_THREADS
cmake --build . --config $BUILD_TYPE --target install
popd
