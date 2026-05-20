CREATE DATABASE ipl2025; 
USE ipl2025;
CREATE TABLE teams (
    team_id     INT PRIMARY KEY,
    team_name   VARCHAR(50) NOT NULL,
    home_city   VARCHAR(30),
    wins        INT DEFAULT 0,
    losses      INT DEFAULT 0,
    points      INT DEFAULT 0,
    nrr         DECIMAL(5,3)
);
ALTER TABLE teams
RENAME COLUMN team_name TO franchise_name;
ALTER TABLE teams
MODIFY COLUMN nrr DECIMAL(5,3) DEFAULT 0.000;
ALTER TABLE teams
ADD status VARCHAR(20) CHECK (status IN ('Champion', 'Runner Up', 'Qualifier', 'Eliminated'));
DESCRIBE teams;
INSERT INTO teams VALUES
(54, 'Kolkata Knight Riders',       'Kolkata',    5,  7,  12, -0.548,  NULL),
(23, 'Gujarat Titans',              'Ahmedabad',  9,  5,  18,  0.408,  NULL),
(71, 'Sunrisers Hyderabad',         'Hyderabad',  4,  9,   8, -0.422,  NULL),
(12, 'Punjab Kings',                'Mohali',     9,  4,  19,  0.527,  NULL),
(38, 'Delhi Capitals',              'Delhi',      7,  6,  15, -0.211,  NULL),
(95, 'Chennai Super Kings',         'Chennai',    3,  10,  6, -1.103,  NULL),
(47, 'Royal Challengers Bengaluru', 'Bengaluru',  9,  4,  19,  0.317,  NULL),
(66, 'Lucknow Super Giants',        'Lucknow',    5,  8,  10, -0.231,  NULL),
(81, 'Mumbai Indians',              'Mumbai',     8,  6,  16,  0.536,  NULL),
(19, 'Rajasthan Royals',            'Jaipur',     6,  7,  12, -0.313,  NULL);
SELECT * FROM teams;
UPDATE teams SET status = 'Champion'
WHERE franchise_name = (
    SELECT franchise_name FROM (
        SELECT franchise_name FROM teams
        ORDER BY points DESC, nrr DESC
        LIMIT 1
    ) AS temp
);
UPDATE teams SET status = 'Runner Up'
WHERE franchise_name = (
    SELECT franchise_name FROM (
        SELECT franchise_name FROM teams
        WHERE status IS NULL
        ORDER BY points DESC, nrr DESC
        LIMIT 1
    ) AS temp
);
UPDATE teams SET status = 'Qualifier'
WHERE franchise_name IN (
    SELECT franchise_name FROM (
        SELECT franchise_name FROM teams
        WHERE status IS NULL
        ORDER BY points DESC, nrr DESC
        LIMIT 2
    ) AS temp
);
SET SQL_SAFE_UPDATES = 0;

UPDATE teams SET status = 'Eliminated'
WHERE status IS NULL;

SET SQL_SAFE_UPDATES = 1;
SELECT *
FROM teams
ORDER BY points DESC, nrr DESC;
SELECT * 
FROM teams
ORDER BY  points ASC , nrr ASC  ;

SELECT * FROM teams;

SELECT franchise_name FROM teams
WHERE status = 'Champion';

SELECT franchise_name, points, nrr
FROM teams
ORDER BY points DESC, nrr DESC;

SELECT franchise_name, points
FROM teams
WHERE status = 'Eliminated';

SELECT franchise_name, points, status
FROM teams
ORDER BY points DESC, nrr DESC
LIMIT 4;

SELECT SUM(wins) AS total_wins FROM teams;

SELECT AVG(wins) AS avg_wins FROM teams;

SELECT franchise_name, nrr
FROM teams
WHERE nrr > 0
ORDER BY nrr DESC;

SELECT franchise_name,
       ROUND((wins / (wins + losses)) * 100, 2) AS win_percentage
FROM teams
ORDER BY win_percentage DESC;

SELECT status, COUNT(*) AS total_teams
FROM teams
GROUP BY status;

SELECT franchise_name, points,
       RANK() OVER (ORDER BY points DESC, nrr DESC) AS team_rank
FROM teams;

SELECT franchise_name, points
FROM teams
WHERE points > (SELECT AVG(points) FROM teams)
ORDER BY points DESC;

SELECT franchise_name, wins,
CASE
    WHEN wins >= 9 THEN 'Excellent'
    WHEN wins >= 7 THEN 'Good'
    WHEN wins >= 5 THEN 'Average'
    ELSE 'Poor'
END AS performance
FROM teams;
SELECT franchise_name, points,
       DENSE_RANK() OVER (ORDER BY points DESC) AS ranks
FROM teams;

SELECT franchise_name, points,
       SUM(points) OVER (ORDER BY points DESC) AS running_total
FROM teams;
 
CREATE VIEW ipl_standings AS
SELECT franchise_name, wins, losses, points, nrr, status,
       RANK() OVER (ORDER BY points DESC, nrr DESC) AS position
FROM teams;

SELECT * FROM ipl_standings;

SELECT franchise_name, nrr,
CASE
    WHEN nrr > 0.5  THEN 'Strong'
    WHEN nrr > 0    THEN 'Positive'
    WHEN nrr > -0.5 THEN 'Weak'
    ELSE 'Poor'
END AS nrr_tier
FROM teams;

SELECT franchise_name,
       (wins + losses) AS matches_played
FROM teams
ORDER BY matches_played DESC;

SELECT franchise_name, points,
       (SELECT MAX(points) FROM teams) - points AS points_behind_leader
FROM teams
ORDER BY points_behind_leader ASC;

SELECT franchise_name, home_city, wins, losses,
       (wins + losses) AS played,
       ROUND((wins / (wins + losses)) * 100, 2) AS win_pct,
       points, nrr, status,
       RANK() OVER (ORDER BY points DESC, nrr DESC) AS position
FROM teams
ORDER BY position;





