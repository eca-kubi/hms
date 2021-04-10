using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Collections.Generic;
using HelpersLibrary;
public partial class Patients : System.Web.UI.Page
{
    private string gridMessage = null;
    const int MaxTotalBytes = 1048576; // 1 MB
    Int64 totalBytes;
    byte[] photoData = null;

    public bool IsGridFiltered
    {
        get
        {
            if (Session["IsGridFiltered"] == null)
            {
                Session["IsGridFiltered"] = false;
            }
            return Convert.ToBoolean(Session["IsGridFiltered"].ToString());
        }

        set
        {
            Session["IsGridFiltered"] = value;
        }
    }
   
    public bool? IsRadAsyncValid
    {
        get
        {
            if (Session["IsRadAsyncValid"] == null)
            {
                Session["IsRadAsyncValid"] = true;
            }

            return Convert.ToBoolean(Session["IsRadAsyncValid"].ToString());
        }
        set
        {
            Session["IsRadAsyncValid"] = value;
        }
    }

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);

        IsRadAsyncValid = null;

        CompanyDataSource.SelectCommand = SQLHelper.GetQueryString("distinct_companies.sql");
        AllPatientsDataSource.SelectCommand = SQLHelper.GetQueryString("all_patients_biodata.sql");

        if (GridFiltered.Value == "1" && Page.IsPostBack)
        {
            DataSource1.SelectParameters.Clear();
            DataSource1.SelectParameters.Add("FullName", SBInputValue.Value);
            DataSource1.SelectCommand = SQLHelper.GetQueryString("patient_biodata_filter_by_fullname.sql");
        } else
        {
            DataSource1.SelectCommand = SQLHelper.GetQueryString("all_patients_biodata.sql");
        }
    }

    //protected void Page_Prerender(object sender, EventArgs e)
    //{
    //    GridCommandItem cmdItem = (GridCommandItem)RadGrid1.MasterTableView.GetItems(GridItemType.CommandItem)[0];
    //    RadToolBar RadToolBar1 = cmdItem.FindControl("RadGrid1ToolBar") as RadToolBar;
    //    RadSearchBox sb =  RadToolBar1.FindItemByText("SearchBox").FindControl("RadSearchBox1") as RadSearchBox;

    //}

    protected void RadGrid1_DataBound(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(gridMessage))
        {
            DisplayMessage(gridMessage);
        }
    }

    protected void RadGrid1_ItemUpdated(object source, Telerik.Web.UI.GridUpdatedEventArgs e)
    {
        if (e.Exception != null)
        {
            e.KeepInEditMode = true;
            e.ExceptionHandled = true;
            SetMessage("Update failed. Reason: " + e.Exception.Message);
        }
        else
        {
            SetMessage("Item updated!");
        }
    }

    protected void RadGrid1_ItemInserted(object source, GridInsertedEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            SetMessage("Insert failed! Reason: " + e.Exception.Message);
        }
        else
        {
            SetMessage("New product is inserted!");
        }
    }

    protected void RadGrid1_ItemDeleted(object source, GridDeletedEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            SetMessage("Delete failed! Reason: " + e.Exception.Message);
        }
        else
        {
            SetMessage("Item deleted!");
        }
    }

    private void DisplayMessage(string text)
    {
        //RadGrid1.Controls.Add(new LiteralControl(string.Format("<span style='color:red'>{0}</span>", text)));
        GridMessageLabel.Text = text;
    }

    private void SetMessage(string message, bool isError = false)
    {
        gridMessage = message;
        if (isError)
        {
            GridMessageLabel.ForeColor = System.Drawing.Color.Red;
        }
        else
        {
            GridMessageLabel.ForeColor = System.Drawing.Color.DarkGreen;
        }
        DisplayMessage(gridMessage);
    }

    protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            GridBinaryImageColumnEditor editor = ((GridEditableItem)e.Item).EditManager.GetColumnEditor("PhotoColumn") as GridBinaryImageColumnEditor;
            //RadAjaxPanel1.ResponseScripts.Add(string.Format("window['PhotoId'] = '{0}';", editor.RadUploadControl.ClientID));
        }

        // Bind Patients searchbox (RadSearchBox1) to a datasource
        if (e.Item.ItemType == GridItemType.CommandItem)
        {
            GridCommandItem cmdItem = e.Item as GridCommandItem;
            RadToolBar radToolBar = cmdItem.FindControl("RadGrid1ToolBar") as RadToolBar;
            RadSearchBox search = radToolBar.FindItemByText("SearchBox").FindControl("RadSearchBox1") as RadSearchBox;
            //search.Search += RadSearchBox1_Search;
            //search.DataSource = null;
            search.DataSourceID = "AllPatientsDataSource";
            search.DataBind();
        }
    }

    protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            RadAsyncUpload upload = ((GridEditableItem)e.Item)["PhotoColumn"].FindControl("AsyncUpload1") as RadAsyncUpload;
            TableCell cell = (TableCell)upload.Parent;
            CustomValidator validator = new CustomValidator();
            validator.ErrorMessage = "Please select file to be uploaded";
            validator.ClientValidationFunction = "validateRadUpload";
            validator.Display = ValidatorDisplay.Dynamic;
            //cell.Controls.Add(validator);

            // Increase width of company combobox
            GridEditableItem editableItem = e.Item as GridEditableItem;
            var editor = editableItem.EditManager.GetColumnEditor("Company") as GridDropDownListColumnEditor;
            editor.ComboBoxControl.DropDownWidth = Unit.Pixel(300);

        }
    }

    protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
    {
        if (!IsRadAsyncValid.Value)
        {
            e.Canceled = true;
            RadAjaxManager1.Alert("The length of the uploaded file must be less than 1 MB");
            return;
        }
        GridEditableItem editedItem = e.Item as GridEditableItem;
        string patientID = (editedItem["PatientID"].Controls[0] as TextBox).Text;
        string surname = (editedItem["Surname"].Controls[0] as TextBox).Text;
        string otherNames = (editedItem["OtherNames"].Controls[0] as TextBox).Text;
        string company = (editedItem["Company"].Controls[0] as RadComboBox).SelectedValue;
        string phone = (editedItem["PhoneOne"].Controls[0] as RadMaskedTextBox).Text;
        string gender = (editedItem["Gender"].Controls[0] as RadComboBox).SelectedValue;
        string birthDate = (editedItem["BirthDate"].Controls[0] as RadDatePicker).SelectedDate.ToString();

        RadAsyncUpload radAsyncUpload = editedItem["PhotoColumn"].FindControl("AsyncUpload1") as RadAsyncUpload;

        //update item in the Db using where ID
        DataSource1.InsertParameters.Add("PhoneOne", phone);
        DataSource1.InsertParameters.Add("Surname", surname);
        DataSource1.InsertParameters.Add("Company", company);
        DataSource1.InsertParameters.Add("OtherNames", otherNames);
        DataSource1.InsertParameters.Add("PatientID", patientID);
        DataSource1.InsertParameters.Add("BirthDate", birthDate);
        DataSource1.InsertParameters.Add("Gender", gender);

        if (radAsyncUpload.UploadedFiles.Count > 0)
        {
            UploadedFile file = radAsyncUpload.UploadedFiles[0];
            byte[] fileData = new byte[file.InputStream.Length];
            file.InputStream.Read(fileData, 0, (int)file.InputStream.Length);
            photoData = fileData;
        }

        int ret = DataSource1.Insert();
        if (ret > 0)
        {
            SetMessage("New record added!");
        }
        else
        {
            SetMessage("Failed to add new record", true);
        }
    }

    protected void RadGrid1_UpdateCommand(object sender, GridCommandEventArgs e)
    {
        if (!IsRadAsyncValid.Value)
        {
            e.Canceled = true;
            RadAjaxManager1.Alert("The length of the uploaded file must be less than 1 MB");
            return;
        }
        GridEditableItem editedItem = e.Item as GridEditableItem;
        int ID = Convert.ToInt32(editedItem.OwnerTableView.DataKeyValues[editedItem.ItemIndex]["BiodataID"].ToString());
        string patientID = (editedItem["PatientID"].Controls[0] as TextBox).Text;
        string surname = (editedItem["Surname"].Controls[0] as TextBox).Text;
        string otherNames = (editedItem["OtherNames"].Controls[0] as TextBox).Text;
        string company = (editedItem["Company"].Controls[0] as RadComboBox).SelectedValue;
        string phone = (editedItem["PhoneOne"].Controls[0] as RadMaskedTextBox).Text;
        string birthDate = (editedItem["BirthDate"].Controls[0] as RadDatePicker).SelectedDate.ToString();
        string gender = (editedItem["Gender"].Controls[0] as RadComboBox).SelectedValue;
        RadAsyncUpload radAsyncUpload = editedItem["PhotoColumn"].FindControl("AsyncUpload1") as RadAsyncUpload;

        //update item in the Db using where ID
        DataSource1.UpdateParameters.Add("PhoneOne", phone);
        DataSource1.UpdateParameters.Add("Surname", surname);
        DataSource1.UpdateParameters.Add("Company", company);
        DataSource1.UpdateParameters.Add("OtherNames", otherNames);
        DataSource1.UpdateParameters.Add("PatientID", patientID);
        DataSource1.UpdateParameters.Add("BirthDate", birthDate);
        DataSource1.UpdateParameters.Add("BiodataID", ID.ToString());
        DataSource1.UpdateParameters.Add("Gender", gender);
        if (radAsyncUpload.UploadedFiles.Count > 0)
        {
            UploadedFile file = radAsyncUpload.UploadedFiles[0];
            byte[] fileData = new byte[file.InputStream.Length];
            file.InputStream.Read(fileData, 0, (int)file.InputStream.Length);
            photoData = fileData;
        }

        int ret = DataSource1.Update();
        if (ret > 0)
        {
            //string radalertscript = "<script language='javascript'> window.onload = function(){radalert('Item updated successfully', 330, 210);}</script>";
            //Page.ClientScript.RegisterStartupScript(this.GetType(), "radalert", radalertscript);
            // RadWindowManager1.RadAlert("Successfully updated!", 330, 180, "", "");
            SetMessage("Record updated!");
        }
        else
        {
            SetMessage("Update failed", true);
        }
        //RadGrid1.MasterTableView.ClearEditItems();
        //RadGrid1.Rebind();
    }

    protected void AsyncUpload1_FileUploaded(object sender, FileUploadedEventArgs e)
    {
        if ((totalBytes < MaxTotalBytes) && (e.File.ContentLength < MaxTotalBytes))
        {
            e.IsValid = true;
            totalBytes += e.File.ContentLength;
            IsRadAsyncValid = true;
        }
        else
        {
            e.IsValid = false;
            IsRadAsyncValid = false;
        }
    }

    protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
    {
        if (e.CommandName == RadGrid.EditCommandName)
        {
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "SetEditMode", "isEditMode = true;", true);
        }
    }

    protected void RadGrid1_DeleteCommand(object sender, GridCommandEventArgs e)
    {
        GridDataItem item = e.Item as GridDataItem;
        int ID = Convert.ToInt32(item.OwnerTableView.DataKeyValues[item.ItemIndex]["BiodataID"].ToString());
        DataSource1.DeleteParameters.Add("BiodataID", ID.ToString());
        int ret = DataSource1.Delete();
        if (ret > 0)
        {
            SetMessage("Record deleted!");
        }
        else
        {
            SetMessage("Failed to delete the record!", true);
        }
    }

    protected void DataSource1_Updating(object sender, SqlDataSourceCommandEventArgs e)
    {
        //NB the Cancel property of the SqlDataSourceCommandEventArgs can be set to true to cancel the update
        if (photoData != null)
        {
            e.Command.Parameters["@Photo"].Value = photoData;
        }
    }

    protected void DataSource1_Inserting(object sender, SqlDataSourceCommandEventArgs e)
    {
        e.Command.Parameters["@Photo"].Value = photoData;
    }

    protected void RadSearchBox1_Search(object sender, SearchBoxEventArgs e)
    {
        // Filter Grid datasource (DataSource1)
        RadSearchBox searchBox = (RadSearchBox)sender;
        string fullName = String.Empty;
        if (!string.IsNullOrEmpty(e.Text))
        {
            fullName = e.Text;
        }
        else if (e.DataItem != null)
        {
            fullName = ((Dictionary<string, object>)e.DataItem)["FullName"].ToString();
        }

        if (!string.IsNullOrEmpty(fullName))
        {
            DataSource1.SelectParameters.Clear();
            DataSource1.SelectParameters.Add("FullName", fullName);
            DataSource1.SelectCommand = SQLHelper.GetQueryString("patient_biodata_filter_by_fullname.sql");
            IsGridFiltered = true;
        }

    }

    protected void RadSearchBox1_ButtonCommand(object sender, SearchBoxButtonEventArgs e)
    {
        // Clear grid filter to select all patients
        if (e.CommandName == "ClearFilter")
        {
            DataSource1.SelectParameters.Clear();
            DataSource1.SelectCommand = SQLHelper.GetQueryString("all_patients_biodata.sql");
            IsGridFiltered = false;
        }
    }
}
