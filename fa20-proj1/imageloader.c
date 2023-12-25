/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	FILE* target;
	size_t total, idx;
	uint32_t rows, cols;
	Image *img;
	uint8_t r, g, b;

	target = fopen(filename, "r");
	if (!target)
	{
		printf("Error: fopen failed\n");
		exit(1);
	}
	fscanf(target, "%*s");
	fscanf(target, "%d %d", &rows, &cols);
	fscanf(target, "%*s");

	total = rows * cols; /* used for calculating the size of memory to be allocated for img */
	img = (Image *)malloc(sizeof(Image));
	img->rows = rows, img->cols = cols;

	img->image = (Color **)malloc(sizeof(Color *) * total);
	/* right now the file pointer is at the begining of image data */ 
	idx = 0; /* used for counting colors */
	while (fscanf(target, " %hhd %hhd %hhd", &r, &g, &b) == 3)
	{
		Color *color = (Color *)malloc(sizeof(Color));
		color->R = r, color->G = g, color->B = b;
		img->image[idx++] = color;
	}

	if (idx != total)
	{
		printf("Error: idx != total\n");
		exit(1);
	}

	fclose(target);

	return img;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	size_t size = image->cols * image->rows;

	fprintf(stdout, "P3\n");
	fprintf(stdout, "%u %u\n", image->rows, image->cols);
	fprintf(stdout, "255\n");
	/* The above code is used to print PPM3 header*/
	for (size_t i = 0; i < size; ++i)
	{
		Color * color = image->image[i];
		uint8_t r = color->R, g = color->G, b = color->B;

		if ((i + 1) % image->cols)
		{
			fprintf(stdout, "%3u %3u %3u   ", r, g, b);
		}
		else fprintf(stdout, "%3u %3u %3u\n", r, g, b);
	}
}

//Frees an image
void freeImage(Image *image)
{
	size_t size = image->cols * image->rows;

	for (size_t i = 0; i < size; ++i)
	{
		/* free each color */	
		free(image->image[i]);
		image->image[i] = NULL;
	}
	/* free image */
	free(image->image);
	image->image = NULL;
	free(image);
}