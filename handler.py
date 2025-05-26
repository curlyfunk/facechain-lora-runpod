import runpod
import subprocess
import os

def handler(event):
    input_data = event.get("input", {})

    dataset_dir = input_data.get("dataset_dir", "/runpod-volume/dataset1")
    output_dir = input_data.get("output_dir", "/runpod-volume/output/lora1")
    resolution = input_data.get("resolution", "512")
    steps = input_data.get("steps", 100)
    name = input_data.get("name", "custom-lora")

    train_cmd = [
        "python3", "train.py",
        "--pretrained_model_name_or_path=SG161222/Realistic_Vision_V5.1_noVAE",
        f"--train_data_dir={dataset_dir}",
        f"--output_dir={output_dir}",
        f"--resolution={resolution}",
        f"--num_train_epochs=1",
        f"--max_train_steps={steps}",
        f"--train_batch_size=1",
        "--learning_rate=1e-4",
        "--lr_scheduler=constant",
        "--lr_warmup_steps=0",
        "--logging_dir=logs",
        "--mixed_precision=fp16",
        "--save_model_as=safetensors",
        "--save_steps=999999",  # няма да сейвва по време на training
        f"--lora_rank=4",
        "--use_lora",
        f"--output_name={name}"
    ]

    os.makedirs(output_dir, exist_ok=True)

    try:
        subprocess.run(train_cmd, check=True)
        return {"status": "training_complete", "output_dir": output_dir}
    except subprocess.CalledProcessError as e:
        return {"error": str(e), "exit_code": e.returncode}

runpod.serverless.start({"handler": handler})
