import os
from setuptools import setup

files = \
[
  t.replace('virtualenv/', '') for t in reduce(
    lambda a, b: a+b, [
      map(lambda y: x[0]+'/'+y, x[2]) \
      for x in os.walk('virtualenv/data')
    ]
  )
]


setup(
  name='goenv',
  version='0.0.1',
  description='Golang environment manager',
  url='https://github.com/biinilya/goenv',
  author='Ilya Biin',
  author_email='me@ilyabiin.com',
  packages=['virtualenv'],
  scripts=['virtualenv/goenv'],
  package_data={'virtualenv': files},
)
