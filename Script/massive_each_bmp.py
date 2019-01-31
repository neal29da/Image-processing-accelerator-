import binascii
import sys
from os import system
import glob
import os

# PARAMETER

DATA_WIDTH = 32
LENGTH = 8
PATH = 'testdata/'

if DATA_WIDTH == 64:
    LENGTH = 16

#   bmp_file = sys.argv[1]
output_dir = 'input_DUT_img'

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

#   hexa_file = open(output_file, "w")

for filename in glob.glob(PATH + '*.bmp'):
    #   printing current file
    print(filename.replace(PATH, ''))

    #   open current bmp file
    with open(filename, 'rb') as f:
        content = f.read()
    hexa_file_current = open(output_dir + '/' + filename.replace(PATH, '').replace('.bmp','.txt'), "a")
    #   convert content to hexa
    data = str(binascii.hexlify(content))

    #   clean only in MACOS not in linux
    data = data.lstrip("b'")
    data = data.replace("'", "")

    #   adding padding
    new_data = data[0:108]
    new_data = new_data + '0000'
    new_data = new_data + data[108:]

    #   width calculation to the current hexa code
    width = int((len(new_data) / LENGTH) + 1)

    new_data = ("\n").join([new_data[i:i + LENGTH] for i in range(0, len(new_data), LENGTH)])

    id = filename.replace('.bmp', '').replace(PATH, '')


    hexa_file_current.write(new_data)

    hexa_file_current.close()
    print('ok')


