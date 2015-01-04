import os
import sys
import subprocess

goenv_path = os.path.join(os.path.dirname(__file__))

def process():
    shell = goenv_path + "/goenv.sh"
    shell_env = dict()

    shell_env.update(os.environ)
    shell_env.update({
        'GOENV_ROOT': goenv_path,
        'GOENV_DIR': goenv_path + "/data",
        'GOENV_CONTRIB': goenv_path + "/data/Godeps/_workspace",
        'GVM_ROOT': goenv_path + "/data/gvm-1.0.22",
    })

    p = subprocess.Popen([shell]+sys.argv[1:], env=shell_env)
    sys.exit(p.wait())
