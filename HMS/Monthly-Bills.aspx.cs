using System;
using System.Data;
using System.Configuration;
using Telerik.Web.UI;
using System.Data.SqlClient;
using System.Globalization;
using System.Threading;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.OpenXml.Xlsx;
using System.Text;
using Telerik.Windows.Documents.Spreadsheet.Model;
using Telerik.Windows.Documents.Spreadsheet.Model.Printing;
using Telerik.Windows.Documents.Model;
using System.IO;
using System.Web;
using HelpersLibrary;

public partial class Monthly_Bills : System.Web.UI.Page
{
    public int Year { get; set; } = DateTime.Now.Year;

    protected void Page_Load(object sender, EventArgs e)
    {

        CultureInfo currentCulture = new CultureInfo(Thread.CurrentThread.CurrentCulture.LCID);
        currentCulture.NumberFormat.CurrencySymbol = "\u20B5";
        Thread.CurrentThread.CurrentCulture = currentCulture;
        /*var year = Request.QueryString?["year"];
        try
        {
            Year = int.Parse(year);
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Source);
        }
        if ((year is null) && hfYear.Value != "")*/
        {
            try
            {
                Year = int.Parse(hfYear.Value);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Source);
            }
        }
        RadGrid1.MasterTableView.Caption = String.Format("<h3>Montly Bills for {0}</h3>", Year);
        RadGrid1.ExportSettings.FileName = "Monthly Bills - " + Year.ToString();
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        RadGrid1.GridExporting += RadGrid1_GridExporting;
    }

    protected void RadGrid1_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
    {
        String connectionString = ConfigurationManager.ConnectionStrings["HMDB"].ConnectionString;
        String query = SQLHelper.GetQueryString("monthly_bills.sql");
        SqlConnection connection = new SqlConnection(connectionString);
        using (SqlDataAdapter adapter = new SqlDataAdapter())
        {
            adapter.SelectCommand = new SqlCommand(query, connection);

            adapter.SelectCommand.Parameters.AddWithValue("@year0", Year);

            for (int i = 1; i <= 12; i++)
            {
                adapter.SelectCommand.Parameters.AddWithValue("@year" + i, Year);
                adapter.SelectCommand.Parameters.AddWithValue("@month" + i, i);
            }

            DataTable myDataTable = new DataTable();

            connection.Open();
            try
            {
                adapter.Fill(myDataTable);
            }
            finally
            {
                connection.Close();
            }

            RadGrid1.DataSource = myDataTable;
        }
    }

    protected void RadGrid1_GridExporting(object sender, GridExportingArgs e)
    {
        string exportOutput = e.ExportOutput;
        ExportType exportType = e.ExportType;
        if (exportType == ExportType.ExcelXlsx)
        {
            XlsxFormatProvider xlsxProvider = new XlsxFormatProvider();
            Workbook workBook = xlsxProvider.Import(Encoding.Default.GetBytes(exportOutput));
            WorksheetPageSetup pageSetup = workBook.ActiveWorksheet.WorksheetPageSetup;

            pageSetup.PageOrientation = PageOrientation.Landscape;

            byte[] data = null;
            using (MemoryStream ms = new MemoryStream())
            {
                xlsxProvider.Export(workBook, ms);
                data = ms.ToArray(); // get the byte data of the document
            }
            // send the data in the response for download
            Response.Clear();
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.Headers.Remove("Content-Disposition");
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + RadGrid1.ExportSettings.FileName + ".xlsx");
            Response.BinaryWrite(data);
            Response.End();

        }
        else if (e.ExportType == ExportType.Word)
        {
            e.ExportOutput = e.ExportOutput.Replace("<body>", "<body><div class=WordSection1>");
            e.ExportOutput = e.ExportOutput.Replace("</body>", "</div></body>");
        }
        else if (e.ExportType == ExportType.Excel)
        {
            string css = "<style> td { border:solid 0.1pt #000000;}</style>";
            e.ExportOutput = e.ExportOutput.Replace("</head>", css + "</head>");
        }
    }

    protected void RadGrid1_HTMLExporting(object sender, GridHTMLExportingEventArgs e)
    {
        if (Response.ContentType.Contains("excel"))
        {
            e.Styles.Append("<!--table @page { mso-page-orientation:landscape;} -->");

            e.XmlOptions = "<xml><x:ExcelWorkbook>" +
                            "<x:ExcelWorksheets><x:ExcelWorksheet><x:WorksheetOptions>" +
                            "<x:Print><x:ValidPrinterInfo/></x:Print>" +
                            "</x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets>" +
                            "</x:ExcelWorkbook></xml>";
        }
        else
        {
            e.Styles.Append("<!-- @page WordSection1 { size: 297mm 210mm; margin:0.50in 1.0in 0.50in 1.0in;}" +
       "div.WordSection1 {page:WordSection1;} table{border-collapse:collapse; font-size:10pt} -->");
        }
    }

    protected void RadGrid1_ExportCellFormatting(object sender, ExportCellFormattingEventArgs e)
    {
        e.Cell.Style["font-size"] = "10pt";
    }

    protected void RadGrid1_FilterCheckListItemsRequested(object sender, GridFilterCheckListItemsRequestedEventArgs e)
    {
        string DataField = (e.Column as IGridDataColumn).GetActiveDataField();
        e.ListBox.DataSource = SQLHelper.GetCompanyDataTable(Year);
        e.ListBox.DataKeyField = DataField;
        e.ListBox.DataTextField = DataField;
        e.ListBox.DataValueField = DataField;
        e.ListBox.DataBind();
    }

    protected void RadToolBarButton1_PreRender(object sender, EventArgs e)
    {
        RadToolBarButton rtbB = (RadToolBarButton)sender;
        RadMonthYearPicker rmyP = (RadMonthYearPicker)rtbB.FindControl("RadMonthYearPicker1");
        rmyP.MaxDate = DateTime.Today;
        rmyP.DateInput.MaxDate = DateTime.Today;
        rmyP.SelectedDate = new DateTime(Year, 1, 1);
    }

    protected void RadToolBar1_ButtonClick(object sender, RadToolBarEventArgs e)
    {
        var urlAuthority = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority);

        if ((e.Item as RadToolBarButton).CommandName.ToString() == "ExportToExcelCommandName")
            RadGrid1.ExportToExcel();

        if ((e.Item as RadToolBarButton).CommandName.ToString() == "ExportToWordCommandName")
            RadGrid1.ExportToWord();

        if ((e.Item as RadToolBarButton).CommandName.ToString() == "BillingHistoryCommandName")
            RadAjaxManager1.Redirect(urlAuthority + "/BillingHistory.aspx");


        if ((e.Item as RadToolBarButton).CommandName.ToString() == "PatientHistoryCommandName")
            RadAjaxManager1.Redirect(urlAuthority + "/PatientMedHistory.aspx");


        if ((e.Item as RadToolBarButton).CommandName.ToString() == "CompanyBillsCommandName")
            RadAjaxManager1.Redirect(urlAuthority + "/Monthly-Bills.aspx");

        if ((e.Item as RadToolBarButton).CommandName.ToString() == "Patients")
            RadAjaxManager1.Redirect(urlAuthority + "/Patients.aspx");

        if ((e.Item as RadToolBarButton).CommandName.ToString() == "Companies")
            RadAjaxManager1.Redirect(urlAuthority + "/Companies.aspx");
    }

    protected void RadMonthYearPicker1_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
    {
        Year = ((DateTime)e.NewDate).Year;
        RadGrid1.MasterTableView.Caption = String.Format("<h3>Montly Bills for {0}</h3>", Year);
        RadGrid1.Rebind();
        // System.Threading.Thread.Sleep(500);
    }

    protected void RadGrid1_PreRender(object sender, EventArgs e)
    {
        
        if (RadGrid1.IsExporting)
        {
            foreach (GridItem item in RadGrid1.MasterTableView.GetItems(GridItemType.FilteringItem, GridItemType.Footer))
            {
                if (item.ItemType == GridItemType.FilteringItem)
                {
                    item.Visible = false;
                }

                if (item.ItemType == GridItemType.Footer)
                {
                    item.Font.Size = new System.Web.UI.WebControls.FontUnit("10pt");
                    for (int i = 1; i < item.Cells.Count; i++)
                    {
                        item.Cells[i].Font.Bold = true;
                        if (RadGrid1.GroupingEnabled)
                            item.Cells[i - 1].Text = item.Cells[i].Text;
                    }
                    if (RadGrid1.GroupingEnabled)
                        item.Cells[item.Cells.Count - 1].Text = "";
                }
            }
        }
    }

    protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
    {
        if (e.Item.Value == "BillingHistory")
        {
            var targetCompany = Request.Form["targetCompany"];
            var urlAuthority = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority);
            RadAjaxManager1.Redirect(urlAuthority + "/BillingHistory.aspx?targetCompany=" + targetCompany);
        }

    }

    protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        //if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
        //{
        //    var item = e.Item.DataItem as DataRowView;
        //    var company = item.Row["Company"].ToString();
        //    var urlAuthority = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority)
        //     + "/BillingHistory.aspx?targetCompany=" + company;
        //    string lsTip = String.Format("Company: {0}<br><a href='{1}'>View Billing History</a>", company, urlAuthority);
        //    e.Item.ToolTip = lsTip;//Its style will be style of the RadToolTipManager style.
        //}
    }

    protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
    {
        var urlAuthority = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority);

        if (e.CommandName == "BillingHistory")
        {
            GridDataItem item = e.Item as GridDataItem;
            var company = item.OwnerTableView.DataKeyValues[item.ItemIndex]["Company"].ToString();
            RadAjaxManager1.Redirect(urlAuthority + string.Format("/BillingHistory.aspx?tc={0}", company));
        }
    }

    protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
    {
        
    }
}

