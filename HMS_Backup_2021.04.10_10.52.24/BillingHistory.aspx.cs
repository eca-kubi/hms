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
using System.Web;
using System.Collections.Generic;
using HelpersLibrary;

public partial class BillingHistory : System.Web.UI.Page
{
    public string Company { get; set; } = "ADAMUS ACACIA";
    //public string StartDate { get; set; } = DateTime.Today.AddYears(-1).ToString("yyyy-MM-dd");
    public string StartDate { get; set; } = new DateTime(DateTime.Today.Year, 01, 01).ToString("yyyy-MM-dd"); // From first January of current year
    public string EndDate { get; set; } = DateTime.Today.ToString("yyyy-MM-dd"); // To current date
    protected void Page_Load(object sender, EventArgs e)
    {
        RadComboBox combo = RadToolBarButton2.FindControl("RadComboBox1") as RadComboBox;
        RadDatePicker fromDatePicker = PeriodSelector.FindControl("fromDatePicker") as RadDatePicker;
        RadDatePicker toDatePicker = PeriodSelector.FindControl("toDatePicker") as RadDatePicker;
        if (!Page.IsPostBack)
        {
            RadGrid1.MasterTableView.GroupsDefaultExpanded = true;
            isGroupExpanded.Value = "1";
            hfStartDate.Value = StartDate;
            hfEndDate.Value = EndDate;
            hfCompany.Value = Company;
            var company = Request.QueryString?["targetCompany"];
            if (company != null)
            {
                Company = company;
            }
            fromDatePicker.SelectedDate = DateTime.Parse(StartDate);
            toDatePicker.SelectedDate = DateTime.Parse(EndDate);
            toDatePicker.MinDate = fromDatePicker.SelectedDate.Value;

            // Bind datasource to Company dropdownlist
            var companyDropDown = RadToolBarButton2.FindControl("RadDropDownList1") as RadDropDownList;
            companyDropDown.DataSource = SQLHelper.GetCompanyDataTable();
            companyDropDown.DataBind();
        }

        RadGrid1.MasterTableView.GroupsDefaultExpanded = isGroupExpanded.Value == "1";
        CultureInfo currentCulture = new CultureInfo(Thread.CurrentThread.CurrentCulture.LCID);
        currentCulture.NumberFormat.CurrencySymbol = "\u20B5";
        Thread.CurrentThread.CurrentCulture = currentCulture;


        // Bind Radsearchbox to its datasource
        //var searchbox = RadToolBarButton2.FindControl("RadSearchBox1") as RadSearchBox;
        //searchbox.DataSource = SQLHelper.GetCompanyDataTable();
        //searchbox.DataBind();

        if (Page.IsPostBack)
        {
            StartDate = fromDatePicker.SelectedDate.Value.ToString("yyyy-MM-dd");
            EndDate = toDatePicker.SelectedDate.Value.ToString("yyyy-MM-dd");
            Company = hfCompany.Value;
            hfStartDate.Value = StartDate;
            hfEndDate.Value = EndDate;
        }
        RadGrid1.MasterTableView.Caption = String.Format("<h3>Billing History for<u> {0}</u> from {1:MMM dd, yyyy} to {2:MMM dd, yyy}</h3>", Company, DateTime.Parse(StartDate), DateTime.Parse(EndDate));

        var gridCmdItems = RadGrid1.MasterTableView.GetItems(GridItemType.CommandItem);
        if (gridCmdItems.Length != 0)
        {
            GridCommandItem cmdItem = gridCmdItems[0] as GridCommandItem;

            RadSearchBox search = cmdItem.FindControl("RadSearchBox2") as RadSearchBox;
            search.Search += RadSearchBox2_Search;
            search.DataSource = null;
            search.DataSource = SQLHelper.GetDistinctPeriodicPatientsFromCompany(Company, StartDate, EndDate);
            search.DataBind();
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        RadGrid1.GridExporting += RadGrid1_GridExporting;
    }

    protected void RadGrid1_PreRender(object sender, EventArgs e)
    {
        if (RadGrid1.IsExporting)
        {
            foreach (GridItem item in RadGrid1.MasterTableView.GetItems(GridItemType.FilteringItem, GridItemType.Footer, GridItemType.GroupFooter, GridItemType.GroupHeader, GridItemType.CommandItem))
            {
                if (item.ItemType == GridItemType.FilteringItem || item.ItemType == GridItemType.CommandItem)
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
            foreach (GridItem item in RadGrid1.MasterTableView.GetItems(GridItemType.Header))
            {
                // Add a collapse button to expand/collapse all group
                var td = item.Cells[0];
                if (td.FindControl("CollapseExpandAll") is null)
                {
                    using (RadButton button = new RadButton())
                    {
                        button.ID = "CollapseExpandAll";
                        button.ClientIDMode = System.Web.UI.ClientIDMode.Static;
                        button.CssClass = "t-button rgActionButton rgExpand";
                        button.ToolTip = "Expand/Collapse All Groups";
                        using (Literal radButtonContent = new Literal())
                        {
                            radButtonContent.ID = "radButtonContent";
                            radButtonContent.Text = isGroupExpanded.Value == "1" ? "<span class='t-font-icon rgIcon rgCollapseIcon'></span>" : "<span class='t-font-icon rgIcon rgExpandIcon'></span>";
                            button.Controls.Add(radButtonContent);
                        }
                        button.OnClientClicked = "collapseExpandAllGroups";
                        button.AutoPostBack = false;
                        td.CssClass = "rgGroupCol";
                        td.Controls.Add(button);
                    }
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


    }

    protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
    {

    }
    protected void RadGrid1_GridExporting(object sender, GridExportingArgs e)
    {
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
        e.ListBox.DataSource = SQLHelper.GetDistinctPeriodicPatientsFromCompany(hfCompany.Value, hfStartDate.Value, hfEndDate.Value);
        e.ListBox.DataKeyField = DataField;
        e.ListBox.DataTextField = DataField;
        e.ListBox.DataValueField = DataField;
        e.ListBox.DataBind();
    }

    protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
    {
        RadGrid1.DataSource = SQLHelper.GetPeriodicBillingHistoryForCompany(StartDate, EndDate, Company);
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

        if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
        {
            var item = e.Item.DataItem as DataRowView;
            var biodataID = item.Row["BiodataID"].ToString();
            var fullName = item.Row["FullName"].ToString();
            var urlAuthority = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority)
             + "/PatientMedHistory.aspx?biodata_id=" + biodataID;
            string lsTip = String.Format("Patient: {0}<br><a href='{1}'>View Medical History</a>", fullName, urlAuthority);
            e.Item.ToolTip = lsTip;//Its style will be style of the RadToolTipManager style.
        }

        if (e.Item.ItemType == GridItemType.CommandItem)
        {
            GridCommandItem cmdItem = e.Item as GridCommandItem;

            RadSearchBox search = cmdItem.FindControl("RadSearchBox2") as RadSearchBox;
            search.Search += RadSearchBox2_Search;
            search.DataSource = null;
            search.DataSource = SQLHelper.GetDistinctPeriodicPatientsFromCompany(Company, StartDate, EndDate);
            search.DataBind();
        }
    }

    //protected void RadCalendar1_SelectionChanged(object sender, Telerik.Web.UI.Calendar.SelectedDatesEventArgs e)
    //{
    //    RadCalendar calendar = sender as RadCalendar;
    //    /*        StartDate = e.SelectedDates[0].Date.ToString("yyyy-MM-dd");
    //            EndDate = e.SelectedDates[e.SelectedDates.Count-1].Date.ToString("yyyy-MM-dd");*/
    //    RadGrid1.Rebind();
    //}

    protected void ToDatePicker_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
    {
        UpdateUIAjax();
    }


    protected void RadSearchBox1_Search(object sender, SearchBoxEventArgs e)
    {
        if (e.Value != null)
        {
            Company = e.Value;
            UpdateUIAjax();
        }
    }

    private void UpdateUIAjax()
    {
        RadGrid1.MasterTableView.Caption = String.Format("<h3>Billing History for<u> {0}</u> from {1:MMM dd, yyyy} to {2:MMM dd, yyy}</h3>", Company, DateTime.Parse(StartDate), DateTime.Parse(EndDate));
        RadGrid1.Rebind();
    }

    protected void RadDropDownList1_ItemSelected(object sender, DropDownListEventArgs e)
    {
        string value = e.Value.ToString();
        Company = value;
        hfCompany.Value = value;
        UpdateUIAjax();
    }


    protected void RadSearchBox2_Search(object sender, SearchBoxEventArgs e)
    {
        if (e.DataItem != null)
        {
            int biodataID = 0;
            try
            {
                biodataID = Convert.ToInt32(((Dictionary<string, object>)e.DataItem)["BiodataID"].ToString());
            }
            catch (Exception)
            { }

            if (biodataID != 0)
            {
                var gridDataSource = SQLHelper.GetPatientHistory(biodataID);
                RadGrid1.DataSource = null;
                RadGrid1.DataSource = gridDataSource;
                RadGrid1.DataBind();
            }

        }
    }

    protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
    {
        /*GridCommandItem cmdItem = e.Item as GridCommandItem;
        if (e.Item.ItemType == GridItemType.CommandItem)
        {
            RadSearchBox search = cmdItem.FindControl("RadSearchBox2") as RadSearchBox;
            search.Search += RadSearchBox2_Search;
            search.DataSource = null;
            search.DataSource = SQLHelper.GetDistinctPeriodicPatientsFromCompany(Company, StartDate, EndDate);
            search.DataBind();
        }*/
    }

    protected void RadSearchBox2_ButtonCommand(object sender, SearchBoxButtonEventArgs e)
    {
        if (e.CommandName == "ClearFilter")
        {
            RadGrid1.DataSource = null;
            RadGrid1.DataSource = SQLHelper.GetPeriodicBillingHistoryForCompany(StartDate, EndDate, Company);
            RadGrid1.DataBind();
        }
    }
}
