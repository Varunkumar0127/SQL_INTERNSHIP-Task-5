## INNER JOIN: show booking details with guest name and room number
SELECT b.BookingID, g.GuestID, g.Name, r.RoomNumber, b.CheckInDate, b.CheckOutDate, b.TotalAmount
FROM bookings b
INNER JOIN guests g ON b.GuestID = g.GuestID
INNER JOIN rooms r ON b.RoomID = r.RoomID;

## LEFT JOIN — all bookings and payments (even if no payment yet)
SELECT b.BookingID, g.Name, r.RoomNumber, b.TotalAmount, p.PaymentID, p.AmountPaid
FROM bookings b
LEFT JOIN payments p ON b.BookingID = p.BookingID
LEFT JOIN guests g ON b.GuestID = g.GuestID
LEFT JOIN rooms r ON b.RoomID = r.RoomID;

## RIGHT JOIN: show payments and their booking info (useful if payments table may have orphan rows)
SELECT p.PaymentID, p.AmountPaid, b.BookingID, g.Name
FROM payments p
RIGHT JOIN bookings b ON p.BookingID = b.BookingID
LEFT JOIN guests g ON b.GuestID = g.GuestID;

## Simulate FULL OUTER JOIN between bookings and payments
SELECT b.BookingID, p.PaymentID, b.TotalAmount, p.AmountPaid
FROM bookings b
LEFT JOIN payments p ON b.BookingID = p.BookingID
UNION
SELECT b.BookingID, p.PaymentID, b.TotalAmount, p.AmountPaid
FROM bookings b
RIGHT JOIN payments p ON b.BookingID = p.BookingID;

## Join 4 tables: guest summary per booking including total services cost and payments
SELECT b.BookingID, g.Name,
       r.RoomNumber,
       b.CheckInDate, b.CheckOutDate,
       (pmt.TotalPaid) AS TotalPaid,
       (svc.TotalServices) AS TotalServicesCost,
       b.TotalAmount
FROM bookings b
JOIN guests g ON b.GuestID = g.GuestID
JOIN rooms r ON b.RoomID = r.RoomID
LEFT JOIN (
    SELECT BookingID, sum(AmountPaid) AS TotalPaid
    FROM payments
    GROUP BY BookingID
) pmt ON b.BookingID = pmt.BookingID
LEFT JOIN (
    SELECT BookingID, sum(ServiceCost) AS TotalServices
    FROM services_used
    GROUP BY BookingID
) svc ON b.BookingID = svc.BookingID;

## CROSS JOIN example: every room × every guest (huge result if tables big)
SELECT g.GuestID, g.Name, r.RoomNumber
FROM guests g
CROSS JOIN rooms r
LIMIT 20;

## SELF JOIN on bookings: pairs of bookings by the same guest (where booking id differs)
SELECT b1.BookingID AS BookingA, b2.BookingID AS BookingB, g.GuestID, g.Name
FROM bookings b1
JOIN bookings b2 ON b1.GuestID = b2.GuestID AND b1.BookingID < b2.BookingID
JOIN guests g ON b1.GuestID = g.GuestID
LIMIT 50;

## NATURAL JOIN example (only if columns have same names and meanings)
-- WARNING: auto-matches columns with same names — safer to use explicit ON
SELECT *
FROM bookings
NATURAL JOIN guests
LIMIT 10;







