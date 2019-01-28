global {
  data=(DataSet:
    a="1"
    b="2"
    c="3"
  ) 
}

task merge
  < in=$data[DataSet:*]
  > out {

  for datum in $in ; do
    cat $datum >> out
  done
}

task check
  < in=$out@merge
  > out {

  if [[ -f $in ]] ; then
    echo `wc -l $in`
    echo "checked" >> $out
  fi
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
  reach check via (DataSet: a b)
}
