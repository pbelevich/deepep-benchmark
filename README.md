# DeepEP Benchmark
https://github.com/deepseek-ai/DeepEP

## Building NCCL Tests Docker image

```bash
GDRCOPY_VERSION=v2.4.4
EFA_INSTALLER_VERSION=1.38.1
AWS_OFI_NCCL_VERSION=v1.14.0
NCCL_VERSION=v2.26.2-1
NCCL_TESTS_VERSION=v2.14.1
TAG="efa${EFA_INSTALLER_VERSION}-ofi${AWS_OFI_NCCL_VERSION}-nccl${NCCL_VERSION}-tests${NCCL_TESTS_VERSION}"
NCCL_CONTAINER_IMAGE_NAME_TAG="nccl-tests:${TAG}"
```

```bash
docker build --progress=plain -f ../nccl-tests/nccl-tests.Dockerfile \
       --build-arg="EFA_INSTALLER_VERSION=${EFA_INSTALLER_VERSION}" \
       --build-arg="AWS_OFI_NCCL_VERSION=${AWS_OFI_NCCL_VERSION}" \
       --build-arg="NCCL_VERSION=${NCCL_VERSION}" \
       --build-arg="NCCL_TESTS_VERSION=${NCCL_TESTS_VERSION}" \
       -t ${NCCL_CONTAINER_IMAGE_NAME_TAG} \
       .
```

### Building NVSHMEM Docker image on top of NCCL Tests Docker base image
https://github.com/aws-samples/awsome-distributed-training/tree/main/micro-benchmarks/nvshmem

```bash
NVSHMEM_VERSION=3.2.5-1
TAG="efa${EFA_INSTALLER_VERSION}-ofi${AWS_OFI_NCCL_VERSION}-nccl${NCCL_VERSION}-tests${NCCL_TESTS_VERSION}-nvshmem${NVSHMEM_VERSION}"
NVSHMEM_CONTAINER_IMAGE_NAME_TAG="nvshmem:${TAG}"
```

```bash
docker build --progress=plain -f ../nvshmem/nvshmem.Dockerfile \
       --build-arg="EFA_INSTALLER_VERSION=${EFA_INSTALLER_VERSION}" \
       --build-arg="AWS_OFI_NCCL_VERSION=${AWS_OFI_NCCL_VERSION}" \
       --build-arg="NCCL_VERSION=${NCCL_VERSION}" \
       --build-arg="NCCL_TESTS_VERSION=${NCCL_TESTS_VERSION}" \
       --build-arg="NVSHMEM_VERSION=${NVSHMEM_VERSION}" \
       -t ${NVSHMEM_CONTAINER_IMAGE_NAME_TAG} \
       .
```

## Building DeepEP Docker image on top of NVSHMEM Docker image

```bash
TAG="efa${EFA_INSTALLER_VERSION}-ofi${AWS_OFI_NCCL_VERSION}-nccl${NCCL_VERSION}-tests${NCCL_TESTS_VERSION}-nvshmem${NVSHMEM_VERSION}"
DEEPEP_CONTAINER_IMAGE_NAME_TAG="deepep:${TAG}"
```

```bash
docker build --progress=plain -f ./deepep.Dockerfile \
       --build-arg="EFA_INSTALLER_VERSION=${EFA_INSTALLER_VERSION}" \
       --build-arg="AWS_OFI_NCCL_VERSION=${AWS_OFI_NCCL_VERSION}" \
       --build-arg="NCCL_VERSION=${NCCL_VERSION}" \
       --build-arg="NCCL_TESTS_VERSION=${NCCL_TESTS_VERSION}" \
       --build-arg="NVSHMEM_VERSION=${NVSHMEM_VERSION}" \
       -t ${DEEPEP_CONTAINER_IMAGE_NAME_TAG} \
       .
```

```bash
enroot import -o ./deepep.sqsh dockerd://${DEEPEP_CONTAINER_IMAGE_NAME_TAG}
```

## Running DeepEP Benchmark

```bash
srun --mpi=pmix --cpu-bind=none --container-image ./deepep.sqsh python /deepep/tests/test_intranode.py
```

## P5en results
```
[config] num_tokens=4096, hidden=7168, num_topk=8
[layout] Kernel performance: 0.050 ms

[testing] Running with BF16, without top-k (async=False, previous=False) ... passed
[testing] Running with BF16, with top-k (async=False, previous=False) ... passed
[testing] Running with BF16, without top-k (async=False, previous=False) ... passed
[testing] Running with BF16, with top-k (async=False, previous=False) ... passed
[testing] Running with FP8, without top-k (async=False, previous=False) ... passed
[testing] Running with FP8, with top-k (async=False, previous=False) ... passed
[testing] Running with BF16, without top-k (async=True, previous=False) ... passed
[testing] Running with BF16, with top-k (async=True, previous=False) ... passed
[testing] Running with BF16, without top-k (async=True, previous=False) ... passed
[testing] Running with BF16, with top-k (async=True, previous=False) ... passed
[testing] Running with FP8, without top-k (async=True, previous=False) ... passed
[testing] Running with FP8, with top-k (async=True, previous=False) ... passed
[testing] Running with BF16, without top-k (async=False, previous=True) ... passed
[testing] Running with BF16, with top-k (async=False, previous=True) ... passed
[testing] Running with BF16, without top-k (async=False, previous=True) ... passed
[testing] Running with BF16, with top-k (async=False, previous=True) ... passed
[testing] Running with FP8, without top-k (async=False, previous=True) ... passed
[testing] Running with FP8, with top-k (async=False, previous=True) ... passed
[testing] Running with BF16, without top-k (async=True, previous=True) ... passed
[testing] Running with BF16, with top-k (async=True, previous=True) ... passed
[testing] Running with BF16, without top-k (async=True, previous=True) ... passed
[testing] Running with BF16, with top-k (async=True, previous=True) ... passed
[testing] Running with FP8, without top-k (async=True, previous=True) ... passed
[testing] Running with FP8, with top-k (async=True, previous=True) ... passed

[tuning] SMs 24, NVL chunk 4: 317.45 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 8: 328.17 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 12: 298.24 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 16: 290.69 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 20: 288.97 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 24: 291.55 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 28: 289.31 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 32: 288.73 GB/s (NVL) 
[tuning] Best dispatch (FP8): SMs 24, NVL chunk 8, 328.17 GB/s (NVL)

[tuning] SMs 24, NVL chunk 4: 341.97 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 8: 312.07 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 12: 316.21 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 16: 312.57 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 20: 308.04 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 24: 305.33 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 28: 300.52 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 32: 298.59 GB/s (NVL) 
[tuning] Best dispatch (BF16): SMs 24, NVL chunk 4, 341.97 GB/s (NVL)

[tuning] SMs 24, NVL chunk 1: 162.45 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 2: 278.05 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 3: 317.37 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 4: 318.00 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 5: 312.30 GB/s (NVL) 
[tuning] SMs 24, NVL chunk 6: 298.78 GB/s (NVL) 
[tuning] Best combine: SMs 24, NVL chunk 4: 318.00 GB/s (NVL)
```