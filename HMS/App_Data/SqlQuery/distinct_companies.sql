use HMDB;
SELECT DISTINCT LTRIM(RTRIM(UPPER(Company))) AS [Company],
ID
FROM CompanyList
WHERE (Company is not null)
AND (Company NOT LIKE '%[[]new]%')
ORDER BY [Company] ASC