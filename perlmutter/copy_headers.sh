#!/bin/bash

cp $(find . -name pdc_client_connect.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name pdc_client_server_common.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name pdc_private.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name pdc_analysis_and_transforms_common.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name pdc_transforms_pkg.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name pdc_timing.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name pdc_server_region_transfer_metadata_query.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name pdc_server_region_transfer.h | head -n 1) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name dart_core.h | head -n 1) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name dart_utils.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name dart_algo.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name dart_math.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name thpool.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name string_utils.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name query_utils.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name comparators.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name pdc_set.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name pdc_compare.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
cp $(find . -name pdc_hash.h) /pscratch/sd/n/nlewi26/src/work_space/install/pdc/include
