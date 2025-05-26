import runpod

def handler(event):
    print(">>> Получена заявка:", event)
    return {"message": "FaceChain LoRA endpoint работи!"}

runpod.serverless.start({"handler": handler})
