#!/usr/bin/env python

from distutils.core import setup
from distutils.extension import Extension
import os.path

from Cython.Build import cythonize
from Cython.Distutils import build_ext
import numpy as np


current_dir = os.path.dirname(os.path.abspath(__file__))
c_src_dir = os.path.join(current_dir, 'src')


def main():

    ext_modules = [

        Extension("lz4.lz4",
                  sources=["lz4/lz4.pyx", os.path.join(c_src_dir, 'lz4.c')],
                  include_dirs=[np.get_include(), c_src_dir],
                  define_macros=[],
                  extra_link_args=[],
                  extra_compile_args=['-mssse3', '-std=c99']),

        Extension("lz4.shuffle",
                  sources=["lz4/shuffle.pyx"],
                  include_dirs=[np.get_include()],
                  define_macros=[],
                  extra_link_args=[],
                  extra_compile_args=['-mssse3', '-std=c99']),

                  ]

    kwargs = dict(
        name = 'lz4',
        packages = ['lz4'],
        cmdclass = {'build_ext': build_ext},
        ext_modules = cythonize(ext_modules),
        )

    setup(**kwargs)


if __name__ == '__main__':
    main()

# from setuptools import setup, find_packages, Extension
#
# VERSION = (0, 6, 0)
#
# setup(
#     name='lz4',
#     version=".".join([str(x) for x in VERSION]),
#     description="LZ4 Bindings for Python",
#     long_description=open('README.rst', 'r').read(),
#     author='Steeve Morin',
#     author_email='steeve.morin@gmail.com',
#     url='https://github.com/steeve/python-lz4',
#     packages=find_packages('src'),
#     package_dir={'': 'src'},
#     ext_modules=[
#         Extension('lz4', [
#             'src/lz4.c',
#             'src/lz4hc.c',
#             'src/python-lz4.c'
#         ], extra_compile_args=["-O4"])
#     ],
# )
