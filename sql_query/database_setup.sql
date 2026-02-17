CREATE DATABASE world_layoffs;
USE world_layoffs;

SELECT * FROM layoffs;




/* 

this is the process of data cleaning and data transformation for the world layoffs project.

        1- creating staging table copy of original table.
        2- finding duplicates. 
        3- standardizing data.
        4- handling with null.
        5- deleting column, row.
       
*/

-- check out 1-cleaning.sql for the data cleaning process and further process.