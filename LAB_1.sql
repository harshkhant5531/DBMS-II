------------------------------------------------------(LAB-1)-----------------------------------------------------------------------	

--- 1. Retrieve a unique genre of songs.
SELECT DISTINCT genre FROM Songs;

--- 2. Find top 2 albums released before 2010.
SELECT * FROM Albums WHERE release_year < 2010 ORDER BY release_year DESC;

--- 3. Insert Data into the Songs Table.
INSERT INTO Songs (song_id, Song_title, duration, genre, album_id) 
VALUES (1245, 'Zaroor', 2.55, 'Feel good', 1005);

SELECT *FROM Songs

--- 4. Change the Genre of the song ‘Zaroor’ to ‘Happy’.
UPDATE Songs 
SET genre = 'Happy' 
WHERE Song_title = 'Zaroor';

SELECT *FROM Songs

--- 5. Delete an Artist ‘Ed Sheeran’.
DELETE FROM Artists 
WHERE Artist_name = 'Ed Sheeran';

--- 6. Add a New Column for Rating in Songs Table.
ALTER TABLE Songs 
ADD Rating DECIMAL(3,2);

SELECT*FROM Songs

--- 7. Retrieve songs whose title starts with 'S'.
SELECT * FROM Songs 
WHERE Song_title LIKE 'S%';

--- 8. Retrieve all songs whose title contains 'Everybody'.
SELECT * FROM Songs 
WHERE Song_title LIKE '%Everybody%';

--- 9. Display Artist Name in Uppercase.
SELECT UPPER(Artist_name) AS artist_name_upper FROM Artists;

--- 10. Find the Square Root of the Duration of a Song ‘Good Luck’.
SELECT SQRT(duration) AS duration_sqrt 
FROM Songs 
WHERE Song_title = 'Good Luck';

--- 11. Find Current Date.
SELECT GETDATE();

--- 12. Find the number of albums for each artist.
SELECT artist_id, COUNT(album_id) AS album_count 
FROM Albums 
GROUP BY artist_id;

--- 13. Retrieve the Album_id which has more than 5 songs in it.
SELECT Albums.Album_id ,COUNT(Songs.Song_id) AS NO_OF_SONGS
FROM Albums
JOIN Songs
ON Albums.Album_id = Songs.Album_id
GROUP BY Albums.Album_id
HAVING COUNT(Songs.Song_id) > 5

--- 14. Retrieve all songs from the album 'Album1' (using Subquery)
SELECT Songs.Song_title
FROM Songs WHERE Songs.Album_id = (SELECT Album_id FROM Albums WHERE Album_title = 'Album1')

---15. Retrieve all albums name from the artist ‘Aparshakti Khurana’ (using Subquery)
SELECT Albums.Album_title
FROM Albums WHERE Albums.Artist_id = (SELECT Artist_id FROM Artists WHERE Artist_name = 'Aparshakti Khurana')

---16. Retrieve all the song titles with its album title.
SELECT Songs.Song_title , Albums.Album_title
FROM Songs
JOIN Albums
ON Songs.Album_id = Albums.Album_id

---17. Find all the songs which are released in 2020.
SELECT Songs.Song_title
FROM Songs
JOIN Albums
ON Songs.Album_id = Albums.Album_id
WHERE Albums.Release_year = 2020

---18. Create a view called ‘Fav_Songs’ from the songs table having songs with song_id 101-105.
CREATE VIEW Fav_Songs AS 
SELECT Song_title , Song_id 
FROM Songs
WHERE Song_id BETWEEN 101 AND 105

SELECT*FROM Fav_Songs


---19. Update a song name to ‘Jannat’ of song having song_id 101 in Fav_Songs view.
UPDATE Fav_Songs
SET Song_title = 'Jannat'
WHERE Song_id = 101

---20. Find all artists who have released an album in 2020.
SELECT Artists.Artist_name
FROM Artists
JOIN Albums
ON Artists.Artist_id = Albums.Artist_id
WHERE Albums.Release_year = 2020

---21. Retrieve all songs by Shreya Ghoshal and order them by duration. 
SELECT Songs.Song_title , Songs.Duration
FROM Albums
INNER JOIN Artists ON Artists.Artist_id = Albums.Artist_id
INNER JOIN Songs ON Albums.Album_id = Songs.Album_id
WHERE Artists.Artist_name = 'Shreya Ghoshal'
ORDER BY Duration


------------------------------------------------------(PART-B)------------------------------------------------------------------

---22. Retrieve all song titles by artists who have more than one album.
SELECT Songs.Song_title
FROM Songs
INNER JOIN Albums ON Songs.album_id = Albums.album_id
INNER JOIN Artists ON Albums.artist_id = Artists.artist_id
WHERE Artists.artist_id IN (
    SELECT artist_id
    FROM Albums
    GROUP BY artist_id
    HAVING COUNT(album_id) > 1
);


---23. Retrieve all albums along with the total number of songs.
SELECT Albums.Album_id, COUNT(Songs.Song_id ) AS TOTAL_SONGS
FROM Albums
LEFT OUTER JOIN Songs ON Albums.Album_id = Songs.Album_id
GROUP BY Albums.Album_id;

---24. Retrieve all songs and release year and sort them by release year. 
SELECT Songs.Song_title,Albums.Release_year 
FROM Albums
INNER JOIN Songs
ON Albums.Album_id = Songs.Album_id
ORDER BY Albums.Release_year

---25. Retrieve the total number of songs for each genre, showing genres that have more than 2 songs.
SELECT Genre, COUNT(*) AS Total_Songs 
FROM Songs 
GROUP BY Genre 
HAVING COUNT(*) > 2;

---26. List all artists who have albums that contain more than 3 songs
SELECT DISTINCT Artists.Artist_name 
FROM Artists 
INNER JOIN Albums ON Artists.Artist_id = Albums.Artist_id 
INNER JOIN Songs ON Albums.Album_id = Songs.Album_id 
GROUP BY Artists.Artist_name, Albums.Album_id 
HAVING COUNT(Songs.Song_id) > 3;




------------------------------------------------------(PART-C)------------------------------------------------------------------
---27. Retrieve albums that have been released in the same year as 'Album4'
SELECT Album_title 
FROM Albums 
WHERE Release_year = (SELECT Release_year FROM Albums WHERE Album_title = 'Album4');

---28. Find the longest song in each genre
SELECT Genre, Song_title, MAX(Duration) AS Longest_Song
FROM Songs
GROUP BY Genre,Song_title;

---29. Retrieve the titles of songs released in albums that contain the word 'Album' in the title.
SELECT Song_title 
FROM Songs 
JOIN Albums ON Songs.Album_id = Albums.Album_id 
WHERE Albums.Album_title LIKE '%Album%';

---30. Retrieve the total duration of songs by each artist where total duration exceeds 15 minutes.
SELECT Artists.Artist_name, SUM(Songs.Duration) AS Total_Duration
FROM Songs
INNER JOIN Albums ON Songs.Album_id = Albums.Album_id
INNER JOIN Artists ON Albums.Artist_id = Artists.Artist_id
GROUP BY Artists.Artist_name
HAVING SUM(Songs.Duration) > 15;


