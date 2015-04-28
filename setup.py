import os
from distutils import log # needed for outputting information messages 
import re
from setuptools import setup
from setuptools.command.install import install

class OverrideInstall(install):

    def run(self):
        install.run(self)

        dir_to_handle = set()
        script_to_handle = set()
        file_to_handle = set()
        for filepath in self.get_outputs():
          dir_to_handle.add(os.path.dirname(filepath))

          if re.search(".sh$", filepath):
            script_to_handle.add(filepath)
            continue
          if re.search("[bin|scripts]/[^/]+$", filepath):
            script_to_handle.add(filepath)
            continue

          file_to_handle.add(filepath)
        
        for d in file_to_handle:
          os.chmod(d, 0666)        

        for d in dir_to_handle:
          os.chmod(d, 0777)

        for d in script_to_handle:
          os.chmod(d, 0777)

files = \
[
  t.replace('goenv/', '') for t in reduce(
    lambda a, b: a+b, [
      map(lambda y: x[0]+'/'+y, x[2]) \
      for x in os.walk('goenv/data')
    ]
  )
] + [
  'goenv.sh'
]


setup(
  name='goenv',
  version='0.0.13',
  description='Golang environment manager',
  url='https://github.com/biinilya/goenv',
  author='Ilya Biin',
  author_email='me@ilyabiin.com',
  packages=['goenv'],
  scripts=['goenv/goenv'],
  package_data={'goenv': files},
  cmdclass={'install': OverrideInstall},
  entry_points={
    'virtualenvwrapper.post_deactivate_source': [
      'gopath = goenv.gopath:deactivate',
    ],
    'virtualenvwrapper.post_activate_source': [
      'gopath = goenv.gopath:activate',
    ],
    'virtualenvwrapper.pre_activate': [
      'gopath = goenv.gopath:pre_activate',
    ],
    },
)
