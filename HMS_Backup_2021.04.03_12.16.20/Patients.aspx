    <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Patients.aspx.cs" Inherits="Patients" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .MyImageButton {
            cursor: pointer;
            cursor: hand;
        }

        .EditFormHeader td {
            font-size: 14px;
            padding: 4px !important;
            color: #0066cc;
        }
    </style>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
            <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
            </Scripts>
        </telerik:RadScriptManager>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" />
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
            <telerik:RadGrid ID="RadGrid1" runat="server" AllowAutomaticDeletes="True"
                AllowAutomaticInserts="True" AllowAutomaticUpdates="True"
                AllowPaging="True" DataSourceID="DataSource1" OnItemUpdated="RadGrid1_ItemUpdated" OnItemDeleted="RadGrid1_ItemDeleted"
                OnItemInserted="RadGrid1_ItemInserted" OnDataBound="RadGrid1_DataBound" AutoGenerateColumns="False" CellSpacing="-1" GridLines="Both">
                <PagerStyle Mode="NextPrevAndNumeric" />
                <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                <MasterTableView CommandItemDisplay="TopAndBottom" DataKeyNames="BiodataID" DataSourceID="DataSource1" EditMode="PopUp" HorizontalAlign="NotSet" Width="100%">
                    <Columns>
                        <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" EditImageUrl="images/edit.png">
                            <ItemStyle CssClass="MyImageButton" />
                        </telerik:GridEditCommandColumn>
                        <telerik:GridButtonColumn ConfirmText="Delete this product?" ConfirmDialogType="RadWindow"
                            ConfirmTitle="Delete" ButtonType="ImageButton" CommandName="Delete" Text="Delete" ImageUrl="images/delete.png"
                            UniqueName="DeleteColumn">
                            <ItemStyle HorizontalAlign="Center" CssClass="MyImageButton" />
                        </telerik:GridButtonColumn>
                        <telerik:GridBoundColumn DataField="BiodataID" DataType="System.Int32" FilterControlAltText="Filter BiodataID column" HeaderText="BiodataID" ReadOnly="True" SortExpression="BiodataID" UniqueName="BiodataID" Visible="False">
                        </telerik:GridBoundColumn>
                        <telerik:GridBinaryImageColumn DataField="Photo" FilterControlAltText="Filter column column" HeaderText="Photo" ImageHeight="64" ImageWidth="64" UniqueName="Photo">
                        </telerik:GridBinaryImageColumn>
                        <telerik:GridBoundColumn DataField="PatientID" FilterControlAltText="Filter PatientID column" HeaderText="PatientID" SortExpression="PatientID" UniqueName="PatientID">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="FullName" FilterControlAltText="Filter FullName column" HeaderText="FullName" ReadOnly="True" SortExpression="FullName" UniqueName="FullName">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Age" DataType="System.Int32" FilterControlAltText="Filter Age column" HeaderText="Age" SortExpression="Age" UniqueName="Age">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="BirthDate" DataType="System.DateTime" FilterControlAltText="Filter BirthDate column" HeaderText="BirthDate" SortExpression="BirthDate" UniqueName="BirthDate">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Gender" FilterControlAltText="Filter Gender column" HeaderText="Gender" SortExpression="Gender" UniqueName="Gender">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="PhoneOne" FilterControlAltText="Filter PhoneOne column" HeaderText="PhoneOne" SortExpression="PhoneOne" UniqueName="PhoneOne">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Company" FilterControlAltText="Filter Company column" HeaderText="Company" SortExpression="Company" UniqueName="Company">
                        </telerik:GridBoundColumn>
                    </Columns>
                    <EditFormSettings>
                        <FormTableItemStyle Wrap="False" />
                        <FormCaptionStyle CssClass="EditFormHeader" />
                        <FormMainTableStyle BackColor="White" CellPadding="3" CellSpacing="0" GridLines="None" Width="100%" />
                        <FormTableStyle BackColor="White" CellPadding="2" CellSpacing="0" Height="110px" />
                        <FormTableAlternatingItemStyle Wrap="False" />
                        <EditColumn ButtonType="ImageButton" CancelText="Cancel edit" UniqueName="EditCommandColumn1">
                        </EditColumn>
                        <FormTableButtonRowStyle CssClass="EditFormButtonRow" HorizontalAlign="Right" />
                    </EditFormSettings>
                </MasterTableView>
            </telerik:RadGrid>
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server"></telerik:RadWindowManager>
        </telerik:RadAjaxPanel>
        <asp:SqlDataSource SelectCommand="SELECT BiodataID, PatientID, Trim(dbo.fnToProperCase(FullName)) AS FullName, Age, BirthDate, Gender, Photo, PhoneOne, Company FROM PatientBiodatas WHERE (FullName NOT LIKE  '%[[]new]%') AND (FullName <> '') ORDER BY FullName" ConnectionString="Data Source=127.0.0.1\sqlexpress;Initial Catalog=HMDB;Integrated Security=False;User ID=hmdbuser;Password=!123456ab;MultipleActiveResultSets=True" ProviderName="System.Data.SqlClient" ID="DataSource1" runat="server"></asp:SqlDataSource>
    </form>
</body>
</html>
