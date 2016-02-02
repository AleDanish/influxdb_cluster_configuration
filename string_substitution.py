#     Author: Alessandro Zanni
#     URL: https://github.com/AleDanish

import sys
import fileinput

def getFileData(file_name, key, value):
    trovato = False
    for line in fileinput.input(file_name, inplace=1):
        if key + ' = ' in line.strip() and trovato == False:
            old_value = line.split(' ' + key + ' = ')[1]
            print '  hostname = \"' + value + '\"'
            trovato = True
        else:
            sys.stdout.write(line)

if len(sys.argv) <= 3:
    print "Few arguments"
    sys.exit(1)
config_file=sys.argv[1]
key=sys.argv[2]
value=sys.argv[3]

getFileData(config_file, key, value)


