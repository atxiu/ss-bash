#!/usr/bin/env python
# -*- coding: utf-8 -*-
from sys import argv
import base64

if argv[1] == '-en':
    code = base64.b64encode(argv[2].encode())
    print(code.decode())
elif argv[1] == '-de':
    code = base64.b64decode(argv[2])
    print(code)