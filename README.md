# Retail-Data-Analytics-End-to-End-SQL-Pipeline-Business-Intelligence

📌 Project Overview
This project involves building a robust data pipeline in PostgreSQL to ingest and analyze over 500,000 rows of raw transactional data from a UK-based online retailer. The project demonstrates the full lifecycle of data management, from overcoming complex ingestion hurdles to generating executive-level business insights using advanced SQL techniques like Common Table Expressions (CTEs) and Window Functions.

📊 Business Problem
A growing online retailer needs to move away from spreadsheet-based tracking to a scalable database solution. The goal is to identify high-value customer segments, analyze monthly revenue growth, and pinpoint "hero" products to drive strategic marketing and inventory decisions.

🛠️ Key Challenges & Technical Solutions
Encoding Conflicts: The raw dataset contained regional symbols (like the British Pound £) that caused UTF-8 ingestion failures. I resolved this by identifying and implementing LATIN1 encoding in the COPY command.

Date Formatting Hurdles: The source data used a non-standard DD-MM-YYYY format, which conflicted with PostgreSQL's default MDY expectation. I bypassed this by dynamically setting the session datestyle to DMY.

Data Integrity & Cleaning: Managed "dirty" data, including missing customer IDs and negative quantities (returns), by building a secondary cleaning layer within analytical queries to ensure accuracy.
