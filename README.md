# Run multiple instances ComfyUI using Docker

Note: only tested in linux with nvidia gpu

Simple usage:

``` bash
./scripts/download.sh ./build/base
./scripts/download.sh ./build/comfyui
docker compose --profile builder build
docker compose --profile comfyui up
```

Support profiles:

* comfyui: common profile for basic workflow
* ootd: [OOTDiffusion](https://github.com/AuroBit/ComfyUI-OOTDiffusion)
* 3dpack: [ComfyUI-3D-Pack](https://github.com/MrForExample/ComfyUI-3D-Pack)
* flowty: [ComfyUI-Flowty-CRM](https://github.com/flowtyone/ComfyUI-Flowty-CRM)