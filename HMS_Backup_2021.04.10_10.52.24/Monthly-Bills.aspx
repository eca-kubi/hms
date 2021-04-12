<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Monthly-Bills.aspx.cs" Inherits="Monthly_Bills" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Monthly Bills</title>
        <link rel="shortcut icon" type="image/x-icon" href="images/patient.png" />
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
    <script src="https://kit.fontawesome.com/013c8b2550.js" crossorigin="anonymous"></script>
    <style type="text/css">
        .monthCellClass {
            display: none;
        }

        .rcSelected[id^=rcMView_J], .rcSelected[id^=rcMView_F], .rcSelected[id^=rcMView_M], .rcSelected[id^=rcMView_A], .rcSelected[id^=rcMView_S], .rcSelected[id^=rcMView_O], .rcSelected[id^=rcMView_N], .rcSelected[id^=rcMView_D] {
            display: none;
        }

        .rcSelected ~ .rcSelected {
            display: table-cell;
        }

        #rcMView_Today {
            display: none;
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

        a[id$=RadMonthYearPicker1_NavigationPrevLink]:after {
            content: "\0020Prev";
        }

        a[id$=RadMonthYearPicker1_NavigationNextLink]:before {
            content: "Next\0020";
        }

        .rtContent a {
            color: whitesmoke
        }

        .rtbLI .rtbButton .rtbArrow .radIcon.radIconDown::before {
            font-family: "WebComponentsIcons";
            content: '\e005';
        }

        .rtbLI .rtbButton.clicked .rtbArrow .radIcon.radIconDown::before {
            font-family: "WebComponentsIcons";
            content: '\e006';
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
                <telerik:AjaxSetting AjaxControlID="RadMonthYearPicker1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" UpdatePanelCssClass="" />
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
        <telerik:RadToolTipManager ID="RadToolTipManager1" runat="server" AutoTooltipify="true">
        </telerik:RadToolTipManager>
        <telerik:RadToolBar ID="RadToolBar1" runat="server" Style="font-weight: 700" OnButtonClick="RadToolBar1_ButtonClick" OnClientDropDownClosing="ClientDropDownClosing">
            <Items>

                

                <telerik:RadToolBarButton ID="RadToolBarButton1" runat="server" Text="Child Button 1" OnPreRender="RadToolBarButton1_PreRender">
                    <ItemTemplate>
                        <asp:Label runat="server" Text="Select year: "></asp:Label>
                        <telerik:RadMonthYearPicker ID="RadMonthYearPicker1" runat="server" Culture="en-US" HiddenInputTitleAttibute="Visually hidden input created for functionality purposes." MinDate="2015-01-01" MonthCellsStyle-CssClass="monthCellClass" OnSelectedDateChanged="RadMonthYearPicker1_SelectedDateChanged" DateInput-DateFormat="yyyy" AutoPostBack="true" DateInput-OnClientDateChanged="dateChanged" DatePopupButton-ToolTip="" MonthYearNavigationSettings-NavigationNextToolTip="" MonthYearNavigationSettings-NavigationPrevToolTip="">
                        </telerik:RadMonthYearPicker>
                    </ItemTemplate>
                </telerik:RadToolBarButton>

                <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>

                <telerik:RadToolBarDropDown Text="Go To" runat="server" ID="RadToolBarDropDown1">
                    <Buttons>
                        <telerik:RadToolBarButton ID="PatientHistory" runat="server"
                            CommandName="PatientHistoryCommandName"
                            Text="Patient Billing History" ImageUrl="~/images/patient.png" ImagePosition="Left">
                        </telerik:RadToolBarButton>
                        <telerik:RadToolBarButton ID="CompanyBills" runat="server" CommandName="CompanyBillsCommandName" ImageUrl="~/images/calendar.png" ImagePosition="Left" Text="Monthly Bills" Visible="false">
                        </telerik:RadToolBarButton>
                        <telerik:RadToolBarButton ID="BillingHis" runat="server" CommandName="BillingHistoryCommandName" ImageUrl="~/images/enterprise1.png" ImagePosition="Left" Text="Company Billing History">
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

               
            </Items>

        </telerik:RadToolBar>

        <div class="scroller">
            <div class="gridWrapper">
                <div>
                    <telerik:RadGrid ID="RadGrid1" runat="server" AllowSorting="True" AutoGenerateColumns="false" AllowFilteringByColumn="true" RenderMode="Lightweight" ShowGroupPanel="True" ShowStatusBar="true" OnGridExporting="RadGrid1_GridExporting" OnHTMLExporting="RadGrid1_HTMLExporting" OnExportCellFormatting="RadGrid1_ExportCellFormatting" OnFilterCheckListItemsRequested="RadGrid1_FilterCheckListItemsRequested" OnPreRender="RadGrid1_PreRender"
                        AllowPaging="True" GridLines="Both" ShowFooter="True" AllowMultiRowSelection="False" FilterType="Combined"
                        PageSize="10" OnNeedDataSource="RadGrid1_NeedDataSource" MasterTableView-Caption="<h3>Monthly Bills for </h3>" Font-Size="Small" EnableHeaderContextMenu="false" EnableHeaderContextFilterMenu="false" PagerStyle-Mode="NextPrevAndNumeric" PagerStyle-PageSizeControlType="RadComboBox" GroupingSettings-CaseSensitive="False" FooterStyle-Font-Bold="true" MasterTableView-EnableHeaderContextMenu="true" OnItemDataBound="RadGrid1_ItemDataBound" ClientSettings-AllowDragToGroup="false">
                        <ClientSettings Resizing-AllowColumnResize="true" AllowDragToGroup="false" Selecting-AllowRowSelect="true">
                            <Scrolling AllowScroll="True" UseStaticHeaders="True" SaveScrollPosition="true" FrozenColumnsCount="1"></Scrolling>
                            <Selecting AllowRowSelect="True"></Selecting>
                            <ClientEvents OnFilterMenuShowing="filterMenuShowing" />
                            <ClientEvents OnRowContextMenu="rowContextMenu" />
                            <Resizing AllowColumnResize="True"></Resizing>
                        </ClientSettings>
                        <MasterTableView Width="100%" AllowMultiColumnSorting="true" TableLayout="Fixed" CommandItemDisplay="None" Caption="Monthly Bills">
                            <%--<CommandItemSettings ShowExportToWordButton="true" ShowExportToCsvButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" ShowExportToExcelButton="True" ShowExportToPdfButton="false" ShowPrintButton="false" PrintGridText="Print" />--%>

                            <Columns>
                                <telerik:GridBoundColumn DataField="Company" HeaderText="Company" HeaderStyle-Width="180px" FilterControlWidth="120px"
                                    ReadOnly="True" FooterText="TOTAL: " FilterCheckListEnableLoadOnDemand="true" FilterControlAltText="Filter Company column" SortExpression="Company" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" DataType="System.String">
                                    <HeaderStyle Width="180px"></HeaderStyle>
                                </telerik:GridBoundColumn>
                                <telerik:GridNumericColumn DataField="C1" ReadOnly="true" HeaderText="Jan" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="C2" ReadOnly="true" HeaderText="Feb" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="C3" ReadOnly="true" HeaderText="Mar" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="C4" ReadOnly="true" HeaderText="Apr" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="C5" ReadOnly="true" HeaderText="May" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="C6" ReadOnly="true" HeaderText="Jun" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="C7" ReadOnly="true" HeaderText="Jul" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="C8" ReadOnly="true" HeaderText="Aug" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="C9" ReadOnly="true" HeaderText="Sep" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="C10" ReadOnly="true" HeaderText="Oct" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="C11" ReadOnly="true" HeaderText="Nov" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="C12" ReadOnly="true" HeaderText="Dec" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                                <telerik:GridNumericColumn DataField="Total" ReadOnly="true" HeaderText="Total" DataFormatString="{0:C}" AllowFiltering="false" Aggregate="Sum">
                                </telerik:GridNumericColumn>
                            </Columns>
                        </MasterTableView>
                        <FilterMenu CssClass="RadFilterMenu_CheckList" OnClientShown="MenuShowing">
                        </FilterMenu>
                        <ExportSettings
                            HideStructureColumns="true"
                            ExportOnlyData="false"
                            IgnorePaging="true"
                            OpenInNewWindow="true" Word-Format="Html" FileName="Monthly Bills" Excel-WorksheetName="Monthly Bills" Excel-FileExtension="xls" Excel-Format="Html">
                            <Pdf
                                PageTitle="Monthly Bills"
                                Author="HMS User"
                                PaperSize="A4"
                                Creator="HMS"
                                PageWidth="11in" PageHeight="8.5in">
                            </Pdf>

                            <Excel WorksheetName="Monthly Bills"></Excel>
                        </ExportSettings>
                        <GroupingSettings ShowUnGroupButton="true" CaseSensitive="False"></GroupingSettings>

                        <HeaderContextMenu RenderMode="Lightweight"></HeaderContextMenu>
                    </telerik:RadGrid>
                    <asp:HiddenField runat="server" ClientIDMode="Static" ID="hfYear" />
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
                            var menu; // Row context menu
                            var column = null;

                            $(function () {
                                //grid = $telerik.findControl(document, "RadGrid1");
                                menu = $telerik.findControl(document, "RadMenu1");
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

                            function ClientDropDownClosing(sender, args) {
                                var dropDownElement = $(args.get_item()._element)
                                dropDownElement.find(".rtbButton").removeClass("clicked");
                            }
                        </script>
                    </telerik:RadCodeBlock>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
