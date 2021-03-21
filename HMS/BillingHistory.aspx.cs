using System;

using System.Data;
using System.Configuration;
using Telerik.Web.UI;
using System.Globalization;
using System.Threading;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.OpenXml.Xlsx;
using System.Text;
using Telerik.Windows.Documents.Spreadsheet.Model;
using Telerik.Windows.Documents.Spreadsheet.Model.Printing;
using Telerik.Windows.Documents.Model;
using System.IO;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class BillingHistory : System.Web.UI.Page
{
    public string Company { get; set; } = "ADAMUS ACACIA";
    public string StartDate { get; set; } = DateTime.Today.AddYears(-1).ToString("yyyy-MM-dd");
    public string EndDate { get; set; } = DateTime.Today.ToString("yyyy-MM-dd");
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            RadGrid1.MasterTableView.GroupsDefaultExpanded = false;
            isGroupExpanded.Value = "";
            //hfStartDate.Value = StartDate ;
            //hfEndDate.Value = EndDate;
            hfCompany.Value = Company;
            /*Company = Request.QueryString?["c"];
            StartDate = Request.QueryString?["sd"];
            EndDate = Request.QueryString?["ed"];*/
        }
        RadGrid1.MasterTableView.GroupsDefaultExpanded = isGroupExpanded.Value == "1" ? true : false;
        CultureInfo currentCulture = new CultureInfo(Thread.CurrentThread.CurrentCulture.LCID);
        currentCulture.NumberFormat.CurrencySymbol = "\u20B5";
        Thread.CurrentThread.CurrentCulture = currentCulture;

        if (Page.IsPostBack)
        {
            RadCalendar calendar = RadToolBarButton1.FindControl("RadCalendar1") as RadCalendar;
            StartDate = calendar.SelectedDates?[0].Date.ToString("yyyy-MM-dd");
            EndDate = calendar.SelectedDates?[calendar.SelectedDates.Count - 1].Date.ToString("yyyy-MM-dd");
            hfStartDate.Value = StartDate;
            hfEndDate.Value = EndDate;
        }
        RadGrid1.MasterTableView.Caption = String.Format("<h3>Billing History for<u> {0}</u> from {1} to {2}</h3>", Company, StartDate, EndDate);
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        RadGrid1.GridExporting += RadGrid1_GridExporting;
    }

    protected void RadGrid1_PreRender(object sender, EventArgs e)
    {
        if (RadGrid1.IsExporting)
        {
            foreach (GridItem item in RadGrid1.MasterTableView.GetItems(GridItemType.FilteringItem, GridItemType.Footer, GridItemType.GroupFooter, GridItemType.GroupHeader))
            {
                if (item.ItemType == GridItemType.FilteringItem)
                {
                    item.Visible = false;
                }

                if (item.ItemType == GridItemType.Footer)
                {
                    item.Font.Size = new System.Web.UI.WebControls.FontUnit("9pt");
                    for (int i = 1; i < item.Cells.Count; i++)
                    {
                        item.Cells[i].Font.Bold = true;
                        if (RadGrid1.GroupingEnabled)
                            item.Cells[i - 1].Text = item.Cells[i].Text;
                    }
                    if (RadGrid1.GroupingEnabled)
                        item.Cells[item.Cells.Count - 1].Text = "";
                }

                if (item.ItemType == GridItemType.GroupFooter)
                {
                    for (int i = 0; i < item.Cells.Count; i++)
                    {
                        item.Cells[i].Font.Bold = true;
                    }
                }

                if (item.ItemType == GridItemType.GroupHeader)
                {
                    for (int i = 0; i < item.Cells.Count; i++)
                    {
                        item.Cells[i].Font.Bold = true;
                    }
                }
            }
        }
        else
        {
            foreach (GridItem item in RadGrid1.MasterTableView.GetItems(GridItemType.FilteringItem))
            {
                // Add a collapse button to expand/collapse all group
                var td = item.Cells[0];
                if (td.FindControl("CollapseExpandAll") is null)
                {
                    RadButton button = new RadButton();
                    button.ID = "CollapseExpandAll";
                    button.ClientIDMode = System.Web.UI.ClientIDMode.Static;
                    button.CssClass = "t-button rgActionButton rgExpand";
                    button.ToolTip = "Expand All Groups";
                    Literal radButtonContent = new Literal();
                    radButtonContent.ID = "radButtonContent";
                    radButtonContent.Text = isGroupExpanded.Value == "1" ? "<span class='t-font-icon rgIcon rgCollapseIcon'></span>" : "<span class='t-font-icon rgIcon rgExpandIcon'></span>";
                    button.Controls.Add(radButtonContent);
                    button.OnClientClicked = "collapseExpandAllGroups";
                    button.AutoPostBack = false;
                    td.CssClass = "rgGroupCol";
                    td.Controls.Add(button);
                }
            }
        }
    }

    protected void CollapseExpandAll_Click(object sender, EventArgs e)
    {
        var collapsed = RadGrid1.MasterTableView.GroupsDefaultExpanded;
        var button = (sender as RadButton);
        button.ToolTip = collapsed ? "Expand All Groups" : "Collapse All Groups";
        RadGrid1.MasterTableView.GroupsDefaultExpanded = !collapsed;
    }

    protected void RadToolBar1_ButtonClick(object sender, RadToolBarEventArgs e)
    {
        if ((e.Item as RadToolBarButton).CommandName.ToString() == "ExportToExcelCommandName")
            RadGrid1.ExportToExcel();

        if ((e.Item as RadToolBarButton).CommandName.ToString() == "ExportToWordCommandName")
            RadGrid1.ExportToWord();
    }

    protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
    {

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

    }

    protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
    {
        String connectionString = ConfigurationManager.ConnectionStrings["HMDB"].ConnectionString;
        String query = SQLHelper.GetQueryString("billing_history_per_company.sql");
        SqlConnection connection = new SqlConnection(connectionString);
        SqlDataAdapter adapter = new SqlDataAdapter();
        adapter.SelectCommand = new SqlCommand(query, connection);

        adapter.SelectCommand.Parameters.AddWithValue("@start_date", StartDate);
        adapter.SelectCommand.Parameters.AddWithValue("@end_date", EndDate);
        adapter.SelectCommand.Parameters.AddWithValue("@company", Company);

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

    protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridGroupFooterItem)
        {
            var valueFooterCell = (e.Item as GridGroupFooterItem)["FullName"];
            valueFooterCell.Text = "";
        }
        else if (e.Item is GridFooterItem)
        {
            var valueFooterCell = (e.Item as GridFooterItem)["FullName"];
            valueFooterCell.Text = "Total Patients: " + valueFooterCell.Text;
        }
    }

    protected void RadToolBarButton1_PreRender(object sender, EventArgs e)
    {
        RadToolBarButton rtbB = (RadToolBarButton)sender;
        RadCalendar calendar = (RadCalendar)rtbB.FindControl("RadCalendar1");
       calendar.RangeSelectionStartDate = DateTime.Parse(StartDate);
        calendar.RangeSelectionEndDate = DateTime.Parse(EndDate);
    }

    protected void RadCalendar1_SelectionChanged(object sender, Telerik.Web.UI.Calendar.SelectedDatesEventArgs e)
    {
       RadCalendar calendar =  sender as RadCalendar;
/*        StartDate = e.SelectedDates[0].Date.ToString("yyyy-MM-dd");
        EndDate = e.SelectedDates[e.SelectedDates.Count-1].Date.ToString("yyyy-MM-dd");*/
        RadGrid1.Rebind();
    }
}
