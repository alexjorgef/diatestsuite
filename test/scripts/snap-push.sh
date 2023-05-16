#!/bin/bash

# Set your Docker image name and tag
IMAGE_NAME="your_username/your_image_name"
IMAGE_TAG="latest"

# Log in to Docker Hub
docker login

# Push the Docker image
docker push $IMAGE_NAME:$IMAGE_TAG

echo "Docker image pushed to Docker Hub successfully."