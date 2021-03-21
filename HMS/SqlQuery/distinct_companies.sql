SELECT DISTINCT [p].[company] AS [Company] FROM 
[MedicalHistories] AS [m]
LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
WHERE DatePart(year, [m].[date]) = @year0
AND company is not null
ORDER BY Company ASC