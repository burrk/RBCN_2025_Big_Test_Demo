"""Custom DataDriverReader that selects only every Xth test for execution.

Requires two additional paramaters vs regular CSV files, which are similar to 
Pabot slices:
    slice:      current slice (or shard) tests are being generated for.
                (default= 1)
    num_slices: total number of slices (or shards)
                (default = 1)

See:
https://github.com/Snooz82/robotframework-datadriver?tab=readme-ov-file#create-custom-reader

"""
# Overload's the DataDriver's csv_reader class to let it do all the parsing work:
# https://github.com/Snooz82/robotframework-datadriver/blob/main/src/DataDriver/csv_reader.py
#
# P.S. The csv_generic_reader could have been used instead so the column names
#      would not have needed formatting in advance.

from DataDriver.csv_reader import csv_reader  # which inherits from AbstractReaderClass

class my_slice_reader(csv_reader):
    def get_data_from_source(self):  
        # This method will be called from DataDriver to get the TestCaseData.
        # There should be some error checking (e.g. slice < num_slices )
        slice       = int(self.kwargs['slice']) - 1
        num_slices  = int(self.kwargs['num_slices']) 

        data_table = super().get_data_from_source()
        return data_table[slice::num_slices]
