import math
import sys

def convert(hex888 = "00FF00"):
    hex888 = str(hex888)
    r = math.floor(int(hex888[0:2], 16) / 8) << 0;
    g = math.floor(int(hex888[2:4], 16) / 8) << 5;
    b = math.floor(int(hex888[4:6], 16) / 8) << 10;

    hex555 = format((r+g+b), "04X")
    return hex555[2:4] + hex555[0:2]

def handleFile(path):
    with open(str(path), "rb") as file:
        hex888 = file.read(3).hex() # Returns 'byte object' without '.hex()'
        while hex888:
            print(convert(hex888))
            hex888 = file.read(3).hex()
        file.close()
    input("Press any key to continue...")

def handleSingle():
    hex_ = input("Enter RGB888 hex value: ")
    print("BGR555 hex: " + convert(hex_))
    input("Press any key to continue...")

if __name__ == "__main__":
    if len(sys.argv) >= 2:
        handleFile(sys.argv[1]) # Next step: Output to 'out.inc' file in snes format
    else:
        handleSingle()
