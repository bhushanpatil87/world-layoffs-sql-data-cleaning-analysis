<h1 align="center">🌍 World Layoffs Data Cleaning & Transformation</h1>
<h3 align="center">SQL Data Cleaning Project (MySQL)</h3>

<hr>

<h2>📌 Project Overview</h2>

<p>
This project focuses on cleaning and transforming a real-world global layoffs dataset using <b>MySQL</b>.  
The objective was to convert raw, inconsistent data into a structured, analysis-ready dataset suitable for reporting and business intelligence.
</p>

<p><b>This project demonstrates:</b></p>

<ul>
<li>✔ Data Cleaning using SQL</li>
<li>✔ Duplicate Detection & Removal</li>
<li>✔ Data Standardization</li>
<li>✔ Null Value Handling</li>
<li>✔ Date Type Conversion</li>
<li>✔ Safe Staging Workflow</li>
<li>✔ Production-Level Best Practices</li>
</ul>

<hr>

<h2>🛠 Tools & Environment</h2>

<ul>
<li><b>Database:</b> MySQL</li>
<li><b>Query Tool:</b> MySQL Workbench</li>
<li><b>Editor:</b> VS Code</li>
<li><b>Version Control:</b> Git & GitHub</li>
</ul>

<hr>

<h2>🗂 Project Structure</h2>

<pre>
world-layoffs-sql-data-cleaning-analysis/
│
├── database_setup.sql     → Database creation & setup
├── 1-cleaning.sql         → Complete data cleaning workflow
└── README.md              → Project documentation
</pre>

<hr>

<h2>🗄 Dataset Description</h2>

<p>The dataset contains global employee layoff information including:</p>

<ul>
<li>Company</li>
<li>Location</li>
<li>Industry</li>
<li>Total Laid Off</li>
<li>Percentage Laid Off</li>
<li>Date</li>
<li>Company Stage</li>
<li>Country</li>
<li>Funds Raised (Millions)</li>
</ul>

<p><b>Initial Data Issues:</b></p>

<ul>
<li>❌ Duplicate records</li>
<li>❌ Inconsistent naming conventions</li>
<li>❌ Improper date formats</li>
<li>❌ Null and blank values</li>
<li>❌ Formatting inconsistencies</li>
</ul>

<hr>

<h2>🔍 Data Cleaning Methodology</h2>

<h3>1️⃣ Creating a Staging Table</h3>

<p>
A staging table was created to protect the original dataset.
</p>

<ul>
<li>Prevents accidental data loss</li>
<li>Allows reversible transformations</li>
<li>Follows production-safe workflow</li>
</ul>

<hr>

<h3>2️⃣ Duplicate Detection & Removal</h3>

<p><b>Technique Used:</b></p>

<ul>
<li>ROW_NUMBER() Window Function</li>
<li>CTE for duplicate identification</li>
<li>JOIN-based DELETE (MySQL limitation workaround)</li>
</ul>

<p>
Only exact duplicate records were removed to ensure no legitimate data was lost.
</p>

<hr>

<h3>3️⃣ Data Standardization</h3>

<h4>✂ Removing Extra Spaces</h4>

<pre><code>
UPDATE layoffs_staging2 
SET company = TRIM(company);
</code></pre>

<h4>🌎 Fixing Inconsistent Country Names</h4>

<pre><code>
UPDATE layoffs_staging2 
SET country = 'United States' 
WHERE country = 'United States.';
</code></pre>

<h4>🪙 Standardizing Industry Naming</h4>

<pre><code>
UPDATE layoffs_staging2 
SET industry = 'Crypto Currency' 
WHERE industry LIKE 'crypto%';
</code></pre>

<hr>

<h3>4️⃣ Date Format Conversion</h3>

<p>
The <b>date</b> column was stored as TEXT and converted to proper DATE format using:
</p>

<pre><code>
STR_TO_DATE(date, '%m/%d/%Y')
</code></pre>

<p><b>Why This Matters:</b></p>

<ul>
<li>Enables time-series analysis</li>
<li>Allows grouping by month/year</li>
<li>Improves performance</li>
<li>Makes BI reporting possible</li>
</ul>

<hr>

<h3>5️⃣ Handling Null & Missing Values</h3>

<ul>
<li>Converted blank values to NULL</li>
<li>Used Self JOIN to fill missing industry values</li>
<li>Removed unusable rows where critical fields were NULL</li>
</ul>

<h4>🧹 Final Cleanup</h4>

<pre><code>
ALTER TABLE layoffs_staging2 
DROP COLUMN row_num;
</code></pre>

<p><b>Final Cleaned Table:</b> layoffs_staging2</p>

<hr>

<h2>📊 Data Quality Improvements Achieved</h2>

<ul>
<li>✔ Removed exact duplicate records</li>
<li>✔ Standardized categorical values</li>
<li>✔ Fixed inconsistent country naming</li>
<li>✔ Converted date to proper DATE format</li>
<li>✔ Handled missing industry values intelligently</li>
<li>✔ Removed unusable records</li>
<li>✔ Preserved raw data integrity</li>
</ul>

<hr>

<h2>🚀 SQL Skills Demonstrated</h2>

<ul>
<li>Window Functions (ROW_NUMBER)</li>
<li>Common Table Expressions (CTEs)</li>
<li>Self Joins</li>
<li>Data Standardization Techniques</li>
<li>Date Formatting & Conversion</li>
<li>Conditional Updates</li>
<li>Data Integrity Best Practices</li>
<li>Production-Safe Staging Workflow</li>
</ul>

<hr>

<h2>📈 Why This Project Matters</h2>

<p>
In real-world analytics, data cleaning consumes <b>70–80% of the workflow</b>.
</p>

<p>This project demonstrates:</p>

<ul>
<li>✔ Analytical thinking</li>
<li>✔ Structured cleaning methodology</li>
<li>✔ Production mindset</li>
<li>✔ Strong SQL fundamentals</li>
<li>✔ Understanding of data integrity principles</li>
</ul>

<hr>

<h2>🔮 Future Enhancements</h2>

<ul>
<li>Exploratory Data Analysis (EDA)</li>
<li>Layoffs trend by year/month</li>
<li>Industry-wise layoff trends</li>
<li>Country comparison analysis</li>
<li>Power BI Dashboard Integration</li>
<li>Data Visualization Layer</li>
</ul>

<hr>

<h2>📌 How to Run This Project</h2>

<ol>
<li>Clone the repository</li>
<li>Import the raw dataset into MySQL</li>
<li>Run <b>database_setup.sql</b></li>
<li>Execute <b>1-cleaning.sql</b></li>
<li>Query the cleaned table <b>layoffs_staging2</b></li>
</ol>

<hr>

<h2>👨‍💻 Author</h2>

<p>
<b>Bhushan Patil</b><br>
Aspiring Data Analyst<br>
Skilled in SQL, Power BI, Data Cleaning & Reporting
</p>

<hr>

<p align="center">⭐ If you found this project useful, consider giving it a star!</p>
