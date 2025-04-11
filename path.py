import os
import re

from numpy import full

for folder, _, file in os.walk('assets/towers'):
    for filename in file:
        fullname = os.path.join(folder, filename)
        if filename.endswith('.import'):
            os.remove(fullname)
