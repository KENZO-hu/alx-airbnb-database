# ALX Airbnb Database - Complex Queries with Joins

## Project Overview

This project is part of the ALX Airbnb Database Module, focusing on advanced SQL querying techniques. The goal is to master different types of SQL joins and write complex queries for data retrieval and analysis.

## Task 0: Write Complex Queries with Joins

### Objective
Master SQL joins by writing complex queries using different types of joins to retrieve meaningful data from the Airbnb database.

### Database Schema Assumptions

The queries assume the following table structure:

- **User**: `user_id`, `first_name`, `last_name`, `email`, `phone_number`, `role`, `created_at`
- **Booking**: `booking_id`, `property_id`, `user_id`, `start_date`, `end_date`, `total_price`, `status`, `created_at`
- **Property**: `property_id`, `host_id`, `name`, `description`, `location`, `pricepernight`, `created_at`
- **Review**: `review_id`, `property_id`, `user_id`, `rating`, `comment`, `created_at`

### Queries Implemented

#### 1. INNER JOIN Query
**Purpose**: Retrieve all bookings and the respective users who made those bookings.

**Key Features**:
- Returns only records where both booking and user exist
- Shows complete booking information with associated user details
- Ordered by booking creation date (most recent first)

#### 2. LEFT JOIN Query
**Purpose**: Retrieve all properties and their reviews, including properties that have no reviews.

**Key Features**:
- Returns all properties, even those without reviews
- Shows NULL values for review fields when no reviews exist
- Useful for identifying properties that need more reviews

#### 3. FULL OUTER JOIN Query
**Purpose**: Retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.

**Key Features**:
- Returns all users and all bookings
- Shows orphaned records on both sides
- Useful for data integrity checks

### Additional Analysis Queries

The file also includes enhanced queries for:
- Counting bookings per user with total spending
- Calculating average ratings per property
- Identifying orphaned records (users without bookings and bookings without users)

### Usage Instructions

1. Ensure you have access to the Airbnb database with the required tables
2. Execute the queries in your preferred SQL client
3. Review the results to understand the relationships between tables

### Performance Considerations

- These queries may benefit from indexes on join columns (`user_id`, `property_id`)
- For large datasets, consider adding `LIMIT` clauses during testing
- Monitor query execution times using `EXPLAIN` or `EXPLAIN ANALYZE`

### Files Structure

```
database-adv-script/
├── joins_queries.sql    # Main SQL queries file
└── README.md           # This documentation file
```

### Learning Outcomes

After completing this task, you will have:
- Mastered different types of SQL joins
- Understanding of when to use each join type
- Experience with complex query writing
- Knowledge of data retrieval patterns in relational databases

### Next Steps

This task prepares you for more advanced topics including:
- Subqueries and CTEs
- Window functions
- Query optimization
- Database performance tuning
# ALX Airbnb Database - Subqueries

## Task 1: Practice Subqueries

### Objective
Write both correlated and non-correlated subqueries to demonstrate advanced SQL querying capabilities.

### Instructions Completed
- ✅ Write a query to find all properties where the average rating is greater than 4.0 using a subquery
- ✅ Write a correlated subquery to find users who have made more than 3 bookings

## Queries Implemented

### 1. Non-Correlated Subquery
**Purpose**: Find all properties where the average rating is greater than 4.0

```sql
SELECT 
   p.property_id,
   p.name AS property_name,
   p.host_id,
   p.location,
   p.pricepernight,
   p.description
FROM
   Property p
WHERE
   p.property_id IN (
    SELECT 
        r.property_id
    FROM
        Review r
    GROUP BY
        r.property_id
    HAVING
        AVG(r.rating) > 4.0
   );
```

**Explanation**:
- This is a **non-correlated subquery** because the inner query is independent of the outer query
- The subquery executes once and returns all property IDs with average rating > 4.0
- The outer query then filters properties based on these IDs
- Uses `HAVING` clause to filter grouped results after aggregation

### 2. Correlated Subquery
**Purpose**: Find users who have made more than 3 bookings

