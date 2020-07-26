# this script reads files from files.txt
# files.txt has the format of the output of the ls command


from PyPDF2 import PdfFileMerger, PdfFileReader
 
mergedObject = PdfFileMerger()
#pdfs_to_merge = ["test_file_1.pdf",
#                "test_file_2.pdf"]

file = open('files.txt', 'r')
pdfs_to_merge = file.readlines()
 
for pdf_file in pdfs_to_merge:
    mergedObject.append(PdfFileReader(pdf_file.replace("\n",""), 'rb'))
 
mergedObject.write("merged.pdf")
