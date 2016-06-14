#include "color.h"

using namespace std;

void make_color_tab(unsigned char *table,vector<Vec3f> &data) //输入表和通道数据
{
	int idx = 0;
	int i;
	for(i = 0; i < 256; i++)
	{
		float r = i/255.0f;
		if(r < 1.0 && r >= data[idx+1].x)
		{
			idx++;
		}
		float prop = (r - data[idx].x)/(data[idx+1].x - data[idx].x);
		float val = data[idx].z + (data[idx+1].y - data[idx].z)*prop;
		table[i] = 255*val;
	}
}
int main(int argc, const char *argv[])
{
	vector<vector<Vec3f> > colormap;
	colormap=createNamedMaps()["jet"];
	unsigned char r_tab[256];
	make_color_tab(r_tab,colormap[0]);
	unsigned char g_tab[256];
	make_color_tab(g_tab,colormap[1]);
	unsigned char b_tab[256];
	make_color_tab(b_tab,colormap[2]);
	int i,j;
	for(i = 0; i < 256; i++) //对于256种颜色
	{
		//printf("%d,%d,%d\n",r_tab[i],g_tab[i],b_tab[i]);
		unsigned int tmp=0;
		tmp=(r_tab[i]<<16) | (g_tab[i]<<8) | (b_tab[i]);
		printf("0x%08X,",tmp);
		if (i%8==7)
		{
			cout<<endl;
		}
	}
	return 0;
}
