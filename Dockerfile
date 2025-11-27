# Use the required Jupyter minimal-notebook base image
FROM quay.io/jupyter/minimal-notebook:afe30f0c9ad8

# sets the default working directory
# this is also specified in the compose file
WORKDIR /workplace

# Copy the environment lock file into a temporary location
# This lock file contains the explicit list of packages and their dependencies
COPY conda-linux-64.lock /tmp/conda-linux-64.lock

# 1. Install the 'conda-lock' utility into the base environment.
RUN conda install -n base -c conda-forge conda-lock -y
# 2. Use the 'conda-lock' tool to create the new, isolated environment named '522-ia2'.
RUN conda-lock install -n 522-ia2 /tmp/conda-linux-64.lock
# 3. Install the Jupyter kernel into the new environment
# This allows the JupyterLab server to see and use the new environment.
RUN /opt/conda/envs/522-ia2/bin/python -m ipykernel install --user --name 522-ia2

# Expose JupyterLab port
EXPOSE 8888

# Set the CMD to run JupyterLab using the new '522-ia2' environment.
CMD ["conda", "run", "--no-capture-output", "-n", "522-ia2", "jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]