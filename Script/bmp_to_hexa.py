import binascii


#   input file
bmp_file = '/Users/nealdahan/Desktop/testttt/im_3.bmp'

with open(bmp_file, 'rb') as f:
    content = f.read()

#   Output file
hexa_file = open('/Users/nealdahan/Desktop/testttt/bb.txt', "a")

data = str(binascii.hexlify(content))
data = data.lstrip("b'")
data = data[0:108] + '0000000000000000' + data[108:]


hexa_file.write(data)


hexa_file.close()
