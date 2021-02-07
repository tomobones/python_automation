#!/usr/bin/python3

'''
This script merges pdf files passed as arguments or - if not - piped via the
standard input. It writes the output to the file passed by the '-o' option. The
default output file is 'output.pdf'. The user is asked, in case of the
existence of this file.
'''

import sys
import os
from PyPDF2 import PdfFileMerger, PdfFileReader

# ________________________________________________________________
# data structures for reading the arguments


class PossibleOption:
    def __init__(self, key, numberParameter, isMandatory):
        self.key = key
        self.numberParameter = numberParameter
        self.isMandatory = isMandatory

class ActualOption:
    def __init__(self, key, parameters):
        self.key = key
        self.parameters = parameters

# ________________________________________________________________
# input/output functions

def getOptions(possibleOptions, argv):
    actualOptions = []
    actualParameters = []
    thisOption = None
    numberRemainingParameterForThisOption = 0

    systemProgramName = argv[0]
    if len(sys.argv) > 1: systemArguments = argv[1:]
    else: systemArguments = []

    if not systemArguments: return []
    #print("systemArgs len=", len(systemArguments))

    for index, thisArgument in enumerate(systemArguments):
        #print("round:", index)
        if numberRemainingParameterForThisOption == 0:

            # set new actualOption
            thisOption = getOptionForArgument(possibleOptions, thisArgument)
            if thisOption == None:
                return None
            elif thisOption.key == "":
                actualParameters.append(thisArgument)
            numberRemainingParameterForThisOption = thisOption.numberParameter
            #print("option key:", thisOption.key, "with parnr:", numberRemainingParameterForThisOption)
        elif numberRemainingParameterForThisOption == -1:
            if thisArgument[0] == '-':
                #print("********* safe actual option *********")
                actualOptions.append(ActualOption(thisOption.key, list(actualParameters)))
                actualParameters.clear()
                thisOption = getOptionForArgument(possibleOptions, thisArgument)
                if thisOption == None:
                    return None
                numberRemainingParameterForThisOption = thisOption.numberParameter
                #print("option key:", thisOption.key, "with parnr:", numberRemainingParameterForThisOption)
            else:
                actualParameters.append(thisArgument)
                #print("option arg", numberRemainingParameterForThisOption, ":", thisArgument)
        elif numberRemainingParameterForThisOption >= 1:
            if thisArgument[0] == '-':
                return None
                print("Error: missing parameter for'" + thisOption.key + "'.")
            #print("option arg", numberRemainingParameterForThisOption, ":", thisArgument)
            numberRemainingParameterForThisOption -= 1
            actualParameters.append(thisArgument)

        # append actualOption and clear list of parameters
        if numberRemainingParameterForThisOption == 0 or index == len(systemArguments) -1:
            if thisOption != None:
                #print("********* safe actual option *********")
                actualOptions.append(ActualOption(thisOption.key, list(actualParameters)))
                actualParameters.clear()

    # check remaining possibelOpts still contain obligatory options
    for possibleOption in possibleOptions:
        if possibleOption.isMandatory:
            print("Error: mandatory argument '" + ("files" if possibleOption.key == "" else  possibleOption.key) + "' not found.")
            return None

    return actualOptions

def parseStdinput():
    files = []
    if not sys.stdin.isatty():
        for line in sys.stdin:
            files.append(line.rstrip())
    return files
# ________________________________________________________________
# auxiliar functions

def getOptionForArgument(possibleOptions, thisArgument):
    argumentWithoutKey = False
    if thisArgument[0] != '-':
        for possibleOption in possibleOptions:
            if possibleOption.key == "":
                possibleOptions.remove(possibleOption)
                return possibleOption
        print("Error: parameter '" + thisArgument + "' is not valid.")
        return None

    for possibleOption in possibleOptions:
        if possibleOption.key == thisArgument:
            possibleOptions.remove(possibleOption)
            return possibleOption
    print("Error: the option '" + thisArgument +"' is not valid.")
    return None

def showArgs(args):
    if args == None:
        print("Error in showArgs(): No valid args.")
        return
    for arg in args:
        print("Argument '" + arg.key + "' has values '", arg.parameters + "'")

# ________________________________________________________________
# main

def main():
    mergedObject = PdfFileMerger()
    input_files = []
    output_file = "output.pdf"

    # parse arguments
    possibleOptions = [
        PossibleOption("", -1, False),
        PossibleOption("-o", 1, False)]
    actualOptions = getOptions(possibleOptions, sys.argv)

    # check arguments
    if actualOptions != None:
        for option in actualOptions:
            if option.key == "":
                input_files = option.parameters
            if option.key == "-o":
                output_file = option.parameters[0]
                if output_file[-4:] != ".pdf":
                    print("Error: '" + output_file + "' is no valid output file.")
                    exit(1)

    # alternatively read from stdin
    if input_files == []:
        input_files = parseStdinput()

    # validity check of input files
    if input_files == []:
        print("Error: couldn't read input files.")
        exit(1)

    for file in input_files:
        if file[-4:] != ".pdf":
            print("Error: '" + file + "' has no extension '.pdf'.")
            exit(1)

    # existence of output file and query
    if os.path.exists(output_file):
        print("Warning: '" + output_file + "' already exists.")
        answer = input("Do you want to overwrite it? ").strip()
        if answer != "yes" and answer != "Yes" and answer != "y" and answer != "Y":
            print("Did not write to file '" + output_file + "'.")
            print("Program was exited.")
            exit(0)

    # merge odf files
    for pdf_file in input_files:
        mergedObject.append(PdfFileReader(pdf_file.replace("\n",""), 'rb'))
        print("Added '" + pdf_file + "'.")

    # write to output file
    if mergedObject.write(output_file) != 0:
        print("Output written to file '" + output_file + "'.")
    else:
        print("Error: couldn't write to '" + output_file + "'.")
        exit(1)

# ________________________________________________________________
# entrance

if __name__ == "__main__":
    main()

# ________________________________________________________________
# end
