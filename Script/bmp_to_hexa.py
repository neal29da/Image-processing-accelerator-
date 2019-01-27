import binascii
import sys
from os import system

#   input file bmp image
#bmp_file = '/Users/nealdahan/Desktop/testttt/im_3.bmp'
#output_file1 = '/Users/nealdahan/Desktop/testttt/bb.txt'
data_width = 64
line_len = 8
if (data_width == 64):
    line_len = 16

bmp_file = sys.argv[1]
output_file1 = bmp_file.rstrip('.bpm') + '1.txt';
output_file2 = bmp_file.rstrip('.bpm') + '2.txt';
# output file with return to line every 4 byte
#output_file2 = '/Users/nealdahan/Desktop/testttt/hexa_output_4B.txt'

#   Opening bmp image
with open(bmp_file, 'rb') as f:
    content = f.read()

#   Create output data, need to specify a location for output file
hexa_file = open(output_file1, "w")

# Converting to hexa
data = str(binascii.hexlify(content))
#data = data.lstrip("b'")

# Addding 16 bit to zero between the HEADERS (54bytes) and the rest of Data
new_data = data[0:108]
new_data = new_data + '0000'
new_data = new_data + data[108:]

# Write into file
hexa_file.write(new_data)

# Close File
hexa_file.close()

linux_command = """a=$(fold -w""" + str(line_len) + ' ' + output_file1 + """); echo "$a" > """ + output_file2

system(linux_command)

#system("ls /Users/nealdahan/Desktop/testttt")

