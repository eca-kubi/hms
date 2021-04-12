SELECT Distinct LTRIM(RTRIM(dbo.fnToProperCase(FullName))) FullName,
PBD.BiodataID BiodataID
FROM PatientBioDatas as PBD
LEFT OUTER JOIN [MedicalHistories] as MedHistory
on PBD.BiodataID=MedHistory.BoidataID
WHERE ([MedHistory].[BoidataID] IS NOT NULL) AND (Date >= 
@start_date AND Date <= @end_date) AND (Company = @company)
Order  By FullName ASC