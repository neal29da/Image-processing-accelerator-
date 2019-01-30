import binascii
import sys
from os import system
import glob


# PARAMETER

DATA_WIDTH = 32
LENGTH = 8
PATH = 'testdata/'

if DATA_WIDTH == 64:
    LENGTH = 16

#   bmp_file = sys.argv[1]
output_file = 'hexa_input_DUT.txt'

hexa_file = open(output_file, "w")

for filename in glob.glob(PATH + '*.bmp'):
    #   printing current file
    print(filename.replace(PATH, ''))

    #   open current bmp file
    with open(filename, 'rb') as f:
        content = f.read()

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

    new_data = ",\n".join([new_data[i:i + LENGTH] for i in range(0, len(new_data), LENGTH)])

    id = filename.replace('.bmp', '').replace(PATH, '')

    hexa_file.write('logic [' + str(DATA_WIDTH) + '-1:0] ' + id + ' [' + str(width) + ":0] ={" + '\n')

    hexa_file.write(new_data)

    hexa_file.write('}' + '\n')
    print('ok')

hexa_file.close()
