SELECT  DISTINCT LTRIM(RTRIM(dbo.fnToProperCase(FullName))) 
FullName, 
BiodataID,
LTRIM(RTRIM(UPPER(Company))) Company
FROM PatientBiodatas
WHERE  FullName NOT LIKE '%[[]new]%' AND  FullName <> ''
ORDER BY FullName ASC