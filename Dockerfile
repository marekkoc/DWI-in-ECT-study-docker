# Dockerfile img-inv
FROM continuumio/miniconda3

# build using:
#    docker build  --build-arg conda_env="test" -t img-inv .

# run with (in current folder):
#    docker run --rm -it -v $(pwd)/input:/input -v $(pwd)/output:/output img-inv

# run and enter to the container
# docker run --rm -it --entrypoint bash -v $(pwd)/input:/input -v $(pwd)/output:/output img-inv

# Set value to the name of your conda environment in requirements.yml.
# Optional: provide it to docker build as a variable
#    --build-arg conda_env="workflow_ai_test"
#ARG conda_env=workflow_ai_test

ARG conda_env
ENV DEFAULT_CONDA_ENV=$conda_env

# System update and installation needed tools
RUN apt-get update && apt-get install -y \
    imagemagick dcm2niix file
    
# get a newer version of FSL using fslinstaller.py --downloadonly ...
COPY fsl/fslinstaller.py fsl/fsl-6.0.5.2-install.tar.gz /install/

RUN conda create --name "$conda_env" python=2.7
RUN sed -i 's/conda activate/conda activate '$conda_env'/g' /root/.bashrc

SHELL ["/bin/bash", "--login", "-c"]
RUN python /install/fslinstaller.py -f /install/fsl-6.0.5.2-install.tar.gz -M -q -d /usr/local/fsl

ENV FSLDIR=/usr/local/fsl
RUN echo "source /usr/local/fsl/etc/fslconf/fsl.sh" >> /root/.bashrc
ENV PATH="$PATH:/usr/local/fsl/bin"

WORKDIR /app
# all our source code should be in process.sh
COPY process.sh /app/
COPY b02b0_edit.cnf /app/
COPY bvals /app/
COPY bvecs /app/
COPY index.txt /app/
COPY bvals1000 /app/

# The code to run when container is started:
RUN ["chmod", "+x", "/app/process.sh"]
ENTRYPOINT [ "/app/process.sh" ]

