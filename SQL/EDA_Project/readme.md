## Exploratory Data Analysis – Layoffs Dataset

This project focuses on performing exploratory data analysis (EDA) on a layoffs dataset using SQL, with the goal of identifying trends, patterns and key insights related to workforce reductions across companies, industries, countries and time periods.

The analysis was carried out on a previously cleaned dataset, allowing the exploration to focus on reliable and standardized data.

### Project Goals

The main objectives of this analysis were:

- Understand the overall scale of layoffs
- Identify the companies with the highest number of layoffs
- Analyze how layoffs were distributed across industries and countries
- Explore trends over time, both yearly and monthly
- Detect the impact of layoffs across company stages
- Rank companies and industries by layoffs for each year

### Approach

The analysis was developed through a structured SQL exploration process, using aggregations, rankings and time-based breakdowns to examine the dataset from multiple perspectives.

Key analytical steps included:

- Identifying maximum values for total and percentage layoffs
- Analyzing companies with full workforce reductions
- Aggregating layoffs by company, industry, country and location
- Exploring layoffs over time using daily, yearly and monthly views
- Calculating rolling totals to observe cumulative trends
- Ranking top companies and industries by layoffs for each year using window functions

The implementation involved SQL features such as:

- `GROUP BY` and aggregate functions (`SUM`, `MAX`, `MIN`)
- Date extraction and time-based grouping
- Common Table Expressions (CTEs)
- Window functions such as `DENSE_RANK()` and cumulative sums
- Filtering and sorting techniques to surface the most relevant results

### Analysis Highlights

The analysis made it possible to identify several important dimensions of the layoffs phenomenon:

- Which companies recorded the highest total layoffs
- Which industries were most affected
- Which countries and locations had the greatest impact
- How layoffs evolved over time
- Which years concentrated the highest volumes
- The top-ranked companies and industries by layoffs in each year

By introducing rolling totals and yearly rankings, the project goes beyond simple aggregation and provides a clearer view of how layoffs developed over time and across different business segments.

### Results & Key Takeaways

This project shows how SQL can be used not only for querying data, but also for building meaningful analytical views that support interpretation and decision-making.

The analysis highlights the importance of:

- Breaking down a problem into multiple analytical dimensions
- Structuring queries progressively, from simple summaries to more advanced rankings
- Combining aggregation, time analysis and window functions to extract deeper insights
- Using clean and structured data as a foundation for reliable analysis

Overall, this project demonstrates a practical SQL-based exploratory analysis workflow, transforming a cleaned dataset into a set of clear and interpretable business insights.

