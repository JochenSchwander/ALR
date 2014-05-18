################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../src/factorization.cu \
../src/gpu_factorization.cu \
../src/main.cu \
../src/rsacalculation.cu 

CU_DEPS += \
./src/factorization.d \
./src/gpu_factorization.d \
./src/main.d \
./src/rsacalculation.d 

OBJS += \
./src/factorization.o \
./src/gpu_factorization.o \
./src/main.o \
./src/rsacalculation.o 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/Developer/NVIDIA/CUDA-5.5/bin/nvcc -G -g -O0 -gencode arch=compute_30,code=sm_30 -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	/Developer/NVIDIA/CUDA-5.5/bin/nvcc --compile -G -O0 -g -gencode arch=compute_30,code=compute_30 -gencode arch=compute_30,code=sm_30  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


