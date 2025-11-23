FROM python:3.13.1
# Working directory in the container
WORKDIR /whatever
# Requirements first! for cache performance
COPY api/requirements.txt .
RUN pip install -r requirements.txt
# Then the source code
COPY api/pyfreeradius/ ./pyfreeradius/
COPY api/settings.py .
COPY api/database.py .
COPY api/dependencies.py .
COPY api/api.py .
