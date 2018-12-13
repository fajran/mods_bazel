import json
import os
import sys
import hashlib

def sha256(fname):
    h = hashlib.sha256()
    with open(fname, 'rb') as f:
        while True:
            data = f.read(65536)
            if not data:
                break
            h.update(data)

    return h.hexdigest()

def main():
    paramfile = sys.argv[1]
    out = sys.argv[2]

    param = json.load(open(paramfile))

    res = dict(files = {})
    for fname in param['files']:
        res['files'][fname] = dict(
            sha256 = sha256(fname),
        )

    with open(out, 'w') as f:
        json.dump(res, f)

if __name__ == '__main__':
    main()

