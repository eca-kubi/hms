<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BillingHistory.aspx.cs" Inherits="BillingHistory" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
        <link rel="shortcut icon" type="image/x-icon" href="images/patient.png" />
    <title>Company Billing History</title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
    <script src="https://kit.fontawesome.com/013c8b2550.js" crossorigin="anonymous"></script>

    <style>
        #CollapseExpandAll.rbButton:focus {
            box-shadow: none;
        }

        #CollapseExpandAll {
            background: none;
            border: none;
        }

            #CollapseExpandAll:hover {
                border: none
            }

        .rtbLI .rtbButton .rtbArrow .radIcon.radIconDown::before {
            font-family: "WebComponentsIcons";
            content: '\e005';
        }

        .rtbLI .rtbButton.clicked .rtbArrow .radIcon.radIconDown::before {
            font-family: "WebComponentsIcons";
            content: '\e006';
        }

        .exportToExcel .rtbText:before, .exportToWord .rtbText:before {
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
        }

        .exportToExcel .rtbText:before {
            content: "\f1c3 \0020";
        }

        .exportToWord .rtbText:before {
            content: "\f1c2 \0020";
        }

        .rtContent a {
            color: whitesmoke
        }

        .border-right {
            border-right: 1px solid gray
        }

        .rgFilterRow {
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
            </Scripts>
        </telerik:RadScriptManager>
        <script type="text/javascript">
        //Put your JavaScript code here.
        </script>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" DefaultLoadingPanelID="RadAjaxLoadingPanel1">
            <AjaxSettings>
                <telerik:AjaxSetting AjaxControlID="ToDatePicker">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" UpdatePanelCssClass="" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="RadDropDownList1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="RadSearchBox1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" UpdatePanelCssClass="" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <%--<telerik:AjaxSetting AjaxControlID="RadSearchBox2">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" UpdatePanelCssClass="" />
                        <telerik:AjaxUpdatedControl ControlID="RadSearchBox2" UpdatePanelCssClass="" />
                    </UpdatedControls>
                </telerik:AjaxSetting>--%>
                <telerik:AjaxSetting AjaxControlID="RadGrid1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" UpdatePanelCssClass="" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
            </AjaxSettings>
        </telerik:RadAjaxManager>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server">
        </telerik:RadAjaxLoadingPanel>
        <telerik:RadToolTipManager ID="RadToolTipManager1" runat="server" AutoTooltipify="true">
        </telerik:RadToolTipManager>
        <telerik:RadToolBar ID="RadToolBar1" runat="server" Style="font-weight: 700" OnButtonClick="RadToolBar1_ButtonClick" OnClientDropDownOpening="ClientDropDownOpening" OnClientDropDownClosing="ClientDropDownClosing">
            <Items>
                <telerik:RadToolBarDropDown Text="Go To">
                    <Buttons>
                        <telerik:RadToolBarButton ID="PatientHistory" runat="server"
                            CommandName="PatientHistoryCommandName"
                            Text="Patient Billing History" ImageUrl="~/images/patient.png" ImagePosition="Left">
                        </telerik:RadToolBarButton>
                        <telerik:RadToolBarButton ID="CompanyBills" runat="server" CommandName="CompanyBillsCommandName" ImageUrl="~/images/calendar.png" ImagePosition="Left" Text="Monthly Bills">
                        </telerik:RadToolBarButton>
                        <telerik:RadToolBarButton ID="BillingHis" runat="server" CommandName="BillingHistoryCommandName" ImageUrl="~/images/enterprise1.png" ImagePosition="Left" Text="Company Billing History" Visible="false">
                        </telerik:RadToolBarButton>
                    </Buttons>
                </telerik:RadToolBarDropDown>
                <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>

                <telerik:RadToolBarDropDown ID="i2" runat="server" Text="Export">
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

                <telerik:RadToolBarButton ID="RadToolBarButton2" ClientIDMode="Static" runat="server" Text="Select Company">
                    <ItemTemplate>
                        <span style="margin-left: 15px"></span>

                        <telerik:RadLabel runat="server" Text="Select company: " Font-Italic="true" Font-Bold="true" Font-Size="Medium">
                        </telerik:RadLabel>

                        <telerik:RadDropDownList runat="server" ID="RadDropDownList1" DataTextField="Company" DataValueField="Company" DropDownWidth="300px" OnItemSelected="RadDropDownList1_ItemSelected" AutoPostBack="true" ToolTip="" OnClientItemSelected="radDropDownList1_ClientItemSelected"></telerik:RadDropDownList>
                    </ItemTemplate>
                </telerik:RadToolBarButton>
                <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>
                  <telerik:RadToolBarButton>
                    <ItemTemplate>
                        <span style="margin-right: 15px"></span>
                    </ItemTemplate>
                </telerik:RadToolBarButton>
                <telerik:RadToolBarButton ID="PeriodSelector" runat="server" Text="PeriodSelector">
                    <ItemTemplate>
                        <span style="margin-left: 15px"></span>
                        
                        <telerik:RadDatePicker ID="FromDatePicker" runat="server" DateInput-Label="From" Width="50%" ShowPopupOnFocus="true" EnableScreenBoundaryDetection="false" EnableShadows="true" DateInput-OnClientDateChanged="fromDateSelected" AutoPostBack="false" DateInput-DisplayDateFormat="dd/MM/yyyy" DateInput-DateFormat="dd/MM/yyyy" ToolTip="" Calendar-FastNavigationNextToolTip="" Calendar-FastNavigationPrevToolTip="" Calendar-NavigationNextToolTip="" Calendar-NavigationPrevToolTip="" Calendar-ShowDayCellToolTips="false" DatePopupButton-ToolTip=""></telerik:RadDatePicker>

                        <telerik:RadDatePicker ID="ToDatePicker" AutoPostBack="true" runat="server" DateInput-DisplayDateFormat="dd/MM/yyyy" DateInput-Label="To" DateInput-DateFormat="dd/MM/yyyy" ShowPopupOnFocus="true" ToolTip="" Calendar-FastNavigationNextToolTip="" Calendar-FastNavigationPrevToolTip="" Calendar-NavigationNextToolTip="" Calendar-NavigationPrevToolTip="" Calendar-ShowDayCellToolTips="false" DatePopupButton-ToolTip=""></telerik:RadDatePicker>
                    </ItemTemplate>
                </telerik:RadToolBarButton>
            </Items>

        </telerik:RadToolBar>

        <div class="scroller">
            <div class="gridWrapper">
                <div>
                    <telerik:RadGrid ID="RadGrid1" runat="server" AllowSorting="True" AutoGenerateColumns="False" AllowFilteringByColumn="True" RenderMode="Lightweight" ShowGroupPanel="True" ShowStatusBar="True" OnGridExporting="RadGrid1_GridExporting" OnHTMLExporting="RadGrid1_HTMLExporting" OnExportCellFormatting="RadGrid1_ExportCellFormatting" OnFilterCheckListItemsRequested="RadGrid1_FilterCheckListItemsRequested" OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound"
                        AllowPaging="False" GridLines="Both" ShowFooter="True" FilterType="Combined"
                        PageSize="50" OnNeedDataSource="RadGrid1_NeedDataSource" MasterTableView-Caption="<h3>Billing History </h3>" Font-Size="Small" PagerStyle-Mode="NextPrevAndNumeric" PagerStyle-PageSizeControlType="RadComboBox" GroupingSettings-CaseSensitive="False" MasterTableView-ShowGroupFooter="true" OnItemCreated="RadGrid1_ItemCreated">
                        <ClientSettings Resizing-AllowColumnResize="true" AllowDragToGroup="true" AllowExpandCollapse="true" Selecting-AllowRowSelect="true" ClientEvents-OnGroupCollapsed="groupCollapsed" ClientEvents-OnGroupExpanded="groupExpanded">
                            <Scrolling AllowScroll="True" UseStaticHeaders="True" SaveScrollPosition="true" FrozenColumnsCount="0"></Scrolling>
                            <Selecting AllowRowSelect="True"></Selecting>
                            <ClientEvents OnFilterMenuShowing="filterMenuShowing" />
                            <Resizing AllowColumnResize="True"></Resizing>
                        </ClientSettings>
                        <MasterTableView Width="100%" AllowMultiColumnSorting="true" TableLayout="Fixed" CommandItemDisplay="Top" GroupsDefaultExpanded="true" GroupLoadMode="Client" GroupHeaderItemStyle-Font-Bold="true" FooterStyle-Font-Bold="true" EnableHeaderContextMenu="true">
                            <CommandItemTemplate>
                                <div id="CommandItemsWrapper" style="float: right">
                                    <telerik:RadSearchBox RenderMode="Lightweight" runat="server" ID="RadSearchBox2" EmptyMessage="Filter by patient"
                                        Filter="Contains"
                                        DataKeyNames="BiodataID"
                                        DataTextField="FullName"
                                        DataValueField="BiodataID"
                                        EnableAutoComplete="true"
                                        ShowSearchButton="true"
                                        Width="300" EnableViewState="true"
                                        OnSearch="RadSearchBox2_Search" OnButtonCommand="RadSearchBox2_ButtonCommand" OnClientSearch="radSearchBox2_ClientSearch" OnClientButtonCommand="radSearchBox2_ClientButtonCommand">
                                        <DropDownSettings Width="300" />
                                        <Buttons>
                                            <telerik:SearchBoxButton CommandName="ClearFilter" CommandArgument="ClearFilter" Position="Left" AlternateText="Clear Filter" ImageUrl="images/filter.png" />
                                        </Buttons>
                                    </telerik:RadSearchBox>
                                </div>
                            </CommandItemTemplate>
                            <%--<CommandItemSettings ShowExportToWordButton="true" ShowExportToCsvButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" ShowExportToExcelButton="True" ShowExportToPdfButton="false" ShowPrintButton="false" PrintGridText="Print" />--%>
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Transaction Code" DataField="TransactCode" AllowFiltering="False" ReadOnly="True" ShowFilterIcon="False">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="FullName" HeaderText="Patient" HeaderStyle-Width="180px" FooterStyle-Font-Bold="true"
                                    ReadOnly="True" FilterCheckListEnableLoadOnDemand="true" FilterControlAltText="Filter by Patient" SortExpression="FullName" AutoPostBackOnFilter="true" FooterAggregateFormatString="{0}" Aggregate="CountDistinct" CurrentFilterFunction="Contains"
                                    DataType="System.String" AllowFiltering="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Company" Display="false" HeaderText="Company"></telerik:GridBoundColumn>
                                <telerik:GridDateTimeColumn DataField="Date" DataFormatString="{0:MMM dd, yyy}" AllowFiltering="false" CurrentFilterFunction="EqualTo" HeaderText="Date"></telerik:GridDateTimeColumn>
                                <telerik:GridBoundColumn DataField="ServiceName" HeaderText="Service/Product" AllowFiltering="false" Aggregate="Count" FooterAggregateFormatString="<b>Total Transactions: {0:n0}</b>"></telerik:GridBoundColumn>
                                <telerik:GridNumericColumn DataField="PackQuantity" FooterStyle-Font-Bold="true" ReadOnly="true" HeaderText="Pack" AllowFiltering="false" Aggregate="Sum" FooterAggregateFormatString="<b>Total Packs: {0:n0}</b>">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="UnitQuantity" FooterStyle-Font-Bold="true" ReadOnly="true" HeaderText="Unit" AllowFiltering="false" Aggregate="Sum" FooterAggregateFormatString="<b>Total Units: {0:n0}</b>">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="Cost" ReadOnly="true" HeaderText="Cost" DataFormatString="{0:C}" FooterStyle-Font-Bold="true" FooterText="Total Cost" AllowFiltering="false" Aggregate="Sum" FooterAggregateFormatString="<b>Total Cost: {0:C}</b>">
                                </telerik:GridNumericColumn>
                            </Columns>
                            <GroupByExpressions>
                                <telerik:GridGroupByExpression>
                                    <SelectFields>
                                        <telerik:GridGroupByField FieldName="FullName" HeaderText="Patient" />
                                        <telerik:GridGroupByField FieldName="Cost" HeaderText="Total Cost" Aggregate="Sum" FormatString="{0:C}" />
                                    </SelectFields>
                                    <GroupByFields>
                                        <telerik:GridGroupByField FieldName="FullName" />
                                    </GroupByFields>
                                </telerik:GridGroupByExpression>
                            </GroupByExpressions>
                        </MasterTableView>
                        <FilterMenu CssClass="RadFilterMenu_CheckList" OnClientShown="MenuShowing">
                        </FilterMenu>
                        <ExportSettings
                            HideStructureColumns="true"
                            ExportOnlyData="false"
                            IgnorePaging="true"
                            OpenInNewWindow="true" Word-Format="Html" FileName="Billing History" Excel-WorksheetName="Billing History" Excel-FileExtension="xls" Excel-Format="Html">
                            <Pdf
                                PageTitle="Billing History"
                                Author="HMS User"
                                PaperSize="A4"
                                Creator="HMS"
                                PageWidth="11in" PageHeight="8.5in">
                            </Pdf>

                            <Excel WorksheetName="Billing History"></Excel>
                        </ExportSettings>
                        <GroupingSettings ShowUnGroupButton="true" CaseSensitive="False"></GroupingSettings>

                        <HeaderContextMenu RenderMode="Lightweight"></HeaderContextMenu>
                    </telerik:RadGrid>
                    <asp:HiddenField runat="server" ClientIDMode="Static" ID="hfYear" />
                    <asp:HiddenField ID="hfStartDate" ClientIDMode="Static" runat="server" />
                    <asp:HiddenField ID="hfEndDate" ClientIDMode="Static" runat="server" />
                    <asp:HiddenField ID="hfCompany" ClientIDMode="Static" runat="server" />
                    <asp:HiddenField ID="isGroupExpanded" ClientIDMode="Static" runat="server" Value="1" />
                    <asp:HiddenField ID="hfRadSearchBox2" runat="server" />

                    <input type="hidden" id="radGridClickedRowIndex" name="radGridClickedRowIndex" />
                    <input type="hidden" id="targetCompany" name="targetCompany" />
                    <telerik:RadContextMenu ID="RadMenu1" runat="server" OnItemClick="RadMenu1_ItemClick"
                        EnableRoundedCorners="True" EnableShadows="True">
                        <Items>
                            <telerik:RadMenuItem Text="Billing History" Value="BillingHistory">
                            </telerik:RadMenuItem>
                        </Items>
                    </telerik:RadContextMenu>
                    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
                        <script type="text/javascript">
                            var dateRangePickerBtnClicked = false;
                            var menu; // Row context menu
                            var column = null;
                            var isGroupExpanded = Boolean(<%= RadGrid1.MasterTableView.GroupsDefaultExpanded? 1 : 0 %>)
                            var rtbButtons = {};
                            var hfCompany;
                            var radGrid1;
                            var radSearchBox2; // Grid search box
                            var hfRadSearchBox2; // store search box value for postBack.
                            var clearFilterClicked = false;
                            $(function () {
                                //grid = $telerik.findControl(document, "RadGrid1");
                                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);

                                menu = $telerik.findControl(document, "RadMenu1");

                                // Add click event to RadToolBar1 dropdown buttons (.rtbButton)
                                $telerik.$("#RadToolBar1 .rtbLI .rtbButton")
                                    .on("click", function (e) {
                                        $(e.currentTarget).toggleClass("clicked");
                                    });
                            });

                            function filterMenuShowing(sender, eventArgs) {
                                // Set value for column to be used in MenuShowing().
                                column = eventArgs.get_column();
                            }

                            function MenuShowing(menu, args) {

                                if (column == null) return;

                                // Iterate through filter menu items.
                                // var items = menu.get_items();
                                var items = menu.get_allItems();
                                /*  for (i = 1; i < items.length - 1; i++) {
                                      var item = items[i];
                                      if (item === null)
                                          continue;
      
                                      // Make adjustments based on data type.
                                      switch (column.get_dataType()) {
      
                                          case "System.String":
      
                                              if (!(item.set_value in { 'NoFilter': '', 'Contains': '', 'EqualTo': '' }))
                                                  item.set_visible(false);
                                              else
                                                  item.set_visible(true);
                                              break;
      
                                          case "System.Int64":
      
                                              if (!(item.get_value() in { 'NoFilter': '', 'GreaterThan': '', 'LessThan': '', 'NotEqualTo': '', 'EqualTo': '' }))
                                                  item.set_visible(false);
                                              else
                                                  item.set_visible(true);
                                              break;
                                      }
                                  }*/
                                // Hide entire filter options menu
                                menu.get_items()._array[0].set_visible(false)
                                column = null;
                                menu.repaint();
                            }

                            /* function dateChanged(sender, args) {
                                 var year = args.get_newDate().getFullYear();
                                 $("#hfYear").val(year);
                             }*/

                            function rowContextMenu(sender, args) {
                                var evt = args.get_domEvent();
                                if (evt.target.tagName == "INPUT" || evt.target.tagName == "A") {
                                    return;
                                }

                                var index = args.get_itemIndexHierarchical();
                                var MasterTable = sender.get_masterTableView();
                                var row = MasterTable.get_dataItems()[index];
                                var cell = MasterTable.getCellByColumnUniqueName(row, "Company");
                                MasterTable.selectItem(row.get_element(), true);
                                document.getElementById("radGridClickedRowIndex").value = index;
                                $("#targetCompany").val(cell.innerHTML);
                                menu.show(evt);
                                evt.cancelBubble = true;
                                evt.returnValue = false;

                                if (evt.stopPropagation) {
                                    evt.stopPropagation();
                                    evt.preventDefault();
                                }
                            }

                            function collapseExpandAllGroups(sender, args) {
                                var $span = $(sender.get_element()).find("span");
                                var $isGroupExpanded = $("#isGroupExpanded");
                                var RadGrid1 = $telerik.findGrid("RadGrid1");
                                if (isGroupExpanded) {
                                    RadGrid1.MasterTableView.collapseAllGroups();
                                    $isGroupExpanded.val("");
                                    $span.addClass("rgExpandIcon").removeClass("rgCollapseIcon");
                                } else {
                                    RadGrid1.MasterTableView.expandAllGroups();
                                    $span.removeClass("rgExpandIcon").addClass("rgCollapseIcon");
                                    $isGroupExpanded.val("1");
                                }
                            }

                            function groupCollapsed() {
                                isGroupExpanded = false;
                            }
                            function groupExpanded() {
                                isGroupExpanded = true;
                            }

                            function fromDateSelected(sender, args) {
                                var date = sender.get_selectedDate();
                                var toDatePicker = $telerik.findControl(document, "ToDatePicker");
                                toDatePicker.set_minDate(date);
                            }

                            function ClientDropDownOpening(sender, args) {
                                //var dropDown = args.get_item();
                                //// manually toggle clicked class of opened siblings and close them
                                //var siblings = dropDown._getSiblings();
                                //var visible = siblings._array.filter(function (d) {
                                //    return d._isDropDownVisible
                                //});
                                //for (var i = 0; i < visible.length; i++) {
                                //    var d = visible[i];
                                //    $(d._element).find(".rtbButton").removeClass("clicked");
                                //    d.hideDropDown();
                                //}
                            }

                            function ClientDropDownClosing(sender, args) {
                                var dropDownElement = $(args.get_item()._element)
                                dropDownElement.find(".rtbButton").removeClass("clicked");
                                //args.set_cancel(dropDownElement.find(".rtbButton").hasClass("clicked"));
                            }

                            function radSearchBox1_ClientSearch(sender, args) {
                                var value = args.get_value();
                                if (value != null) {
                                    hfCompany.val(value);
                                }
                            }

                            function pageLoad() {
                                hfCompany = $telerik.$("#<%= hfCompany.ClientID %>");
                                radGrid1 = $find("<%= RadGrid1.ClientID %>");
                                hfRadSearchBox2 = $telerik.$("#<%= hfRadSearchBox2.ClientID %>");
                                radSearchBox2 = $telerik.findControl(document, "RadSearchBox2");
                                //radSearchBox2.trackChanges();
                            }

                            function radDropDownList1_ClientItemSelected(sender, args) {
                                hfCompany.val(args.get_item().get_value());
                            }

                            function radSearchBox2_ClientSearch(sender, args) {
                                hfRadSearchBox2.val(args.get_text());
                            }

                            function endRequestHandler(sender, args) {
                                $(radSearchBox2.get_inputElement()).val(hfRadSearchBox2.val());
                                if (clearFilterClicked) {
                                    radSearchBox2.set_emptyMessage("Filter by patient");
                                    clearFilterClicked = false;
                                }
                            }

                            function radSearchBox2_ClientButtonCommand(sender, args) {
                                if (args.get_commandName() == "ClearFilter") {
                                    hfRadSearchBox2.val("");
                                    clearFilterClicked = true;
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
