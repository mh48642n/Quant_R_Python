# -*- coding: utf-8 -*-
"""
Created on Mon Jun 12 22:32:19 2023

@author: marvi
"""
"""
Pulling data from columns A12:A6376 and B12:B6376

"""

import openpyxl as op
import pandas as pd


#pulls data and makes a specfic worksheet active , allowing us to to interact
sheet = op.load_workbook("C:\\Users\\marvi\\OneDrive\\Documents\\GitHub\\Quant_R_Python\\Time Analysis\\Euro_Exchange_Rates.xlsx")
sheet = sheet.active

#iterates through column A from cell 12 to 6376 accounting for dates
dates = [sheet.cell(row=i,column=1).value for i in range(12,6376)]
print(dates[:10])

#iterates through column B from cell 12 to 6376 accounting for rates 
rates = [sheet.cell(row=i,column=2).value for i in range(12,6376)]
print(rates[:10])

#creates dictionary out of the lists and then the dictionary is converted to df
dictt = {"date": dates, "rate": rates}
r_to_d = pd.DataFrame(dictt)

r_to_d.to_excel('Exchange_numbers_.xlsx', sheet_name = "Euro exchange rates", index = False)




