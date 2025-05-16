# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
ARG GDRCOPY_VERSION=v2.4.1
ARG EFA_INSTALLER_VERSION=1.37.0
ARG AWS_OFI_NCCL_VERSION=v1.13.2-aws
ARG NCCL_VERSION=v2.23.4-1
ARG NCCL_TESTS_VERSION=v2.13.10
ARG NVSHMEM_VERSION=3.2.5-1

FROM nvshmem:efa${EFA_INSTALLER_VERSION}-ofi${AWS_OFI_NCCL_VERSION}-nccl${NCCL_VERSION}-tests${NCCL_TESTS_VERSION}-nvshmem${NVSHMEM_VERSION}

# Install Miniconda to not depend on the base image python
RUN mkdir -p /opt/miniconda3 \
    && curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/Miniconda3-latest-Linux-x86_64.sh \
    && bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -f -p /opt/miniconda3 \
    && rm /tmp/Miniconda3-latest-Linux-x86_64.sh \
    && /opt/miniconda3/bin/conda init bash

ENV PATH="/opt/miniconda3/bin:${PATH}"

RUN pip install torch ninja numpy cmake pytest

RUN git clone https://github.com/deepseek-ai/DeepEP.git /deepep && cd /deepep \
    && pip install -e .