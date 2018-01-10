-- "word" count in URL paths (parts separated by '/')
--   - only for URLs in the French (.fr) top-level domain
--   - only output words which occur at least 100 times
SELECT url_path_element,
       COUNT(url_path_element) as frequency
FROM "ccindex"."ccindex",
  UNNEST(split(url_path, '/')) AS t (url_path_element)
WHERE crawl = 'CC-MAIN-2017-47'
  AND subset = 'warc'
  AND url_host_reverse[1] = 'fr'
GROUP BY url_path_element
HAVING (COUNT(url_path_element) >= 100)
ORDER BY frequency DESC;