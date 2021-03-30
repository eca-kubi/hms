SELECT DISTINCT LTRIM(RTRIM(UPPER([p].[company]))) AS [Company] FROM 
[MedicalHistories] AS [m]
LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
WHERE DatePart(year, [m].[date]) = @year0
AND Company is not null
AND Company NOT LIKE '%[[]new]%'
ORDER BY Company ASC