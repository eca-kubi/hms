SELECT 
[MedHistory].[ID] AS [MedHistory_ID], 
PBD.FullName as FullName,
[MedHistory].[Date] AS [Date], 
[MedHistory].[ServiceCategory] AS [ServiceCategory], 
[MedHistory].[ServiceName] AS [ServiceName], 
[MedHistory].[PackQuantity] AS [PackQuantity], 
[MedHistory].[UnitQuantity] AS [UnitQuantity], 
[MedHistory].[Cost] AS [Cost], 
[MedHistory].[TransactCode] AS [TransactCode], 
[MedHistory].[BoidataID] AS [BoidataID]
FROM [dbo].[MedicalHistories] AS [MedHistory]
Left Outer join PatientBioDatas as PBD
on PBD.BiodataID=MedHistory.BoidataID
WHERE ([MedHistory].[BoidataID] IS NOT NULL) AND (Date >= 
@start_date AND Date <= @end_date) AND (Company = @company)