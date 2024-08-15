# whisper-onnxruntime-web-test
A repository that provides an environment for generating WASM binaries for onnxruntime-web and a demo environment for running the demo in a browser. Everything is done in Docker. This is a repository for reviewing the work steps required to convert ONNX to WASM and run it in a browser.

## Usage

```bash
################################### selective
docker pull pinto0309/whisper-onnxruntime-web-builder:latest

or

docker build -t pinto0309/whisper-onnxruntime-web-builder:latest .
################################### selective

docker run --rm -it \
--net host \
-v `pwd`:/workdir \
pinto0309/whisper-onnxruntime-web-builder:latest
```

```bash
cd js/ort-whisper/Olive/examples/whisper

# English only
python prepare_whisper_configs.py \
--model_name openai/whisper-tiny.en \
--no_audio_decoder

olive run \
--config whisper_cpu_int8.json \
--setup

olive run \
--config whisper_cpu_int8.json

cp models/*/whisper_cpu_int8_cpu-cpu_model.onnx /onnxruntime-inference-examples/js/ort-whisper/whisper_cpu_int8_0_model.onnx
cd /onnxruntime-inference-examples/js/ort-whisper
cp whisper_cpu_int8_0_model.onnx /workdir

ls -lh

total 75M
drwxr-xr-x 1 user user 4.0K Aug 15 11:13 Olive
-rw-r--r-- 1 user user 1.5K Aug 15 11:12 README.md
drwxr-xr-x 1 user user 4.0K Aug 15 11:12 dist
-rw-r--r-- 1 user user 2.9K Aug 15 11:12 index.html
-rw-r--r-- 1 user user 8.4K Aug 15 11:12 main.js
drwxr-xr-x 1 user user  12K Aug 15 11:14 node_modules
-rw-r--r-- 1 user user 231K Aug 15 11:14 package-lock.json
-rw-r--r-- 1 user user  532 Aug 15 11:14 package.json
-rw-r--r-- 1 user user  737 Aug 15 11:12 webpack.config.js
-rw-r--r-- 1 user user  74M Aug 15 11:19 whisper_cpu_int8_0_model.onnx

npx light-server -s . -p 8888
```

Start a browser on the host PC and access `http://localhost:8888` to display the speech recognition demo screen.

https://github.com/user-attachments/assets/623df3dd-fc8f-4ae2-ad15-318440ec47fa

## References
1. https://github.com/microsoft/onnxruntime-inference-examples/tree/main/js/ort-whisper
2. https://github.com/PINTO0309/onnxruntime-inference-examples
3. https://github.com/microsoft/onnxruntime-inference-examples/issues/374
4. https://github.com/microsoft/Olive/tree/main/examples/whisper

## TODO
- [ ] Multilingual https://github.com/microsoft/Olive/tree/main/examples/whisper#prepare-workflow-config-json
