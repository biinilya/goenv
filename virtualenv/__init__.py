import os
import sys
import subprocess

env_pass = """
LD_LIBRARY_PATH
DYLD_LIBRARY_PATH
PKG_CONFIG_PATH
PATH
GOEXTRA
""".split()

goenv_path = os.path.join(os.path.dirname(__file__))

def process():
    shell = goenv_path + "/goenv.sh"
    shell_env = {
        'GOENV_ROOT': goenv_path,
        'GOENV_DIR': os.environ.get('VIRTUAL_ENV', os.environ['PWD']),
        'GOENV_CONTRIB': goenv_path + "/data/Godeps/_workspace",
        'GVM_ROOT': goenv_path + "/data/gvm-1.0.22",
    }
    shell_env.update({
        n: os.environ[n] for n in env_pass if n in os.environ
    })

    p = subprocess.Popen([shell]+sys.argv[1:], env=shell_env)
    sys.exit(p.wait())
