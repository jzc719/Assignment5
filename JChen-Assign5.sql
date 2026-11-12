-- 1
SELECT SUM(quantityOnHand) AS antibioticsOnHand
FROM item
WHERE itemDescription = 'bottle of antibiotics';

-- 2
SELECT volunteerName
FROM volunteer
WHERE volunteerTelephone NOT LIKE '2%'
  AND TRIM(volunteerName) NOT LIKE '% Jones'
ORDER BY volunteerName;

-- 3
SELECT DISTINCT v.volunteerName
FROM volunteer AS v
JOIN assignment AS a ON a.volunteerId = v.volunteerId
JOIN task AS t ON t.taskCode = a.taskCode
JOIN task_type AS tt ON tt.taskTypeId = t.taskTypeId
WHERE tt.taskTypeName = 'transporting'
ORDER BY v.volunteerName;

-- 4
SELECT t.taskDescription
FROM task AS t
LEFT JOIN assignment AS a ON a.taskCode = t.taskCode
WHERE a.taskCode IS NULL
ORDER BY t.taskCode;

-- 5
SELECT DISTINCT pt.packageTypeName
FROM package_type AS pt
JOIN package AS p ON p.packageTypeId = pt.packageTypeId
JOIN package_contents AS pc ON pc.packageId = p.packageId
JOIN item AS i ON i.itemId = pc.itemId
WHERE i.itemDescription LIKE '%bottle%'
ORDER BY pt.packageTypeName;

-- 6
SELECT i.itemDescription
FROM item AS i
LEFT JOIN package_contents AS pc ON pc.itemId = i.itemId
WHERE pc.itemId IS NULL
ORDER BY i.itemDescription;

-- 7
SELECT DISTINCT t.taskDescription
FROM task AS t
JOIN assignment AS a ON a.taskCode = t.taskCode
JOIN volunteer AS v ON v.volunteerId = a.volunteerId
WHERE TRIM(v.volunteerAddress) LIKE '% NJ'
ORDER BY t.taskDescription;

-- 8
SELECT DISTINCT v.volunteerName
FROM volunteer AS v
JOIN assignment AS a ON a.volunteerId = v.volunteerId
WHERE a.startDateTime >= '2021-01-01'
  AND a.startDateTime < '2021-07-01'
ORDER BY v.volunteerName;

-- 9
SELECT DISTINCT v.volunteerName
FROM volunteer AS v
JOIN assignment AS a ON a.volunteerId = v.volunteerId
JOIN package AS p ON p.taskCode = a.taskCode
JOIN package_contents AS pc ON pc.packageId = p.packageId
JOIN item AS i ON i.itemId = pc.itemId
WHERE i.itemDescription = 'can of spam'
ORDER BY v.volunteerName;

-- 10
SELECT DISTINCT i.itemDescription
FROM item AS i
JOIN package_contents AS pc ON pc.itemId = i.itemId
WHERE pc.itemQuantity * i.itemValue = 100
ORDER BY i.itemDescription;

-- 11
SELECT s.taskStatusName, COUNT(DISTINCT a.volunteerId) AS volunteerCount
FROM task_status AS s
LEFT JOIN task AS t ON t.taskStatusId = s.taskStatusId
LEFT JOIN assignment AS a ON a.taskCode = t.taskCode
GROUP BY s.taskStatusId, s.taskStatusName
ORDER BY volunteerCount DESC, s.taskStatusName;

-- 12
SELECT taskCode, SUM(packageWeight) AS totalWeight
FROM package
GROUP BY taskCode
ORDER BY totalWeight DESC, taskCode
LIMIT 1;

-- 13
SELECT COUNT(*) AS nonPackingTaskCount
FROM task AS t
JOIN task_type AS tt ON tt.taskTypeId = t.taskTypeId
WHERE tt.taskTypeName <> 'packing';

-- 14
SELECT i.itemDescription
FROM item AS i
JOIN package_contents AS pc ON pc.itemId = i.itemId
JOIN package AS p ON p.packageId = pc.packageId
LEFT JOIN assignment AS a ON a.taskCode = p.taskCode
GROUP BY i.itemId, i.itemDescription
HAVING COUNT(DISTINCT a.volunteerId) < 3
ORDER BY i.itemDescription;

-- 15
SELECT pc.packageId, SUM(pc.itemQuantity * i.itemValue) AS totalValue
FROM package_contents AS pc
JOIN item AS i ON i.itemId = pc.itemId
GROUP BY pc.packageId
HAVING SUM(pc.itemQuantity * i.itemValue) > 100
ORDER BY totalValue, pc.packageId;
