/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

static uint8_t alive_to[9], dead_to[9];
//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	Color *res;
	size_t idx, cnt, size;
	uint8_t flag; /* whether the cell to be evaluated is alive */
	uint32_t bottom, top;

	idx = row * image->cols + col;
	size = image->cols * image->rows;
	res = (Color *)malloc(sizeof(Color));
	cnt = 0; /* count for how many alive neighbors are nearby the current cell */
	flag = image->image[idx]->R ? 1 : 0;
	/* Top */
	top = (idx - image->cols + size) % size;
	if (image->image[top]->R) ++cnt;
	/* Bottom */
	bottom = (idx + image->cols) % size;	
	if (image->image[bottom]->R) ++cnt;
	/* Left */
	if (idx % image->cols == 0)
	{
		if (image->image[idx + image->cols - 1]->R) ++cnt;
	}
	else if (image->image[idx - 1]->R) ++cnt;
	/* Right */
	if ((idx + 1) % image->cols == 0)
	{
		if (image->image[idx - image->cols + 1]->R) ++cnt;
	}
	else if (image->image[idx + 1]->R) ++cnt;
	/* Top left */
	if (top % image->cols == 0)
	{
		if (image->image[top + image->cols - 1]->R) ++cnt;
	}
	else if (image->image[top - 1]->R) ++cnt;
	/* Top right */
	if ((top + 1) % image->cols == 0)
	{
		if (image->image[top - image->cols + 1]->R) ++cnt;
	}
	else if (image->image[top + 1]->R) ++cnt;
	/* Bottom left */
	if (bottom % image->cols == 0)
	{
		if (image->image[bottom + image->cols - 1]->R) ++cnt; 
	}
	else if (image->image[bottom - 1]->R) ++cnt;
	/* Bottom right */
	if ((bottom + 1) % image->cols == 0)
	{
		if (image->image[bottom - image->cols + 1]->R) ++cnt;
	}
	else if (image->image[bottom + 1]->R) ++cnt;

	if ((flag && alive_to[cnt]) || (!flag && dead_to[cnt]))
	{
		res->R = res->G = res->B = 255;
		return res;
	}	

	res->R = res->G = res->B = 0;
	return res;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	Image* res;
	for (int i = 0; i < 9; ++i)
		dead_to[i] = (rule >> i) & 1;
	rule >>= 9;
	for (int i = 0; i < 9; ++i)
		alive_to[i] = (rule >> i) & 1;

	res = (Image *)malloc(sizeof(Image));
	res->cols = image->cols, res->rows = image->rows;
	res->image = (Color **)malloc(sizeof(Color *) * image->cols * image->rows);

	for (int r = 0; r < image->rows; ++r)
		for (int c = 0; c < image->cols; ++c)
			res->image[r * res->cols + c] = evaluateOneCell(image, r, c, rule);
	
	return res;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	if (argc != 3)
	{
		printf("usage: %s filename rule\n", argv[0]);
		printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
		printf("rule is a hex number beginning with 0x; Life is 0x1808.\n");

		exit(-1);
	}
	char * filename = argv[1];
	uint32_t rule = strtol(argv[2], NULL, 0);
	Image *in = readData(filename);
	Image *out = life(in, rule);
	writeData(out);

	freeImage(in), free(out);

	return 0;
}
