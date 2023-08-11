#########################################################
# Made by CoffeeCatRailway                              #
# Converts .pal files with rgb888 colors                #
# into .inc file with bgr555 colors for snes            #
#                                                       #
# Usage:                                                #
# 1) File Explorer: Drag .pal file onto this script     #
# 2) Console: C:\> python rgb8-bgr5.py example.pal      #
#########################################################

import math
import sys
import argparse

# Constants
paletteName = "BG_Palette"
emptyColor = "0000"
fileOut = "palette-out.inc"

# Function to convert rgb888 color to bgr555
def convert(hex888="00FF00"):
    hex888 = str(hex888)
    r = math.floor(int(hex888[0:2], 16) / 8) << 0;
    g = math.floor(int(hex888[2:4], 16) / 8) << 5;
    b = math.floor(int(hex888[4:6], 16) / 8) << 10;

    hex555 = format((r+g+b), "04X")
    return hex555[2:4] + hex555[0:2]

# Function to convert .pal file
def handleFile(path, paletteSize=4, printOut=False, ignoreEmpty=True):
    if not args.path.endswith(".pal"): # Check if file ends with .pal
        raise Exception("'path' must be of type '.pal'!")
    
    hex555array = []
    # Convert colors
    print("Converting colors...")
    with open(str(path), "rb") as file:
        hex888 = file.read(3).hex() # Returns 'byte object' without '.hex()'
        while hex888:
            hex555 = convert(hex888);
            if printOut:
                print(hex555)
            hex555array.append(hex555)
            hex888 = file.read(3).hex()
    
    # Filter out empty palette's
    if ignoreEmpty:
        print("Removing empty palette's...")
        toRemove = []
        for i in range(0, len(hex555array), paletteSize):
            count = 0
            for j in range(0, paletteSize):
                if hex555array[i+j] == emptyColor:
                    count += 1
            if count == 4:
                toRemove.append(i)
                toRemove.append(i+1)
                toRemove.append(i+2)
                toRemove.append(i+3)
        hex555array = [i for j, i in enumerate(hex555array) if j not in toRemove] # All indices in 'toRemove'
    
    # Write colors to file
    print("Writing to '" + fileOut + "'...")
    with open(fileOut, "w") as file:
        file.write(paletteName + ":\n")
        for i in range(0, len(hex555array), paletteSize):
            palette = "\t.db "
            for j in range(0, paletteSize):
                hex555 = hex555array[i+j]
                palette += "$" + hex555[0:2] + ", $" + hex555[2:4] +", "
            file.write(palette[0:-2] + "\n")
    
    input("Press any key to continue...")

#def handleSingle():
#    hex_ = input("Enter RGB888 hex value: ")
#    print("BGR555 hex: " + convert(hex_))
#    input("Press any key to continue...")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("path", type=str, help="Path to .pal file")
    parser.add_argument("-s", "--palettesize", type=int, choices=[4,8,16], default=4, help="How many colors are in one palette")
    parser.add_argument("-p", "--printout", action="store_true", help="Print out colors in console")
    parser.add_argument("-e", "--ignoreempty", action="store_false", help="Should ignore 'empty' palette's")
    args = parser.parse_args()
    
    handleFile(args.path, args.palettesize, args.printout, args.ignoreempty)
    
    #if len(sys.argv) >= 2:
    #    handleFile(sys.argv[1])
    #else:
    #    handleSingle()
