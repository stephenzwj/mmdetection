#!/bin/bash

# Set default value for device_count if it is not provided
device_count=''

# Parse command-line arguments using getopts
while getopts ":d:" opt; do
  case $opt in
    d) device_count="$OPTARG";;
    \?) echo "Invalid option -$OPTARG" >&2;;
  esac
done
batch_size_per_device=16
# Check if device_count is a number
if [[ $device_count =~ ^[0-9]+$ ]]; then
  # Generate the string
  string=""
  for ((i=0;i<$device_count;i++)); do
    string="$string,$i"
  done

  # get the string
  devices="${string:1}"
  batch_size=$(($batch_size_per_device*$device_count))
else
  # Set devices to device_count
  devices="$device_count"
  batch_size=batch_size_per_device
fi

echo "Running with devices $devices and batch_size $batch_size"
model_name="retinanet_R_50_FPN_3x"
python tools/train.py configs/IDID/mask_rcnn_r50_caffe_fpn_mstrain-poly_1x_IDID.py
