using HelpersLibrary;
using System;
using System.Data;
using System.Globalization;
using System.IO;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.UI;
using Telerik.Web.UI;
using Telerik.Windows.Documents.Model;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.OpenXml.Xlsx;
using Telerik.Windows.Documents.Spreadsheet.Model;
using Telerik.Windows.Documents.Spreadsheet.Model.Printing;

namespace HMS
{
    public partial class PatientMedHistory : System.Web.UI.Page
    {
        public int BioDataID { get; set; } = 0;
        public string DefaultPhoto { get; set; } = "images/profile.png";
        public string DefaultManPhoto { get; set; } = "images/man.jpg";
        public string DefaultWomanPhoto { get; set; } = "images/woman.jpg";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                var biodata_id = hfBiodataID.Value = Request.QueryString["biodata_id"] ?? "0";
                try
                {
                    BioDataID = Convert.ToInt32(biodata_id);
                }
                catch (Exception)
                {
                }

            }
            else
            {
                try
                {
                    BioDataID = Convert.ToInt32(hfBiodataID.Value);
                }
                catch (Exception)
                {
                }
            }

            // Bind Radsearchbox to its datasource
            var searchbox = RadToolBarButton1.FindControl("RadSearchBox1") as RadSearchBox;
            searchbox.DataSource = SQLHelper.GetAllPatients();
            searchbox.DataBind();
            searchbox.SearchContext.DataSource = SQLHelper.GetCompanyDataTable();
            searchbox.SearchContext.DataBind();

            // Select Command for sqldatasource1
            SqlDataSource1.SelectCommand = SQLHelper.GetQueryString("all_patients.sql");

            CultureInfo currentCulture = new CultureInfo(Thread.CurrentThread.CurrentCulture.LCID);
            currentCulture.NumberFormat.CurrencySymbol = "\u20B5";
            Thread.CurrentThread.CurrentCulture = currentCulture;

            UpdateUIAjax();
        }

        protected void Patients_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            var combo = RadToolBarButton1.FindControl("RadComboBox_Patients") as RadComboBox;
            var selectedValue = combo.SelectedValue;
            try
            {
                BioDataID = Convert.ToInt32(selectedValue);
                hfBiodataID.Value = selectedValue;
                RadGrid1.Rebind();
            }
            catch (Exception)
            {

                throw;
            }
        }

        protected void RadToolBar1_ButtonClick(object sender, Telerik.Web.UI.RadToolBarEventArgs e)
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

        protected void RadGrid1_ExportCellFormatting(object sender, Telerik.Web.UI.ExportCellFormattingEventArgs e)
        {
            e.Cell.Style["font-size"] = "10pt";
        }

        protected void RadGrid1_HTMLExporting(object sender, Telerik.Web.UI.GridHTMLExportingEventArgs e)
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

        protected void RadGrid1_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {

        }

        protected void RadGrid1_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            var myDataTable = SQLHelper.GetPatientHistory(BioDataID);
            RadGrid1.DataSource = myDataTable;
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



        protected void RadSearchBox1_Search(object sender, SearchBoxEventArgs e)
        {
            if (e.Value != null)
            {
                BioDataID = Convert.ToInt32(e.Value);
                hfBiodataID.Value = BioDataID.ToString();
                UpdateUIAjax();
            }
        }

        private void UpdateUIAjax()
        {
            var dataTable = SQLHelper.GetPatientBiodata(BioDataID);
            DataRow biodata;
            var profilePhoto = DefaultPhoto;
            var fullName = "";
            var companyName = "";
            var patientID = "";
            if (dataTable.Rows.Count == 0)
            {
                photo.ImageUrl = profilePhoto;
            }
            else
            {
                biodata = dataTable.Rows[0];
                fullName = biodata["fullname"].ToString();
                companyName = biodata["company"].ToString();
                string gender = biodata["gender"].ToString();
                patientID = biodata["patientID"].ToString();
                //Get the byte array from image file
                if (biodata["photo"].ToString() != "")
                {
                    byte[] imgBytes = (byte[])biodata["photo"];
                    //If you want convert to a bitmap file
                    // TypeConverter tc = TypeDescriptor.GetConverter(typeof(Bitmap));
                    // Bitmap MyBitmap = (Bitmap)tc.ConvertFrom(imgBytes);
                    string imgString = Convert.ToBase64String(imgBytes);
                    //Set the source with data:image/bmp
                    //img.Src = String.Format("data:image/Bmp;base64,{0}\"", imgString);   //img is the Image control ID
                    photo.ImageUrl = @String.Format("data:image/jpg;base64,{0}", imgString);
                }
                else
                {
                    photo.ImageUrl = gender == "Male" ? DefaultManPhoto : DefaultWomanPhoto;
                }
            }

            name.InnerText = "Name: " + fullName;
            patient_id.InnerText = "Patient ID: " + patientID;
            company.InnerText = "Company: " + companyName;
            RadGrid1.MasterTableView.Caption = fullName != "" ? "<h4>Medical History for " + fullName + "</h4>" : "<h4>Medical History</h4>";
            RadGrid1.Rebind();
        }

        protected void Previous_Click(object sender, EventArgs e)
        {
            try
            {
                BioDataID = Convert.ToInt32(hfBiodataID.Value);
                UpdateUIAjax();
            }
            catch (Exception)
            {
            }
        }

        protected void Next_Click(object sender, EventArgs e)
        {
            try
            {
                BioDataID = Convert.ToInt32(hfBiodataID.Value);
                UpdateUIAjax();
            }
            catch (Exception)
            {
            }
        }
    }
}