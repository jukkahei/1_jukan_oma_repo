
def find_mappping_table_row (temperature):

    print ("python got this  temperature %s for mapping." % temperature)

    plain_temp = temperature.encode('ascii', 'ignore').decode('ascii')

    # Below converting temperature string to float to be able to compare temperatures
    plain_temp = float(plain_temp)

    if plain_temp <= -20:
        row_num = 0
    elif plain_temp > -20 and plain_temp <= -10:
        row_num = 1
    elif plain_temp > -10 and plain_temp <= 0:
        row_num = 2
    elif plain_temp > 0 and plain_temp <= 10:
        row_num = 3
    elif plain_temp > 10 and plain_temp <= 20:
        row_num = 4
    elif plain_temp > 20 and plain_temp <= 28:
        row_num = 5
    else:
        row_num = 6

    print ("FINALLY python returns mapping table row num %s" % row_num)

    # Below mapping table row is returned based on the tempterature in the given location
    return row_num