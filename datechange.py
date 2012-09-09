#! /usr/bin/python

import glob
import re

extensionsToAnalyze = ('*.cbx', '*.bbx')
filesToReplace = []
for selectedExtension in extensionsToAnalyze:
    filesToReplace.extend(glob.glob(selectedExtension))
for currentFile in filesToReplace:
    print('File ' + currentFile + '...')
    inputHandler = open(currentFile, 'r')
    for line in inputHandler:
        pattern = re.search('\\\\ProvidesFile{(.*)}\\[(.*)\\]', line)
        if pattern:
            print(' - Current date: ' + pattern.group(2))
    inputHandler.close()

newDate = str(raw_input('\nNew date: '))

filesToReplace = []
for selectedExtension in extensionsToAnalyze:
    filesToReplace.extend(glob.glob(selectedExtension))
for currentFile in filesToReplace:
    print('Processing file ' + currentFile + '...')
    inputHandler = open(currentFile, 'r')
    newOutput = []
    for line in inputHandler:
        pattern = re.search('\\\\ProvidesFile{(.*)}\\[(.*)\\]', line)
        if pattern:
            print(' - from ' + pattern.group(2) + ' to ' + str(newDate))
            newOutput.append('\\ProvidesFile{' + pattern.group(1) + '}[' + newDate + ']\n')
        else:
            newOutput.append(line)
    inputHandler.close()
    inputHandler = open(currentFile, 'w')
    for line in newOutput:
        inputHandler.write(line)
    inputHandler.close()
print('Ducks.')
