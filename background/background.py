from PIL import Image
imgs = [Image.open('background.1.bmp'), Image.open('background.2.bmp'), Image.open('background.3.bmp'), Image.open('background.4.bmp')]
width, height = imgs[0].size
f = open('background.bit', 'wb')
for row in range(height):
    for column in range(width):
        if column < 450: img = imgs[1]
        else: img = imgs[0]
        red, green, blue = img.getpixel((column, row))
        f.write(bytearray(((red>>5) + ((green>>2)&0x38) + (blue&0xc0),)))
    f.write(bytearray((0,)*(2048-width)))
f.write(bytearray((0,)*((1<<21)-2048*height)))
for row in range(height):
    for column in range(width):
        if column < 450: img = imgs[0]
        elif column < 610: img = imgs[1]
        elif column < 730: img = imgs[2]
        else: img = imgs[3]
        red, green, blue = img.getpixel((column, row))
        f.write(bytearray(((red>>5) + ((green>>2)&0x38) + (blue&0xc0),)))
    f.write(bytearray((0,)*(2048-width)))
f.write(bytearray((0,)*((1<<21)-2048*height)))
f.close()
