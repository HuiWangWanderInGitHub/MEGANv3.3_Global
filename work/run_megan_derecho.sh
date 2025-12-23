#!/bin/bash
#e.g., ./run_megan_derecho.sh 2012 
# ==== input field ====
YEAR=$1
if [ -z "$YEAR" ]; then
  echo "Usage: $0 <year>"
  exit 1
fi

# ==== month loop ====
for m in $(seq -w 1 12); do

  # start time
  start="${YEAR}-${m}-01 00:00:00"

  # end time
  end_day=$(date -d "${YEAR}-${m}-01 +1 month -1 day" +'%d')
  end="${YEAR}-${m}-${end_day} 23:00:00"

  # create namelist_XX
  sed -e "s/__START__/${start}/" -e "s/__END__/${end}/" namelist.template > namelist_${m}

  # create running directory
  rundir="run_${YEAR}_${m}"
  mkdir -p ${rundir}
  cp namelist_${m} ${rundir}/namelist
  cp megan_v3.3.exe ${rundir}/
  cp co2_mm_gl.csv ${rundir}/ 
  
  # generate PBS scripts
  cat > ${rundir}/submit_job.pbs <<EOF
#!/bin/bash -l
#PBS -N MEGAN_${YEAR}_${m}
#PBS -A UCIR0060
#PBS -l select=1:ncpus=2:mpiprocs=2:mem=128g
#PBS -l walltime=12:00:00
#PBS -q main
#PBS -j oe

cd \$PBS_O_WORKDIR
time mpirun -n 2 ./megan_v3.3.exe < namelist
EOF

  # submit task
  cd ${rundir}
  qsub submit_job.pbs
  cd ..
  rm namelist_${m}
done

