'''
module managing I/O for shell scripts


- include way to output error with specific levels

'''


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
# public functions

def getOptions(possibleOptions, argv):
    actualOptions = []
    actualParameters = []
    thisOption = None
    numberRemainingParameterForThisOption = 0

    systemProgramName = argv[0]
    if len(sys.argv) > 1: systemArguments = argv[1:]
    else: systemArguments = []

    if not systemArguments: return []
    print("systemArgs len=", len(systemArguments))

    for index, thisArgument in enumerate(systemArguments):
        print("round:", index)
        if numberRemainingParameterForThisOption == 0:

            # set new actualOption
            thisOption = getOptionForArgument(possibleOptions, thisArgument)
            if thisOption == None:
                return None
            elif thisOption.key == "":
                actualParameters.append(thisArgument)
            numberRemainingParameterForThisOption = thisOption.numberParameter
            print("option key:", thisOption.key, "with parnr:", numberRemainingParameterForThisOption)
        elif numberRemainingParameterForThisOption == -1:
            if thisArgument[0] == '-':
                print("********* safe actual option *********")
                actualOptions.append(ActualOption(thisOption.key, list(actualParameters)))
                actualParameters.clear()
                thisOption = getOptionForArgument(possibleOptions, thisArgument)
                if thisOption == None:
                    return None
                numberRemainingParameterForThisOption = thisOption.numberParameter
                print("option key:", thisOption.key, "with parnr:", numberRemainingParameterForThisOption)
            else:
                actualParameters.append(thisArgument)
                print("option arg", numberRemainingParameterForThisOption, ":", thisArgument)
        elif numberRemainingParameterForThisOption >= 1:
            if thisArgument[0] == '-':
                return None
                print("missing parameter for", thisOption.key)
            print("option arg", numberRemainingParameterForThisOption, ":", thisArgument)
            numberRemainingParameterForThisOption -= 1
            actualParameters.append(thisArgument)
            
        # append actualOption and clear list of parameters
        if numberRemainingParameterForThisOption == 0 or index == len(systemArguments) -1:
            if thisOption != None:
                print("********* safe actual option *********")
                actualOptions.append(ActualOption(thisOption.key, list(actualParameters)))
                actualParameters.clear()


    # check remaining possibelOpts still contain obligatory options
    for possibleOption in possibleOptions:
        if possibleOption.isMandatory:
            print("mandatory argument " + ("files" if possibleOption.key == "" else  possibleOption.key) + " not found")
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
        print("parameter", thisArgument, "is not valid")
        return None
    
    for possibleOption in possibleOptions:
        if possibleOption.key == thisArgument:
            possibleOptions.remove(possibleOption)
            return possibleOption
    print("the option", thisArgument, "is not valid")
    return None

def showArgs(args):
    if args == None:
        print("error in showArgs: no valid args")
        return
    for arg in args:
        print("arg " + arg.key + " has values ", arg.parameters)

# ________________________________________________________________
# main

def main():

    print("module managing I/O for shell scripts\n")
    print("test this module")

    examplePossibleArgs = [
            PossibleOption("-b", 1, False),
            PossibleOption("-v", 0, False),
            PossibleOption("", -1, True)]

    showArgs(getOptions(examplePossibleArgs, sys.argv))
    print("stdin: ", parseStdinput())


if __name__ == "__main__":
    import sys
    main()
