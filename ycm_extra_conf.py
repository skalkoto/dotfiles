# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>

import os
import ycm_core
import collections

DIRNAME = os.path.dirname(os.path.abspath(__file__))
SOURCE_EXTENSION = '.cpp'

default_flags = [
    '-Wall',
    '-Wextra',
    '-Wno-long-long',
    '-Wno-variadic-macros',
    '-fexceptions',
    '-ferror-limit=10000',
    '-DNDEBUG',
    '-std=c++14',
    '-xc++',
    '-I/usr/lib/',
    '-I/usr/include/',
    '-I/opt/ros/melodic/include',
]

all_warnings = [
    '-Weverything',
    '-Wno-c++98-compat',
    '-Wno-c++98-compat-pedantic',
    '-Wno-unused-macros',
    '-Wno-newline-eof',
    '-Wno-exit-time-destructors',
    '-Wno-global-constructors',
    '-Wno-gnu-zero-variadic-macro-arguments',
    '-Wno-documentation',
    '-Wno-shadow',
    '-Wno-switch-enum',
    '-Wno-missing-prototypes',
    '-Wno-used-but-marked-unused',
    '-Wno-covered-switch-default',
    '-Wno-undef',
    '-Wno-zero-as-null-pointer-constant',
]

extra_warnings = [
    '-Wnon-virtual-dtor',
]

CompilationInfo = collections.namedtuple(
    'CompilationInfo', ['compiler_flags_', 'compiler_working_dir_'])

# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# You can get CMake to generate this file for you by adding:
#   set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )
# to your CMakeLists.txt file.
DB_DIR = os.path.join(DIRNAME, 'build')


def GetDB(db_dir=DB_DIR):
    if os.path.exists(db_dir):
        return ycm_core.CompilationDatabase(db_dir)
    return None


def IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in ['.h', '.hxx', '.hpp', '.hh']


def GetCompilationInfoForHeader(database, filename):

    if '/devel/include/' in filename:
        workspace = filename.split('/devel/include/')[0]
        flags = default_flags + ['-I', '../devel/include']
        return CompilationInfo(flags, "%s/build" % workspace)

    basename = os.path.splitext(filename)[0]
    # find the suitable cpp file
    if '/include/' in basename:
        pre, post = basename.split('/include/')
        basename = os.path.join(pre, 'src', "/".join(post.split('/')[1:]))

    replacement_file = basename + SOURCE_EXTENSION
    if not os.path.exists(replacement_file):
        filedir = os.path.dirname(replacement_file)
        if not os.path.exists(filedir):
            return None
        src_files = [
            f for f in os.listdir(filedir) if f.endswith(SOURCE_EXTENSION)
        ]
        if src_files:
            replacement_file = os.path.join(filedir, src_files[0])
    if os.path.exists(replacement_file):
        compilation_info = database.GetCompilationInfoForFile(replacement_file)
        if compilation_info.compiler_flags_:
            return compilation_info

    return None


def GetPackage(filename):
    dirname = os.path.dirname(filename)

    f = open("/tmp/package", "w")
    dirs = dirname.split(os.sep)
    for i in range(len(dirs)):
        current = "/".join(dirs[:len(dirs) - i])
        f.write(current + "\n")
        if os.path.exists("{}{}package.xml".format(current, os.sep)):
            return os.path.basename(current)

    return ""


def GetCompilationInfoForFile(filename):
    # The compilation_commands.json file generated by CMake does not have
    # entries for header files. So we do our best by asking the db for flags
    # for a corresponding source file, if any. If one exists, the flags for
    # that file should be good enough.

    myrmex_root = os.path.dirname(DIRNAME)
    if filename.startswith(myrmex_root):
        workspace = filename.split(myrmex_root, 1)[1].split(os.sep)[1]
        pkg = GetPackage(filename)
        global_path = os.path.join(myrmex_root, workspace, 'build')
        pkg_path = os.path.join(global_path, pkg)
        if (os.path.isfile(os.path.join(global_path,
                                        'compile_commands.json'))):
            db = GetDB(global_path)
        elif (os.path.isfile(os.path.join(pkg_path, 'compile_commands.json'))):
            db = GetDB(pkg_path)
        else:
            db = GetDB()
    else:
        db = GetDB()

    if IsHeaderFile(filename):
        return GetCompilationInfoForHeader(db, filename)

    return db.GetCompilationInfoForFile(filename)


def FlagsForFile(filename, **kwargs):

    compilation_info = GetCompilationInfoForFile(filename)
    if not compilation_info:
        return None

    # Bear in mind that compilation_info.compiler_flags_ does NOT return a
    # python list, but a "list-like" StringVec object.
    final_flags = list(compilation_info.compiler_flags_)

    # NOTE: This is just for YouCompleteMe; it's highly likely that your
    # project does NOT need to remove the stdlib flag. DO NOT USE THIS IN YOUR
    # ycm_extra_conf IF YOU'RE NOT 100% SURE YOU NEED IT.
    # try:
    #     final_flags.remove('-stdlib=libc++')
    # except ValueError:
    #     pass
    final_flags.extend(extra_warnings)

    return {
        'flags': final_flags,
        'include_paths_relative_to_dir': compilation_info.compiler_working_dir_
    }


# vim: set noai ts=2 sw=2:
