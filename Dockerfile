FROM runpod/worker-comfyui:5.1.0-base

# 2. Install git, required for cloning some custom nodes.
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# 3. Create all necessary model directories.
RUN mkdir -p \
    /comfyui/models/checkpoints/FLUX1 \
    /comfyui/models/upscale_models

# 5. Download all the large, slow models first to leverage Docker caching.

# --- Checkpoints ---
RUN comfy model download --url "https://huggingface.co/singhal4896/lily_lora/resolve/main/flux1-dev-fp8.safetensors?download=true" --relative-path models/checkpoints/FLUX1 --filename "flux1-dev.sft"

# --- Upscale Models ---
RUN wget -O "/comfyui/models/upscale_models/4x-ClearRealityV1.pth" "https://huggingface.co/skbhadra/ClearRealityV1/resolve/main/4x-ClearRealityV1.pth?download=true" 
RUN wget -O "/comfyui/models/upscale_models/4x-UltraSharp.pth" "https://huggingface.co/lokCX/4x-Ultrasharp/resolve/main/4x-UltraSharp.pth?download=true"
RUN wget -O "/comfyui/models/upscale_models/4xFaceUpDAT.safetensors" "https://huggingface.co/Phips/4xFaceUpDAT/resolve/main/4xFaceUpDAT.safetensors?download=true"
RUN wget -O "/comfyui/models/upscale_models/RealESRGAN_x4.pth" "https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth?download=true"


# 7. Install Custom Nodes LAST for maximum cache efficiency.
RUN comfy-node-install \
    rgthree-comfy \
    comfyui_ultimatesdupscale \
    was-node-suite-comfyui \
    comfyui-florence2 \
    comfyui-impact-pack \
    comfyui-custom-scripts \
    cg-use-everywhere