# OS X Setup Conda Environment pyspark3

#### conda_setup

```
function conda_setup() {
  # NOTE: this is is for anaconda / conda
  export PATH="$HOME/anaconda/bin:$PATH"
  eval "$(register-python-argcomplete conda)"
  alias conda-workon='source activate '
  alias wo_tensorflow3='source activate tensorflow3'
  alias find_tensorflow3_models="python -c 'import os; import inspect; import tensorflow; print(os.path.dirname(inspect.getfile(tensorflow)))'"
  export USING_CONDA='conda'
  #
  # To activate this environment, use:
  # $ source activate snakes
  #
  # To deactivate this environment, use:
  # $ source deactivate
  #

  echo '[conda_setup]'
  echo ' [initalizing anaconda environment ... ]'
  echo ' [run] export PATH="$HOME/anaconda/bin:$PATH"'
  echo ' [run] eval "$(register-python-argcomplete conda)"'
  echo " [run] alias conda-workon='source activate '"
  echo " [run] alias wo_tensorflow3='source activate tensorflow3'"
  echo " [run] export USING_CONDA='conda'"
  echo " [info] To activate virtualenv run: source activate snakes"
  echo " [info] To de-activate virtualenv run: source deactivate"
  echo " [info] To update conda run: conda update conda"
  echo " [info] To create new conda virtualenv run: conda create -n pyspark2 python=2.7"

}

```

#### activate_pyspark3
```
function activate_pyspark3 {
  echo ' [start] Activating pyspark3 conda virtualenv and setting paths to spark'
  echo ' [run] conda_setup'
  echo ' [run] source activate pyspark3'
  echo ' [run] export SPARK_HOME=/usr/local/Cellar/apache-spark/2.2.0/libexec'
  echo ' [run] export PYSPARK_PYTHON=$HOME/anaconda/envs/pyspark3/bin/python'
  echo ' [run] export HADOOP_HOME=/usr/local/Cellar/hadoop/2.8.1/libexec'
  echo ' [run] export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH'

  conda_setup && \
  source activate pyspark3 && \
  export SPARK_HOME=/usr/local/Cellar/apache-spark/2.2.0/libexec && \
  export PYSPARK_PYTHON=$HOME/anaconda/envs/pyspark3/bin/python && \
  export HADOOP_HOME=/usr/local/Cellar/hadoop/2.8.1/libexec && \
  export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH && \
  echo ' [run] Verify everything works: ipython -c "import pyspark"' && \
  export PYSPARK_PYTHON=$(which python) && \
  echo " [show] SPARK_HOME=${SPARK_HOME}" && \
  echo " [show] PYSPARK_PYTHON=${PYSPARK_PYTHON}" && \
  echo " [show] HADOOP_HOME=${HADOOP_HOME}" && \
  echo " [show] LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" && \
  echo " [show] PYSPARK_PYTHON=${PYSPARK_PYTHON}" && \
  python -c 'import pyspark' && \
  RET_VAL=$(echo $?) && \
  echo " [run] Return code is: ${RET_VAL}"
}
```

#### conda env setup
```
conda_setup

conda create -n pyspark3 python=3

source activate pyspark3

conda install -y numpy pandas pip setuptools
conda install -c conda-forge pyspark
conda install -y py4j
pip install pdbpp gnureadline pydocstyle autopep8 pylint coverage flake8
```
