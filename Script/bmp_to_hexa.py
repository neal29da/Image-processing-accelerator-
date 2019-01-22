import binascii


#   input file bmp image
bmp_file = '/Users/nealdahan/Desktop/testttt/im_3.bmp'

#   Opening bmp image
with open(bmp_file, 'rb') as f:
    content = f.read()

#   Create output data, need to specify a location for output file
hexa_file = open('/Users/nealdahan/Desktop/testttt/bb.txt', "w")

# Converting to hexa
data = str(binascii.hexlify(content))
data = data.lstrip("b'")

# Addding 16 bit to zero between the HEADERS (54bytes) and the rest of Data
new_data = data[0:432]
new_data = new_data + '0000000000000000'
new_data = new_data + data[432:]

# Write into file
hexa_file.write(new_data)

# Close File
hexa_file.close()
