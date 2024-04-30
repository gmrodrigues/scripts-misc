from pdfminer.high_level import extract_text

text = extract_text("./Fatura_Itau_2024-03.pdf")
print(text)
