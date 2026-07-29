FROM python:3.13.1
# Working directory in the container
WORKDIR /whatever
# Requirements first! for cache performance
COPY requirements.txt .
RUN pip install -r requirements.txt
# Then the source code
COPY pyfreeradius/ ./pyfreeradius/
COPY settings.py .
COPY database.py .
COPY dependencies.py .
COPY api.py .
