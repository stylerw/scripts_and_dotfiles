#!/usr/bin/python
# This script turns IPA in unicode into TIPA
# You should be using XeLaTeX and unicode anyways, but enjoy!

import sys
chars = sys.argv[1]
import eltk
from eltk.utils.CharConverter import *
from eltk.utils.functions import *

latex_converter=CharConverter('uni','tipa')
doc = latex_converter.convert(chars)
clean = eltk.utils.functions.tipaClean(doc)
final = "\\textipa{" + clean + "}"
print final
