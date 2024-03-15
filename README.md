# Run multiple instances ComfyUI using Docker

```

./scripts/download.sh base
./scripts/download.sh comfyui
docker compose --profile builder build
docker compose --profile comfyui up
```