```sql
SELECT 
     u.user_id,
     u.first_name,
     u.last_name,
     u.email,
     u.phone_number,
     u.role
FROM 
   User u
WHERE
   (SELECT COUNT(*)
   FROM Booking b
   WHERE b.user_id = u.user_id) > 3;
```

**Explanation**:
- This is a **correlated subquery** because the inner query references the outer query (`u.user_id`)
- The subquery executes once for each row in the User table
- For each user, it counts their bookings and checks if the count exceeds 3
- The correlation happens through `WHERE b.user_id = u.user_id`

## Key Differences

| Feature | Non-Correlated Subquery | Correlated Subquery |
|---------|------------------------|-------------------|
| **Independence** | Inner query is independent | Inner query references outer query |
| **Execution** | Executes once | Executes once per outer row |
| **Performance** | Generally faster | Can be slower on large datasets |
| **Use Case** | Filtering with static criteria | Row-by-row comparisons |

## Database Schema Assumptions

The queries assume these table structures:

```
Property
├── property_id (Primary Key)
├── name
├── host_id
├── location
├── pricepernight
└── description

User
├── user_id (Primary Key)
├── first_name
├── last_name
├── email
├── phone_number
└── role

Review
├── review_id (Primary Key)
├── property_id (Foreign Key)
├── use
# ALX Airbnb Database - Aggregations and Window Functions

## Task Objective

Use SQL aggregation and window functions to analyze data and gain insights into booking patterns, user behavior, and property performance.

## Instructions Completed
- ✅ Write a query to find the total number of bookings made by each user using COUNT function and GROUP BY clause
- ✅ Use window functions (ROW_NUMBER, RANK) to rank properties based on total number of bookings

## Core Queries Implemented

### 1. Aggregation Query - User Booking Counts

**Purpose**: Find the total number of bookings made by each user

```sql
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
ORDER BY 
    total_bookings DESC;
```

**Key Concepts**:
- **COUNT()**: Aggregation function to count bookings
- **GROUP BY**: Groups results by user attributes
- **LEFT JOIN**: Includes users with zero bookings
- **ORDER BY**: Sorts by booking count (highest first)

### 2. Window Functions - Property Rankings

**Purpose**: Rank properties based on total number of bookings received

```sql
-- Using ROW_NUMBER
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.location
ORDER BY 
    total_bookings DESC;

-- Using RANK
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank_position
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.location
ORDER BY 
    total_bookings DESC;
