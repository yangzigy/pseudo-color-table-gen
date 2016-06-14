#!/usr/bin/python
# -*- coding:utf-8 -*-

import pylab
import inspect
import numpy
import sys

f=open("color.cpp","w")
f.write("""
#include "color.h"

map<string,vector<vector<Vec3f> > > createNamedMaps(void)
{
	map<string,vector<vector<Vec3f> > > m;
""")
discrete_n = 10
for name in pylab.cm.cmap_d:
	if not type(pylab.cm.cmap_d[name]) is pylab.matplotlib.colors.LinearSegmentedColormap:
		continue
	f.write("	{\n")
	for channel in ('red','green','blue'):
		f.write("		vector<Vec3f> %s;\n"%(channel[0]))
		d = pylab.cm.cmap_d[name]._segmentdata[channel]
		if inspect.isfunction(d):
			newd = []
			x = numpy.linspace(0,1,discrete_n)
			y = numpy.clip(numpy.array(d(x), dtype=numpy.float), 0, 1)
			for i in range(discrete_n):
				newd.append((x[i], y[i], y[i]))
			d = newd
		for i in d:
			f.write("		%s.push_back(Vec3f("%(channel[0]))
			f.write(str.join(",",map(str,i)))
			f.write("));\n")
	f.write("		vector<vector<Vec3f> > a; a.push_back(r);a.push_back(g);a.push_back(b);\n")
	f.write("		m[\"%s\"] = a;\n"%(name))
	f.write("	}\n")
f.write("	return m;\n")
f.write("}\n")
f.close()
