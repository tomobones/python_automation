
# ________________________________________________________________
# create pdf

from fpdf import FPDF

def build_pdf():
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font('Arial', '', 16)
    pdf.set_draw_color(0, 80, 0)
    pdf.set_fill_color(30, 30, 0)
    pdf.set_text_color(220, 50, 50)
    pdf.cell(40, 10, 'Hello World!', ln=True, border=True, fill=True)

    pdf.set_fill_color(200, 200, 200)
    pdf.cell(40, 30, 'Ausgaben Harras', 'C', ln=True, fill=True)
    pdf.cell(90, 10, ' ', 0, 2, 'C')
    pdf.cell(-55)
    columnNameList = list(volume.columns)

    for header in columnNameList:
        pdf.cell(35, 10, header, 1, 0, 'C')

    """
    pdf.cell(35, 10, columnNameList[-1], 1, 2, 'C')
    pdf.cell(-140)
    pdf.set_font('arial', '', 11)
    for row in range(0, len(iris_grouped_df)):
    for col_num, col_name in enumerate(columnNameList):
        if col_num != len(columnNameList)-1:
        pdf.cell(35,10, str(iris_grouped_df['%s' % (col_name)].iloc[row]), 1, 0, 'C')
        else:
        pdf.cell(35,10, str(iris_grouped_df['%s' % (col_name)].iloc[row]), 1, 2, 'C')  
        pdf.cell(-140)
    """

    pdf.output('tuto1.pdf', 'F')

build_pdf()










