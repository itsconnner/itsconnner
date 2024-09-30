#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-only

import sys
import os
import multiprocessing as mp
import pymupdf
from PIL import Image, ImageOps

foreground = (168 / 255, 168 / 255, 168 / 255)

def error(mas):
	print('error:', mas)
	exit(128)

if (len(sys.argv) < 2):
	error("no input file provided")

def rander_page(name, num):
	doc = pymupdf.open(name)
	page = doc.load_page(num)

	pix = page.get_pixmap(dpi=200)

	im = Image.frombytes("RGB", [pix.width, pix.height], pix.samples)
	im = ImageOps.invert(im)

	background = Image.new("RGB", im.size, "#141414")
	im = Image.blend(background, im, alpha=0.7)

	im.save(f"{name}-{num}.png")
	doc.close()

pool = mp.Pool(mp.cpu_count() + 1)
for name in sys.argv[1:]:
	doc = pymupdf.open(name)
	pool.starmap_async(rander_page, [(name, page.number) for page in doc])
	doc.close()

pool.close()
pool.join()

def make_output(name):
	out = pymupdf.open()
	doc = pymupdf.open(name)

	for num in range(doc.page_count):
		path = f"{name}-{num}.png"
		im = pymupdf.Pixmap(path)
		os.remove(path)

		page = out.new_page(width=im.width, height=im.height)
		page.insert_image(page.rect, pixmap=im)

	out.save(f"rec_{doc.name}")
	out.close()
	doc.close()

pool = mp.Pool(mp.cpu_count() + 1)
pool.map_async(make_output, [name for name in sys.argv[1:]])

pool.close()
pool.join()
