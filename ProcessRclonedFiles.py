import argparse
import json
import logging
import pathlib
import subprocess
import sys


def main(argv, p=None):

    parser = argparse.ArgumentParser()
    parser.add_argument('--json', required=True)
    parser.add_argument('--dir', required=True)

    parser.add_argument('--debug', action='store_true')

    args = parser.parse_args(argv)
    logging.info('%srunning with %s', (p + " ") if p is not None else "", args)

    if args.debug:
        logging.getLogger().setLevel(logging.DEBUG)

    dir = pathlib.Path(args.dir)

    with open(args.json, 'rb') as f:
        j = json.load(f)

    for j1 in j:
        f = dir / j1['Path']
        if j1['IsDir']:
            continue
        d = j1.get('Metadata', {}).get('description', '')
        if d != '':
            logging.info ("'%s' gets description '%s'", f, d)

            sargs = ['exiftool', '-overwrite_original', f'-MWG:Description="{d}"', f]
            cp = subprocess.run(sargs)
            if cp.returncode != 0:
                logging.error("Command '%s' received return code %d", cp.args, cp.returncode)


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, stream=sys.stdout)
    # logging.getLogger('PIL').setLevel(logging.INFO)

    main(sys.argv[1:], sys.argv[0])
