/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	/* row and col are supposed to start with 0 */
	size_t idx;
	Color * res; 
	/* First, we calculate the index of the corresponding pixel */
	idx = (row) * image->cols + (col);
	
	res = (Color*)malloc(sizeof(Color));
	if (image->image[idx]->B & 0x1) /* The least significant bit is nonzero */
		res->R = res->G = res->B = 255;
	else res->R = res->G = res->B = 0;

	return res;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	Image *res;
	size_t total, cnt;

	res = (Image *)malloc(sizeof(Image));
	res->cols = image->cols, res->rows = image->cols;

	total = image->cols * image->rows;
	res->image = (Color**)malloc(sizeof(Color *) * total);

	cnt = 0;
	for (int r = 0; r < res->rows; ++r)
		for (int c = 0; c < res->cols; ++c)
			res->image[cnt++] = evaluateOnePixel(image, r, c);

	return res;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	if (argc != 2)
	{
		printf("Usage: %s <ppm file>\n", argv[0]);
		exit(-1);
	}

	Image *in, *out;
	in = readData(argv[1]);
	out = steganography(in);
	writeData(out);

	freeImage(in), freeImage(out);

	return 0;
}
