#!/bin/bash
# usage: run_mrpc.sh <code_dir> <out_dir> [extra args...]
CODE=$1; OUT=$2; shift 2
export WANDB_MODE=offline
cd $CODE
mkdir -p $OUT
python ./run_glue_lora.py \
  --model_name_or_path FacebookAI/roberta-base --task_name mrpc \
  --do_train --do_eval --max_seq_length 256 \
  --per_device_train_batch_size 128 --per_device_eval_batch_size 128 \
  --load_best_model_at_end True --metric_for_best_model accuracy \
  --learning_rate 4e-4 --num_train_epochs 30 \
  --evaluation_strategy epoch --save_strategy epoch \
  --weight_decay 0.1 --warmup_ratio 0.06 --logging_steps 10 \
  --seed 42 --wandb_project project_name \
  --lora_alpha 16 --lora_dropout 0.05 --lora_bias none \
  --lora_task_type SEQ_CLS --target_modules query value --rank 8 \
  --l_num 2 --mode me \
  --output_dir $OUT/model --logging_dir $OUT/log \
  --run_name roberta-lora-me-mrpc-r-8-n-2-alpha-16-seed-42-bs-128-lr-4e-4-epochs-30 \
  --overwrite_output_dir "$@"
