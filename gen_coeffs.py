import os
import sys
import pdb

if not (os.path.abspath("../../thesdk") in sys.path):
    sys.path.append(os.path.abspath("../../thesdk"))

from thesdk import *
<<<<<<< HEAD
from URC_toolkit import *
=======
from hb_universal import *

from hb_universal.hb_model import *
>>>>>>> ba3212d

class coefficient_generator():
    @property
    def _classfile(self):
        return os.path.dirname(os.path.realpath(__file__)) + "/"+__name__

    def __init__(self, *arg):
        """generator parameters and attributes

        """
<<<<<<< HEAD
        self.toolkit = URC_toolkit()
=======
        self.toolkit = dsp_toolkit()
        self.HB1 = hb_model()
        self.HB2 = hb_model()
        self.HB3 = hb_model()

        self.HB1.gen_H(self.HB1.HB1_params)
        self.HB2.gen_H(self.HB2.HB2_params)
        self.HB3.gen_H(self.HB3.HB3_params)
>>>>>>> ba3212d

if __name__ == "__main__":
    import argparse
    
    gen = coefficient_generator()
<<<<<<< HEAD
    print("Generating coefficients for halfband filters")
    hb1_H, hb2_H, hb3_H = gen.toolkit.generate_uHfiles(f"{os.path.dirname(os.path.realpath(__file__))}/")
=======

    print("Generating coefficients for halfband filters")
    
    hb1_H, hb2_H, hb3_H = gen.HB1.generate_Hfiles(f"{os.path.dirname(os.path.realpath(__file__))}/", gen.HB1, gen.HB2, gen.HB3)
>>>>>>> ba3212d
    gen.toolkit.plot_coeff_fft([hb1_H, hb2_H, hb3_H])

    input("---\nPress enter to continue to generation\n---\n")

