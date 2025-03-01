import os
import urllib.request

# Not a true nor complete Python setup.py. Simply run `python setup.py`
#
# This runs 'pip' to install required Python packages from the 
# 'requirements.txt' file, and then copies 'pict.exe' into
# '.venv/Scripts/pict.exe'
# (NOTE: PICT is not actually executed in the demo...)

# This assumes you have a .venv folder to move pict.exe into. If you are not
# using a Design Environment (IDE) which does this for you, like VSCode, use:
# `python -venv .env`

PICT = r"https://github.com/microsoft/pict/releases/download/v3.7.4/pict.exe"
PATH = r".venv/Scripts/pict.exe"

def main():
    os.system('pip install -U -r requirements.txt')
    urllib.request.urlretrieve(PICT, PATH)

if __name__ == "__main__":
    main()