```

## Window Functions Explained

### ROW_NUMBER() vs RANK() vs DENSE_RANK()

| Function | Behavior | Example Results |
|----------|----------|-----------------|
| **ROW_NUMBER()** | Assigns unique sequential numbers | 1, 2, 3, 4, 5 |
| **RANK()** | Same rank for ties, gaps after ties | 1, 2, 2, 4, 5 |
| **DENSE_RANK()** | Same rank for ties, no gaps | 1, 2, 2, 3, 4 |

### Window Function Syntax
```sql
function_name() OVER (
    [PARTITION BY column1, column2, ...]
    [ORDER BY column1 ASC/DESC, column2 ASC/DESC, ...]
    [ROWS/RANGE frame_specification]
)
```

## Advanced Examples Included

### 3. Monthly Booking Statistics
- Aggregates bookings by year and month
- Calculates unique users, properties, and revenue
- Uses `EXTRACT()` function for date parts

### 4. Running Totals and Moving Averages
- **Running totals**: Cumulative sum over time
- **Moving averages**: 3-booking rolling average
- **Window frames**: `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`

### 5. Partitioned Rankings
- Rankings within each property using `PARTITION BY`
- Booking sequence and price rankings per property

### 6. User Behavior Analysis
- Multiple aggregations with window functions
- Spending quartiles using `NTILE(4)`
- Multiple ranking criteria

### 7. Property Performance Dashboard
- Comprehensive property metrics
- Multiple ranking dimensions
- Percentile rankings using `PERCENT_RANK()`

### 8. Time-Series Analysis
- Month-over-month comparisons using `LAG()`
- Year-over-year analysis
- Rolling 12-month averages

## Key Concepts Demonstrated

### Aggregation Functions
- **COUNT()**: Count non-null values
- **SUM()**: Total of numeric values
- **AVG()**: Average of numeric values
- **MIN()/MAX()**: Minimum/maximum values

### Window Functions Categories

#### 1. Ranking Functions
- `ROW_NUMBER()`: Unique sequential numbering
- `RANK()`: Ranking with gaps for ties
- `DENSE_RANK()`: Ranking without gaps
- `NTILE(n)`: Divide into n equal groups

#### 2. Aggregate Window Functions
- `SUM() OVER()`: Running totals
- `AVG() OVER()`: Moving averages
- `COUNT() OVER()`: Running counts

#### 3. Value Functions
- `LAG()`: Previous row value
- `LEAD()`: Next row value
- `FIRST_VALUE()`: First value in window
- `LAST_VALUE()`: Last value in window

#### 4. Statistical Functions
- `PERCENT_RANK()`: Percentile ranking
- `CUME_DIST()`: Cumulative distribution

## Business Applications

### User Analysis
- **Customer Segmentation**: Identify frequent vs occasional users
- **Loyalty Programs**: Target high-booking users
- **Marketing**: Focus on user acquisition vs retention

### Property Analysis
- **Performance Ranking**: Identify top-performing properties
- **Inventory Management**: Focus on popular properties
- **Host Relations**: Recognize successful hosts

### Revenue Analysis
- **Trend Analysis**: Monthly/seasonal patterns
- **Forecasting**: Use historical data for predictions
- **Performance Metrics**: Track key business indicators

## Performance Considerations

### Aggregation Optimization
- **Indexes**: Create indexes on GROUP BY columns
- **Selective Filtering**: Use WHERE clauses before GROUP BY
- **Column Selection**: Only select needed columns

### Window Function Optimization
- **Partitioning**: Use PARTITION BY to reduce window size
- **Ordering**: Efficient ORDER BY with proper indexes
- **Frame Specification**: Limit window frame size when possible

### Best Practices
1. **Index Strategy**: Index columns used in PARTITION BY and ORDER BY
2. **Memory Usage**: Be cautious with large window frames
3. **Query Planning**: Use EXPLAIN ANALYZE to understand execution
4. **Data Volume**: Consider data partitioning for large tables

## Database Schema Requirements

```sql
User Table:
- user_id (Primary Key)
- first_name
- last_name  
- email

Property Table:
- property_id (Primary Key)
- name
- host_id
- location
- pricepernight

Booking Table:
- booking_id (Primary Key)
- property_id (Foreign Key)
- user_id (Foreign Key)
- start_date
- total_price

Review Table:
- review_id (Primary Key)
- property_id (Foreign Key)
- user_id (Foreign Key)
- rating
```

## Usage Instructions

1. **Setup**: Ensure tables exist with appropriate sample data
2. **Execution**: Run queries individually to understand each concept
3. **Analysis**: Compare results between different window functions
4. **Optimization**: Use EXPLAIN ANALYZE to study performance

## Learning Outcomes

After completing this task, you will understand:

- **Aggregation Functions**: How to summarize data using GROUP BY
- **Window Functions**: Advanced analytical capabilities
- **Performance Analysis**: Ranking and percentile calculations
- **Time-Series Analysis**: Trend analysis and comparisons
- **Business Intelligence**: Practical applications for data analysis

## Files Structure

```
database-adv-script/
├── aggregations_and_window_functions.sql    # Main SQL queries
└── README.md                               # This documentation
```

## Next Steps

This foundation prepares you for:
- Advanced analytics and reporting
- Data warehouse design patterns
- Business intelligence dashboards
- Performance monitoring systems

---

**Repository**: alx-airbnb-database  
**Directory**: database-adv-script  
**Files**: aggregations_and_window_functions.sql, README.md