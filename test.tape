global {
  data=(DataSet:
    a="/export/c11/shuoyangd/projects/ducttape_test/1"
    b="/export/c11/shuoyangd/projects/ducttape_test/2"
    c="/export/c11/shuoyangd/projects/ducttape_test/3"
  ) 
}

task merge
  < in=$data[DataSet:*]
  > out {

  for datum in $in ; do
    cat $datum >> out
  done
}

# COMMANDS: the bash commands from some task
# TASK, REALIZATION, CONFIGURATION: variables passed by ducttape
submitter shell :: COMMANDS TASK_VARIABLES {
  action run {
    wrapper="ducttape_job.sh"
    echo "set -o pipefail # stop on pipeline errors" >> $wrapper
    echo "set -x # show each command as it is executed" >> $wrapper
    echo "$TASK_VARIABLES" >> $wrapper

    # The current working directory will also be changed by most schedulers
    echo "cd $PWD" >> $wrapper

    echo "$COMMANDS" >> $wrapper

    # Use SGE's -sync option to prevent qsub from immediately returning
    bash $wrapper
  }
}

plan test {
  reach merge via (DataSet: a b)
}
