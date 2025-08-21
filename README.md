
# Layoffs Data Cleaning Project

## Project Overview
This project involved a comprehensive data cleaning process for a company layoffs dataset. The goal was to transform raw, unstructured data into a clean, analysis-ready dataset through systematic data cleaning techniques.

## Data Source
The dataset was originally provided by Alex the Analyst, focusing on company layoff information across various industries and geographic locations.

## Data Cleaning Process

### Initial Setup
Created staging tables to preserve the original data integrity while performing cleaning operations, ensuring the raw data remained untouched throughout the process.

### Duplicate Removal
Implemented an advanced duplicate identification system using window functions to detect and eliminate exact duplicate records across all relevant columns including company details, layoff statistics, and financial information.

### Data Standardization
- Performed comprehensive text cleaning by trimming whitespace from all string fields
- Standardized industry classifications by consolidating variations (e.g., all crypto-related entries to "Crypto")
- Cleaned geographic data by removing trailing punctuation from country names
- Converted date fields to proper DATE format for temporal analysis

### Missing Value Handling
- Developed a self-join strategy to intelligently impute missing industry data using existing company information
- Removed records with incomplete essential data where both layoff metrics were missing
- Maintained data quality by preserving records with partial information when possible

### Structural Improvements
- Removed temporary columns used during the cleaning process
- Renamed fields for better clarity and consistency throughout the dataset

## Exploratory Data Analysis
Conducted comprehensive analysis including:
- Identification of maximum layoff values and percentages
- Analysis of companies that experienced complete layoffs (100%)
- Aggregate layoff statistics by company, industry, and country
- Temporal analysis across years and months
- Rolling sum calculations to track layoff trends over time
- Ranking of top companies by layoff numbers annually

## Key Achievements
- Transformed raw data into a clean, analysis-ready dataset
- Implemented reproducible cleaning procedures using SQL
- Maintained data integrity throughout the cleaning process
- Created foundation for robust data analysis and visualization
- Established patterns and trends in company layoffs across multiple dimensions

## Final Output
The project resulted in a fully cleaned dataset featuring:
- Zero duplicate records
- Standardized values across all categorical fields
- Proper data types and formatting
- Comprehensive handling of missing values
- Consistent naming conventions and structure

The cleaned dataset is now optimized for in-depth analysis, visualization, and reporting on company layoff trends and patterns.

