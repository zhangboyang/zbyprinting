/*
 * Copyright 2002-2011 Guillaume Cottenceau and contributors.
 *
 * This software may be freely redistributed under the terms
 * of the X11 license.
 *
 */

#include <iostream>
#include <iomanip>
#include <cstdio>
#include <cstdlib>
#include <png.h>
using namespace std;

bool LoadAndAnalysis(string file_name, double &result)
{
	unsigned char header[8];    // 8 is the maximum size that can be checked
	unsigned long width, height, rowbytes;
	png_byte color_type;
	png_bytep *row_pointers;
	png_structp png_ptr;
	png_infop info_ptr;
	
	unsigned long i, j;
	unsigned long long int sum = 0;
	
	/* open file and test for it being a png */
	FILE *fp = fopen(file_name.c_str(), "rb");
	if(!fp)
		return false;
	fread(header, 1, 8, fp);
	if(png_sig_cmp(header, 0, 8))
	{
		fclose(fp);
		return false;
	}

	/* initialize stuff */
	png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
	if(!png_ptr)
	{
		fclose(fp);
		return false;
	}
	info_ptr = png_create_info_struct(png_ptr);
	if(!info_ptr)
	{
		fclose(fp);
		return false;
	}
	setjmp(png_jmpbuf(png_ptr));

	png_init_io(png_ptr, fp);
	png_set_sig_bytes(png_ptr, 8);
	png_read_info(png_ptr, info_ptr);

	width = png_get_image_width(png_ptr, info_ptr);
	height = png_get_image_height(png_ptr, info_ptr);
	color_type = png_get_color_type(png_ptr, info_ptr);
	rowbytes = png_get_rowbytes(png_ptr, info_ptr);
	
	png_read_update_info(png_ptr, info_ptr);
	
	if(color_type != PNG_COLOR_TYPE_GRAY)
	{
		png_destroy_read_struct(&png_ptr, &info_ptr, png_infopp_NULL);
		fclose(fp);
		return false;
	}
	
	/* read file */
	if(setjmp(png_jmpbuf(png_ptr)))
	{
		png_destroy_read_struct(&png_ptr, &info_ptr, png_infopp_NULL);
		fclose(fp);
		return false;
	}

	row_pointers = new png_bytep[height];
	for(i = 0; i < height; i++)
		row_pointers[i] = new png_byte[rowbytes];

	png_read_image(png_ptr, row_pointers);
	png_read_end(png_ptr, info_ptr);
	png_destroy_read_struct(&png_ptr, &info_ptr, png_infopp_NULL);
	fclose(fp);

	for(i = 0; i < height; i++)
		for(j = 0; j < width; j++)
		{
			sum += row_pointers[i][j];
		}
	result = 1 - (double)sum / (height * width * 0xff);
	
	for(i = 0; i < height; i++)
		delete row_pointers[i];
	delete row_pointers;
	
	return true;
}

int main()
{
	double result;
	string name;
	ios::sync_with_stdio(false);
	cout << setprecision(4) << setiosflags(ios::fixed);
	while(cin >> name)
		if(LoadAndAnalysis(name, result))
			cout << result << endl;
		else
			cout << "ERROR" << endl;
	return EXIT_SUCCESS;
}
