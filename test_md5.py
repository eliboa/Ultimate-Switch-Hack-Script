#!/usr/bin/python
# -*- coding:Utf-8 -*-



import hashlib

m = hashlib.md5()
m.update("abcdef")
print m.digest()
print m.hexdigest()
print hashlib.md5("abcdeF").hexdigest()