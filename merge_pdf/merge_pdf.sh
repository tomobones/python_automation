#!/usr/local/bin/python3

# this script reads files from files.txt
# files.txt has the format of the output of the ls command

import sys
from PyPDF2 import PdfFileMerger, PdfFileReader

def main():
    mergedObject = PdfFileMerger()
    #pdfs_to_merge = ["test_file_1.pdf",
    #                "test_file_2.pdf"]

    try:
        file = open('files.txt', 'r')
    except FileNotFoundError:
        print("FileNotFoundError: please provide 'files.txt', eg as an output of 'ls'", file=sys.stderr)

    sys.exit(1)

    pdfs_to_merge = file.readlines()

    for pdf_file in pdfs_to_merge:
        mergedObject.append(PdfFileReader(pdf_file.replace("\n",""), 'rb'))

    mergedObject.write("merged.pdf")

    file.close()

if __name__ == "__main__":
    main()
