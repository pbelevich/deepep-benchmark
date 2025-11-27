# DeepEP Benchmark
https://github.com/deepseek-ai/DeepEP

## Git clone NVSHMEM

3.4.5-0:
```
git clone https://github.com/NVIDIA/nvshmem.git && cd ./nvshmem && git checkout v3.4.5-0 && cd ..
```

devel brach:
```
git clone https://github.com/NVIDIA/nvshmem.git && cd ./nvshmem && git checkout devel && cd ..
```

## Building DeepEP Docker image

```bash
GDRCOPY_VERSION=v2.5.1
EFA_INSTALLER_VERSION=1.45.0
NCCL_VERSION=v2.28.9-1
NCCL_TESTS_VERSION=v2.17.6
DEEPEP_REPO=https://github.com/deepseek-ai/DeepEP.git
DEEPEP_COMMIT=92fe2deaec24bc92ebd9de276daa6ca9ed602ed4
DEEPEP_CONTAINER_IMAGE_NAME_TAG="deepep:latest"
```

To use my dummy slow DeepEP implementation that works on EFA:
```bash
DEEPEP_REPO=https://github.com/pbelevich/DeepEP.git
DEEPEP_COMMIT=27e8e661857499068275dbaa09e4c15d67d51f81
```

```bash
docker build --progress=plain -f ./deepep.Dockerfile \
       --build-arg="EFA_INSTALLER_VERSION=${EFA_INSTALLER_VERSION}" \
       --build-arg="NCCL_VERSION=${NCCL_VERSION}" \
       --build-arg="NCCL_TESTS_VERSION=${NCCL_TESTS_VERSION}" \
       --build-arg="NVSHMEM_VERSION=${NVSHMEM_VERSION}" \
       --build-arg="DEEPEP_REPO=${DEEPEP_REPO}" \
       --build-arg="DEEPEP_COMMIT=${DEEPEP_COMMIT}" \
       -t ${DEEPEP_CONTAINER_IMAGE_NAME_TAG} \
       . 2>&1 | tee docker_build.log
```

```bash
enroot import -o ./deepep.sqsh dockerd://${DEEPEP_CONTAINER_IMAGE_NAME_TAG}
```

## Running DeepEP Benchmark

### Intranode

```bash
sbatch test_intranode.sbatch
```

### Internode

```bash
sbatch test_internode.sbatch
```

### Low Latency

```bash
sbatch test_low_latency.sbatch
```
