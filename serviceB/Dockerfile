# Use the official Python image as base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Python file into the container
COPY serviceB.py .


# Command to run the Python application
CMD ["python", "serviceB.py"]
