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
        SqlDataAdapter adapter = new SqlDataAdapter();
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

    protected void RadGrid1_GridExporting(object sender, GridExportingArgs e)
    {
        string exportOutput = e.ExportOutput;
        ExportType exportType = e.ExportType;
        if (exportType == ExportType.ExcelXlsx)
        {
            XlsxFormatProvider xlsxProvider = new XlsxFormatProvider();
            Workbook workBook = xlsxProvider.Import(Encoding.Default.GetBytes(e.ExportOutput));
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
            "div.WordSection1 {page:WordSection1;} -->");
        }
    }

    protected void RadGrid1_ExportCellFormatting(object sender, ExportCellFormattingEventArgs e)
    {
        e.Cell.Style["font-size"] = "9pt";
    }

    protected void RadGrid1_FilterCheckListItemsRequested(object sender, GridFilterCheckListItemsRequestedEventArgs e)
    {
        string DataField = (e.Column as IGridDataColumn).GetActiveDataField();
        e.ListBox.DataSource = GetCompanyDataTable(Year);
        e.ListBox.DataKeyField = DataField;
        e.ListBox.DataTextField = DataField;
        e.ListBox.DataValueField = DataField;
        e.ListBox.DataBind();
    }

    public DataTable GetCompanyDataTable(int year)
    {
        string query = SQLHelper.GetQueryString("distinct_companies.sql");
        String connectionString = ConfigurationManager.ConnectionStrings["HMDB"].ConnectionString;
        SqlConnection connection = new SqlConnection(connectionString);
        SqlDataAdapter adapter = new SqlDataAdapter();
        adapter.SelectCommand = new SqlCommand(query, connection);
        adapter.SelectCommand.Parameters.AddWithValue("@year0", year);

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

        return myDataTable;
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
        if ((e.Item as RadToolBarButton).CommandName.ToString() == "ExportToExcelCommandName")
            RadGrid1.ExportToExcel();

        if ((e.Item as RadToolBarButton).CommandName.ToString() == "ExportToWordCommandName")
            RadGrid1.ExportToWord();
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
                    item.Font.Size = new System.Web.UI.WebControls.FontUnit("9pt");
                    item.Cells[2].Font.Bold = true;
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
}

