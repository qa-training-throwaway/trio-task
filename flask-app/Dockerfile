# Use Python 3.6 or later as a base image
FROM python:3.7
# Copy contents into image
WORKDIR /app
COPY app.py .
COPY templates/ templates/.
COPY requirements.txt .

# Install pip dependencies from requirements
RUN pip install -r requirements.txt

# Set YOUR_NAME environment variable
ENV YOUR_NAME=Shivam

# Expose the correct port
EXPOSE 5000

# Create an entrypoint
ENTRYPOINT ["python", "app.py"]