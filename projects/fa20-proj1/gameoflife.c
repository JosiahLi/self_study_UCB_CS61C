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

int moveRight(int idx, int cols, int size)
{
	if ((idx + 1) % cols == 0) return (idx - cols + 1);
	
	return idx + 1;
}

int moveLeft(int idx, int cols, int size)
{
	if (idx % cols == 0) return (idx + cols - 1);
	
	return idx - 1;
}

int moveUp(int idx, int cols, int size)
{
	return (idx - cols + size) % size;
}

int moveDown(int idx, int cols, int size)
{
	return (idx + cols) % size;
}

uint32_t combineColor(Color *color)
{
	uint32_t res = 0;
	res |= color->R << 16;
	res |= color->G << 8;
	res |= color->B;	

	return res;
}

/*
	color_type: 0 -> R, 1 -> G, 2 -> B
*/
uint32_t evaluateOneColor(Image *image, int row, int col)
{
	uint32_t cnt, res;
	uint32_t idx = row * image->cols + col, size, cols;
	uint32_t top, bottom; /* the index of top and bottom neighbors */
	uint32_t cur_val; /* current color value */
	Color **colors = image->image;

	cur_val = combineColor(colors[idx]);	
	res = 0, cols = image->cols, size = image->cols * image->rows;
	top = moveUp(idx, cols, size), bottom = moveDown(idx, cols, size);
	for (int i = 0; i < 24; ++i)
	{ 
		cnt = 0;
		uint32_t temp_val; /* used to store color value of neighbors */
		uint8_t flag = (cur_val >> i) & 1;
		/* UP */
		temp_val = combineColor(colors[top]); 
		if ((temp_val >> i) & 1) ++cnt;
		/* Down */
		temp_val = combineColor(colors[bottom]);
		if ((temp_val) >> i & 1) ++cnt;
		/* Right */
		temp_val = combineColor(colors[moveRight(idx, cols, size)]);
		if ((temp_val) >> i & 1) ++cnt;
		/* Left */
		temp_val = combineColor(colors[moveLeft(idx, cols, size)]);
		if ((temp_val) >> i & 1) ++cnt;
		/* Top left */
		temp_val = combineColor(colors[moveLeft(top, cols, size)]);
		if ((temp_val) >> i & 1) ++cnt;
		/* Top right */
		temp_val = combineColor(colors[moveRight(top, cols, size)]);
		if ((temp_val) >> i & 1) ++cnt;
		/* Bottom left */
		temp_val = combineColor(colors[moveLeft(bottom, cols, size)]);
		if ((temp_val) >> i & 1) ++cnt;
		/* Bottom right */
		temp_val = combineColor(colors[moveRight(bottom, cols, size)]);
		if ((temp_val) >> i & 1) ++cnt;

		if ((flag && alive_to[cnt]) || (!flag && dead_to[cnt]))
			res |= 1 << i;
	}

	return res;
}

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	Color *res;
	uint32_t color_val; 

	res = (Color *)malloc(sizeof(Color));
	color_val = evaluateOneColor(image, row, col);
	// printf("[%d][%d] = %X\n", row, col, color_val);
	// printf("%x %x %x\n", color_val >> 16, (color_val & 0xff00) >> 8, color_val & 0xff);
	res->R = color_val >> 16;
	res->G = (color_val & 0xff00) >> 8;
	res->B = color_val & 0xff;

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

	freeImage(in), freeImage(out);

	return 0;
}
