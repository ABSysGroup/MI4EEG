"""This module contains utils used through the rest of the code files.

Functions
----------
    check_directory: checks if a directory exists, creates it if not.
"""

import sys
import os

def check_directory(path: str) -> str:
    """Checks if a path exists in filesystem and whether it is a dir or
    not.

    If it exists but not a directory, it exists with an error code. If 
    it does not exist, it creates the directory.

    Parameters
    ----------
    path: str
        path that is going to be checked

    Returns
    ----------
    str
        returns the path. this is so that it can be used inline.
    """

    if os.path.exists(path):
        if not os.path.isdir(path):
            print(f"{path} exists but is not a directory. Aborting...")
            sys.exit(1)
    else:
        print(f"{path} does not exist. Creating directory...")
        os.mkdir(path)

    return os.path.join(path)  # adds slash if needed

