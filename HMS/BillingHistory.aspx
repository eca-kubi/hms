<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BillingHistory.aspx.cs" Inherits="BillingHistory" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
        <script src="https://kit.fontawesome.com/013c8b2550.js" crossorigin="anonymous"></script>

    <style>
        #CollapseExpandAll.rbButton:focus{
            box-shadow: none;
        }
        #CollapseExpandAll {
            background:none;
            border: none;
        }
        #CollapseExpandAll:hover{
            border: none
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
                <telerik:AjaxSetting AjaxControlID="RadCalendar1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadCalendar1" UpdatePanelCssClass="" />
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" UpdatePanelCssClass="" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="RadGrid1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" UpdatePanelCssClass="" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
            </AjaxSettings>
        </telerik:RadAjaxManager>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server">
        </telerik:RadAjaxLoadingPanel>
        <telerik:RadToolBar ID="RadToolBar1" runat="server" Style="font-weight: 700" OnButtonClick="RadToolBar1_ButtonClick" OnClientButtonClicked="ClientButtonClicked1" OnClientDropDownClosing="ClientDropDownClosing1" OnClientDropDownOpening="ClientDropDownOpening1">
            <Items>
                <telerik:RadToolBarDropDown ID="RadToolBarDropDown1" runat="server" Text="Period ">
                    <Buttons>
                        <telerik:RadToolBarButton ID="RadToolBarButton1" CommandName="DateRangePicker" CheckOnClick="true" OnPreRender="RadToolBarButton1_PreRender" runat="server" Text="Child Button 1">
                            <ItemTemplate>
                                <telerik:RadCalendar RenderMode="Lightweight" runat="server" ID="RadCalendar1" AutoPostBack="true" EnableMultiSelect="true" ClientEvents-OnCalendarViewChanged="CalendarViewChanged1" MultiViewColumns="2" OnSelectionChanged="RadCalendar1_SelectionChanged" EnableAjaxSkinRendering="true"
                                     RangeSelectionMode="None" EnableViewSelector="true">
                                </telerik:RadCalendar>
                            </ItemTemplate>
                        </telerik:RadToolBarButton>
                    </Buttons>

                </telerik:RadToolBarDropDown>

                <telerik:RadToolBarDropDown ID="RadToolBarDropDown2" runat="server" Text="Export To">
                    <Buttons>
                        <telerik:RadToolBarButton ID="RadToolBarButton2" runat="server" CommandName="ExportToExcelCommandName" Text="Excel" CssClass="exportToExcel">
                        </telerik:RadToolBarButton>
                        <telerik:RadToolBarButton ID="RadToolBarButton3" runat="server" CommandName="ExportToWordCommandName" Text="Word" CssClass="exportToWord">
                        </telerik:RadToolBarButton>
                    </Buttons>
                </telerik:RadToolBarDropDown>

            </Items>

        </telerik:RadToolBar>

        <div class="scroller">
            <div class="gridWrapper">
                <div>
                    <telerik:RadGrid ID="RadGrid1" runat="server" AllowSorting="True" AutoGenerateColumns="False" AllowFilteringByColumn="True" RenderMode="Lightweight" ShowGroupPanel="True" ShowStatusBar="True" OnGridExporting="RadGrid1_GridExporting" OnHTMLExporting="RadGrid1_HTMLExporting" OnExportCellFormatting="RadGrid1_ExportCellFormatting" OnFilterCheckListItemsRequested="RadGrid1_FilterCheckListItemsRequested" OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound"
                        AllowPaging="False" GridLines="Both" ShowFooter="True" FilterType="Combined"
                        PageSize="50" OnNeedDataSource="RadGrid1_NeedDataSource" MasterTableView-Caption="<h3>Billing History </h3>" Font-Size="Small" PagerStyle-Mode="NextPrevAndNumeric" PagerStyle-PageSizeControlType="RadComboBox" GroupingSettings-CaseSensitive="False" MasterTableView-ShowGroupFooter="true">
                        <ClientSettings Resizing-AllowColumnResize="true" AllowDragToGroup="true" AllowExpandCollapse="true" Selecting-AllowRowSelect="true" ClientEvents-OnGroupCollapsed="groupCollapsed" ClientEvents-OnGroupExpanded="groupExpanded">
                            <Scrolling AllowScroll="True" UseStaticHeaders="True" SaveScrollPosition="true" FrozenColumnsCount="1"></Scrolling>
                            <Selecting AllowRowSelect="True"></Selecting>
                            <ClientEvents OnFilterMenuShowing="filterMenuShowing" />
                            <ClientEvents OnRowContextMenu="rowContextMenu" />
                            <Resizing AllowColumnResize="True"></Resizing>
                        </ClientSettings>
                        <MasterTableView Width="100%" AllowMultiColumnSorting="true" TableLayout="Fixed" CommandItemDisplay="Top" GroupsDefaultExpanded="false" GroupLoadMode="Client" GroupHeaderItemStyle-Font-Bold="true" FooterStyle-Font-Bold="true">
                            <CommandItemSettings ShowExportToWordButton="true" ShowExportToCsvButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" ShowExportToExcelButton="True" ShowExportToPdfButton="false" ShowPrintButton="false" PrintGridText="Print" />

                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Transaction Code" DataField="TransactCode" AllowFiltering="False" ReadOnly="True" ShowFilterIcon="False">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="FullName" HeaderText="Patient" FooterStyle-Font-Bold="true"
                                    ReadOnly="True" FilterCheckListEnableLoadOnDemand="true" FilterControlAltText="Filter Patients column" SortExpression="FullName" AutoPostBackOnFilter="true" FooterAggregateFormatString="{0}" Aggregate="CountDistinct" CurrentFilterFunction="Contains" DataType="System.String">
                                </telerik:GridBoundColumn>
                                <telerik:GridDateTimeColumn DataField="Date" HeaderText="Date"></telerik:GridDateTimeColumn>
                                <telerik:GridBoundColumn DataField="ServiceName" HeaderText="Service/Product" AllowFiltering="false"></telerik:GridBoundColumn>
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
                    <asp:HiddenField ID="hfStartDate" ClientIDMode="Static" runat="server"/>
                    <asp:HiddenField ID="hfEndDate" ClientIDMode="Static" runat="server"/>
                    <asp:HiddenField ID="hfCompany" ClientIDMode="Static" runat="server"/>
                    <asp:HiddenField ID="isGroupExpanded" ClientIDMode="Static" runat="server"  />
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

                            $(function () {
                                //grid = $telerik.findControl(document, "RadGrid1");
                                menu = $telerik.findControl(document, "RadMenu1");
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

                            function dateChanged(sender, args) {
                                var year = args.get_newDate().getFullYear();
                                $("#hfYear").val(year);
                            }

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

                            function ClientButtonClicked1(sender, args) {
                                if (args.get_item().get_commandName() == "DateRangePicker") {
                                    dateRangePickerBtnClicked = !dateRangePickerBtnClicked;
                                }
                            }

                            function ClientDropDownClosing1(sender, args) {
                                $span = $(args.get_item().get_linkElement());
                                if ($span.hasClass("clicked")) {
                                    args.set_cancel(true)
                                }
                                
                            }

                            function ClientDropDownOpening1(sender, args) {
                                args.get_item().set_cssClass("clicked")
                                $span = $(args.get_item().get_linkElement());
                                $span.addClass("clicked");
                                $span.one("click", function () {
                                    if ($span.hasClass("clicked")) {
                                        $span.removeClass("clicked")
                                    } else {
                                        $span.addClass("clicked");
                                    }
                                });
                            }

                            function CalendarViewChanged1(sender, args) {
                                console.log("view changed")
                            }
                        </script>
                    </telerik:RadCodeBlock>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
