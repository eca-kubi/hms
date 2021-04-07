SELECT 
[MedHistory].[ID] AS [MedHistory_ID], 
LTRIM(RTRIM(dbo.fnToProperCase(PBD.FullName))) as FullName,
[MedHistory].[Date] AS [Date], 
[MedHistory].[Diagnoses] AS [Diagnoses], 
[MedHistory].[ServiceName] AS [ServiceName], 
[MedHistory].[PackQuantity] AS [PackQuantity], 
[MedHistory].[UnitQuantity] AS [UnitQuantity], 
[MedHistory].[Cost] AS [Cost], 
[MedHistory].[TransactCode] AS [TransactCode], 
[MedHistory].[BoidataID] AS [BoidataID],
[MedHistory].[BoidataID] AS [BiodataID],
[PBD].[Company] AS [Company]
FROM [dbo].[MedicalHistories] AS [MedHistory]
Left Outer join PatientBioDatas as PBD
on PBD.BiodataID=MedHistory.BoidataID
WHERE ([MedHistory].[BoidataID] IS NOT NULL) 
AND (BiodataID = @biodata_id) 
Order By Date DESC