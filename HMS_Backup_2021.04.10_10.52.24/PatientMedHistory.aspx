<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PatientMedHistory.aspx.cs" Inherits="HMS.PatientMedHistory" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Patient Billing History</title>
        <link rel="shortcut icon" type="image/x-icon" href="images/patient.png" />
    <style>
        .hideUpdatePanel {
            display: none;
        }

        .rgFilterRow, .rgCommandRow {
            display: none;
        }

        .rgCaption {
        <link rel="shortcut icon" type="image/x-icon" href="images/patient.png" />
        <link rel="shortcut icon" type="image/x-icon" href="images/patient.png" />
            display: none
        }

        .rtbLI .rtbButton .rtbArrow .radIcon.radIconDown::before {
            font-family: "WebComponentsIcons";
            content: '\e005';
        }

        .rtbLI .rtbButton.clicked .rtbArrow .radIcon.radIconDown::before {
            font-family: "WebComponentsIcons";
            content: '\e006';
        }

        .rcbActionButton {
            display: none;
        }

        .rgGroupPanel {
            background: lightgray !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
            <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
                <asp:ScriptReference Path="~/JSCode/CircularDoublyLinkedList.js" />
                <asp:ScriptReference Path="~/JSCode/DoublyLinkedList.js" />
            </Scripts>
        </telerik:RadScriptManager>
        <script type="text/javascript">
        //Put your JavaScript code here.
        </script>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" DefaultLoadingPanelID="RadAjaxLoadingPanel1">
            <AjaxSettings>
                <telerik:AjaxSetting AjaxControlID="RadSearchBox1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" UpdatePanelCssClass="" />
                        <telerik:AjaxUpdatedControl ControlID="photo" UpdatePanelCssClass="" LoadingPanelID="RadAjaxLoadingPanel2" />
                        <telerik:AjaxUpdatedControl ControlID="patient_id" UpdatePanelCssClass="" LoadingPanelID="RadAjaxLoadingPanel2" />
                        <telerik:AjaxUpdatedControl ControlID="name" UpdatePanelCssClass="" LoadingPanelID="RadAjaxLoadingPanel2" />
                        <telerik:AjaxUpdatedControl ControlID="company" UpdatePanelCssClass="" LoadingPanelID="RadAjaxLoadingPanel2" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="RadGrid1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" UpdatePanelCssClass="" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="Previous">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" />
                        <telerik:AjaxUpdatedControl ControlID="photo" UpdatePanelCssClass="" LoadingPanelID="RadAjaxLoadingPanel2" />
                        <telerik:AjaxUpdatedControl ControlID="patient_id" UpdatePanelCssClass="" LoadingPanelID="RadAjaxLoadingPanel2" />
                        <telerik:AjaxUpdatedControl ControlID="name" UpdatePanelCssClass="" LoadingPanelID="RadAjaxLoadingPanel2" />
                        <telerik:AjaxUpdatedControl ControlID="company" UpdatePanelCssClass="" LoadingPanelID="RadAjaxLoadingPanel2" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="Next">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" />
                        <telerik:AjaxUpdatedControl ControlID="photo" UpdatePanelCssClass="" LoadingPanelID="RadAjaxLoadingPanel2" />
                        <telerik:AjaxUpdatedControl ControlID="patient_id" UpdatePanelCssClass="" LoadingPanelID="RadAjaxLoadingPanel2" />
                        <telerik:AjaxUpdatedControl ControlID="name" UpdatePanelCssClass="" LoadingPanelID="RadAjaxLoadingPanel2" />
                        <telerik:AjaxUpdatedControl ControlID="company" UpdatePanelCssClass="" LoadingPanelID="RadAjaxLoadingPanel2" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
            </AjaxSettings>
        </telerik:RadAjaxManager>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server">
        </telerik:RadAjaxLoadingPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel2" runat="server" CssClass="hideUpdatePanel">
        </telerik:RadAjaxLoadingPanel>

        <telerik:RadClientDataSource runat="server" ID="RadClientDataSource1">
            <DataSource>
                <DataSourceControlSettings DataSourceID="SqlDataSource1" DataFields="BiodataID" />
            </DataSource>
        </telerik:RadClientDataSource>

        <asp:SqlDataSource runat="server"
            ID="SqlDataSource1"
            ConnectionString="<%$ ConnectionStrings:HMDB %>"></asp:SqlDataSource>

        <telerik:RadToolBar ID="RadToolBar1" runat="server" Style="font-weight: 700" OnButtonClick="RadToolBar1_ButtonClick" OnClientDropDownOpening="ClientDropDownOpening" OnClientDropDownClosing="ClientDropDownClosing">
            <Items>
                <telerik:RadToolBarDropDown Text="Go To">
                    <Buttons>
                        <telerik:RadToolBarButton ID="PatientHistory" runat="server" Visible="false"
                            CommandName="PatientHistoryCommandName"
                            Text="Patient Billing History" ImageUrl="~/images/patient.png" ImagePosition="Left">
                        </telerik:RadToolBarButton>
                        <telerik:RadToolBarButton ID="CompanyBills" runat="server" CommandName="CompanyBillsCommandName" ImageUrl="~/images/calendar.png" ImagePosition="Left" Text="Monthly Bills">
                        </telerik:RadToolBarButton>
                        <telerik:RadToolBarButton ID="BillingHistory" runat="server" CommandName="BillingHistoryCommandName" ImageUrl="~/images/enterprise1.png" ImagePosition="Left" Text="Company Billing History">
                        </telerik:RadToolBarButton>
                    </Buttons>
                </telerik:RadToolBarDropDown>

                <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>

                <telerik:RadToolBarDropDown ID="RadToolBarDropDown2" runat="server" Text="Export">
                    <Buttons>
                        <telerik:RadToolBarButton ID="i0" runat="server" CommandName="ExportToExcelCommandName" ImageUrl="~/images/excel.png" Text="Excel">
                        </telerik:RadToolBarButton>
                        <telerik:RadToolBarButton ID="i1" runat="server" CommandName="ExportToWordCommandName" ImageUrl="~/images/word.png" Text="Word">
                        </telerik:RadToolBarButton>
                    </Buttons>
                </telerik:RadToolBarDropDown>

                <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>

                <telerik:RadToolBarButton>
                    <ItemTemplate>
                        <span style="margin-right: 15px"></span>
                    </ItemTemplate>
                </telerik:RadToolBarButton>

                <telerik:RadToolBarButton ID="RadToolBarButton1">
                    <ItemTemplate>
                        <telerik:RadSearchBox RenderMode="Lightweight" runat="server" ID="RadSearchBox1"
                            CssClass="searchBox"
                            Width="460" DropDownSettings-Height="300"
                            DataTextField="FullName"
                            DataValueField="BiodataID"
                            DataKeyNames="Company, BiodataID, FullName"
                            DataContextKeyField="Company"
                            EmptyMessage="Search for patient"
                            Filter="Contains"
                            MaxResultCount="20"
                            EnableAutoComplete="true"
                            OnSearch="RadSearchBox1_Search" OnClientSearch="radSearchBox1_ClientSearch">
                            <SearchContext DataTextField="Company" DataKeyField="Company" DropDownCssClass="contextDropDown"></SearchContext>
                        </telerik:RadSearchBox>
                    </ItemTemplate>
                </telerik:RadToolBarButton>






            </Items>
        </telerik:RadToolBar>
        <div style="align-items: flex-end; display: flex; justify-content: space-between">
            <table style="border: solid; font-size: small">
                <tr>
                    <td>
                        <asp:Image runat="server" ID="photo" ImageUrl="images/profile.png" Shape="Wide" ImageWidth="50px" ImageHeight="50px" Height="80px" Width="100px" />
                    </td>
                    <td style="vertical-align: text-top">
                        <b id="patient_id" runat="server"></b>
                        <b id="name" runat="server" style="display: block; margin-top: 2px"></b>
                        <b id="company" runat="server" style="display: block; margin-top: 2px"></b>
                    </td>
                </tr>
            </table>
            <span style="margin-left: 15px; margin-bottom: 5px" id="PrevNext">
                <telerik:RadButton ID="Previous" runat="server" Text="Previous" OnClick="Previous_Click" OnClientClicked="prevNextClick" AutoPostBack="true" CommandName="CommandBtn_Prev">
                    <Icon PrimaryIconCssClass="rbPrevious" />
                </telerik:RadButton>
                <telerik:RadButton ID="Next" runat="server" Text="Next" OnClick="Next_Click" OnClientClicked="prevNextClick" AutoPostBack="true" CommandName="CommandBtn_Next">
                    <Icon SecondaryIconCssClass="rbNext" />
                </telerik:RadButton>
            </span>
        </div>

        <div class="scroller">
            <div class="gridWrapper">
                <div>
                    <telerik:RadGrid ID="RadGrid1" runat="server" AllowSorting="True" AutoGenerateColumns="False" AllowFilteringByColumn="True" RenderMode="Lightweight" ShowGroupPanel="True" ShowStatusBar="True" OnGridExporting="RadGrid1_GridExporting" OnHTMLExporting="RadGrid1_HTMLExporting" OnExportCellFormatting="RadGrid1_ExportCellFormatting" OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound"
                        AllowPaging="True" GridLines="Both" ShowFooter="True" FilterType="Combined"
                        PageSize="50" OnNeedDataSource="RadGrid1_NeedDataSource" MasterTableView-Caption="Medical History" Font-Size="Small" PagerStyle-Mode="NextPrevAndNumeric" PagerStyle-Position="Top" PagerStyle-PageSizeControlType="RadComboBox" GroupingSettings-CaseSensitive="False" MasterTableView-ShowGroupFooter="true">
                        <ClientSettings Resizing-AllowColumnResize="true" AllowDragToGroup="false" AllowExpandCollapse="true" Selecting-AllowRowSelect="true">
                            <Scrolling AllowScroll="True" UseStaticHeaders="True" SaveScrollPosition="true" FrozenColumnsCount="0"></Scrolling>
                            <Selecting AllowRowSelect="True"></Selecting>
                            <Resizing AllowColumnResize="True"></Resizing>
                        </ClientSettings>
                        <MasterTableView Width="100%" AllowMultiColumnSorting="true" TableLayout="Fixed" CommandItemDisplay="Top" GroupsDefaultExpanded="true" GroupLoadMode="Client" GroupHeaderItemStyle-Font-Bold="true" FooterStyle-Font-Bold="true" EnableHeaderContextMenu="true">
                            <CommandItemSettings ShowExportToWordButton="false" ShowExportToCsvButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" ShowExportToExcelButton="false" ShowExportToPdfButton="false" ShowPrintButton="false" PrintGridText="Print" />
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Transaction Code" Display="false" DataField="TransactCode" AllowFiltering="False" ReadOnly="True">
                                </telerik:GridBoundColumn>
                                <telerik:GridDateTimeColumn DataField="Date" DataFormatString="{0:MMM dd, yyy}" AllowFiltering="false" CurrentFilterFunction="EqualTo" HeaderText="Date"></telerik:GridDateTimeColumn>
                                <telerik:GridBoundColumn AllowFiltering="false" DataField="Diagnoses" HeaderText="Diagnoses" ReadOnly="true"></telerik:GridBoundColumn>
                                <telerik:GridBoundColumn AllowFiltering="false" DataField="ServiceName" HeaderText="Service" ReadOnly="True" Aggregate="Count" FooterAggregateFormatString="<b>Total Transactions: {0:n0}</b>">
                                </telerik:GridBoundColumn>
                                <telerik:GridNumericColumn DataField="PackQuantity" FooterStyle-Font-Bold="true" ReadOnly="true" HeaderText="Pack" AllowFiltering="false" Aggregate="Sum" FooterAggregateFormatString="<b>Total Packs: {0:n0}</b>">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="UnitQuantity" FooterStyle-Font-Bold="true" ReadOnly="true" HeaderText="Unit" AllowFiltering="false" Aggregate="Sum" FooterAggregateFormatString="<b>Total Units: {0:n0}</b>">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="Cost" ReadOnly="true" HeaderText="Cost" DataFormatString="{0:C}" FooterStyle-Font-Bold="true" FooterText="Total Cost" AllowFiltering="false" Aggregate="Sum" FooterAggregateFormatString="<b>Total Cost: {0:C}</b>">
                                </telerik:GridNumericColumn>
                            </Columns>
                            <%--  <GroupByExpressions>
                                <telerik:GridGroupByExpression>
                                    <SelectFields>
                                        <telerik:GridGroupByField FieldName="Date" HeaderText="Date" FormatString="{0:MMM, dd yyyy}" />
                                        <telerik:GridGroupByField FieldName="Cost" HeaderText="Total Cost" Aggregate="Sum" FormatString="{0:C}" />
                                    </SelectFields>
                                    <GroupByFields>
                                        <telerik:GridGroupByField FieldName="Date" />
                                    </GroupByFields>
                                </telerik:GridGroupByExpression>
                            </GroupByExpressions> --%>
                        </MasterTableView>
                        <FilterMenu CssClass="RadFilterMenu_CheckList" OnClientShown="MenuShowing">
                        </FilterMenu>
                        <ExportSettings
                            HideStructureColumns="true"
                            ExportOnlyData="false"
                            IgnorePaging="true"
                            OpenInNewWindow="true" Word-Format="Html" FileName="Patient History" Excel-WorksheetName="Patient History" Excel-FileExtension="xls" Excel-Format="Html">
                            <Pdf
                                PageTitle="Patient History"
                                Author="HMS User"
                                PaperSize="A4"
                                Creator="HMS"
                                PageWidth="11in" PageHeight="8.5in">
                            </Pdf>
                        </ExportSettings>
                        <GroupingSettings ShowUnGroupButton="true" CaseSensitive="False"></GroupingSettings>
                        <HeaderContextMenu RenderMode="Lightweight"></HeaderContextMenu>
                    </telerik:RadGrid>
                    <asp:HiddenField ID="hfBiodataID" ClientIDMode="Static" runat="server" />

                    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
                        <script type="text/javascript">
                            var activeDropDown;
                            var radToolBar1;
                            var radComboBoxPatients;
                            var hfBiodataID;
                            var radClientDataSource1;
                            var listBiodataIDs;
                            var radGrid1;
                            $(function () {
                                // Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);

                                // Add click event to RadToolBar1 dropdown buttons (.rtbButton)
                                $telerik.$("#RadToolBar1 .rtbLI .rtbButton")
                                    .on("click", function (e) {
                                        $(e.currentTarget).toggleClass("clicked");
                                    });
                            });

                            function endRequestHandler(sender, args) {
                                // this will trigger after ajax postback completed
                                if (typeof activeDropDown != 'undefined') {
                                    // toggle active dropdown visibility;
                                    //$(activeDropDown._element).find(".rtbButton").removeClass("clicked");
                                    //activeDropDown.hideDropDown();
                                }
                            }

                            function filterMenuShowing(sender, eventArgs) {
                                // Set value for column to be used in MenuShowing().
                                column = eventArgs.get_column();
                            }

                            function filterMenuShowing(sender, eventArgs) {
                                // Set value for column to be used in MenuShowing().
                                column = eventArgs.get_column();
                            }

                            function MenuShowing(menu, args) {
                                if (column == null) return;
                                menu.get_items()._array[0].set_visible(false)
                                column = null;
                                menu.repaint();
                            }

                            function ClientDropDownOpening(sender, args) {
                                var dropDown = args.get_item();
                                $(dropDown.get_linkElement()).toggleClass("clicked");
                                // manually toggle clicked class of opened siblings and close them
                                /*var siblings = dropDown._getSiblings();
                                var visible = siblings._array.filter(function (d) {
                                    return d._isDropDownVisible
                                });
                                for (var i = 0; i < visible.length; i++) {
                                    var d = visible[i];
                                    $(d._element).find(".rtbButton").removeClass("clicked");
                                    d.hideDropDown();
                                }*/
                                activeDropDown = dropDown;
                            }

                            function ClientDropDownClosing(sender, args) {
                                //var dropDown = args.get_item();
                                //var linkedElement = $(dropDown.get_linkElement());
                                //// args.set_cancel(dropDownElement.find(".rtbButton").hasClass("clicked"));
                                //// prevent dropdown from closing if child combobox is opened
                                //if (dropDown.get_attributes().getAttribute("child_combobox_id") == "RadComboBox_Patients") {
                                //    args.set_cancel((function () {
                                //        if (!radComboBoxPatients.get_dropDownVisible()) {
                                //            linkedElement.toggleClass("clicked");
                                //        }
                                //        return radComboBoxPatients.get_dropDownVisible();
                                //    })());
                                //    return;
                                //}
                                //linkedElement.toggleClass("clicked");
                                var dropDownElement = $(args.get_item()._element)
                                dropDownElement.find(".rtbButton").removeClass("clicked");
                            }

                            function pageLoad() {
                                radToolBar1 = $find("<%= RadToolBar1.ClientID %>");
                                hfBiodataID = $telerik.$("#<%= hfBiodataID.ClientID %>");
                                radClientDataSource1 = $find("<%= RadClientDataSource1.ClientID %>");
                                radGrid1 = $find("<%= RadGrid1.ClientID %>");
                                radClientDataSource1.fetch(function (args) {
                                    var data = radClientDataSource1.get_data().toJSON();
                                    listBiodataIDs = new CircularDoublyLinkedList();
                                    // Parse as to doubly linked list
                                    for (var i = 0; i < data.length; i++) {
                                        var item = data[i];
                                        var key = item.BiodataID;
                                        listBiodataIDs.add(key, item);
                                    }
                                });

                            }

                            function radSearchBox1_ClientSearch(sender, args) {
                                var value = args.get_value();
                                if (value != null) {
                                    hfBiodataID.val(value);
                                }
                            }

                            function prevNextClick(sender, args) {
                                var biodataID = hfBiodataID.val();
                                if (biodataID == "0" || biodataID == "") {
                                    hfBiodataID.val(listBiodataIDs.circularValues().next().value.BiodataID);
                                } else {
                                    if (args.get_commandName() == "CommandBtn_Next") {
                                        hfBiodataID.val(listBiodataIDs.getCustom(biodataID).next.data.BiodataID);
                                    } else {
                                        hfBiodataID.val(listBiodataIDs.getCustom(biodataID).previous.data.BiodataID);
                                    }
                                }
                            }
                        </script>
                    </telerik:RadCodeBlock>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
