import base64
import os
import random
import subprocess


def pre_activate(*args):
  subprocess.call(
    "umask 0000;export -p|grep -vE 'ge_|PWD'>/tmp/venv.sh",
    shell=True,
  )


def activate(*args):
  rndfile = "/tmp/0.%d" % random.randint(1, 1e8)
  env = subprocess.check_output("goenv activate", shell=True)
  return """
cp /tmp/venv.sh {rndfile}
export RNDFILE={rndfile}
""".format(rndfile=rndfile) + env


def deactivate(*args):
  return """
for p in $GOENV_UPDATED;do unset $p; done
. $RNDFILE
"""
