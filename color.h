/*
 * 文件名： color.h
 * 功能：
 *	定义伪彩色的数据结构
 * */
#pragma once

#include "main.h"
#include <map>

using namespace std;

struct Vec3f
{
	float x,y,z;
	Vec3f(float a,float b,float c)
	{
		x=a;
		y=b;
		z=c;
	}
};

map<string,vector<vector<Vec3f> > > createNamedMaps(void);

