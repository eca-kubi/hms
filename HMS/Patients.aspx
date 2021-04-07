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

        div.RadToolBar .rtbUL {
            width: 100%;
            white-space: normal;
        }

        div.RadToolBar .rightButton {
            float: right;
            padding: 3px;
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
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
            <AjaxSettings>
                <telerik:AjaxSetting AjaxControlID="RadGrid1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="GridMessageLabel"></telerik:AjaxUpdatedControl>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1"></telerik:AjaxUpdatedControl>
                    </UpdatedControls>
                </telerik:AjaxSetting>
            </AjaxSettings>
        </telerik:RadAjaxManager>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" />
        <telerik:RadLabel runat="server" ForeColor="Green" ID="GridMessageLabel"></telerik:RadLabel>
        <telerik:RadGrid ID="RadGrid1" runat="server" OnInsertCommand="RadGrid1_InsertCommand" OnUpdateCommand="RadGrid1_UpdateCommand" OnItemCommand="RadGrid1_ItemCommand" OnDeleteCommand="RadGrid1_DeleteCommand"
            AllowPaging="True" DataSourceID="DataSource1" OnItemUpdated="RadGrid1_ItemUpdated" OnItemDeleted="RadGrid1_ItemDeleted"
            OnItemInserted="RadGrid1_ItemInserted" OnDataBound="RadGrid1_DataBound" AutoGenerateColumns="False" CellSpacing="-1" GridLines="Both" ShowStatusBar="True"
            OnItemDataBound="RadGrid1_ItemDataBound" OnItemCreated="RadGrid1_ItemCreated">
            <PagerStyle Mode="NextPrevAndNumeric" />
            <GroupingSettings CollapseAllTooltip="Collapse all groups" />
            <MasterTableView CommandItemDisplay="Top" DataKeyNames="BiodataID" DataSourceID="DataSource1" EditMode="PopUp" HorizontalAlign="NotSet" Width="100%" AllowAutomaticInserts="False" AllowAutomaticUpdates="False">
                <CommandItemSettings />
                <CommandItemTemplate>
                    <telerik:RadToolBar ID="RadGrid1ToolBar" runat="server" AutoPostBack="true">
                        <Items>
                            <telerik:RadToolBarButton Text="Add new patient"
                                ImageUrl="images/plus.png" CommandName="InitInsert"
                                ImagePosition="Left">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton IsSeparator="true">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton Text="Refresh" CommandName="RebindGrid" ImageUrl="images/refresh.png" ImagePosition="Left">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton OuterCssClass="rightButton">
                                <ItemTemplate>
                                    <telerik:RadSearchBox RenderMode="Lightweight" runat="server" ID="RadSearchBox1" EmptyMessage="Filter by patient"
                                        Filter="Contains"
                                        DataKeyNames="BiodataID"
                                        DataTextField="FullName"
                                        DataValueField="BiodataID"
                                        EnableAutoComplete="true"
                                        ShowSearchButton="true"
                                        Width="300" EnableViewState="true"
                                        OnSearch="RadSearchBox1_Search" OnButtonCommand="RadSearchBox1_ButtonCommand" OnClientSearch="" OnClientButtonCommand="">
                                        <DropDownSettings Width="300" />
                                        <Buttons>
                                            <telerik:SearchBoxButton CommandName="ClearFilter" CommandArgument="ClearFilter" Position="Left" AlternateText="Clear Filter" ImageUrl="images/filter.png" />
                                        </Buttons>
                                    </telerik:RadSearchBox>
                                </ItemTemplate>
                            </telerik:RadToolBarButton>
                        </Items>
                    </telerik:RadToolBar>
                </CommandItemTemplate>
                <Columns>
                    <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" EditImageUrl="images/edit.png">
                        <ItemStyle CssClass="MyImageButton" />
                    </telerik:GridEditCommandColumn>
                    <telerik:GridButtonColumn ConfirmText="Delete this record?" ConfirmDialogType="RadWindow"
                        ConfirmTitle="Delete" ButtonType="ImageButton" CommandName="Delete" Text="Delete" ImageUrl="images/delete.png"
                        UniqueName="DeleteColumn">
                        <ItemStyle HorizontalAlign="Center" CssClass="MyImageButton" />
                    </telerik:GridButtonColumn>
                    <telerik:GridBoundColumn DataField="BiodataID" DataType="System.Int32" FilterControlAltText="Filter BiodataID column" HeaderText="BiodataID" ReadOnly="True" SortExpression="BiodataID" UniqueName="BiodataID" Visible="False">
                    </telerik:GridBoundColumn>
                    <telerik:GridTemplateColumn UniqueName="PhotoColumn" HeaderText="Photo">
                        <ItemTemplate>
                            <telerik:RadBinaryImage runat="server" DataField="Photo" FilterControlAltText="Filter column column" HeaderText="Photo" Width="32" Height="32" DataValue='<%#Eval("Photo")  is DBNull ? ImageConverter.fromFile(Server.MapPath( "images/profile.png")) : Eval("Photo") %>'
                                AutoAdjustImageControlSize="false" ToolTip='<%#Eval("FullName", "Photo of {0}") %>'
                                AlternateText='<%#Eval("FullName", "Photo of {0}") %>' UniqueName="Photo" ResizeMode="Fit" DataAlternateTextFormatString="Photo of {0}"></telerik:RadBinaryImage>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="AsyncUpload1"
                                AllowedFileExtensions="jpg,jpeg,png,gif" MaxFileSize="1048576" OnFileUploaded="AsyncUpload1_FileUploaded">
                            </telerik:RadAsyncUpload>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridBoundColumn DataField="PatientID" FilterControlAltText="Filter PatientID column" HeaderText="Patient ID" SortExpression="PatientID" UniqueName="PatientID">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Surname" FilterControlAltText="Filter Surname column" HeaderText="Surname" ReadOnly="False" Visible="false" SortExpression="Surname" UniqueName="Surname">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="OtherNames" FilterControlAltText="Filter Other Names column" HeaderText="Other Names" ReadOnly="False" Visible="false" SortExpression="OtherNames" UniqueName="OtherNames">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="FullName" FilterControlAltText="Filter FullName column" HeaderText="Full Name" ReadOnly="True" SortExpression="FullName" UniqueName="FullName">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Age" DataType="System.Int32" FilterControlAltText="Filter Age column" HeaderText="Age" SortExpression="Age" UniqueName="Age" ReadOnly="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridDateTimeColumn DataField="BirthDate" DataType="System.DateTime" FilterControlAltText="Filter BirthDate column" HeaderText="Birth Date" DataFormatString="{0:MMM dd, yyyy}" SortExpression="Birth Date" UniqueName="BirthDate">
                    </telerik:GridDateTimeColumn>
                    <telerik:GridDropDownColumn DataField="Gender" FilterControlAltText="Filter Gender column" HeaderText="Gender" SortExpression="Gender" UniqueName="Gender" ListValueField="Gender" ListTextField="Gender" DataSourceID="GenderDataSource">
                    </telerik:GridDropDownColumn>
                    <telerik:GridMaskedColumn UniqueName="PhoneOne" HeaderText="Phone" DataField="PhoneOne"
                        Mask="(###) ###-####" DisplayMask="(###) ###-####" DataFormatString="{0:(###) ###-####}" />

                    <telerik:GridDropDownColumn DataField="Company" DataSourceID="CompanyDataSource" HeaderText="Company"
                        ListValueField="Company" ListTextField="Company" UniqueName="Company">
                    </telerik:GridDropDownColumn>

                </Columns>
                <EditFormSettings>
                    <FormTableItemStyle Wrap="False" />
                    <FormCaptionStyle CssClass="EditFormHeader" />
                    <FormMainTableStyle BackColor="White" CellPadding="3" CellSpacing="0" GridLines="None" Width="100%" />
                    <FormTableStyle BackColor="White" CellPadding="2" CellSpacing="0" Height="110px" />
                    <FormTableAlternatingItemStyle Wrap="False" />
                    <EditColumn ButtonType="ImageButton" CancelText="Cancel edit" UniqueName="EditCommandColumn1" CancelImageUrl="images/close.png" UpdateImageUrl="images/diskette.png" InsertImageUrl="images/diskette.png">
                    </EditColumn>
                    <FormTableButtonRowStyle CssClass="EditFormButtonRow" HorizontalAlign="Right" />
                </EditFormSettings>
            </MasterTableView>
            <ClientSettings>
                <Selecting AllowRowSelect="True" EnableDragToSelectRows="True" />
            </ClientSettings>
        </telerik:RadGrid>

        <telerik:RadWindowManager ID="RadWindowManager1" runat="server"></telerik:RadWindowManager>

        <asp:XmlDataSource ID="GenderDataSource" DataFile="~/App_Data/XML/Gender.xml" runat="server"></asp:XmlDataSource>

        <asp:SqlDataSource SelectCommand="SELECT BiodataID, PatientID, Trim(dbo.fnToProperCase(FullName)) AS FullName, OtherNames, Surname, (0+ FORMAT(GETDATE(),'yyyyMMdd') - FORMAT(BirthDate,'yyyyMMdd') ) /10000 Age, BirthDate, Gender, Photo, PhoneOne, Company FROM PatientBiodatas WHERE (FullName NOT LIKE  '%[[]new]%') AND (FullName <> '') ORDER BY FullName" ConnectionString="<%$ ConnectionStrings:HMDB.connectionString %>" ProviderName="System.Data.SqlClient" ID="DataSource1" runat="server"
            UpdateCommand="Update PatientBiodatas SET Surname=@Surname, PhoneOne=@PhoneOne, Photo=COALESCE(@Photo, Photo), OtherNames=@OtherNames, BirthDate=@BirthDate, Company=@Company, Gender=@Gender WHERE BiodataID=@BiodataID" DeleteCommand="DELETE FROM PatientBiodatas WHERE BiodataID=@BiodataID"
            InsertCommand="INSERT INTO PatientBiodatas (Surname, OtherNames, PhoneOne, Photo, BirthDate, Company, Gender) VALUES (@Surname, @OtherNames, @PhoneOne, @Photo, @BirthDate, @Company, @Gender)" OnUpdating="DataSource1_Updating" OnInserting="DataSource1_Inserting">
            <InsertParameters>
                <asp:Parameter Name="Photo" DbType="Binary" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="Photo" DbType="Binary" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="CompanyDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:HMDB.connectionString  %>" ProviderName="System.Data.SqlClient"></asp:SqlDataSource>
        <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
            <script type="text/javascript">
                //On insert and update buttons click temporarily disables ajax to perform upload actions      
                function conditionalPostback(e, sender) {
                    var theRegexp = new RegExp("\.UpdateButton$|\.PerformInsertButton$", "ig");
                    if (sender.EventTarget.match(theRegexp)) {
                        var upload = $find(window['PhotoId']);
                        //AJAX is disabled only if file is selected for upload                  
                        if (upload.getFileInputs()[0].value != "") {
                            sender.EnableAjax = false;
                        }
                    }
                }
                function validateRadUpload(source, e) {
                    e.IsValid = false;
                    var upload = $find(source.parentNode.getElementsByTagName('div')[0].id);
                    var inputs = upload.getFileInputs(); for (var i = 0; i < inputs.length; i++) {
                        //check for empty string or invalid extension     
                        if (inputs[i].value != "" && upload.isExtensionValid(inputs[i].value)) {
                            e.IsValid = true;
                            break;
                        }
                    }
                }

                function addRecordToGrid() {
                    var grid = $find('<%=RadGrid1.ClientID%>');
                    grid.get_batchEditingManager().addNewRecord(grid.get_masterTableView());
                    return false;
                }
                function saveChangesToGrid() {
                    var grid = $find('<%=RadGrid1.ClientID%>');
                    grid.get_batchEditingManager().saveChanges(grid.get_masterTableView());
                    return false;
                }
                function cancelChangesToGrid() {
                    var grid = $find('<%=RadGrid1.ClientID%>');
                    grid.get_batchEditingManager().cancelChanges(grid.get_masterTableView());
                    return false;
                }
                function refreshGrid() {
                    var grid = $find('<%=RadGrid1.ClientID%>');
                    grid.get_masterTableView().rebind();
                }
            </script>
        </telerik:RadCodeBlock>
    </form>
</body>
</html>
