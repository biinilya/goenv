import os
from setuptools import setup

# Utility function to read the README file.
# Used for the long_description.  It's nice, because now 1) we have a top level
# README file and 2) it's easier to type in the README file than to put a raw
# string in below ...
def read(fname):
  return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(
  name='goenv',
  version='0.0.1',
  description='Golang environment manager',
  url='https://github.com/termie/govenv',
  packages=['govenv'],
  author='Andy Smith',
  author_email='github@anarkystic.com',
  entry_points={
    'virtualenvwrapper.post_mkvirtualenv_source': [
      'gopath = govenv.gopath:post_mkvirtualenv_source',
      ],
    'virtualenvwrapper.post_activate_source': [
      'gopath = govenv.gopath:post_activate_source',
      ],
    'virtualenvwrapper.post_deactivate_source': [
      'gopath = govenv.gopath:post_deactivate_source',
      ],
    },
  )