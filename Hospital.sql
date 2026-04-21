create database hospital_analysis;
USE hospital_analysis;


/* ================= KPI 1 : TOTAL REVENUE ================= */
SELECT 
FORMAT(SUM(revenue_realized),0) AS total_revenue
FROM fact_bookings;



/* ================= KPI 2 : TOTAL BOOKINGS ================= */
SELECT 
FORMAT(COUNT(*),0) AS total_bookings
FROM fact_bookings;



/* ================= KPI 3 : CANCELLATION RATE (%) ================= */
SELECT 
ROUND(
SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END)
/ COUNT(*) * 100, 2
) AS cancellation_rate_percent
FROM fact_bookings;



/* ================= KPI 4 : OCCUPANCY (%) ================= */
SELECT 
ROUND(
SUM(successful_bookings) / SUM(capacity) * 100,2
) AS occupancy_percent
FROM fact_aggregated_bookings;


/* ================= KPI 5 : WEEKDAY vs WEEKEND ================= */
SELECT 
d.day_type,
FORMAT(SUM(f.revenue_realized),0) AS revenue,
FORMAT(COUNT(f.booking_id),0) AS bookings
FROM fact_bookings f
JOIN dim_date d
ON f.check_in_date = d.date
GROUP BY d.day_type;

SELECT COUNT(*) FROM fact_bookings;
/* ================= KPI 6 : REVENUE BY STATE & HOTEL ================= */
SELECT 
h.city,
h.property_name,
FORMAT(SUM(f.revenue_realized),0) AS revenue
FROM fact_bookings f
JOIN dim_hotels h 
ON f.property_id = h.property_id
GROUP BY h.city, h.property_name
ORDER BY SUM(f.revenue_realized) DESC;



/* ================= KPI 7 : CLASS WISE REVENUE ================= */
SELECT 
r.room_class,
FORMAT(SUM(f.revenue_realized),0) AS revenue
FROM fact_bookings f
JOIN dim_rooms r
ON f.room_category = r.room_id
GROUP BY r.room_class
ORDER BY SUM(f.revenue_realized) DESC;



/* ================= KPI 8 : CHECKED OUT / CANCEL / NO SHOW ================= */
SELECT 
booking_status,
ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM fact_bookings),2) AS percentage
FROM fact_bookings
GROUP BY booking_status;



/* ================= KPI 9 : WEEKLY TREND ================= */
SELECT 
    d.`week no` AS week_no,
    FORMAT(SUM(f.revenue_realized),0) AS total_revenue,
    FORMAT(COUNT(f.booking_id),0) AS total_bookings
FROM fact_bookings f
JOIN dim_date d
    ON f.check_in_date = d.date
GROUP BY d.`week no`
ORDER BY d.`week no`;