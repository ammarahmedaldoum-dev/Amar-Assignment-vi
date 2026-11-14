# Query Explanations and Analysis Notes

These explanations correspond to the executable scripts under `queries/`. All 13 split setup/query scripts were executed successfully on a temporary MySQL 8.0.46 instance. Review the result grids in your own MySQL Workbench and capture the screenshots required for submission.

## JOIN queries

### INNER JOIN
The INNER JOIN connects orders and order lines to products by their key columns. It returns only product lines with matching order and product records, so it is useful for examining which items were sold and the value of each line.

### LEFT JOIN
The LEFT JOIN starts with all customers and adds matching orders where available. Customers without orders remain in the result with a count of zero, which makes the query useful for identifying customers who may need follow-up.

### RIGHT JOIN
The RIGHT JOIN preserves every branch from the right-hand table and attaches its matching orders. A branch with no order would still appear with an order count of zero, allowing management to check for inactive locations.

### FULL OUTER JOIN equivalent
MySQL does not provide a native FULL OUTER JOIN, so the query unions a left join with a right join. Together they retain matched rows and unmatched rows from both sides; `UNION` removes duplicate matched rows.

### SELF JOIN
The self join links `employees.manager_id` back to `employees.employee_id`. It shows the reporting relationship while retaining employees without a manager through a LEFT JOIN, which is appropriate for top-level managers.

## Window-function interpretation

- `ROW_NUMBER()` assigns a distinct sequential position, including when values tie.
- `RANK()` gives tied values the same rank and leaves gaps after ties.
- `DENSE_RANK()` gives tied values the same rank without gaps.
- `PERCENT_RANK()` expresses a row's relative rank from 0 to 1.
- `SUM() OVER` calculates cumulative revenue while keeping the underlying rows visible.
- `AVG() OVER` compares each order with a branch average and calculates a moving monthly average.
- `MIN()`, `MAX()`, and `COUNT()` provide yearly window summaries without collapsing monthly rows.
- `LAG()` and `LEAD()` retrieve the previous or next month/order for comparison.
- `NTILE(4)` allocates customers ordered by total spending to four groups; the groups may differ by one customer if the customer count is not divisible by four.
- `CUME_DIST()` reports the fraction of rows with values less than or equal to the current row's value.

In the monthly query, the `ROWS` frame counts physical rows and the `RANGE` frame uses the numeric month key. Since the query generates one row for every month, including zero-sales months, the three-month windows include the current and two preceding months.

## Results analysis template

Fill the brackets from your own MySQL output; do not submit the brackets as findings.

1. **Descriptive - what happened?** The highest revenue product was [product] at [amount]. The top branch was [branch] at [amount]. Monthly revenue [describe actual pattern from the twelve rows].
2. **Diagnostic - why might it have happened?** A possible explanation is [hypothesis], but this dataset alone cannot establish causation. To test it, collect [additional evidence, such as inventory, promotions, or foot traffic].
3. **Prescriptive - what should happen next?** Based on [observed result], test [specific action] at [branch/customer group] for [period]. Track [metric] and compare it with a suitable baseline before expanding the action.

## Execution evidence

The `screenshots/joins/` and `screenshots/window_functions/` folders are reserved for genuine MySQL Workbench screenshots. Capture the SQL and successful result grid after running the relevant query. Do not present this draft as if those queries were executed when they were not.
