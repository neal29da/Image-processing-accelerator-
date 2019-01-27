import binascii
import sys
from os import system

#   input file bmp image
#bmp_file = '/Users/nealdahan/Desktop/testttt/im_3.bmp'
#output_file1 = '/Users/nealdahan/Desktop/testttt/bb.txt'
bmp_file = sys.argv[1]
output_file1 = bmp_file.rstrip('.txt') + '.bmp';
# output file with return to line every 4 byte
#output_file2 = '/Users/nealdahan/Desktop/testttt/hexa_output_4B.txt'

#   Opening bmp image
with open(bmp_file, 'rb') as f:
    content = f.read()

#   Create output data, need to specify a location for output file
hexa_file = open(output_file1, "w")

content = content.replace("\n","")

# Addding 16 bit to zero between the HEADERS (54bytes) and the rest of Data
new_data = content[0:107]
new_data = new_data + content[111:]


# Converting to hexa
data = str(binascii.unhexlify(new_data.strip()))
#data = data.lstrip("b'")



# Write into file
hexa_file.write(data)

# Close File
hexa_file.close()
#linux_command = """a=$(fold -w8 """ + output_file1 + """); """

#system(linux_command)

#system("ls /Users/nealdahan/Desktop/testttt")
