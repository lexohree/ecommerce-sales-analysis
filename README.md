# E-Commerce Sales & Customer Analysis

## Project Overview

This project analyzes e-commerce sales transactions, customer purchasing behavior, product performance, and profitability from 2021 through 2025. The objective is to identify trends, evaluate business performance, and develop data-driven recommendations to support revenue growth, customer retention, and profitability.

The project combines Python for exploratory data analysis, SQL for querying and analyzing transactional data, and Tableau for interactive data visualization. Findings are consolidated into a final analytical report highlighting key insights and business recommendations.

## Business Objectives
- Evaluate sales performance and identify revenue trends.

- Analyze customer purchasing behavior and revenue contributions.

- Identify top-performing products and product categories.

- Examine profitability and the relationship between discounts and profit margins.

- Develop actionable recommendations based on analytical findings.


## Tools & Technologies
- **Python:** pandas, NumPy, Matplotlib
- **SQL:** MySQL
- **Data Visualization:** Tableau Public
- **Development Environment:** Visual Studio Code, Jupyter Notebook
- **Version Control:** Git and GitHub

*Project status: In progress — Python exploratory data analysis completed; SQL analysis, Tableau dashboards, and final report are being developed.*

## Dataset Overview
This project uses three interconnected e-commerce datasets covering transactions from 2021 through 2025:

- **Sales:** Order transactions, customer information, and financial performance.
- **Order Items:** Individual products purchased within each order.
- **Product Catalog:** Product categories, brands, pricing, and costs.

The primary financial analysis focuses on **67,978 completed USD orders** to ensure consistent financial comparisons.

Detailed information about data preparation, methodology, and limitations will be included in the final analytical report.

## Project Components
### Python — Exploratory Data Analysis
Performed data inspection, validation, preparation, and exploratory analysis using pandas, Matplotlib, and Seaborn.

The analysis examines sales performance, customer purchasing behavior, product profitability, and discount patterns.

**Status:** Completed

### SQL — Data Analysis
MySQL queries will be used to analyze sales transactions, customer behavior, product performance, and profitability through joins, aggregations, and analytical functions.

**Status:** In Progress

### Tableau — Interactive Dashboards
Interactive dashboards will visualize key performance indicators, revenue trends, customer segments, and product performance.

**Status:** In Progress

### Final Analytical Report
A comprehensive report will consolidate findings from Python, SQL, and Tableau into business insights and recommendations.

**Status:** Planned

## Key Findings
The Python exploratory data analysis identified several insights from 67,978 completed USD orders between 2021 and 2025:

- **Sales Performance:** Generated $83.34 million in net sales and $32.86 million in profit, with an overall profit margin of 39.43%.
- **Product Performance:** Electronics generated the highest product-category revenue at $19.34 million, while Grocery recorded the highest profit margin at 52.65%.
- **Customer Behavior:** Loyal customers contributed 93.94% of total net sales and averaged 5.04 orders per customer.
- **Profitability:** Higher discount amounts were associated with lower profit margins, particularly during November and December.

These findings provide a foundation for further analysis using SQL and Tableau. Detailed interpretations and business recommendations will be presented in the final analytical report.

## Running the Python Analysis
To reproduce the exploratory data analysis:

1. Clone this repository to your local computer.
2. Install the required Python packages using:

   ```bash
   python -m pip install -r requirements.txt
   ```

3. Open `03_python/ecommerce_eda.ipynb` in Jupyter Notebook or Visual Studio Code.
4. Ensure the three source CSV files are available in the `01_data/` directory.
5. Run all notebook cells in sequence.

The analysis uses completed USD orders from 2021–2025 for consistent financial comparisons.

## Project Status

- **Python EDA:** Completed
- **SQL Analysis:** In progress
- **Tableau Dashboards:** In progress
- **Final Analytical Report:** Planned

This repository will be updated as additional project components are completed.

## Author
Aspiring Data Analyst transitioning into the field, building practical skills in Python, SQL, data visualization, and exploratory data analysis through hands-on projects and continued learning.
