#!/usr/bin/env bash
source onnxruntime/cmake/external/emsdk/emsdk_env.sh

sysOS=$(uname -s)
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

EXE_PATH=${sysOS}-WASM-BIN
cd $EXE_PATH
EXE_PATH=

TARGET_IMG=images/1.jpg

##### run test on MacOS or Linux
echo ${EXE_PATH}

node "./${EXE_PATH}/RapidOcrOnnx.js" --models models \
    --det ch_PP-OCRv3_det_infer.onnx \
    --cls ch_ppocr_mobile_v2.0_cls_infer.onnx \
    --rec ch_PP-OCRv3_rec_infer.onnx \
    --keys ppocr_keys_v1.txt \
    --image $TARGET_IMG \
    --padding 50 \
    --maxSideLen 1024 \
    --boxScoreThresh 0.5 \
    --boxThresh 0.3 \
    --unClipRatio 1.6 \
    --doAngle 1 \
    --mostAngle 1 \
    -t 8 \
    -G -1

# ["--models", "models", "--det", "ch_PP-OCRv3_det_infer.onnx", "--cls", "ch_ppocr_mobile_v2.0_cls_infer.onnx", "--rec", "ch_PP-OCRv3_rec_infer.onnx", "--keys", "ppocr_keys_v1.txt", "--image", "images/1.jpg", "--padding", "50", "--maxSideLen", "1024", "--boxScoreThresh", "0.5", "--boxThresh", "0.3", "--unClipRatio", "1.6", "--doAngle", "1", "--mostAngle", "1", "-t", "8", "-G", "-1"]

