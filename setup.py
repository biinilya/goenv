import os
from setuptools import setup

files = \
[
  t.replace('goenv/', '') for t in reduce(
    lambda a, b: a+b, [
      map(lambda y: x[0]+'/'+y, x[2]) \
      for x in os.walk('goenv/data')
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
  packages=['goenv'],
  scripts=['goenv/goenv'],
  package_data={'goenv': files},
)
