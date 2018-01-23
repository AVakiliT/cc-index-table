-- detect domains with language translations by URL path
--   - only for URLs in the Vatican State (.va) top-level domain
--     (a small but multi-lingual TLD for demonstration purposes)
--   - extract two-letter ISO-639-1 language codes in the URL path
--     (using a rather simplistic regular expression)
--   - and show the domain with
--     - page count
--     - number of distinct languages
--     - number of pages per language as map/histogram
--   - only output domains with at least 100 pages and
--     at least one language code in the URL path
SELECT url_host_registered_domain,
       COUNT(DISTINCT(url_path_lang)) as n_lang,
       COUNT(*) as n_pages,
       histogram(DISTINCT(url_path_lang)) as lang_counts
FROM "ccindex"."ccindex",
  UNNEST(regexp_extract_all(url_path, '(?<=/)(?:[a-z][a-z])(?=/)')) AS t (url_path_lang)
WHERE crawl = 'CC-MAIN-2017-47'
  AND subset = 'warc'
  AND url_host_registry_suffix = 'va'
GROUP BY url_host_registered_domain
HAVING COUNT(*) >= 100
   AND COUNT(DISTINCT(url_path_lang)) >= 1
ORDER BY n_pages DESC;
